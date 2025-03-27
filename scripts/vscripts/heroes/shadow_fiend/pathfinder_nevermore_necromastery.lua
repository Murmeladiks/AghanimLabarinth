pathfinder_nevermore_necromastery = pathfinder_nevermore_necromastery or class({})
LinkLuaModifier("modifier_pathfinder_necromastery_souls", "heroes/shadow_fiend/pathfinder_nevermore_necromastery.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pathfinder_revenant_status", "heroes/shadow_fiend/pathfinder_nevermore_revenant_status.lua", LUA_MODIFIER_MOTION_NONE)


function pathfinder_nevermore_necromastery:GetIntrinsicModifierName()	
	return "modifier_pathfinder_necromastery_souls"
end

--------------------------------------------------------------------------------

function pathfinder_nevermore_necromastery:GetAbilityTextureName()
	return self:GetAbilityTextureNameFromParticle("particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf")
end

--------------------------------------------------------------------------------

function pathfinder_nevermore_necromastery:GetBehavior()		
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	else		
		return DOTA_ABILITY_BEHAVIOR_PASSIVE	
	end
end

function pathfinder_nevermore_necromastery:CastFilterResultTarget(target)
	if IsServer() and self:GetCaster():HasAbility("pathfinder_nevermore_special_necromastery_revenant") and self:GetCaster():FindModifierByName("modifier_pathfinder_necromastery_souls"):GetStackCount() < self:GetCaster():FindAbilityByName("pathfinder_nevermore_special_necromastery_revenant"):GetLevelSpecialValueFor("soul_cost",1) then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function pathfinder_nevermore_necromastery:GetCustomCastErrorTarget(hTarget)
	if IsServer() then
		if self:GetCaster():HasAbility("pathfinder_nevermore_special_necromastery_revenant") and self:GetCaster():FindModifierByName("modifier_pathfinder_necromastery_souls"):GetStackCount() < self:GetCaster():FindAbilityByName("pathfinder_nevermore_special_necromastery_revenant"):GetLevelSpecialValueFor("soul_cost",1) then
			return "NEED MORE SOULS, FOOL"
		end

		return UF_SUCCESS
	end
end

function pathfinder_nevermore_necromastery:GetCooldown(iLevel)
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return 17
	end
end

function pathfinder_nevermore_necromastery:GetManaCost(iLevel)
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return 100
	end
end

function pathfinder_nevermore_necromastery:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return 700
	end
end

function pathfinder_nevermore_necromastery:GetCastPoint()
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return 0.6
	end
end

function pathfinder_nevermore_necromastery:GetAbilityTargetFlags()
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
end

function pathfinder_nevermore_necromastery:GetAbilityTargetTeam()
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	end
end

function pathfinder_nevermore_necromastery:GetAbilityTargetType()
	if self:GetCaster():HasShard("pathfinder_nevermore_special_necromastery_revenant") then
		return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	end
end



