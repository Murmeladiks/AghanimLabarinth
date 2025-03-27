LinkLuaModifier("modifier_bristleback_shock_and_awe", "heroes/bristleback/warpath_pf/modifier_bristleback_shock_and_awe", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

modifier_bristleback_warpath_pf = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:IsHidden()
	if self:GetStackCount() >= 1 then
		return false
	else
		return true
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:GetEffectName()
	if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("max_stacks") / 2 then
		return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf"
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:OnCreated()
	if IsClient() then return end
	self.shock_lock = true
	self:StartIntervalThink(0.1)
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:OnIntervalThink()
	local parent = self:GetParent()

	local shock_and_awe = parent:FindAbilityByName("pathfinder_bristleback_warpath_shock_and_awe")
	if not shock_and_awe or not shock_and_awe:IsTrained() then return end

	parent:AddNewModifier(parent, self:GetAbility(), "modifier_bristleback_shock_and_awe", {})
	self:StartIntervalThink(-1)
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:GetModifierPreAttack_BonusDamage(keys)
	if not self:GetParent():IsIllusion() then
		-- Need to call this somewhere other than OnCreated since it can be boosted by talent
		local damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack") + self:GetCaster():FindTalentValue("special_bonus_imba_bristleback_3")

		if self:GetParent():HasModifier("modifier_bristleback_warpath_active") then
			return damage_per_stack * self:GetStackCount() * (1 + (self:GetAbility():GetSpecialValueFor("active_bonus_attack_percent") / 100))
		else
			return damage_per_stack * self:GetStackCount()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("aspd_per_stack") * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:GetModifierMoveSpeedBonus_Percentage(keys)
	if self:GetParent():HasModifier("modifier_bristleback_warpath_active") then
		return (self:GetAbility():GetSpecialValueFor("move_speed_per_stack") * self:GetStackCount()) * (1 + (self:GetAbility():GetSpecialValueFor("active_bonus_movement_percent") / 100))
	else
		return self:GetAbility():GetSpecialValueFor("move_speed_per_stack") * self:GetStackCount()
	end
end

--------------------------------------------------------------------------------

-- Gonna ignore the mechanic that updates stacks for illusions too for now
function modifier_bristleback_warpath_pf:OnAbilityFullyCast(keys)
	local ability = keys.ability
	if ability and keys.unit == self:GetParent() and not self:GetParent():PassivesDisabled() and not ability:IsItem() and ability:GetName() ~= "ability_aghsfort_capture" then
		self:ProcWarpath()
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:ProcWarpath()
	self:SetDuration(self:GetAbility():GetSpecialValueFor("stack_duration"), true)
	self:AddIndependentStack(1, self:GetAbility():GetSpecialValueFor("stack_duration"), self:GetAbility():GetSpecialValueFor("max_stacks"), false)
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:GetModifierModelScale()
	return self:GetStackCount() * 5
end

--------------------------------------------------------------------------------

--
-- Mega Wallop Section
--
function modifier_bristleback_warpath_pf:GetModifierPreAttack_CriticalStrike()
	local mega_wallop = self:GetParent():FindAbilityByName("pathfinder_bristleback_warpath_mega_wallop")
	if not ((mega_wallop and not mega_wallop:IsNull()) and self:GetStackCount() == self:GetAbility():GetSpecialValueFor("max_stacks")) then return end
	
	return mega_wallop:GetSpecialValueFor("crit_multiplier") + mega_wallop:GetSpecialValueFor("crit_per_stack") * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:GetCritDamage()
	local mega_wallop = self:GetParent():FindAbilityByName("pathfinder_bristleback_warpath_mega_wallop")
	if not (mega_wallop and not mega_wallop:IsNull()) then return end
	
	return (mega_wallop:GetSpecialValueFor("crit_multiplier") + mega_wallop:GetSpecialValueFor("crit_per_stack") * self:GetStackCount()) / 100
end

--------------------------------------------------------------------------------

local legal_repos_drop_table = {
	"item_health_potion",
	"item_mana_potion",
	"item_bag_of_gold"
}

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:GetModifierProcAttack_Feedback(kv)
	local target = kv.target
	if not target or target:IsNull() then return end

	local legal_repos = self:GetParent():FindAbilityByName("pathfinder_bristleback_warpath_legal_repossession")
	if (legal_repos and not legal_repos:IsNull()) and RollPercentage(self:GetStackCount() * legal_repos:GetSpecialValueFor("chance_per_warpath")) then
		local rolled_item_name = legal_repos_drop_table[math.random(#legal_repos_drop_table)]
		local rolled_item = CreateItem(rolled_item_name, nil, nil)
		CreateItemOnPositionForLaunch(target:GetAbsOrigin(), rolled_item)
		
		rolled_item:SetPurchaseTime(0)
		if rolled_item_name == "item_bag_of_gold" then
			rolled_item:SetCurrentCharges(legal_repos:GetSpecialValueFor("gold_amount"))
		end

		rolled_item:LaunchLootInitialHeight(true, 0, 100, 0.5, target:GetAbsOrigin() + self:GetParent():GetForwardVector() * legal_repos:GetSpecialValueFor("item_distance"))
		EmitSoundOn( "Dungeon.TreasureItemDrop", target )
	end

	local mega_wallop = self:GetParent():FindAbilityByName("pathfinder_bristleback_warpath_mega_wallop")
	if not ((mega_wallop and not mega_wallop:IsNull()) and self:GetStackCount() == self:GetAbility():GetSpecialValueFor("max_stacks")) then return end

	if self.lock == true then return end
	self.lock = true
	local radius = mega_wallop:GetSpecialValueFor("knockup_radius")

	target:EmitSound("Bristleback.MegaWallop.Punch")
	self:MegaWallopResponse()

	local pfx = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_burst.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), 
		target:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
		if not (target == enemy) then
			self:GetParent():PerformAttack(enemy, true, true, true, false, true, false, false)
		end
		enemy:AddNewModifier(enemy, mega_wallop, "modifier_bristleback_mega_wallop_stun", {duration = mega_wallop:GetSpecialValueFor("knockup_time")})
	end

	self:CancelIndependentStacks()
	self.lock = false
end

--------------------------------------------------------------------------------

local mega_wallop_response_list = {
	"bristleback_bristle_attack_01",
	"bristleback_bristle_attack_03",
	"bristleback_bristle_attack_04",
	"bristleback_bristle_attack_05",
	"bristleback_bristle_attack_06",
	"bristleback_bristle_attack_12",
	"bristleback_bristle_attack_13",
	"bristleback_bristle_attack_17",
	"bristleback_bristle_attack_18",
	"bristleback_bristle_attack_20"
}

--------------------------------------------------------------------------------

function modifier_bristleback_warpath_pf:MegaWallopResponse()
	self:GetParent():EmitSound(mega_wallop_response_list[math.random(#mega_wallop_response_list)])
end


