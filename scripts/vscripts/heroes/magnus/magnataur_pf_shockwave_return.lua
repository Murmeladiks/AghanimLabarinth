LinkLuaModifier("modifier_magnataur_pf_shockwave", 					"heroes/magnus/magnataur_pf_shockwave_return", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magnataur_pf_shockwave_pull", 			"heroes/magnus/magnataur_pf_shockwave_return", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_magnataur_pf_shockwave_damage_reduction", "heroes/magnus/magnataur_pf_shockwave_return", LUA_MODIFIER_MOTION_NONE)

magnataur_pf_shockwave_return = class({})

--------------------------------------------------------------------------------

function magnataur_pf_shockwave_return:Precache( context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf", context)
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave_return:Spawn()
	if IsClient() then return end
	self.Shockwaves = {}
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave_return:OnAbilityPhaseStart()
	if IsServer() then
		self.nCastFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nCastFX, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)

		self:GetCaster():EmitSound("Hero_Magnataur.ShockWave.Cast")
	end
	
	return true
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave_return:OnAbilityPhaseInterrupted()
	if IsClient() then return end
	self:GetCaster():StopSound("Hero_Magnataur.ShockWave.Cast")
	ParticleManager:DestroyParticle(self.nCastFX, true)
	ParticleManager:ReleaseParticleIndex(self.nCastFX)
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave_return:OnSpellStart()
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

function magnataur_pf_shockwave_return:SendShockwave(vLocation, nDamagePct, vOrigin, bReturning)
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

function magnataur_pf_shockwave_return:OnProjectileThink_ExtraData(vLocation, ExtraData)
	if ExtraData.nSoundID then
		local hSoundEntity = EntIndexToHScript(ExtraData.nSoundID)

		if hSoundEntity and not hSoundEntity:IsNull() then
			hSoundEntity:SetOrigin(vLocation)
		end
	end
end

--------------------------------------------------------------------------------

function magnataur_pf_shockwave_return:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
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

function magnataur_pf_shockwave_return:Boomerang(vLocation, ExtraData)
	local hCaster = self:GetCaster()

	if self:GetSpecialValueFor("return_damage_pct") <= 0 or ExtraData.bReturning == 1 then return end
	local vOrigin = Vector(ExtraData.X, ExtraData.Y, 0)
	local vDir = (vOrigin - vLocation):Normalized()
	
	local vExtendedPos = vOrigin + self:GetSpecialValueFor("return_shockwave_bonus_distance") * vDir

	self:SendShockwave(vExtendedPos, ExtraData.nMult * self:GetSpecialValueFor("return_damage_pct") / 100, vLocation, true)
end