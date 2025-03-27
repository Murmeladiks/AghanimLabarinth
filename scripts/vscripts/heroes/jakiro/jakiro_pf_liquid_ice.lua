LinkLuaModifier("modifier_jakiro_pf_liquid_ice", 		"heroes/jakiro/jakiro_pf_liquid_ice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_pf_liquid_ice_debuff", "heroes/jakiro/jakiro_pf_liquid_ice", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

jakiro_pf_liquid_ice = class({})

--------------------------------------------------------------------------------

function jakiro_pf_liquid_ice:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_ready.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_ice.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_frost.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_shard.vpcf", context)	
end

--------------------------------------------------------------------------------

function jakiro_pf_liquid_ice:GetIntrinsicModifierName()
	return "modifier_jakiro_pf_liquid_ice"
end

--------------------------------------------------------------------------------

function jakiro_pf_liquid_ice:GetCastRange( vLocation, hTarget )
	return math.max(self.BaseClass.GetCastRange(self, vLocation, hTarget), self:GetCaster():Script_GetAttackRange())
end

--------------------------------------------------------------------------------

function jakiro_pf_liquid_ice:OnProjectileHit(hTarget, vLocation)
	if not hTarget then return end

	local hCaster = self:GetCaster()

	ApplyDamage({
		victim = hTarget,
		attacker = hCaster,
		damage = self:GetSpecialValueFor("damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	})

	hTarget:AddNewModifier(hCaster, self, "modifier_jakiro_pf_liquid_ice_debuff", {duration = self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance())})
	hTarget:EmitSound("Hero_Jakiro.LiquidFrost")

	return true
end

--------------------------------------------------------------------------------

modifier_jakiro_pf_liquid_ice = class({})

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:IsPurgable()	return false end
function modifier_jakiro_pf_liquid_ice:IsHidden()	return true end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:OnCreated( kv )
	if IsClient() then return end
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()

	self.nDuration = hAbility:GetSpecialValueFor("duration")	
	self.tAttackRecords = {}

	if hParent:IsIllusion() then
		self:Destroy()
		return
	end

	self.nReadyFX = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_ready.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.nReadyFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:OnIntervalThink()
	if not self:GetAbility():IsCooldownReady() then return end
	self:StartIntervalThink(-1)
	local hParent = self:GetParent()

	self.nReadyFX = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_ready.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.nReadyFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:OnAttack( event )
	if IsClient() or event.attacker ~= self:GetParent() or event.no_attack_cooldown then return end
	local hAttacker = event.attacker
	local hTarget = event.target
	local hAbility = self:GetAbility()

	if hTarget == nil or hAbility == nil then
		return 0
	end

	if not self:CanUseOrb() then
		return 0
	end

	if not self:IsValidTarget(hTarget) then
		return 0
	end

	self.tAttackRecords[event.record] = true

	hAttacker:EmitSound("Hero_Jakiro.LiquidFrost")

	hAbility:UseResources(true, false, false, true)

	local hFire = hAttacker:FindAbilityByName("jakiro_pf_liquid_fire")

	if hFire then
		hFire:UseResources(false, false, false, true)
	end

	if self.nReadyFX then
		ParticleManager:DestroyParticle(self.nReadyFX, false)
		ParticleManager:ReleaseParticleIndex(self.nReadyFX)
		self.nReadyFX = nil
	end

	if hAttacker:HasShard("pathfinder_special_jakiro_glacial_path") and hAttacker:HasAbility("jakiro_ice_path_lua") then
		hAttacker:FindAbilityByName("jakiro_ice_path_lua"):IceProjectile(hTarget)
	end

	self:StartIntervalThink(0.1)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:GetModifierProcAttack_Feedback( event )
	if IsClient() or not self.tAttackRecords[event.record] then return end
	local hAttacker = self:GetParent()
	local hTarget = event.target
	local hAbility = self:GetAbility()

	if not hTarget or hTarget:IsInvulnerable() or hTarget:IsAttackImmune() then
		return 0
	end

	ApplyDamage({
		victim = hTarget,
		attacker = hAttacker,
		damage = hAbility:GetSpecialValueFor("damage"),
		damage_type = hAbility:GetAbilityDamageType(),
		ability = hAbility
	})

	hTarget:AddNewModifier(hAttacker, hAbility, "modifier_jakiro_pf_liquid_ice_debuff", {duration = self.nDuration * (1 - hTarget:GetStatusResistance())})
	hTarget:EmitSound("Hero_Jakiro.IcePath")
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:GetModifierProjectileName(event)
	if IsServer() then
		if (self:CanUseOrb() and self:CanUseProjectile()) or (self:GetParent():GetCurrentActiveAbility() == self:GetAbility()) then
			return "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf"
		end
	end
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:GetPriority()
	if self:CanUseOrb() and self:CanUseProjectile() or self:GetParent():GetCurrentActiveAbility() == self:GetAbility() then
		return MODIFIER_PRIORITY_SUPER_ULTRA
	end
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:OnAttackRecordDestroy(event)
	self.tAttackRecords[event.record] = nil
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:CanUseOrb()
	local hAbility = self:GetAbility()
	local hAttacker = self:GetParent()

	if not hAbility:IsFullyCastable() or hAttacker:IsSilenced() or hAbility:GetManaCost(hAbility:GetLevel()) > hAttacker:GetMana() then
		return false
	end

	if hAttacker:GetCurrentActiveAbility() ~= hAbility and hAbility:GetAutoCastState() == false then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:IsValidTarget(hTarget)
	local hAttacker = self:GetParent()

	if not hTarget or hTarget:IsNull() or not IsValidEntity(hTarget) or not hTarget:IsAlive() then
		return false
	end

	if hTarget:GetClassname() == "dota_item_drop" then
		return false
	end

	if hTarget:IsInvulnerable() or hTarget:IsBuilding() or hTarget:IsOther() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice:CanUseProjectile()
	local hAttacker = self:GetParent()
	local hTarget = hAttacker:GetAggroTarget() or hAttacker:GetCursorCastTarget()

	if not self:IsValidTarget(hTarget) then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

modifier_jakiro_pf_liquid_ice_debuff = class({})

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:OnCreated( kv )
	local hAbility = self:GetAbility()

	self.nSlow = -hAbility:GetSpecialValueFor("movement_slow")
	self.nBonusDamage = hAbility:GetSpecialValueFor("bonus_instance_damage_from_other_abilities")
	
	if IsClient() then return end
	local hParent = self:GetParent()

	self.tDamageTable = {
		attacker = self:GetCaster(),
		victim = hParent,
		damage = self.nBonusDamage,
		damage_type = hAbility:GetAbilityDamageType(),
		ability = hAbility
	}
	
	local nIceFX = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(nIceFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControlEnt(nIceFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:SetParticleControl(nIceFX, 2, Vector(hParent:GetModelRadius(), 0, 0))
	ParticleManager:ReleaseParticleIndex(nIceFX)

	self.nAllyCooldown = self:GetCaster():FindTalentValue("pathfinder_special_jakiro_frozen_synchrony", "ally_cooldown")
	self.bAllyReady = true
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:OnRefresh()
	if IsClient() then return end
	local hParent = self:GetParent()

	local nIceFX = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(nIceFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControlEnt(nIceFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:SetParticleControl(nIceFX, 2, Vector(hParent:GetModelRadius(), 0, 0))
	ParticleManager:ReleaseParticleIndex(nIceFX)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:OnDestroy()
	if IsClient() or self:GetParent():IsAlive() or not self:GetCaster():HasShard("pathfinder_special_jakiro_frigid_shrapnel") then return end

	local hCaster = self:GetCaster()
	local vOrigin = self:GetParent():GetOrigin()
	local nShardCount = hCaster:FindTalentValue("pathfinder_special_jakiro_frigid_shrapnel", "count")
	local nAnglePerShard = 360 / nShardCount

	for i = 1, nShardCount do
		local nAngle = (i * nAnglePerShard) - 360
		local nAngleRad = nAngle * (math.pi / 180)
		local vTargetPos = vOrigin + Vector(math.cos(nAngleRad), math.sin(nAngleRad), 0) * 700
		local vDirection = vTargetPos - vOrigin
		vDirection.z = 0
		vDirection = vDirection:Normalized()
		local nDistance = (vTargetPos - vOrigin):Length2D()

		ProjectileManager:CreateLinearProjectile({
			EffectName = "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_shard.vpcf",
			Ability = self:GetAbility(),
			vSpawnOrigin = vOrigin + Vector(0, 0, 128),
			fStartRadius = 100,
			fEndRadius = 100,
			vVelocity = vDirection * hCaster:GetProjectileSpeed() * 1.5,
			fDistance = nDistance,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			Source = hCaster,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		})
	end
	
	EmitSoundOnLocationWithCaster(vOrigin, "Hero_Jakiro.IcePath.ti7", hCaster)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:OnIntervalThink()
	self:StartIntervalThink(-1)
	self.bAllyReady = true
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:GetModifierMoveSpeedBonus_Percentage( event )
	return self.nSlow
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:OnTooltip()
	return self.nBonusDamage
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:OnTakeDamage(event)
	if IsClient() or event.unit ~= self:GetParent() then return end
	local hInflictor = event.inflictor
	local hAttacker = event.attacker
	local bIsCaster = hAttacker == self:GetCaster()

	if hInflictor == self:GetAbility() then return end

	if not bIsCaster and (not self:GetCaster():HasShard("pathfinder_special_jakiro_frozen_synchrony") or not self.bAllyReady) then return end
	
	-- Might be OP in combination with some sharing legendaries (like jugg spin), need to check
	--if hInflictor and hInflictor:GetCaster() ~= self:GetCaster() then return end
	
	ApplyDamage(self.tDamageTable)

	if hAttacker ~= self:GetCaster() then
		self.bAllyReady = false
		self:StartIntervalThink(self.nAllyCooldown)
	end
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_ice_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end