function pathfinder_nevermore_necromastery:OnSpellStart()	
	if IsServer() and self:GetCaster():HasAbility("pathfinder_nevermore_special_necromastery_revenant") and self:GetCaster():FindModifierByName("modifier_pathfinder_necromastery_souls"):GetStackCount() >= self:GetCaster():FindAbilityByName("pathfinder_nevermore_special_necromastery_revenant"):GetLevelSpecialValueFor("soul_cost",1) then
		local ability = self:GetCaster():FindAbilityByName("pathfinder_nevermore_shadowraze_near")
		if ability and self:GetCaster():HasAbility("pathfinder_nevermore_special_necromastery_revenant") then
			local target = self:GetCaster():GetCursorCastTarget()
			local necromastery_modifier = self:GetCaster():FindModifierByName("modifier_pathfinder_necromastery_souls")		
			local raze_radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)

			if target and not target:IsNull() and necromastery_modifier and not necromastery_modifier:IsNull() then
				necromastery_modifier:RemoveNecromasterySouls(self:GetCaster():FindAbilityByName("pathfinder_nevermore_special_necromastery_revenant"):GetLevelSpecialValueFor("soul_cost",1))
				Timers:CreateTimer(0.05, function()
					local particle_raze_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(particle_raze_fx, 0, target:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle_raze_fx, 1, Vector(250, 1, 1))
					ParticleManager:SetParticleControl(particle_raze_fx, 60, Vector(255, 255, 1))
					ParticleManager:SetParticleControl(particle_raze_fx, 61, Vector(1, 1, 1))
					ParticleManager:ReleaseParticleIndex(particle_raze_fx)
				end)
				target:AddNewModifier(self:GetCaster(), self, "modifier_pathfinder_revenant_status", {duration = 0.5})
				local raze_point = target:GetAbsOrigin()
				self:GetCaster():CastShadowRazeOnPoint(ability, raze_point, raze_radius)
				
				Timers:CreateTimer(0.5, function()
					local particle_raze_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(particle_raze_fx, 0, target:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle_raze_fx, 1, Vector(250, 1, 1))
					ParticleManager:SetParticleControl(particle_raze_fx, 60, Vector(255, 255, 1))
					ParticleManager:SetParticleControl(particle_raze_fx, 61, Vector(1, 1, 1))
					ParticleManager:ReleaseParticleIndex(particle_raze_fx)
					target:AddNewModifier(self:GetCaster(), self, "modifier_pathfinder_revenant_status", {duration = 0.5})
					local raze_point = target:GetAbsOrigin()
					self:GetCaster():CastShadowRazeOnPoint(ability, raze_point, raze_radius)
				end)					
			end
		end
	end
end

-- function pathfinder_nevermore_necromastery:OnProjectileHit_ExtraData(target, location, extra_data)
-- 	local req = self:GetCaster():FindAbilityByName("pathfinder_nevermore_requiem")
-- 	if not target and not (self.caster:HasAbility("pathfinder_nevermore_special_requiem_soul_projectile") and req and req:GetLevel() > 0) then	
-- 	-- If there was no target, do nothing
-- 		return nil
-- 	end

-- 	-- Ability properties
-- 	local caster = self:GetCaster()
-- 	local ability = req
-- 	local modifier_debuff = "modifier_pathfinder_nevermore_requiem_debuff"

-- 	-- Ability specials
-- 	local damage = ability:GetSpecialValueFor("damage")

-- --print(damage)
-- 	local slow_duration = ability:GetSpecialValueFor("slow_duration")


-- 	-- Apply the debuff on enemies hit
-- 	target:AddNewModifier(caster, ability, modifier_debuff, {duration = slow_duration * (1 - target:GetStatusResistance())})

	
-- 	target:EmitSound("Hero_Nevermore.RequiemOfSouls.Damage")
	
-- 	-- Damage the target
-- 	local damageTable = {victim = target,
-- 						damage = damage,
-- 						damage_type = DAMAGE_TYPE_MAGICAL,
-- 						attacker = caster,
-- 						ability = ability
-- 						}

-- 	local damage_dealt = ApplyDamage(damageTable)

-- 	if IsServer() and caster:HasAbility("pathfinder_nevermore_special_requiem_attack") then
-- 		local special = caster:FindAbilityByName("pathfinder_nevermore_special_requiem_attack")
-- 		if not caster:HasModifier("modifier_pathfinder_requiem_attack") then
-- 			caster:AddNewModifier(caster, ability, "modifier_pathfinder_requiem_attack", {duration = special:GetLevelSpecialValueFor("stacks_duration",1)})
-- 		end
-- 		for i=1,special:GetLevelSpecialValueFor("stacks_per_hit",1) do			
-- 			local mod = caster:FindModifierByName("modifier_pathfinder_requiem_attack")
-- 			if mod then
-- 				mod:IncrementStackCount()			
-- 				mod:ForceRefresh()
-- 			end
-- 		end
-- 	end
-- end

