LinkLuaModifier("modifier_dragon_knight_pf_dragon_blood", 				"heroes/dragon_knight/dragon_knight_pf_dragon_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_knight_pf_corrosive_breath_dot", 		"heroes/dragon_knight/dragon_knight_pf_dragon_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_knight_pf_frost_breath_slow", 			"heroes/dragon_knight/dragon_knight_pf_dragon_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_knight_pf_dragon_blood_boiling_veins", "heroes/dragon_knight/dragon_knight_pf_dragon_blood", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

dragon_knight_pf_dragon_blood = class({})

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_corrosion_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context)
    PrecacheResource("particle", "particles/generic_gameplay/generic_slowed_cold.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_frost.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb_fire.vpcf", context)
	PrecacheResource("particle", "particles/items3_fx/fish_bones_active.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", context)	
end

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:GetIntrinsicModifierName()
    return "modifier_dragon_knight_pf_dragon_blood"
end

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:GetCastPoint()
	return self:GetCaster():FindTalentValue("pathfinder_dk_dragon_blood_active", "cast_point")
end

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:GetCooldown(iLevel)
	return self:GetCaster():FindTalentValue("pathfinder_dk_dragon_blood_active", "cooldown")
end

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:GetCastRange(vLocation, hTarget)
	return self:GetCaster():FindTalentValue("pathfinder_dk_dragon_blood_active", "radius")
end

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:GetBehavior()
	if self:GetCaster():HasShard("pathfinder_dk_dragon_blood_active") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return self.BaseClass.GetBehavior(self)
	end	
end

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:GetCastAnimation()
	return self:GetCaster():HasModifier("modifier_dragon_knight_pf_elder_dragon_form") and ACT_DOTA_CAST_ABILITY_5 or ACT_DOTA_VICTORY
end

--------------------------------------------------------------------------------

function dragon_knight_pf_dragon_blood:OnSpellStart()
	local hCaster = self:GetCaster()
	local nDuration = hCaster:FindTalentValue("pathfinder_dk_dragon_blood_active", "duration")
	local nRadius = hCaster:FindTalentValue("pathfinder_dk_dragon_blood_active", "radius")
	local nStunDuration = hCaster:FindTalentValue("pathfinder_dk_dragon_blood_active", "stun_duration")
	local nRegenToDamagePct = hCaster:FindTalentValue("pathfinder_dk_dragon_blood_active", "regen_damage_mult") / 100
	
	local vOrigin = hCaster:GetOrigin()

	local hKV = {
		knockback_duration = 0.35,
		duration = 0.35,
		knockback_distance = 250,
		knockback_height = 30,
		should_stun = false,
		center_x = hCaster:GetAbsOrigin().x,
		center_y = hCaster:GetAbsOrigin().y,
		center_z = hCaster:GetAbsOrigin().z,
	}

	local tDamageTable = {
		attacker = hCaster,
		victim = nil,
		damage = hCaster:GetHealthRegen() * nRegenToDamagePct,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}

	local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), vOrigin, nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	for _, hEnemy in pairs(hEnemies) do
		hKV.knockback_distance = nRadius - (vOrigin - hEnemy:GetOrigin()):Length2D()
		tDamageTable.victim = hEnemy

		hEnemy:RemoveModifierByName("modifier_knockback")
		hEnemy:AddNewModifier(hCaster, self, "modifier_knockback", hKV)	
		hEnemy:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nStunDuration})	
		ApplyDamage(tDamageTable)

		Timers:CreateTimer(0.35 + FrameTime(), function()
			if hEnemy and not hEnemy:IsNull() and hEnemy:IsAlive() then
				FindClearSpaceForUnit(hEnemy, hEnemy:GetOrigin(), false)
			end
		end)
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_minotaur_horn_immune", {duration = nDuration})
	hCaster:EmitSound("Hero_DragonKnight.ElderDragonForm")
	
	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	)
end

--------------------------------------------------------------------------------

