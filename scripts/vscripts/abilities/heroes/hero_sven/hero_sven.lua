remake_storm_bolt = class({})

LinkLuaModifier("modifier_remake_storm_bolt_caster", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_remake_storm_bolt_crit_buff", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_remake_storm_bolt_storm_attsp", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)

function remake_storm_bolt:IsHiddenWhenStolen() 		return false end
function remake_storm_bolt:IsRefreshable() 			return true end
function remake_storm_bolt:IsStealable() 			return true end
function remake_storm_bolt:IsNetherWardStealable()	return true end
function remake_storm_bolt:GetAOERadius() return self:GetSpecialValueFor("bolt_aoe") end
function remake_storm_bolt:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasModifier("modifier_remake_storm_bolt_rush") then
		return self:GetSpecialValueFor("cast_range") * 2
	else
		return self:GetSpecialValueFor("cast_range")
	end
end

function remake_storm_bolt:GetCooldown(level)
	local caster = self:GetCaster()
	local modifier_anger = "modifier_remake_sven_gods_strength_anger"
	local modifier_god = "modifier_imba_god_strength"
	local cooldown = self.BaseClass.GetCooldown(self, level)
	if caster:HasModifier(modifier_god) and caster:HasModifier(modifier_anger) then
		local pct_cd = self:GetCaster():GetModifierStackCount("modifier_remake_sven_gods_strength_anger", nil)			
		cooldown = cooldown * (1-pct_cd/100)					
	end
	return cooldown
end

function remake_storm_bolt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("Hero_Sven.StormBolt")
	if caster:HasAbility("remake_storm_bolt_rush") then 
		caster:AddNewModifier(caster, self, "modifier_remake_storm_bolt_caster", {duration = 3})		
    end
	if caster:HasAbility("remake_storm_bolt_crit") then 		
		caster:AddNewModifier(caster, self, "modifier_remake_storm_bolt_crit_buff", {duration = 5})	
    end
	local pfxname = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf"
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfxname,
		iMoveSpeed = self:GetSpecialValueFor("bolt_speed"),
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function remake_storm_bolt:OnProjectileHit(target, location)
	local hTarget = target or self:GetCaster()
	local caster = self:GetCaster()
	hTarget:EmitSound("Hero_Sven.StormBoltImpact")
	if hTarget ~= self:GetCaster() then
		if hTarget:TriggerStandardTargetSpell(self) or hTarget:IsMagicImmune() then
			self:GetCaster():RemoveModifierByName("modifier_remake_storm_bolt_caster")
			self:GetCaster():RemoveModifierByName("modifier_remake_storm_bolt_crit")
			return
		end
		local radius = self:GetSpecialValueFor("bolt_aoe")
		local dmg = self:GetSpecialValueFor("damage")		

		local hero_att = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())
		
		local finaldamage = dmg
		if caster:HasModifier("modifier_remake_sven_gods_strength_anger") and caster:HasModifier("modifier_imba_god_strength") then
			local pct_ability = caster:FindAbilityByName("remake_sven_gods_strength")
			local pct_dmg = pct_ability:GetSpecialValueFor("gods_strength_damage")*0.5
			finaldamage = (pct_dmg/100) * finaldamage
		end	
		
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("bolt_stun_duration")})
			local damageTable = {
								victim = enemy,
								attacker = self:GetCaster(),
								damage = finaldamage,
								damage_type = self:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}
			ApplyDamage(damageTable)

			-- if self:GetCaster():HasModifier("modifier_remake_storm_bolt_crit") then
			-- 	local rush_stack = self:GetCaster():GetModifierStackCount("modifier_remake_storm_bolt_crit", nil)
			-- 	--攻击目标一次
			-- 	if enemy:IsAlive() then
			-- 		self:GetCaster():PerformAttack(hTarget, true, true, true, false, false, false, true)	
			-- 		self:GetCaster():RemoveModifierByName("modifier_remake_storm_bolt_crit_buff")		
			-- 	end	
			-- end				
			 
		    if self:GetCaster():HasModifier("modifier_remake_storm_bolt_storm") then
				caster:AddNewModifier(caster, self, "modifier_remake_storm_bolt_storm_attsp", {duration = 5})	
				if enemy:IsConsideredHero() then	
					caster:AddNewModifier(caster, self, "modifier_remake_storm_bolt_storm_attsp", {duration = 5})
					caster:AddNewModifier(caster, self, "modifier_remake_storm_bolt_storm_attsp", {duration = 5})					
				end
			end

		end		
		
		if caster:HasAbility("remake_storm_bolt_rush") then 
			FindClearSpaceForUnit(self:GetCaster(), hTarget:GetAbsOrigin(), true) 
	        self:GetCaster():RemoveModifierByName("modifier_remake_storm_bolt_caster")	    
			if hTarget:IsAlive() then
				self:GetCaster():PerformAttack(hTarget, true, true, true, false, false, false, true)	
				self:GetCaster():SetAttacking(hTarget)		
			end	       
			-- self:GetCaster():RemoveModifierByName("modifier_remake_storm_bolt_crit_buff")
	    end
	    
	end
