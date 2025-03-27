LinkLuaModifier("modifier_jakiro_pf_liquid_fire", 			"heroes/jakiro/jakiro_pf_liquid_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_pf_liquid_fire_debuff", 	"heroes/jakiro/jakiro_pf_liquid_fire", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

jakiro_pf_liquid_fire = class({})

--------------------------------------------------------------------------------

function jakiro_pf_liquid_fire:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_ready.vpcf", context)
end

--------------------------------------------------------------------------------

function jakiro_pf_liquid_fire:GetIntrinsicModifierName()
	return "modifier_jakiro_pf_liquid_fire"
end

--------------------------------------------------------------------------------

function jakiro_pf_liquid_fire:GetCastRange( vLocation, hTarget )
	return math.max(self.BaseClass.GetCastRange(self, vLocation, hTarget), self:GetCaster():Script_GetAttackRange())
end

--------------------------------------------------------------------------------

modifier_jakiro_pf_liquid_fire = class({})

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:IsPurgable()	return false end
function modifier_jakiro_pf_liquid_fire:IsHidden()		return true end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:OnCreated( kv )
	if IsClient() then return end
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()

	self.nDuration = hAbility:GetDuration()
	self.nRadius = hAbility:GetSpecialValueFor("radius")
	self.tAttackRecords = {}

	if hParent:IsIllusion() then
		self:Destroy()
		return
	end

	self.nReadyFX = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_ready.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.nReadyFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0, 0, 0), true)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:OnIntervalThink()
	if not self:GetAbility():IsCooldownReady() then return end
	self:StartIntervalThink(-1)
	local hParent = self:GetParent()

	self.nReadyFX = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_ready.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(self.nReadyFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0, 0, 0), true)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:OnAttack( event )
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

	hAttacker:EmitSound("Hero_Jakiro.LiquidFire")

	hAbility:UseResources(true, false, false, true)

	local hIce = hAttacker:FindAbilityByName("jakiro_pf_liquid_ice")

	if hIce then
		hIce:UseResources(false, false, false, true)
	end

	if self.nReadyFX then
		ParticleManager:DestroyParticle(self.nReadyFX, false)
		ParticleManager:ReleaseParticleIndex(self.nReadyFX)
		self.nReadyFX = nil
	end

	self:StartIntervalThink(0.1)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:GetModifierProcAttack_Feedback( event )
	if IsClient() or not self.tAttackRecords[event.record] then return end
	local hAttacker = self:GetParent()
	local hTarget = event.target
	local hAbility = self:GetAbility()

	if not hTarget or hTarget:IsInvulnerable() or hTarget:IsAttackImmune() then
		return 0
	end

	local hEnemies = FindUnitsInRadius(hAttacker:GetTeam(), hTarget:GetOrigin(), nil, self.nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 0, false)

	for _, hEnemy in pairs(hEnemies) do
		hEnemy:AddNewModifier(hAttacker, hAbility, "modifier_jakiro_pf_liquid_fire_debuff", {duration = self.nDuration * (1 - hEnemy:GetStatusResistance())})
	end

	hTarget:EmitSound("Hero_Jakiro.LiquidFire")

	local nImpactFX = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(nImpactFX, 1, Vector(self.nRadius, 0, 0))		
	ParticleManager:ReleaseParticleIndex(nImpactFX)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:GetModifierProjectileName(event)
	if IsServer() then
		if (self:CanUseOrb() and self:CanUseProjectile()) or (self:GetParent():GetCurrentActiveAbility() == self:GetAbility()) then
			return "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf"
		end
	end
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:GetPriority()
	if self:CanUseOrb() and self:CanUseProjectile() or self:GetParent():GetCurrentActiveAbility() == self:GetAbility() then
		return MODIFIER_PRIORITY_SUPER_ULTRA
	end
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:OnAttackRecordDestroy(event)
	self.tAttackRecords[event.record] = nil
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:CanUseOrb()
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