modifier_pathfinder_nevermore_special_necromastery_lifesteal						= class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
})



-- Necromastery souls modifier
modifier_pathfinder_necromastery_souls = modifier_pathfinder_necromastery_souls or class({})


function modifier_pathfinder_necromastery_souls:OnCreated()	
	-- Ability properties
	self.caster = self:GetCaster()
	self.requiem_ability = "pathfinder_nevermore_requiem"
	
	self.ability = self:GetAbility()
	self.particle_soul = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

	-- Ability specials
	self.damage_per_soul = self.ability:GetLevelSpecialValueFor("damage_per_soul", self.ability:GetLevel() - 1)
	self.max_souls = self.ability:GetLevelSpecialValueFor("max_souls", self.ability:GetLevel() - 1)

	self.souls_per_kill = self.ability:GetLevelSpecialValueFor("souls_per_kill", self.ability:GetLevel() - 1)


	self.soul_projectile_speed = self.ability:GetLevelSpecialValueFor("soul_projectile_speed", self.ability:GetLevel() - 1)
	self.souls_lost_on_death_pct = self.ability:GetLevelSpecialValueFor("souls_lost_on_death_pct", self.ability:GetLevel() - 1)
end

function modifier_pathfinder_necromastery_souls:GetHeroEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_souls_hero_effect.vpcf"
end



function modifier_pathfinder_necromastery_souls:OnRefresh()
	self:OnCreated()
end

function modifier_pathfinder_necromastery_souls:DestroyOnExpire()
	return false
end

function modifier_pathfinder_necromastery_souls:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end

function modifier_pathfinder_necromastery_souls:GetModifierPreAttack_BonusDamage()
	return self.damage_per_soul * self:GetStackCount()
end

function modifier_pathfinder_necromastery_souls:OnAttackLanded(keys)
	if IsServer() then		
		local attacker = keys.attacker
		local target = keys.target
		
		if self:GetCaster() ~= attacker or self:GetCaster() == target then
			return
		elseif not self:GetCaster():HasAbility("pathfinder_nevermore_special_necromastery_attack_soul") or self:GetCaster():PassivesDisabled() then
			return
		end
		local special = self:GetCaster():FindAbilityByName("pathfinder_nevermore_special_necromastery_attack_soul")
		if RandomInt(1,100) > special:GetLevelSpecialValueFor("chance",1) then
			return
		end
		local soul_count = special:GetLevelSpecialValueFor("amount",1)
									
		-- Increase souls appropriately

		self:AddNecromasterySouls(soul_count)

		-- If caster is not disabled and is visible, launch a soul
		if IsServer() and not self.caster:PassivesDisabled() then		
			-- Launch a creep soul to the caster
			local soul_projectile = {Target = attacker,
											Source = target,
											Ability = self.ability,
											EffectName = self.particle_soul,
											bDodgeable = false,
											bProvidesVision = false,
											iMoveSpeed = self.soul_projectile_speed,
											iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
											}

			ProjectileManager:CreateTrackingProjectile(soul_projectile)			
			if self.caster:HasAbility("pathfinder_nevermore_special_requiem_soul_projectile") then						
				local req = self:GetCaster():FindAbilityByName("pathfinder_nevermore_requiem")
				if req and req:GetLevel() > 0 then	
					self.caster:SetCursorCastTarget(target)
					self.caster:FindAbilityByName("pathfinder_nevermore_special_requiem_soul_projectile"):OnSpellStart()
				end
			end
		end	
	end
end