end

modifier_remake_storm_bolt_caster = class({})

function modifier_remake_storm_bolt_caster:IsDebuff()			return false end
function modifier_remake_storm_bolt_caster:IsHidden() 		return true end
function modifier_remake_storm_bolt_caster:IsPurgable() 		return false end
function modifier_remake_storm_bolt_caster:IsPurgeException() return false end
function modifier_remake_storm_bolt_caster:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true} end

function modifier_remake_storm_bolt_caster:OnCreated()
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end
function modifier_remake_storm_bolt_caster:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveNoDraw()
	end
end

modifier_remake_storm_bolt_crit_buff = class({})

function modifier_remake_storm_bolt_crit_buff:IsDebuff()			return false end
function modifier_remake_storm_bolt_crit_buff:IsHidden() 		return false end
function modifier_remake_storm_bolt_crit_buff:IsPurgable() 		return false end
function modifier_remake_storm_bolt_crit_buff:IsPurgeException() return false end
function modifier_remake_storm_bolt_crit_buff:DeclareFunctions() return { MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_remake_storm_bolt_crit_buff:OnAttackLanded(key)
	if key.attacker == self:GetParent() then
		self:GetParent():RemoveModifierByName("modifier_remake_storm_bolt_crit_buff")
    end
end
function modifier_remake_storm_bolt_crit_buff:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then
		local crit = self:GetAbility():GetSpecialValueFor("damage") * 0.75
		local caster = self:GetCaster()
		local finaldamage = crit
		-- if caster:HasModifier("modifier_remake_sven_gods_strength_anger") and caster:HasModifier("modifier_imba_god_strength") then
		-- 	local pct_ability = caster:FindAbilityByName("remake_sven_gods_strength")
		-- 	local pct_dmg = pct_ability:GetSpecialValueFor("gods_strength_damage")
		-- 	finaldamage = (pct_dmg/100) * finaldamage
		-- end		 
		return finaldamage + 100		
	end
end

modifier_remake_storm_bolt_storm_attsp = class({})

function modifier_remake_storm_bolt_storm_attsp:IsDebuff()			return false end
function modifier_remake_storm_bolt_storm_attsp:IsHidden() 		return true end
function modifier_remake_storm_bolt_storm_attsp:IsPurgable() 		return false end
function modifier_remake_storm_bolt_storm_attsp:IsPurgeException() return false end
function modifier_remake_storm_bolt_storm_attsp:DeclareFunctions() return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_remake_storm_bolt_storm_attsp:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_remake_storm_bolt_storm_attsp:GetModifierAttackSpeedBonus_Constant()
	local bonus_attsp = 0
	if self:GetCaster():HasModifier("modifier_remake_storm_bolt_storm") then
		bonus_attsp = self:GetCaster():GetModifierStackCount("modifier_remake_storm_bolt_storm", nil) 	
	end
	return bonus_attsp
end
-- 风暴
remake_storm_bolt_storm = class({})
LinkLuaModifier("modifier_remake_storm_bolt_storm", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_storm_bolt_storm:GetIntrinsicModifierName() return "modifier_remake_storm_bolt_storm" end
function remake_storm_bolt_storm:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_storm_bolt_storm", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_storm_bolt_storm = class({})
function modifier_remake_storm_bolt_storm:IsDebuff()			return false end
function modifier_remake_storm_bolt_storm:IsHidden() 		return true end
function modifier_remake_storm_bolt_storm:IsPurgable() 		return false end
function modifier_remake_storm_bolt_storm:IsPurgeException() return false end

-- 勇气
remake_storm_bolt_rush = class({})
LinkLuaModifier("modifier_remake_storm_bolt_rush", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_storm_bolt_rush:GetIntrinsicModifierName() return "modifier_remake_storm_bolt_rush" end
function remake_storm_bolt_rush:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_storm_bolt_rush", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_storm_bolt_rush = class({})
function modifier_remake_storm_bolt_rush:IsDebuff()			return false end
function modifier_remake_storm_bolt_rush:IsHidden() 		return true end
function modifier_remake_storm_bolt_rush:IsPurgable() 		return false end
function modifier_remake_storm_bolt_rush:IsPurgeException() return false end

-- 力量
remake_storm_bolt_crit = class({})
LinkLuaModifier("modifier_remake_storm_bolt_crit", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_storm_bolt_crit:GetIntrinsicModifierName() return "modifier_remake_storm_bolt_crit" end
function remake_storm_bolt_crit:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_storm_bolt_crit", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_storm_bolt_crit = class({})
function modifier_remake_storm_bolt_crit:IsDebuff()			return false end
function modifier_remake_storm_bolt_crit:IsHidden() 		return true end
function modifier_remake_storm_bolt_crit:IsPurgable() 		return false end
function modifier_remake_storm_bolt_crit:IsPurgeException() return false end


remake_great_cleave = class({})

LinkLuaModifier("modifier_imba_great_cleave_passive", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_great_cleave_active", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_great_cleave_stack", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)

function remake_great_cleave:IsHiddenWhenStolen() 	return false end
function remake_great_cleave:IsRefreshable() 		return true end
function remake_great_cleave:IsStealable() 			return true end
function remake_great_cleave:IsNetherWardStealable()	return true end
function remake_great_cleave:GetBehavior()	
	if not self:GetCaster():HasModifier("modifier_remake_great_cleave_focus") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	else 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
	end
end
function remake_great_cleave:GetIntrinsicModifierName() return "modifier_imba_great_cleave_passive" end

function remake_great_cleave:OnSpellStart()	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_great_cleave_active", {duration = 10})	
end

modifier_imba_great_cleave_passive = class({})

function modifier_imba_great_cleave_passive:IsDebuff()			return false end
function modifier_imba_great_cleave_passive:IsHidden() 			return true end
function modifier_imba_great_cleave_passive:IsPurgable() 		return false end
function modifier_imba_great_cleave_passive:IsPurgeException() 	return false end
function modifier_imba_great_cleave_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_DEATH} end

function modifier_imba_great_cleave_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end		
		local dmg = keys.damage * (self:GetAbility():GetSpecialValueFor("great_cleave_damage") / 100)
		local cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
		local cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
		local cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")		
				
	
	if not keys.attacker:HasModifier("modifier_imba_great_cleave_active") then	
		local pfx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"	
		DoCleaveAttack(self:GetParent(), keys.target, self:GetAbility(), dmg, cleave_starting_width, cleave_ending_width, cleave_distance, pfx)				
	end
	
	if self:GetCaster():HasModifier("modifier_remake_great_cleave_lifesteal") then
		local heal_pct = self:GetCaster():GetModifierStackCount("modifier_remake_great_cleave_lifesteal", nil)
		local damage_dis = self:GetAbility():GetSpecialValueFor("great_cleave_damage") / 200		
		self:GetParent():Heal(keys.damage * heal_pct * damage_dis , self:GetCaster())
		local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(lifesteal_particle)  
	end	
end

modifier_imba_great_cleave_active = class({})

function modifier_imba_great_cleave_active:IsDebuff()			return false end
function modifier_imba_great_cleave_active:IsHidden() 			return false end
function modifier_imba_great_cleave_active:IsPurgable() 		return false end
function modifier_imba_great_cleave_active:IsPurgeException() 	return false end
function modifier_imba_great_cleave_active:DeclareFunctions() return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_great_cleave_active:GetModifierBaseAttack_BonusDamage(params)	
	local base_att = self:GetAbility():GetSpecialValueFor("great_cleave_damage")	
	if self:GetCaster():HasModifier("modifier_remake_great_cleave_focus") then		
		local pct_dmg = self:GetCaster():GetModifierStackCount("modifier_remake_great_cleave_focus", nil)
		base_att = (pct_dmg/100) * base_att
	end	
	return base_att
 end

-- 专注
remake_great_cleave_focus = class({})
LinkLuaModifier("modifier_remake_great_cleave_focus", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_great_cleave_focus:GetIntrinsicModifierName() return "modifier_remake_great_cleave_focus" end
function remake_great_cleave_focus:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_great_cleave_focus", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_great_cleave_focus = class({})
function modifier_remake_great_cleave_focus:IsDebuff()			return false end
function modifier_remake_great_cleave_focus:IsHidden() 		return true end
function modifier_remake_great_cleave_focus:IsPurgable() 		return false end
function modifier_remake_great_cleave_focus:IsPurgeException() return false end

-- 嗜血
remake_great_cleave_lifesteal = class({})
LinkLuaModifier("modifier_remake_great_cleave_lifesteal", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_great_cleave_lifesteal:GetIntrinsicModifierName() return "modifier_remake_great_cleave_lifesteal" end
function remake_great_cleave_lifesteal:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_great_cleave_lifesteal", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_great_cleave_lifesteal = class({})
function modifier_remake_great_cleave_lifesteal:IsDebuff()			return false end
function modifier_remake_great_cleave_lifesteal:IsHidden() 		return true end
function modifier_remake_great_cleave_lifesteal:IsPurgable() 		return false end
function modifier_remake_great_cleave_lifesteal:IsPurgeException() return false end

-- 大力
remake_great_cleave_great = class({})
LinkLuaModifier("modifier_remake_great_cleave_great", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_great_cleave_great:GetIntrinsicModifierName() return "modifier_remake_great_cleave_great" end
function remake_great_cleave_great:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_great_cleave_great", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_great_cleave_great = class({})
function modifier_remake_great_cleave_great:IsDebuff()			return false end
function modifier_remake_great_cleave_great:IsHidden() 		return true end
function modifier_remake_great_cleave_great:IsPurgable() 		return false end
function modifier_remake_great_cleave_great:IsPurgeException() return false end
function modifier_remake_great_cleave_great:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
	return funcs
end
function modifier_remake_great_cleave_great:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "remake_great_cleave" then
		return 0
	end	
	if szSpecialValueName == "cleave_ending_width" then		
		return 1
	end
	if szSpecialValueName == "cleave_distance" then		
		return 1
	end

	return 0
end
function modifier_remake_great_cleave_great:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "remake_great_cleave" then
		return 0
	end
	local szSpecialValueName = params.ability_special_value	
	if szSpecialValueName == "cleave_ending_width"then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		return flBaseValue * 2
	end
	if szSpecialValueName == "cleave_distance"then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		return flBaseValue * 2
	else
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		return flBaseValue
	end
	return 0	
end

remake_sven_warcry = class({})

LinkLuaModifier("modifier_remake_sven_warcry_active", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_remake_sven_warcry_active_anger", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_remake_sven_warcry_destruction_debuff", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)

function remake_sven_warcry:IsHiddenWhenStolen() 		return false end
function remake_sven_warcry:IsRefreshable() 			return true end
function remake_sven_warcry:IsStealable() 			return true end
function remake_sven_warcry:IsNetherWardStealable()	return true end
function remake_sven_warcry:GetCastRange() return self:GetSpecialValueFor("warcry_radius") end
function remake_sven_warcry:GetBehavior()
	if not self:GetCaster():HasModifier("modifier_remake_sven_warcry_protect_passive") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	else return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	end
end

function remake_sven_warcry:OnSpellStart()
	local caster = self:GetCaster()
	local pfx_name1 = "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf"
	local pfx_name2 = "particles/units/heroes/hero_sven/sven_warcry_buff_sven.vpcf"
	local sound_name = "Hero_Sven.WarCry"	
	caster:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name1, PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	if self:GetCaster():HasModifier("modifier_remake_sven_warcry_magic") then
		caster:Purge(false, true, false, true, true)
		caster:AddNewModifier(caster, self, "modifier_phased", {duration = self:GetSpecialValueFor("duration")})
	end
	if self:GetCaster():HasModifier("modifier_remake_sven_warcry_protect") then		
		caster:AddNewModifier(caster, self, "modifier_black_king_bar_immune", {duration = 5})							
	end		
	
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("warcry_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		local buff = ally:AddNewModifier(caster, self, "modifier_remake_sven_warcry_active", {duration = self:GetSpecialValueFor("duration")})
		
		if caster:HasModifier("modifier_remake_sven_warcry_magic") then
			ally:Purge(false, true, false, true, true)	
			ally:AddNewModifier(caster, self, "modifier_phased", {duration = self:GetSpecialValueFor("duration")})		
		end
		if self:GetCaster():HasModifier("modifier_remake_sven_warcry_protect") then		
			ally:AddNewModifier(caster, self, "modifier_black_king_bar_immune", {duration = 5})								
		end	

		local pfx = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN_FOLLOW, ally)
		--ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
		--ParticleManager:SetParticleControlEnt(pfx, 1, ally, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
		buff:AddParticle(pfx, false, false, 15, false, false)
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("warcry_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if caster:HasModifier("modifier_remake_sven_warcry_destruction") then
    	for i, v in pairs(enemies) do
		v:AddNewModifier(caster, self, "modifier_remake_sven_warcry_destruction_debuff", {duration = self:GetSpecialValueFor("duration")})	
		end	
	end
end

modifier_remake_sven_warcry_active = class({})

function modifier_remake_sven_warcry_active:IsDebuff()			return false end
function modifier_remake_sven_warcry_active:IsHidden() 		return false end
function modifier_remake_sven_warcry_active:IsPurgable() 		return true end
function modifier_remake_sven_warcry_active:IsPurgeException() return true end
function modifier_remake_sven_warcry_active:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_remake_sven_warcry_active:GetModifierMoveSpeedBonus_Percentage()
	local bonus_ms = self:GetAbility():GetSpecialValueFor("warcry_movespeed")	
	return bonus_ms
end
 
function modifier_remake_sven_warcry_active:GetModifierPhysicalArmorBonus()
	
	local armor = self:GetAbility():GetSpecialValueFor("warcry_armor")	
	return armor
end
function modifier_remake_sven_warcry_active:OnCreated()
	if IsServer() then		
	end
end
modifier_remake_sven_warcry_active_anger = class({})

function modifier_remake_sven_warcry_active_anger:IsDebuff()			return false end
function modifier_remake_sven_warcry_active_anger:IsHidden() 		return true end
function modifier_remake_sven_warcry_active_anger:IsPurgable() 		return true end
function modifier_remake_sven_warcry_active_anger:IsPurgeException() return true end
function modifier_remake_sven_warcry_active_anger:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_remake_sven_warcry_active_anger:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("warcry_movespeed") end
function modifier_remake_sven_warcry_active_anger:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("warcry_armor") end
function modifier_remake_sven_warcry_active_anger:OnCreated()
	if IsServer() then		
	end
end

modifier_remake_sven_warcry_destruction_debuff = class({})

function modifier_remake_sven_warcry_destruction_debuff:IsDebuff()			return true end
function modifier_remake_sven_warcry_destruction_debuff:IsHidden() 		return false end
function modifier_remake_sven_warcry_destruction_debuff:IsPurgable() 		return true end
function modifier_remake_sven_warcry_destruction_debuff:IsPurgeException() return true end
function modifier_remake_sven_warcry_destruction_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_remake_sven_warcry_destruction_debuff:GetModifierPhysicalArmorBonus()	
	local armor = self:GetAbility():GetSpecialValueFor("warcry_armor")	
	return (0-armor)
end 
function modifier_remake_sven_warcry_destruction_debuff:OnCreated()
	if IsServer() then		
	end
end

-- 破坏
remake_sven_warcry_destruction = class({})
LinkLuaModifier("modifier_remake_sven_warcry_destruction", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_sven_warcry_destruction:GetIntrinsicModifierName() return "modifier_remake_sven_warcry_destruction" end
function remake_sven_warcry_destruction:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_sven_warcry_destruction", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_sven_warcry_destruction = class({})
function modifier_remake_sven_warcry_destruction:IsDebuff()			return false end
function modifier_remake_sven_warcry_destruction:IsHidden() 		return true end
function modifier_remake_sven_warcry_destruction:IsPurgable() 		return false end
function modifier_remake_sven_warcry_destruction:IsPurgeException() return false end

-- 抗拒
remake_sven_warcry_magic = class({})
LinkLuaModifier("modifier_remake_sven_warcry_magic", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_sven_warcry_magic:GetIntrinsicModifierName() return "modifier_remake_sven_warcry_magic" end
function remake_sven_warcry_magic:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_sven_warcry_magic", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_sven_warcry_magic = class({})
function modifier_remake_sven_warcry_magic:IsDebuff()			return false end
function modifier_remake_sven_warcry_magic:IsHidden() 		return true end
function modifier_remake_sven_warcry_magic:IsPurgable() 		return false end
function modifier_remake_sven_warcry_magic:IsPurgeException() return false end

-- 守护
remake_sven_warcry_protect = class({})
LinkLuaModifier("modifier_remake_sven_warcry_protect", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_sven_warcry_protect:GetIntrinsicModifierName() return "modifier_remake_sven_warcry_protect" end
function remake_sven_warcry_protect:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_sven_warcry_protect", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_sven_warcry_protect = class({})
function modifier_remake_sven_warcry_protect:IsDebuff()			return false end
function modifier_remake_sven_warcry_protect:IsHidden() 		return true end
function modifier_remake_sven_warcry_protect:IsPurgable() 		return false end
function modifier_remake_sven_warcry_protect:IsPurgeException() return false end

remake_sven_gods_strength = class({})

LinkLuaModifier("modifier_imba_god_strength", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_god_strength_cd", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)

function remake_sven_gods_strength:IsHiddenWhenStolen() 		return false end
function remake_sven_gods_strength:IsRefreshable() 			return true end
function remake_sven_gods_strength:IsStealable() 				return true end
function remake_sven_gods_strength:IsNetherWardStealable()	return true end
function remake_sven_gods_strength:GetIntrinsicModifierName()
	return "modifier_imba_god_strength_cd"
end
function remake_sven_gods_strength:OnSpellStart()
	local caster = self:GetCaster()		
	local pfx_name = "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
	local pfx_head = "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf"
	local sound_name = "Hero_Sven.GodsStrength"	
	caster:EmitSound(sound_name)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	local duration = self:GetSpecialValueFor("duration")
	local buff = caster:AddNewModifier(caster, self, "modifier_imba_god_strength", {duration = duration})
	local pfx = ParticleManager:CreateParticle(pfx_head, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	buff:AddParticle(pfx, false, false, 15, false, false)
	
end

modifier_imba_god_strength = class({})

function modifier_imba_god_strength:IsDebuff()			return false end
function modifier_imba_god_strength:IsHidden() 			return false end
function modifier_imba_god_strength:IsPurgable() 		return false end
function modifier_imba_god_strength:IsPurgeException() 	return false end
function modifier_imba_god_strength:GetStatusEffectName() return "particles/status_fx/status_effect_gods_strength.vpcf" end
function modifier_imba_god_strength:StatusEffectPriority() return 16 end
function modifier_imba_god_strength:DeclareFunctions() return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, MODIFIER_EVENT_ON_DEATH,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end
function modifier_imba_god_strength:GetModifierBaseDamageOutgoing_Percentage()
	local bonus = self:GetAbility():GetSpecialValueFor("gods_strength_damage")	
	if self:GetParent():HasModifier("modifier_remake_sven_gods_strength_berserker") then		
		local value = self:GetCaster():GetModifierStackCount("modifier_remake_sven_gods_strength_berserker", nil)
		bonus = bonus * (value /100+1)
	end	
	return bonus
end

function modifier_imba_god_strength:GetModifierBonusStats_Strength()
	local bonus_att = 0
	local value = 0
	if self:GetParent():HasModifier("modifier_remake_sven_gods_strength_focus") then
		bonus_att = self:GetAbility():GetSpecialValueFor("gods_strength_damage")
		value = self:GetCaster():GetModifierStackCount("modifier_remake_sven_gods_strength_focus", nil)
		bonus_att = bonus_att * value /100
	end	
	return bonus_att
end

function modifier_imba_god_strength:OnDeath(keys)
	if IsServer() and keys.unit == self:GetParent() then
		self:Destroy()
	end
end

-- 神佑
remake_sven_gods_strength_berserker = class({})
LinkLuaModifier("modifier_remake_sven_gods_strength_berserker", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_sven_gods_strength_berserker:GetIntrinsicModifierName() return "modifier_remake_sven_gods_strength_berserker" end
function remake_sven_gods_strength_berserker:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_sven_gods_strength_berserker", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_sven_gods_strength_berserker = class({})
function modifier_remake_sven_gods_strength_berserker:IsDebuff()			return false end
function modifier_remake_sven_gods_strength_berserker:IsHidden() 		return true end
function modifier_remake_sven_gods_strength_berserker:IsPurgable() 		return false end
function modifier_remake_sven_gods_strength_berserker:IsPurgeException() return false end


-- 愤怒
remake_sven_gods_strength_anger = class({})
LinkLuaModifier("modifier_remake_sven_gods_strength_anger", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_sven_gods_strength_anger:GetIntrinsicModifierName() return "modifier_remake_sven_gods_strength_anger" end
function remake_sven_gods_strength_anger:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_sven_gods_strength_anger", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_sven_gods_strength_anger = class({})
function modifier_remake_sven_gods_strength_anger:IsDebuff()			return false end
function modifier_remake_sven_gods_strength_anger:IsHidden() 		return true end
function modifier_remake_sven_gods_strength_anger:IsPurgable() 		return false end
function modifier_remake_sven_gods_strength_anger:IsPurgeException() return false end

-- 降临
remake_sven_gods_strength_focus = class({})
LinkLuaModifier("modifier_remake_sven_gods_strength_focus", "scripts/vscripts/abilities/heroes/hero_sven/hero_sven.lua", LUA_MODIFIER_MOTION_NONE)
function remake_sven_gods_strength_focus:GetIntrinsicModifierName() return "modifier_remake_sven_gods_strength_focus" end
function remake_sven_gods_strength_focus:OnUpgrade()	
	local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_remake_sven_gods_strength_focus", {})
	local stacks = self:GetSpecialValueFor("value")
	buff:SetStackCount(stacks)
end
modifier_remake_sven_gods_strength_focus = class({})
function modifier_remake_sven_gods_strength_focus:IsDebuff()			return false end
function modifier_remake_sven_gods_strength_focus:IsHidden() 		return true end
function modifier_remake_sven_gods_strength_focus:IsPurgable() 		return false end
function modifier_remake_sven_gods_strength_focus:IsPurgeException() return false end