modifier_dragon_knight_pf_dragon_blood = class({})

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:IsPurgable()	return false end
function modifier_dragon_knight_pf_dragon_blood:IsHidden()		return true end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:OnCreated(kv)
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	self.bGreenDragon = hAbility:GetSpecialValueFor("is_green_dragon") > 0
	self.bRedDragon = hAbility:GetSpecialValueFor("is_red_dragon") > 0
	self.bBlueDragon = hAbility:GetSpecialValueFor("is_blue_dragon") > 0

	self.nMagicDamage = hAbility:GetSpecialValueFor("magic_damage")

	local hDragonAbility = hCaster:FindAbilityByName("dragon_knight_pf_elder_dragon_form")

	if hDragonAbility then
		self.nSplashRadius = hDragonAbility:GetLevelSpecialValueFor("ranged_splash_radius", 1)
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:OnRefresh(kv)
	local hAbility = self:GetAbility()
	
	self.nMagicDamage = hAbility:GetSpecialValueFor("magic_damage")
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:OnAttackLanded(event)
	if IsClient() or event.attacker ~= self:GetParent() then return end
	local hTarget = event.target

	if self.bGreenDragon then
		self:CorrosiveAttack(hTarget)
	elseif self.bBlueDragon then
		self:ColdAttack(hTarget)
	end	
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:GetModifierProcAttack_BonusDamage_Magical(event)
	if IsClient() or not self.bRedDragon then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hTarget = event.target

	if hParent:IsIllusion() then return end

	if hCaster:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") or self:GetStackCount() == 1 then
		local tDamageTable = {
			attacker = hParent,
			victim = nil,
			damage = self.nMagicDamage * (1 + (hParent:FindAbilityByName("dragon_knight_pf_elder_dragon_form"):GetSpecialValueFor("fire_breath_effect_bonus") / 100)),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility
		}

		local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), hTarget:GetOrigin(), nil, self.nSplashRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				tDamageTable.victim = hEnemy
				ApplyDamage(tDamageTable)
			end
		end

		self:SetStackCount(0)
	end

	if not hTarget:IsBuilding() and not hTarget:IsOther() then
		return self.nMagicDamage
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:CorrosiveAttack(hTarget)
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local nDuration = hAbility:GetSpecialValueFor("corrosive_breath_duration")

	hTarget:AddNewModifier(hCaster, hAbility, "modifier_dragon_knight_pf_corrosive_breath_dot", {duration = nDuration * (1 - hTarget:GetStatusResistance())})

	if hCaster:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") or self:GetStackCount() == 1 then
		local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), hTarget:GetOrigin(), nil, self.nSplashRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				hEnemy:AddNewModifier(hCaster, hAbility, "modifier_dragon_knight_pf_corrosive_breath_dot", {duration = nDuration * (1 - hEnemy:GetStatusResistance())})
			end
		end

		self:SetStackCount(0)
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood:ColdAttack(hTarget)
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local nDuration = hAbility:GetSpecialValueFor("frost_duration")

	hTarget:AddNewModifier(hCaster, hAbility, "modifier_dragon_knight_pf_frost_breath_slow", {duration = nDuration * (1 - hTarget:GetStatusResistance())})

	if hCaster:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") or self:GetStackCount() == 1 then
		local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), hTarget:GetOrigin(), nil, self.nSplashRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				hEnemy:AddNewModifier(hCaster, hAbility, "modifier_dragon_knight_pf_frost_breath_slow", {duration = nDuration * (1 - hEnemy:GetStatusResistance())})
			end
		end

		self:SetStackCount(0)
	end
end

--------------------------------------------------------------------------------

modifier_dragon_knight_pf_corrosive_breath_dot = class({})

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:OnCreated()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	self.nDamage = hAbility:GetSpecialValueFor("corrosive_breath_damage")
	self.nArmorReduction = -hAbility:GetSpecialValueFor("corrosive_breath_armor_reduction")

	if hCaster:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") or hCaster:GetModifierStackCount("modifier_dragon_knight_pf_dragon_blood", hCaster) == 1 then
		local hDragonAbility = hCaster:FindAbilityByName("dragon_knight_pf_elder_dragon_form")

		if hDragonAbility then
			local nBonus = hDragonAbility:GetSpecialValueFor("corrosive_breath_effect_bonus") / 100
			
			self.nDamage = self.nDamage * (1 + nBonus)
			self.nArmorReduction = self.nArmorReduction * (1 + nBonus)
		end
	end

	if IsClient() then return end

	self.tDamageTable = {
		attacker = hCaster,
		victim = self:GetParent(),
		damage = self.nDamage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = hAbility
	}

	self:StartIntervalThink(1)
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:OnRefresh()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	self.nDamage = hAbility:GetSpecialValueFor("corrosive_breath_damage")
	self.nArmorReduction = -hAbility:GetSpecialValueFor("corrosive_breath_armor_reduction")

	if hCaster:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") then
		local hDragonAbility = hCaster:FindAbilityByName("dragon_knight_pf_elder_dragon_form")

		if hDragonAbility then
			local nBonus = hDragonAbility:GetSpecialValueFor("corrosive_breath_effect_bonus") / 100
			
			self.nDamage = self.nDamage * (1 + nBonus)
			self.nArmorReduction = self.nArmorReduction * (1 + nBonus)
		end
	end

	if IsClient() then return end
	self.tDamageTable.damage = self.nDamage
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:OnIntervalThink()
	ApplyDamage(self.tDamageTable)
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:OnTooltip()
	return self.nDamage
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:GetModifierPhysicalArmorBonus()
	return self.nArmorReduction
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:GetEffectName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_corrosion_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_corrosive_breath_dot:GetTexture()
	return "dragon_knight_corrosive"
end