function modifier_jakiro_pf_liquid_fire:IsValidTarget(hTarget)
	local hAttacker = self:GetParent()

	if not hTarget or hTarget:IsNull() or not IsValidEntity(hTarget) or not hTarget:IsAlive() then
		return false
	end

	if hTarget:GetClassname() == "dota_item_drop" then
		return false
	end

	if hTarget:IsInvulnerable() or hTarget:IsOther() or hTarget:GetTeamNumber() == hAttacker:GetTeamNumber() then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire:CanUseProjectile()
	local hAttacker = self:GetParent()
	local hTarget = hAttacker:GetAggroTarget() or hAttacker:GetCursorCastTarget()

	if not self:IsValidTarget(hTarget) then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

modifier_jakiro_pf_liquid_fire_debuff = class({})

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:OnCreated( kv )
	local hAbility = self:GetAbility()

	self.nAttackSlow = hAbility:GetSpecialValueFor("slow_attack_speed_pct")
	self.nDamage = hAbility:GetSpecialValueFor("damage")
	self.nInterval = hAbility:GetSpecialValueFor("tick_rate")
	
	if IsClient() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	self.bIsBuilding = hParent:IsBuilding()

	if self.bIsBuilding then
		self.nDamage = self.nDamage * hAbility:GetSpecialValueFor("building_dmg_pct") / 100
	end

	self.tDamageTable = {
		attacker = hCaster,
		victim = hParent,
		damage = self.nDamage * self.nInterval,
		damage_type = hAbility:GetAbilityDamageType(),
		ability = hAbility
	}

	self:StartIntervalThink(self.nInterval)

	if hCaster:HasShard("pathfinder_jakiro_liquid_fire_burst") then
		local nBurstDamage = (self.nDamage * hCaster:FindTalentValue("pathfinder_jakiro_liquid_fire_burst", "burst_damage") / 100) * self:GetDuration()
		ApplyDamage({
			attacker = hCaster,
			victim = hParent,
			damage = nBurstDamage,
			damage_type = hAbility:GetAbilityDamageType(),
			ability = hAbility
		})

		SendOverheadEventMessage(hCaster:GetPlayerOwner(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, hParent, nBurstDamage, hCaster:GetPlayerOwner())
	end
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:OnRefresh()
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	self.nDamage = hAbility:GetSpecialValueFor("damage")

	if self.bIsBuilding then
		self.nDamage = self.nDamage * hAbility:GetSpecialValueFor("building_dmg_pct") / 100
	end

	self.tDamageTable.damage = self.nDamage * self.nInterval
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:OnIntervalThink()
	ApplyDamage(self.tDamageTable)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:DeclareFunctions()
	local tFunctions = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}

	if self:GetCaster():HasShard("pathfinder_jakiro_liquid_fire_macropyre") then
		table.insert(tFunctions, MODIFIER_EVENT_ON_DEATH)
	end

	return tFunctions
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.nAttackSlow
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:OnTooltip()
	return self.nDamage
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:OnDeath(event)
	if IsClient() or event.unit ~= self:GetParent() then return end
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hMacropyre = hCaster:FindAbilityByName("jakiro_macropyre_lua")

	if not hMacropyre or not hMacropyre:IsTrained() or not RollPseudoRandomPercentage(hCaster:FindTalentValue("pathfinder_jakiro_liquid_fire_macropyre", "chance"), DOTA_PSEUDO_RANDOM_CUSTOM_GAME_6, hCaster) then return end

	local nRadius = hMacropyre:GetSpecialValueFor("path_radius")

	local vStart = hParent:GetAbsOrigin() + hParent:GetForwardVector() * (nRadius / 4)
	local vEnd = hParent:GetAbsOrigin() + hParent:GetForwardVector() * -1 * (nRadius / 4)

	hMacropyre:MakeMacropyreAt(vStart, vEnd, hMacropyre:GetSpecialValueFor("duration") * hCaster:FindTalentValue("pathfinder_jakiro_liquid_fire_macropyre", "duration") / 100)
end

--------------------------------------------------------------------------------

function modifier_jakiro_pf_liquid_fire_debuff:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end