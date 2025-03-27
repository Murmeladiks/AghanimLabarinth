LinkLuaModifier("modifier_marci_pf_bodyguard_self",		"heroes/marci/marci_pf_bodyguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marci_pf_bodyguarded",		"heroes/marci/marci_pf_bodyguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marci_pf_bodyguarded_enemy",	"heroes/marci/marci_pf_bodyguard", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

marci_pf_bodyguard = class({})

--------------------------------------------------------------------------------

function marci_pf_bodyguard:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_bodyguard_radius.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_bodyguard_radius_enemy.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_sidekick_debuff.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_marci_sidekick.vpcf", context)
end

--------------------------------------------------------------------------------

function marci_pf_bodyguard:CastFilterResultTarget(hTarget)
	local hCaster = self:GetCaster()

	if hTarget == hCaster then return UF_FAIL_CUSTOM end

	if hCaster:HasShard("special_bonus_unique_marci_bodyguard_enemy") then
		return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, hCaster:GetTeamNumber())
	end

	return self.BaseClass.CastFilterResultTarget(self, hTarget)
end

--------------------------------------------------------------------------------

function marci_pf_bodyguard:GetCustomCastErrorTarget(hTarget)
	if hTarget == self:GetCaster() then return "#dota_hud_error_cant_cast_on_self" end
end

--------------------------------------------------------------------------------

function marci_pf_bodyguard:GetIntrinsicModifierName()
	return "modifier_marci_pf_bodyguard_self"
end
--------------------------------------------------------------------------------

function marci_pf_bodyguard:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:GetTeam() ~= hCaster:GetTeam() then
		hTarget:AddNewModifier(hCaster, self, "modifier_marci_pf_bodyguarded_enemy", {duration = self:GetSpecialValueFor("bodyguard_duration")})

		hTarget:EmitSound("Hero_Marci.Guardian.Applied")
		return
	end

	if self.hCurrentAlly and self.hCurrentAlly:HasModifier("modifier_marci_pf_bodyguarded") then
		self.hCurrentAlly:RemoveModifierByName("modifier_marci_pf_bodyguarded")
	end

	self.hCurrentAlly = hTarget
	
	hTarget:AddNewModifier(hCaster, self, "modifier_marci_pf_bodyguarded", {duration = self:GetSpecialValueFor("bodyguard_duration")})

	hTarget:EmitSound("Hero_Marci.Guardian.Applied")

	if hCaster:HasShard("pathfinder_marci_unleash_bash_bodyguard") then
		local hUnleash = hCaster:FindAbilityByName("marci_unleash_lua")

		if hTarget and hUnleash:IsTrained() then
			hTarget:AddNewModifier(hCaster, hUnleash, "modifier_marci_unleash_lua_passive", nil)
			hTarget:AddNewModifier(hCaster, hUnleash, "modifier_marci_unleash_lua_fury", { type = MARCI_UNLEASH_STACK_SIDEKICK})
		end
	end

	if hCaster:HasShard("pathfinder_marci_bodyguard_kick") then
		local nHealthPctPerKick = hCaster:FindTalentValue("pathfinder_marci_bodyguard_kick", "health_percent_per_kick")
		local nKicks = math.floor((100 - hTarget:GetHealthPercent()) / nHealthPctPerKick) + 1

		for i = 1, nKicks do
			Timers:CreateTimer((i-1) * 0.1, function() self:DoKick(hTarget) end)
		end
	end
end
--------------------------------------------------------------------------------

function marci_pf_bodyguard:DoKick(hTarget)
	local hCaster = self:GetCaster()
	local nRadius = hCaster:FindTalentValue("pathfinder_marci_bodyguard_kick", "radius")
	local nKickDuration = 0.5

	local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), hTarget:GetOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_DAMAGE_FLAG_NONE, 0, false)

	local nStartAngle = VectorToAngles(hTarget:GetForwardVector()).y
	local vOrigin = hTarget:GetAbsOrigin()

	local tEnemyAngles = {}

	for _, hEnemy in pairs(hEnemies) do
		local vDir = (hEnemy:GetAbsOrigin() - vOrigin):Normalized()
		local nDirAngle = (360 - (VectorToAngles(vDir).y - nStartAngle)) % 360

		tEnemyAngles[hEnemy] = nDirAngle
	end

	table.sort(hEnemies, function(a,b) return tEnemyAngles[a] <= tEnemyAngles[b] end)

	for _, hEnemy in ipairs(hEnemies) do
		local nDelay = tEnemyAngles[hEnemy] / 360 * nKickDuration

		Timers:CreateTimer(nDelay, function() 
			if IsValidEntity(hEnemy) and IsValidEntity(hTarget) and hEnemy:IsAlive() and hTarget:IsAlive() then
				hTarget:PerformAttack(hEnemy, false, true, true, false, hTarget:IsRangedAttacker(), false, false)
			end
		end)
	end
end

--------------------------------------------------------------------------------

