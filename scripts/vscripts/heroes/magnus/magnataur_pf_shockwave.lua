LinkLuaModifier("modifier_magnataur_pf_shockwave", 					"heroes/magnus/magnataur_pf_shockwave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magnataur_pf_shockwave_pull", 			"heroes/magnus/magnataur_pf_shockwave", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_magnataur_pf_shockwave_damage_reduction", "heroes/magnus/magnataur_pf_shockwave", LUA_MODIFIER_MOTION_NONE)

magnataur_pf_shockwave = class({})

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:Precache( context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf", context)
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:Spawn()
	if IsClient() then return end
	self.Shockwaves = {}

	Timers:CreateTimer(0.1, function()
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity(self:GetCaster():GetPlayerOwnerID())

		if self:GetLevelSpecialValueFor("swap_ability", 1) <= 0 or hPlayerHero.bSwappedToBoomerang then return end
		hPlayerHero.bSwappedToBoomerang = true
			
		local hCurveVersion = hPlayerHero:AddAbility("magnataur_pf_shockwave_return")
		hPlayerHero:SwapAbilities("magnataur_pf_shockwave", "magnataur_pf_shockwave_return", false, true)
		hPlayerHero:RemoveAbility("magnataur_pf_shockwave")
	end)
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:OnAbilityPhaseStart()
	if IsServer() then
		self.nCastFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nCastFX, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)

		self:GetCaster():EmitSound("Hero_Magnataur.ShockWave.Cast")
	end
	
	return true
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:OnAbilityPhaseInterrupted()
	if IsClient() then return end
	self:GetCaster():StopSound("Hero_Magnataur.ShockWave.Cast")
	ParticleManager:DestroyParticle(self.nCastFX, true)
	ParticleManager:ReleaseParticleIndex(self.nCastFX)
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:OnSpellStart()
	ParticleManager:DestroyParticle(self.nCastFX, false)
	ParticleManager:ReleaseParticleIndex(self.nCastFX)

	local hCaster = self:GetCaster()
	local vOrigin = hCaster:GetOrigin()
	local vPosition = self:GetCursorPosition()

	if (vPosition - vOrigin):Length2D() < 1 then
		vPosition = vPosition + hCaster:GetForwardVector() * 10
	end

	self:SendShockwave(vPosition, 100, vOrigin, false)

	if not hCaster:HasShard("aghsfort_special_magnataur_shockwave_multishot") then return end

	local nDegree = hCaster:FindTalentValue("aghsfort_special_magnataur_shockwave_multishot", "degrees_between_shockwaves")
	local nDamagePct = hCaster:FindTalentValue("aghsfort_special_magnataur_shockwave_multishot", "damage_pct")

	self:SendShockwave(RotatePosition(vOrigin, QAngle(0, -nDegree, 0), vPosition), nDamagePct, vOrigin, false)
	self:SendShockwave(RotatePosition(vOrigin, QAngle(0, nDegree, 0), vPosition), nDamagePct, vOrigin, false)
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:SendShockwave(vLocation, nDamagePct, vOrigin, bReturning)
	local hCaster = self:GetCaster()
	local nSpeed = self:GetSpecialValueFor("shock_speed")

	local nDistance = self:GetEffectiveCastRange(vLocation, hCaster)
	local vDirection = vLocation - vOrigin

	vDirection.z = 0
	vDirection = vDirection:Normalized()

	local hSoundEntity = CreateModifierThinker(hCaster, self, "", {duration = 6}, vOrigin, hCaster:GetTeam(), false)
	hSoundEntity:EmitSound(bReturning and "Hero_Magnataur.ShockWave.Return" or "Hero_Magnataur.ShockWave.Particle")

	local nShockwaveHandle = ProjectileManager:CreateLinearProjectile({
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
		vSpawnOrigin		= vOrigin,
		fDistance			= nDistance,
		fStartRadius		= self:GetSpecialValueFor("shock_width"),
		fEndRadius			= self:GetSpecialValueFor("shock_width"),
		Source				= hCaster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= self:GetAbilityTargetTeam(),
		iUnitTargetFlags	= self:GetAbilityTargetFlags(),
		iUnitTargetType		= self:GetAbilityTargetType(),
		fExpireTime 		= GameRules:GetGameTime() + (nDistance / nSpeed) + 2,
		bDeleteOnHit		= false,
		vVelocity			= vDirection * nSpeed,
		bProvidesVision		= false,
		ExtraData = {
			nSoundID = hSoundEntity:entindex(),
			nMult = nDamagePct,
			X = vOrigin.x,
			Y = vOrigin.y,
			bReturning = bReturning
		}
	})
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:OnProjectileThink_ExtraData(vLocation, ExtraData)
	if ExtraData.nSoundID then
		local hSoundEntity = EntIndexToHScript(ExtraData.nSoundID)

		if hSoundEntity and not hSoundEntity:IsNull() then
			hSoundEntity:SetOrigin(vLocation)
		end
	end
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if not hTarget then self:Boomerang(vLocation, ExtraData) return end
	local hCaster = self:GetCaster()

	ApplyDamage({
		attacker = hCaster,
		victim = hTarget,
		damage = self:GetSpecialValueFor("shock_damage") * ExtraData.nMult / 100,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	})

	local vDir = (vLocation - hTarget:GetOrigin()):Normalized()
	local vPullLoc = hTarget:GetOrigin() + vDir * self:GetSpecialValueFor("pull_distance")


	if hCaster:HasShard("aghsfort_special_magnataur_shockwave_damage_reduction") then
		local nDur = self:GetSpecialValueFor("basic_slow_duration") + hCaster:FindTalentValue("aghsfort_special_magnataur_shockwave_damage_reduction", "value")

		hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("basic_slow_duration") * (1 - hTarget:GetStatusResistance())})
		hTarget:AddNewModifier(hCaster, self, "modifier_magnataur_pf_shockwave_damage_reduction", {duration = nDur * (1 - hTarget:GetStatusResistance())})
	else
		hTarget:AddNewModifier(hCaster, self, "modifier_magnataur_pf_shockwave", {duration = self:GetSpecialValueFor("basic_slow_duration") * (1 - hTarget:GetStatusResistance())})
	end

	hTarget:AddNewModifier(hCaster, self, "modifier_magnataur_pf_shockwave_pull", {duration = self:GetSpecialValueFor("pull_duration") * (1 - hTarget:GetStatusResistance()), X = vPullLoc.x, Y = vPullLoc.y})

	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	)

	hTarget:EmitSound("Hero_Magnataur.ShockWave.Target")
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave:Boomerang(vLocation, ExtraData)
	local hCaster = self:GetCaster()

	if not hCaster:HasShard("aghsfort_special_magnataur_shockwave_boomerang") or ExtraData.bReturning == 1 then return end
	local vOrigin = Vector(ExtraData.X, ExtraData.Y, 0)

	self:SendShockwave(vOrigin, ExtraData.nMult, vLocation, true)
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_shockwave = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave:OnCreated()
	self.nSlow = -self:GetAbility():GetSpecialValueFor("movement_slow")
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave:GetModifierMoveSpeedBonus_Percentage()
	return self.nSlow
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_shockwave_pull = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_pull:IsHidden() return true end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_pull:OnCreated(kv)
	if IsClient() then return end

	local vOrigin = Vector(kv.X, kv.Y, 0)
	self.vDirection = vOrigin - self:GetParent():GetOrigin()
	self.nSpeed = self.vDirection:Length2D() / self:GetDuration()

	self.vDirection.z = 0
	self.vDirection = self.vDirection:Normalized()

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_pull:OnDestroy()
	if IsClient() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_pull:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_pull:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_pull:UpdateHorizontalMotion(hParent, dt)
	hParent:SetOrigin(hParent:GetOrigin() + self.vDirection * self.nSpeed * dt)
	GridNav:DestroyTreesAroundPoint(hParent:GetOrigin(), hParent:GetHullRadius(), true)
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_pull:OnHorizontalMotionInterrupted()
	self:Destroy()
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_shockwave_damage_reduction = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_damage_reduction:OnCreated()
	self.nDamageReduction = -self:GetCaster():FindTalentValue("aghsfort_special_magnataur_shockwave_damage_reduction", "damage_reduction_pct")
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_damage_reduction:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_shockwave_damage_reduction:GetModifierTotalDamageOutgoing_Percentage()
	return self.nDamageReduction
end