--------------------------------------------------------------------------------

modifier_dragon_knight_pf_frost_breath_slow = class({})

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:OnCreated()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	self.nDamage = hAbility:GetSpecialValueFor("corrosive_breath_damage")
	self.nArmorReduction = hAbility:GetSpecialValueFor("corrosive_breath_armor_reduction")

	if hCaster:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") then
		local hDragonAbility = hCaster:FindAbilityByName("dragon_knight_pf_elder_dragon_form")

		if hDragonAbility then
			local nBonus = hDragonAbility:GetSpecialValueFor("corrosive_breath_effect_bonus") / 100
			
			self.nDamage = self.nDamage * (1 + nBonus)
			self.nArmorReduction = self.nArmorReduction * (1 + nBonus)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:OnRefresh()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	self.nMoveSlow = hAbility:GetSpecialValueFor("frost_bonus_movement_speed")
	self.nAttackSlow = hAbility:GetSpecialValueFor("frost_bonus_attack_speed")
	self.nHealReduction = -hAbility:GetSpecialValueFor("frost_healing_reduction")
	
	if hCaster:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") or hCaster:GetModifierStackCount("modifier_dragon_knight_pf_dragon_blood", hCaster) == 1 then
		local hDragonAbility = hCaster:FindAbilityByName("dragon_knight_pf_elder_dragon_form")

		if hDragonAbility then
			local nBonus = hDragonAbility:GetSpecialValueFor("frost_breath_effect_bonus") / 100
			
			self.nMoveSlow = self.nMoveSlow * (1 + nBonus)
			self.nAttackSlow = self.nAttackSlow * (1 + nBonus)
			self.nHealReduction = self.nHealReduction * (1 + nBonus)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.nMoveSlow
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetModifierAttackSpeedBonus_Constant()
	return self.nAttackSlow
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetModifierHealAmplify_PercentageTarget()
	return self.nHealReduction
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetModifierHPRegenAmplify_Percentage()
	return self.nHealReduction
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetModifierLifestealRegenAmplify_Percentage()
	return self.nHealReduction
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetModifierSpellLifestealRegenAmplify_Percentage()
	return self.nHealReduction
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_frost_breath_slow:GetTexture()
	return "dragon_knight_frost"
end

--------------------------------------------------------------------------------

modifier_dragon_knight_pf_dragon_blood_boiling_veins = class({})

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood_boiling_veins:IsPurgable()		return false end
function modifier_dragon_knight_pf_dragon_blood_boiling_veins:RemoveOnDeath()	return false end
function modifier_dragon_knight_pf_dragon_blood_boiling_veins:IsPermanent()		return true end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood_boiling_veins:OnCreated()
	if IsClient() then return end
	self.nMaxStacks = self:GetParent():FindTalentValue("pathfinder_dk_dragon_blood_damage", "max_stack")

	self:SetStackCount(0)	
	self:StartIntervalThink(1)
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood_boiling_veins:OnIntervalThink()
	local hParent = self:GetParent()

	local nMaxStack = math.ceil(hParent:GetHealthRegen()) * self.nMaxStacks

	if self:GetStackCount() < nMaxStack then
		local nNewStack = self:GetStackCount() + math.ceil(hParent:GetHealthRegen())

		if nNewStack >= nMaxStack then
			nNewStack = nMaxStack

			if not self.nFireFX then
				local sAttachment = hParent:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") and "attach_attack1" or "attach_weapon"
				self.nFireFX = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker_kid/invoker_kid_exort_orb_fire.vpcf", PATTACH_POINT_FOLLOW, hParent)
				ParticleManager:SetParticleControlEnt(self.nFireFX, 3, hParent, PATTACH_POINT_FOLLOW, sAttachment, Vector(0, 0, 0), true)
			end
		end

		self:SetStackCount(nNewStack)
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood_boiling_veins:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_dragon_blood_boiling_veins:OnAttackLanded(event)
	if IsClient() or event.attacker ~= self:GetParent() or event.no_attack_cooldown then return end
	local hAttacker = event.attacker
	local hTarget = event.target

	ApplyDamage({
		victim = hTarget,
		attacker = hAttacker,
		damage = self:GetStackCount(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	})

	local nMaxStack = math.ceil(hAttacker:GetHealthRegen()) * self.nMaxStacks

	if self:GetStackCount() >= nMaxStack then
		hAttacker:HealWithParams(event.damage, self:GetAbility(), false, true, hAttacker, false)

		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
		)

		hTarget:EmitSound("Dungeon.BloodSplatterImpact.Lesser")

		if self.nFireFX then
			ParticleManager:DestroyParticle(self.nFireFX, false)
			ParticleManager:ReleaseParticleIndex(self.nFireFX)
			self.nFireFX = nil
		end
	end

	self:SetStackCount(0)
	self:StartIntervalThink(1)
end