modifier_marci_pf_bodyguard_self = class({})

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguard_self:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguard_self:OnCreated()
	if IsClient() then return end
	local hAbility = self:GetAbility()

	self.nAttackRangeBuffer = hAbility:GetSpecialValueFor("bodyguard_attack_range_buffer")
	self.nAttackCooldown = hAbility:GetSpecialValueFor("counter_cooldown")
	self.bReadyToCounter = true
	self.nSharedLifesteal = hAbility:GetSpecialValueFor("shared_healing_percent") / 100
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguard_self:OnRefresh()
	self.nAttackCooldown = self:GetAbility():GetSpecialValueFor("counter_cooldown")
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguard_self:OnIntervalThink()
	self.bReadyToCounter = true
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguard_self:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED
	}
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguard_self:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguard_self:OnAttacked(event)
	if IsClient() then return end
	local hAttacker = event.attacker
	local hTarget = event.target
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	if not hTarget or hTarget:IsBuilding() or hTarget:IsOther() then return end

	if hAttacker == self:GetParent() then
		local nLifesteal = event.damage * hAbility:GetSpecialValueFor("lifesteal_pct") / 100
		local hCurrentAlly = hAbility.hCurrentAlly

		hAttacker:HealWithParams(nLifesteal, hAbility, true, true, hCaster, false)

		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
		)

		if self.nSharedLifesteal > 0 and hCurrentAlly and hCurrentAlly:HasModifier("modifier_marci_pf_bodyguarded") then
			hCurrentAlly:HealWithParams(nLifesteal * self.nSharedLifesteal, hAbility, true, true, hCaster, false)
			ParticleManager:ReleaseParticleIndex(
				ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCurrentAlly)
			)
		end
	elseif (hAttacker:HasModifier("modifier_marci_pf_bodyguarded") or hTarget:HasModifier("modifier_marci_pf_bodyguarded_enemy")) and (hTarget:GetOrigin() - hCaster:GetOrigin()):Length2D() <= (hCaster:Script_GetAttackRange() + self.nAttackRangeBuffer) and self.bReadyToCounter then
		self.bReadyToCounter = false

		hCaster:PerformAttack(hTarget, false, true, true, false, false, false, false)
		hCaster:ForcePlayActivityOnce(ACT_DOTA_ATTACK)

		self:StartIntervalThink(self.nAttackCooldown)
	elseif (hTarget:HasModifier("modifier_marci_pf_bodyguarded") or hAttacker:HasModifier("modifier_marci_pf_bodyguarded_enemy")) and (hAttacker:GetOrigin() - hCaster:GetOrigin()):Length2D() <= (hCaster:Script_GetAttackRange() + self.nAttackRangeBuffer) and self.bReadyToCounter then
		self.bReadyToCounter = false

		hCaster:PerformAttack(hAttacker, false, true, true, false, false, false, false)
		hCaster:ForcePlayActivityOnce(ACT_DOTA_ATTACK)

		self:StartIntervalThink(self.nAttackCooldown)		
	end
end

--------------------------------------------------------------------------------

modifier_marci_pf_bodyguarded = class({})

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:OnCreated()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()

	self.nSharedPct = hAbility:GetSpecialValueFor("max_partner_penalty") / 100
	self.nLifesteal = (hAbility:GetSpecialValueFor("lifesteal_pct") / 100) * self.nSharedPct
	self.nDamagePct = hAbility:GetSpecialValueFor("bonus_damage") * self.nSharedPct

	self.nHealShare = hAbility:GetSpecialValueFor("shared_healing_percent") / 100

	if IsClient() then
		local nBuffFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(nBuffFX, 0, hParent, PATTACH_OVERHEAD_FOLLOW, nil, Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(nBuffFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
		ParticleManager:SetParticleControl(nBuffFX, 2, Vector(1, 0, 0))
		self:AddParticle(nBuffFX, false, false, -1, false, true)
		return
	end

	local nRangeFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_bodyguard_radius.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(nRangeFX, 1, Vector(hCaster:Script_GetAttackRange() + hAbility:GetSpecialValueFor("bodyguard_attack_range_buffer"), 0, 0))
	self:AddParticle(nRangeFX, false, false, -1, false, false)
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED
	}
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:GetModifierBaseDamageOutgoing_Percentage()
	return self.nDamagePct
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:OnAttacked(event)
	if IsClient() then return end
	local hAttacker = event.attacker
	local hTarget = event.target
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	if hAttacker ~= self:GetParent() or not hTarget or hTarget:GetTeam() == hAttacker:GetTeam() or hTarget:IsBuilding() or hTarget:IsOther() then return end

	local nLifesteal = event.damage * self.nLifesteal

	hAttacker:HealWithParams(nLifesteal, hAbility, true, true, hCaster, false)

	if self.nHealShare > 0 and hCaster:IsAlive() then
		hCaster:HealWithParams(nLifesteal * self.nHealShare, hAbility, true, true, hCaster, false)
		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		)
	end

	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
	)
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded:ShouldUseOverheadOffset()
	return true
end

--------------------------------------------------------------------------------

modifier_marci_pf_bodyguarded_enemy = class({})

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded_enemy:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded_enemy:OnCreated()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()

	if IsClient() then
		local nDebuffFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_sidekick_debuff.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(nDebuffFX, 0, hParent, PATTACH_OVERHEAD_FOLLOW, nil, Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(nDebuffFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
		ParticleManager:SetParticleControl(nDebuffFX, 2, Vector(1, 0, 0))
		self:AddParticle(nDebuffFX, false, false, -1, false, true)
		return
	end

	local nRangeFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_bodyguard_radius_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(nRangeFX, 1, Vector(hCaster:Script_GetAttackRange() + hAbility:GetSpecialValueFor("bodyguard_attack_range_buffer"), 0, 0))
	self:AddParticle(nRangeFX, false, false, -1, false, false)
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded_enemy:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded_enemy:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

function modifier_marci_pf_bodyguarded_enemy:ShouldUseOverheadOffset()
	return true
end