function modifier_pathfinder_necromastery_souls:OnDeath(keys)
	if IsServer() then
		local target = keys.unit
		local attacker = keys.attacker

		-- Only apply if the caster is the attacker (and NOT the victim)
		if self.caster == attacker and self.caster ~= target then			
			-- If the target was a building, do nothing
			if target:IsBuilding() then
				return nil
			end

			-- Decide how many souls should the caster get
			local soul_count = self.souls_per_kill
									
			-- Increase souls appropriately
	
			self:AddNecromasterySouls(soul_count)

			-- If caster is not disabled and is visible, launch a soul
			if IsServer() and not self.caster:PassivesDisabled() then		
				-- Launch a creep soul to the caster
				local soul_projectile = {Target = self.caster,
											Source = target,
											Ability = self.ability,
											EffectName = self.particle_soul,
											bDodgeable = false,
											bProvidesVision = false,
											iMoveSpeed = self.soul_projectile_speed,
											iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
											}

				ProjectileManager:CreateTrackingProjectile(soul_projectile)	
				if self.caster:HasAbility("pathfinder_nevermore_special_requiem_soul_projectile") then					
					local req = self:GetCaster():FindAbilityByName("pathfinder_nevermore_requiem")
					if req and req:GetLevel() > 0 then	
						self.caster:SetCursorCastTarget(target)
						self.caster:FindAbilityByName("pathfinder_nevermore_special_requiem_soul_projectile"):OnSpellStart()
					end
				end
			end
		end


		-- If the caster was the one who died, he loses half his stacks
		if self.caster == target and not target:IsIllusion() then
			local stacks = self:GetStackCount()
			local stacks_lost = math.floor(stacks * (self.souls_lost_on_death_pct * 0.01))
			self:RemoveNecromasterySouls(stacks_lost)

			-- If the caster has Requiem of Souls, use the spell with a death cast tag
			if IsServer() and self.caster:HasAbility(self.requiem_ability) then
				local requiem_ability_handler = self.caster:FindAbilityByName(self.requiem_ability)
				if requiem_ability_handler then
					if requiem_ability_handler:GetLevel() >= 1 then
						requiem_ability_handler:OnSpellStart(true)
					end
				end
			end
		end
	end
end

function modifier_pathfinder_necromastery_souls:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	if self:GetParent():HasShard("pathfinder_nevermore_special_necromastery_lifesteal") then
		return self:GetStackCount() * 2
	end
end

function modifier_pathfinder_necromastery_souls:GetModifierSpellAmplify_Percentage( params )
	if self:GetParent():HasShard("pathfinder_nevermore_special_necromastery_lifesteal") then		
		return self:GetStackCount()	
	end
end


function modifier_pathfinder_necromastery_souls:RemoveOnDeath() return false end
function modifier_pathfinder_necromastery_souls:IsHidden() return false end
function modifier_pathfinder_necromastery_souls:IsPurgable() return false end
function modifier_pathfinder_necromastery_souls:IsDebuff() return false end
function modifier_pathfinder_necromastery_souls:AllowIllusionDuplicate() return true end

function modifier_pathfinder_necromastery_souls:AddNecromasterySouls(soul_count)
	-- If caster is broken, do nothing
	if self:GetParent():PassivesDisabled() then
		return nil
	end
	local nMaxSouls = self:GetAbility():GetSpecialValueFor("max_souls")
	local hFrenzyAbility = self:GetCaster():FindAbilityByName("nevermore_pf_frenzy")

	if hFrenzyAbility and self:GetParent():HasModifier("modifier_nevermore_pf_frenzy") then
		nMaxSouls = nMaxSouls + hFrenzyAbility:GetSpecialValueFor("soul_cost")
	end

	self:SetStackCount(math.min(self:GetStackCount() + soul_count, nMaxSouls))
end

function modifier_pathfinder_necromastery_souls:RemoveNecromasterySouls(soul_count)
	self:SetStackCount(math.max(self:GetStackCount() - soul_count, 0))
end

modifier_pathfinder_nevermore_necromastery_revenant = modifier_pathfinder_nevermore_necromastery_revenant or class({})

function modifier_pathfinder_nevermore_necromastery_revenant:IsHidden() return true end
function modifier_pathfinder_nevermore_necromastery_revenant:RemoveOnDeath() return false end
