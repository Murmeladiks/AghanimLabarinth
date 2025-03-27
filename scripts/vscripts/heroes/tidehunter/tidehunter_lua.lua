LinkLuaModifier("modifier_tidehunter_gush_pf", 				"heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_tidehunter_kraken_shell_pf", 			"heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_tidehunter_anchor_smash_pf", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tidehunter_anchor_smash_pf_caster", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tidehunter_anchor_smash_pf_karate", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)

-- FIXME: incorrect
LinkLuaModifier( "modifier_pathfinder_healing_ward_root", "heroes/juggernaut/modifier_pathfinder_healing_ward_root", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier("modifier_tidehunter_ravage_pf_puddle", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tidehunter_ravage_pf_puddle_effect", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_tidehunter_pf_crunch_victim", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tidehunter_pf_crunch_buff", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tidehunter_kraken_shell_boost_pf", "heroes/tidehunter/tidehunter_lua", LUA_MODIFIER_MOTION_NONE)

tidehunter_gush_pf										= class({})
modifier_tidehunter_gush_pf								= class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end,		
})

tidehunter_kraken_shell_pf								= class({})
modifier_tidehunter_kraken_shell_pf						= class({
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
})

modifier_tidehunter_kraken_shell_boost_pf				= class({
	IsPurgable	  			= function(self) return false end,
})

tidehunter_anchor_smash_pf								= class({})
modifier_tidehunter_anchor_smash_pf						= class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end,		
})
modifier_tidehunter_anchor_smash_pf_caster				= class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,		
	RemoveOnDeath			= function(self) return false end,		
})
modifier_tidehunter_anchor_smash_pf_karate				= class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	RemoveOnDeath			= function(self) return false end,		
})
tidehunter_anchor_smash_pf								= class({})

tidehunter_pf_crunch								= class({})
modifier_tidehunter_pf_crunch_victim				= class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return true end,	
})
modifier_tidehunter_pf_crunch_buff				= class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,	
	RemoveOnDeath			= function(self) return false end,	
})

tidehunter_ravage_pf = tidehunter_ravage_pf or class({})

----------
-- GUSH --
----------
function tidehunter_gush_pf:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("cast_range")
end

function tidehunter_gush_pf:GetAOERadius()
	return self:GetLevelSpecialValueFor("radius", self:GetLevel() - 1)
end

function tidehunter_gush_pf:CreateGush(from, to, bounce_count)
	local projectile =
		{
			Target 				= to,
			Source 				= from,
			Ability 			= self,
			EffectName 			= "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
			iMoveSpeed			= self:GetSpecialValueFor("projectile_speed"),
			vSourceLoc 			= from:GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10.0,
			bProvidesVision 	= false,
			
			iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, -- Need to put the mouth?
			
			ExtraData = {
				bounce = bounce_count,
			}
		}
		
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function tidehunter_gush_pf:OnSpellStart()
	self:GetCaster():EmitSound("Ability.GushCast")	
	
	if self:GetCursorTarget() then
		self:CreateGush(self:GetCaster(), self:GetCursorTarget(), 0)
	end
	
end

function tidehunter_gush_pf:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end

	local radius = self:GetLevelSpecialValueFor("radius", self:GetLevel() - 1)

	-- Gush hit some unit
	if target and not target:IsMagicImmune() then
		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then			
			target:EmitSound("Ability.GushImpact")

			local radiusParticle = ParticleManager:CreateParticle("particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf", PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl( radiusParticle, 1, Vector( radius, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex(radiusParticle)

			local ravage = self:GetCaster():FindAbilityByName("tidehunter_ravage_pf")
			if self:GetCaster():HasAbility("tidehunter_gush_pf_ravage") and not target:IsMagicImmune() and ravage:IsTrained() then				
				local stat_mult = self:GetCaster():FindAbilityByName("tidehunter_gush_pf_ravage"):GetLevelSpecialValueFor("damage_percent", 1)
				local stun_duration	= ravage:GetLevelSpecialValueFor("duration", ravage:GetLevel() - 1)
				local stun_damage	= ravage:GetLevelSpecialValueFor("damage", ravage:GetLevel() - 1) / 100 * stat_mult
				target:EmitSound("Hero_Tidehunter.RavageDamage")				

				-- Apply stun and air time modifiers
				target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration * (1 - target:GetStatusResistance())})

				-- Knock the enemy into the air
				local knockback =
				{
					knockback_duration = 0.5 * (1 - target:GetStatusResistance()),
					duration = 0.5 * (1 - target:GetStatusResistance()),
					knockback_distance = 0,
					knockback_height = 350,
				}
				target:RemoveModifierByName("modifier_knockback")
				target:AddNewModifier(caster, self, "modifier_knockback", knockback)

				local hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_ABSORIGIN, target)
				ParticleManager:ReleaseParticleIndex(hit_fx)
				hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_ravage_tentacle_model_rocks.vpcf", PATTACH_ABSORIGIN, target)
				ParticleManager:ReleaseParticleIndex(hit_fx)
	
				
				Timers:CreateTimer(0.5, function()
					-- Apply damage
					local damageTable = {victim = target,
						damage = stun_damage,
						damage_type = self:GetAbilityDamageType(),
						attacker = self:GetCaster(),
						ability = self
					}
					ApplyDamage(damageTable)

					-- We need to do this because the gesture takes it's fucking time to stop
					target:RemoveGesture(ACT_DOTA_FLAIL)
				end)
			end

				
			self:CreateVisibilityNode(target:GetAbsOrigin(), radius, 2)			

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )

			for _,enemy in pairs(enemies) do
				-- "Gush first applies the debuff, then the damage."
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_tidehunter_gush_pf", {duration = self:GetLevelSpecialValueFor("debuff_duration",self:GetLevel() - 1) * (1 - enemy:GetStatusResistance())})				
				

				local damageTable = {
					victim 			= enemy,
					damage 			= self:GetLevelSpecialValueFor("gush_damage", self:GetLevel() - 1),
					damage_type		= self:GetAbilityDamageType(),
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self
				}

				ApplyDamage(damageTable)
			end
		end
		if self:GetCaster():HasAbility("tidehunter_gush_pf_bounce") then
			local special = self:GetCaster():FindAbilityByName("tidehunter_gush_pf_bounce")
			if data.bounce < special:GetLevelSpecialValueFor("bounce",1) then
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, special:GetLevelSpecialValueFor("radius",1), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST , false )
				if enemies[1] and enemies[1] ~= target then
					self:CreateGush(target, enemies[1], data.bounce + 1)
				end
			end
		end
	end
end

-------------------
-- GUSH MODIFIER --
-------------------

function modifier_tidehunter_gush_pf:GetEffectName()
	return "particles/units/heroes/hero_tidehunter/tidehunter_gush_slow.vpcf"
end

function modifier_tidehunter_gush_pf:GetStatusEffectName()
	return "particles/status_fx/status_effect_gush.vpcf"
end

function modifier_tidehunter_gush_pf:OnCreated()
	if self:GetAbility() then
		self.movement_speed	= self:GetAbility():GetSpecialValueFor("movement_speed_reduction")
		self.negative_armor	= self:GetAbility():GetSpecialValueFor("negative_armor")

		if IsServer() and self:GetCaster():HasAbility("tidehunter_gush_pf_miss") then
			local blind_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        	self:AddParticle(blind_fx, false, false, 1, false, false)
		end
	else
		self:Destroy()
	end
end

function modifier_tidehunter_gush_pf:OnRefresh()
	self:OnCreated()
end

function modifier_tidehunter_gush_pf:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,		
	}	
	if IsServer() and self:GetCaster():HasAbility("tidehunter_gush_pf_miss") then
		table.insert(decFuncs, MODIFIER_PROPERTY_MISS_PERCENTAGE)
	end

	return decFuncs
end

function modifier_tidehunter_gush_pf:GetModifierMoveSpeedBonus_Percentage()	
	return self.movement_speed * -1
end

function modifier_tidehunter_gush_pf:GetModifierPhysicalArmorBonus()
	return self.negative_armor * (-1)
end

function modifier_tidehunter_gush_pf:GetModifierMiss_Percentage()
	if IsServer() and self:GetCaster():HasAbility("tidehunter_gush_pf_miss") then
		return self:GetCaster():FindAbilityByName("tidehunter_gush_pf_miss"):GetLevelSpecialValueFor("miss_percent",1)
	end
end

------------------
-- KRAKEN SHELL --
------------------

function tidehunter_kraken_shell_pf:GetIntrinsicModifierName()	
	return "modifier_tidehunter_kraken_shell_pf"
end

function tidehunter_kraken_shell_pf:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_tidehunter_kraken_shell_boost_pf", {duration = self:GetSpecialValueFor("active_duration")})
	hCaster:EmitSound("Hero_Tidehunter.KrakenShell")
end

function modifier_tidehunter_kraken_shell_boost_pf:OnCreated()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	self.nMoveSlow = -hAbility:GetSpecialValueFor("active_move_speed_penalty_pct")

	if IsClient() then return end
	local nShellFX = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_shell.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(nShellFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	self:AddParticle(nShellFX, false, false, -1, false, false)
end

function modifier_tidehunter_kraken_shell_boost_pf:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_tidehunter_kraken_shell_boost_pf:GetModifierMoveSpeedBonus_Percentage()
	return self.nMoveSlow
end

function modifier_tidehunter_kraken_shell_pf:IsHidden() return self:GetStackCount() < 1 end

---------------------------
-- KRAKEN SHELL MODIFIER --
---------------------------

function modifier_tidehunter_kraken_shell_pf:OnCreated()
	self.hParent = self:GetParent()
	self.hAbility = self:GetAbility()
end

function modifier_tidehunter_kraken_shell_pf:DeclareFunctions()
	return {		
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_tidehunter_kraken_shell_pf:GetModifierPhysical_ConstantBlock()
	if self.hParent:HasModifier("modifier_tidehunter_kraken_shell_boost_pf") then
		return (self.hAbility:GetSpecialValueFor("damage_reduction") + self.hAbility:GetSpecialValueFor("bonus_reduction_per_kill") * self:GetStackCount()) * 2
	else
		return self.hAbility:GetSpecialValueFor("damage_reduction") + self.hAbility:GetSpecialValueFor("bonus_reduction_per_kill") * self:GetStackCount()
	end
end

function modifier_tidehunter_kraken_shell_pf:OnDeath(event)
	if IsClient() then return end
	local hUnit = event.unit
	local hCaster = self:GetCaster()

	if not hUnit or not hUnit.IsConsideredHero or not hUnit:IsConsideredHero() or not hUnit:HasModifier("modifier_tidehunter_anchor_smash_pf") then return end

	if hCaster:GetHeroFacetID() ~= 1 or not hCaster:IsAlive() then return end
	self:IncrementStackCount()
end

function modifier_tidehunter_kraken_shell_pf:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("bonus_reduction_per_kill") * self:GetStackCount()
end

------------------
-- ANCHOR SMASH --
------------------
function tidehunter_anchor_smash_pf:GetCastRange(vLocation, hTarget)
	return self:GetLevelSpecialValueFor("radius",self:GetLevel() - 1)
end

function tidehunter_anchor_smash_pf:GetIntrinsicModifierName()
	return "modifier_tidehunter_anchor_smash_pf_caster"
end

function tidehunter_anchor_smash_pf:OnSpellStart()		
	self:GetCaster():EmitSound("Hero_Tidehunter.AnchorSmash")
	
	local anchor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(anchor_particle)

	anchor_particle = ParticleManager:CreateParticle("particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide_swirl.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(anchor_particle, 1, Vector(self:GetSpecialValueFor("radius"), 0 , 0))
	ParticleManager:ReleaseParticleIndex(anchor_particle)
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER + DOTA_UNIT_TARGET_BUILDING , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
		self:Smash(enemy)
	end

	if self:GetCaster():HasAbility("tidehunter_anchor_smash_pf_allies") then
		allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetCaster():FindAbilityByName("tidehunter_anchor_smash_pf_allies"):GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,ally in pairs(allies) do
			GridNav:DestroyTreesAroundPoint( ally:GetAbsOrigin(), self:GetSpecialValueFor("radius"), true )

			ally:EmitSound("Hero_Tidehunter.AnchorSmash")
			local anchor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, ally)
			ParticleManager:ReleaseParticleIndex(anchor_particle)
			anchor_particle = ParticleManager:CreateParticle("particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide_swirl.vpcf", PATTACH_ABSORIGIN, ally)
			ParticleManager:SetParticleControl(anchor_particle, 1, Vector(self:GetSpecialValueFor("radius"), 0 , 0))
			ParticleManager:ReleaseParticleIndex(anchor_particle)
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), ally:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER  + DOTA_UNIT_TARGET_BUILDING , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				self:Smash(enemy)				
			end
		end
	end
end

function tidehunter_anchor_smash_pf:Smash(enemy)
	local caster = self:GetCaster()
	local ability = self
			
	-- The smash first applies the debuff, then the instant attack.
	if not enemy:IsMagicImmune() then
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_tidehunter_anchor_smash_pf", {duration = self:GetSpecialValueFor("reduction_duration") * (1 - enemy:GetStatusResistance())})

		if self:GetCaster():HasAbility("tidehunter_anchor_smash_pf_whack") then
			local whack = self:GetCaster():FindAbilityByName("tidehunter_anchor_smash_pf_whack")
			local root_chance = whack:GetLevelSpecialValueFor("root_chance",1)
			local root_duration = whack:GetLevelSpecialValueFor("root_duration",1)

			local knockback =
			{
				knockback_duration = 0.2 * (1 - enemy:GetStatusResistance()),
				duration = 0.2 * (1 - enemy:GetStatusResistance()),
				knockback_distance = 150,
				knockback_height = 30,
				center_x = caster:GetAbsOrigin().x,
				center_y = caster:GetAbsOrigin().y,
				center_z = caster:GetAbsOrigin().z,
			}
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

			if RandomInt(1, 100) < root_chance then
				Timers:CreateTimer(0.2 * (1 - enemy:GetStatusResistance()), function()
					if enemy and not enemy:IsNull() then
						enemy:AddNewModifier(
							caster,
							ability,
							"modifier_pathfinder_healing_ward_root",
							{ duration = root_duration }
						)
					end
				end)
			end
		end
	end
			
	
	self:GetCaster():PerformAttack(enemy, false, true, true, false, false, false, true)	
end


function tidehunter_anchor_smash_pf:GetCooldown(iLevel)
	local cooldown = self.BaseClass.GetCooldown(self, iLevel)

	if self:GetCaster():HasModifier("modifier_tidehunter_anchor_smash_pf_karate") then
		local reduce_pct = 50
		cooldown = cooldown - (cooldown / 100 * reduce_pct)
    end
    return cooldown
end

function tidehunter_anchor_smash_pf:GetManaCost(iLevel)
	local manacost = self.BaseClass.GetManaCost(self, iLevel)

	if self:GetCaster():HasModifier("modifier_tidehunter_anchor_smash_pf_karate") then		
        manacost = 0
    end
    return manacost
end


---------------------------
function modifier_tidehunter_anchor_smash_pf_caster:OnCreated()
	self:StartIntervalThink(0.5)
end

function modifier_tidehunter_anchor_smash_pf_caster:OnIntervalThink()
	if not IsServer() then return end
	if IsServer() and self:GetCaster():HasAbility("tidehunter_anchor_smash_pf_karate") and not self:GetCaster():HasModifier("tidehunter_anchor_smash_pf_karate") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_tidehunter_anchor_smash_pf_karate", {})
	end
	local anchor = self:GetCaster():FindAbilityByName("tidehunter_anchor_smash_pf")

	if anchor and anchor:GetAutoCastState() and anchor:IsTrained() and anchor:IsCooldownReady() and self:GetCaster():GetMana() > anchor:GetManaCost(anchor:GetLevel()) and not self:GetCaster():IsChanneling() then
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, anchor:GetLevelSpecialValueFor("radius", anchor:GetLevel() - 1), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			-- self:GetCaster():CastAbilityNoTarget(anchor, -1)
			ExecuteOrderFromTable({
			UnitIndex = self:GetCaster():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = anchor:entindex(),
			Queue = false,
		})
		end
	end
end


function modifier_tidehunter_anchor_smash_pf_karate:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT     ,	
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT ,	
	}
	
	return decFuncs
end

function modifier_tidehunter_anchor_smash_pf_karate:GetModifierAttackSpeedBonus_Constant()
	return -10000
end

function modifier_tidehunter_anchor_smash_pf_karate:GetModifierBaseAttackTimeConstant()
	return 1
end

---------------------------
-- ANCHOR SMASH MODIFIER --
---------------------------

function modifier_tidehunter_anchor_smash_pf:OnCreated()
	if self:GetAbility() then
		self.damage_reduction	= self:GetAbility():GetLevelSpecialValueFor("damage_reduction", self:GetAbility():GetLevel() - 1)
	else
		self:Destroy()
	end
end

function modifier_tidehunter_anchor_smash_pf:OnRefresh()
	self:OnCreated()
end

function modifier_tidehunter_anchor_smash_pf:DeclareFunctions()
	return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
end

function modifier_tidehunter_anchor_smash_pf:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction * -1
end


-----------------------------
------ 	   RAVAGE	  -------
-----------------------------
function tidehunter_ravage_pf:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end

function tidehunter_ravage_pf:OnAbilityPhaseStart()
	self:GetCaster():AddActivityModifier("belly_flop")
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	self:GetCaster():ClearActivityModifiers()
	return true
end


function tidehunter_ravage_pf:OnSpellStart()

	-- Ability properties
	local caster			=	self:GetCaster()
	local caster_pos		=	caster:GetAbsOrigin()
	local cast_sound		=	"Ability.Ravage"
	local hit_sound			=	"Hero_Tidehunter.RavageDamage"		
	local particle 			=	"particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf"
	-- Ability parameters
	local end_radius	=	self:GetSpecialValueFor("radius")
	local stun_duration	=	self:GetSpecialValueFor("duration")		

	-- Emit sound
	caster:EmitSound(cast_sound)

	-- Emit particle
	self.particle_fx	=	ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(self.particle_fx, 0, caster_pos)
	-- Set each ring in it's position
	for i=1, 5 do
		ParticleManager:SetParticleControl(self.particle_fx, i, Vector(end_radius * 0.2 * i, 0 , 0))
	end
	ParticleManager:ReleaseParticleIndex(self.particle_fx)

	local radius =	end_radius * 0.2
	local ring	 =	1	
	local hit_units	=	{}

	-- Find units in a ring 5 times and hit them with ravage
	Timers:CreateTimer(function()
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), caster_pos, nil, ring * radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )

		for _,enemy in pairs(enemies) do
			local bIsHitAlready = false
			for _,unit in pairs(hit_units) do
				if unit == enemy then
					bIsHitAlready = true
					break
				end
			end
			if not bIsHitAlready then
				-- Emit hit sound
				enemy:EmitSound(hit_sound)

				-- Apply stun and air time modifiers
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration * (1 - enemy:GetStatusResistance())})

				-- Knock the enemy into the air
				local knockback =
				{
					knockback_duration = 0.5 * (1 - enemy:GetStatusResistance()),
					duration = 0.5 * (1 - enemy:GetStatusResistance()),
					knockback_distance = 0,
					knockback_height = 350,
				}
				enemy:RemoveModifierByName("modifier_knockback")
				enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

				local hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_ABSORIGIN, enemy)
				ParticleManager:ReleaseParticleIndex(hit_fx)
				hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_ravage_tentacle_model_rocks.vpcf", PATTACH_ABSORIGIN, enemy)
				ParticleManager:ReleaseParticleIndex(hit_fx)


				
				Timers:CreateTimer(0.5, function()
					-- Apply damage
					local damageTable = {victim = enemy,
						damage = self:GetLevelSpecialValueFor("damage", self:GetLevel() - 1),
						damage_type = self:GetAbilityDamageType(),
						attacker = caster,
						ability = self
					}
					ApplyDamage(damageTable)

					-- We need to do this because the gesture takes it's fucking time to stop
					enemy:RemoveGesture(ACT_DOTA_FLAIL)
				end)

				-- Mark the enemy as hit to not get hit again
				table.insert(hit_units, enemy)
			end
		end

		-- Send the next ring
		if ring < 5 then
			ring = ring + 1
			return 0.2
		else
			if self:GetCaster():HasAbility("tidehunter_ravage_pf_puddle") then
				local puddle_thinker = CreateModifierThinker(
					self:GetCaster(),
					self,
					"modifier_tidehunter_ravage_pf_puddle",
					{},
					self:GetCaster():GetOrigin(),
					self:GetCaster():GetTeamNumber(),
					false		
				)
			end
			return nil
		end
	end)
end

-------------------------------------------
-- RAVAGE PUDDLE AURA MODIFIER --
-------------------------------------------

modifier_tidehunter_ravage_pf_puddle = class ({})

function modifier_tidehunter_ravage_pf_puddle:IsHidden()					return true end

function modifier_tidehunter_ravage_pf_puddle:IsAura()					return true end
function modifier_tidehunter_ravage_pf_puddle:IsAuraActiveOnDeath() 		return false end

function modifier_tidehunter_ravage_pf_puddle:GetAuraRadius()				
	return self.puddle_radius 
end


function modifier_tidehunter_ravage_pf_puddle:GetAuraSearchTeam()			
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tidehunter_ravage_pf_puddle:GetAuraSearchType()			
	return DOTA_UNIT_TARGET_HERO
end

function modifier_tidehunter_ravage_pf_puddle:GetModifierAura()			
	return "modifier_tidehunter_ravage_pf_puddle_effect" 
end

function modifier_tidehunter_ravage_pf_puddle:GetAuraEntityReject(hTarget)	return hTarget ~= self:GetCaster() end

function modifier_tidehunter_ravage_pf_puddle:OnCreated()
	if not IsServer() or not self:GetCaster():HasAbility("tidehunter_ravage_pf_puddle") then
		return
	end

	self.puddle_radius	= self:GetCaster():FindAbilityByName("tidehunter_ravage_pf_puddle"):GetLevelSpecialValueFor("radius",1)
	
	
	self.puddle_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_water_puddle.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.puddle_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.puddle_particle, 1, Vector(self.puddle_radius, 1, 1))
	ParticleManager:SetParticleControl(self.puddle_particle, 15, Vector(255, 1, 1))
	ParticleManager:SetParticleControl(self.puddle_particle, 16, Vector(1, 1, 1))
	self:AddParticle(self.puddle_particle, false, false, -1, false, false)

	self:StartIntervalThink(0.5)
end

function modifier_tidehunter_ravage_pf_puddle:OnIntervalThink()
	local ravage = self:GetCaster():FindAbilityByName("tidehunter_ravage_pf")
	local special = self:GetCaster():FindAbilityByName("tidehunter_ravage_pf_puddle")

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, special:GetLevelSpecialValueFor("radius",1), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local bCasterInAoE = false
	for _,ally in pairs(allies) do
		if ally == self:GetCaster() then
			bCasterInAoE = true
		end
	end
	if not bCasterInAoE then
		self:Destroy()
		return
	end

	if not ravage or not ravage:IsTrained() or not special then return end
	
	local proc_chance =  special:GetLevelSpecialValueFor("stun_chance",1) * 0.5
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, special:GetLevelSpecialValueFor("radius",1), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	
	local caster = self:GetCaster()
	
	for _,target in pairs(enemies) do
		if target and not target:IsMagicImmune() and RollPseudoRandomPercentage(proc_chance,DOTA_PSEUDO_RANDOM_CUSTOM_GAME_3, self:GetCaster()) then						
			local stun_duration	= ravage:GetLevelSpecialValueFor("duration", ravage:GetLevel() - 1)
			local stun_damage	= ravage:GetLevelSpecialValueFor("damage", ravage:GetLevel() - 1)
			target:EmitSound("Hero_Tidehunter.RavageDamage")		

			-- Apply stun and air time modifiers
			target:AddNewModifier(self:GetCaster(), ravage, "modifier_stunned", {duration = stun_duration * (1 - target:GetStatusResistance())})

			-- Knock the enemy into the air
			local knockback =
			{
				knockback_duration = 0.5 * (1 - target:GetStatusResistance()),
				duration = 0.5 * (1 - target:GetStatusResistance()),
				knockback_distance = 0,
				knockback_height = 350,
			}
			target:RemoveModifierByName("modifier_knockback")
			target:AddNewModifier(caster, self, "modifier_knockback", knockback)

			local hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_a.vpcf", PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(hit_fx, 60, Vector(255, 0, 0))
			ParticleManager:SetParticleControl(hit_fx, 61, Vector(255, 0, 0))
			ParticleManager:ReleaseParticleIndex(hit_fx)

			hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_ravage_tentacle_model_rocks.vpcf", PATTACH_ABSORIGIN, target)
			ParticleManager:ReleaseParticleIndex(hit_fx)

			target:EmitSound("Ability.GushImpact")

			
			Timers:CreateTimer(0.5, function()
				-- Apply damage
				local damageTable = {
					victim = target,
					damage = stun_damage,
					damage_type = ravage:GetAbilityDamageType(),
					attacker = caster,
					ability = self
				}
				ApplyDamage(damageTable)

				-- We need to do this because the gesture takes it's fucking time to stop
				if target and not target:IsNull() then
					target:RemoveGesture(ACT_DOTA_FLAIL)
				end
			end)
		end
	end
end

function modifier_tidehunter_ravage_pf_puddle:OnDestroy()
	if not IsServer() then return end
	if self.puddle_particle then
		ParticleManager:DestroyParticle(self.puddle_particle, false)
		ParticleManager:ReleaseParticleIndex(self.puddle_particle)
	end
	self:GetParent():RemoveSelf()
end

modifier_tidehunter_ravage_pf_puddle_effect = class({})

function modifier_tidehunter_ravage_pf_puddle_effect:IsHidden()	return false end

function modifier_tidehunter_ravage_pf_puddle_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK }
end

function modifier_tidehunter_ravage_pf_puddle_effect:GetModifierPhysical_ConstantBlock()
	if self:GetParent() ~= self:GetCaster() then return end
	local shell_modifier = self:GetParent():FindModifierByName("modifier_tidehunter_kraken_shell_pf")
	if not shell_modifier then return end

	local block_amp	= self:GetCaster():FindAbilityByName("tidehunter_ravage_pf_puddle"):GetLevelSpecialValueFor("block_amp",1)

	return shell_modifier:GetModifierPhysical_ConstantBlock() + (shell_modifier:GetModifierPhysical_ConstantBlock() / 100 * block_amp)
end

function modifier_tidehunter_ravage_pf_puddle_effect:GetStatusEffectName()	
	return "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_v2_omni.vpcf"	
end


---------------------------
----- CRUNCH --------------
---------------------------
function tidehunter_pf_crunch:OnAbilityPhaseStart()
	self:GetCaster():AddActivityModifier("tidehunter_toss_fish")
	self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
	
	local target = self:GetCursorTarget()
	if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then
		return false
	else
		return true
	end	
end

function tidehunter_pf_crunch:OnUpgrade()
	if IsServer() then
		self:GetCaster():SwapAbilities("tidehunter_kraken_shell_pf", "tidehunter_pf_crunch", true , true)
	end
end

function tidehunter_pf_crunch:OnSpellStart()
	if not IsServer() then return end	

	local crunch_duration = self:GetLevelSpecialValueFor("duration",1)
	if self:GetCursorTarget() then	
		local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_WORLDORIGIN, self:GetCursorTarget())
		ParticleManager:SetParticleControl( fx, 0, self:GetCursorTarget():GetAbsOrigin())
		ParticleManager:SetParticleControl( fx, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(fx)	
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_tidehunter_pf_crunch_victim", {duration = crunch_duration})
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_nevermore_requiem_fear", {duration = crunch_duration}) --to disable
	end
end

function modifier_tidehunter_pf_crunch_victim:OnCreated()
	if not IsServer() then return end
	self:GetParent():AddNoDraw()
	self:StartIntervalThink(1)
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
end

function modifier_tidehunter_pf_crunch_victim:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.overhead_particle, false)
	ParticleManager:ReleaseParticleIndex(self.overhead_particle)
	FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
	self:GetParent():RemoveNoDraw()

	if self:GetCaster() then
		self:GetCaster():ClearActivityModifiers()
		local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl( fx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl( fx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(fx)	
	end
end

function modifier_tidehunter_pf_crunch_victim:OnIntervalThink()

	local ability = self:GetAbility()
	if not ability or not IsServer() then return end
	
	local pct_damage = ability:GetLevelSpecialValueFor("pct_damage",1)
	local dmg = self:GetCaster():GetMaxHealth() / 100 * pct_damage


	local damageTable = {
					victim = self:GetParent(),
					damage = dmg,
					damage_type = ability:GetAbilityDamageType(),
					attacker = self:GetCaster(),
					ability = ability,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
				}
	ApplyDamage(damageTable)

	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())

	damageTable.victim = self:GetAbility():GetCaster()
	-- damageTable.attacker = self:GetParent()
	ApplyDamage(damageTable)

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( nFXIndex, 1, RandomVector(10):Normalized() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 10, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Dungeon.BloodSplatterImpact.Lesser", self:GetCaster() )
	EmitSoundOn( "Damage_Melee.Player", self:GetCaster() )	
	
end

function modifier_tidehunter_pf_crunch_victim:CheckState() return {	
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_ATTACK_IMMUNE ]	= true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
} end


function modifier_tidehunter_pf_crunch_victim:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH ,		
	}
	return funcs
end

function modifier_tidehunter_pf_crunch_victim:OnDeath(params)	
	if not IsServer() then return end	
	if params.unit ~= self:GetParent() and params.unit ~= self:GetCaster() then 		
		return 
	end
	if params.unit == self:GetCaster() then				
		self:Destroy()
	elseif params.unit == self:GetParent() then		
		if not self:GetCaster():HasModifier("modifier_tidehunter_pf_crunch_buff") then			
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_tidehunter_pf_crunch_buff", {}):IncrementStackCount()
			self:GetCaster():CalculateStatBonus(true)
		else			
			local mod = self:GetCaster():FindModifierByName("modifier_tidehunter_pf_crunch_buff")
			if mod then 
				mod:IncrementStackCount()
				self:GetCaster():CalculateStatBonus(true)
			end
		end
		local fx = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_splash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl( fx, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( fx, 3, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex(fx)
	end
end

------------------------------
function modifier_tidehunter_pf_crunch_buff:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.speed_reduction = ability:GetLevelSpecialValueFor("speed_reduction",1)
		self.armor = ability:GetLevelSpecialValueFor("armor",1)
		self.health = ability:GetLevelSpecialValueFor("health",1)
		self.magic_resist = ability:GetLevelSpecialValueFor("magic_resist",1)
		self.size = ability:GetLevelSpecialValueFor("size",1)
		self.regen = ability:GetLevelSpecialValueFor("regen",1)
		self.status_resist = ability:GetLevelSpecialValueFor("status_resist",1)
		self.as_reduction = ability:GetLevelSpecialValueFor("as_reduction",1)
		self.damage_bonus = ability:GetLevelSpecialValueFor("damage_bonus",1)
		self:SetHasCustomTransmitterData( true )
	end
end

function modifier_tidehunter_pf_crunch_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE, 
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,

		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_tidehunter_pf_crunch_buff:OnDeath(params)	
	if IsServer() and params.unit == self:GetParent() then
		self:SetStackCount(math.floor(self:GetStackCount() / 2))
		if self:GetStackCount() < 1 then
			self:Destroy()
		end
	end
end

function modifier_tidehunter_pf_crunch_buff:AddCustomTransmitterData( )
	return
	{
		speed_reduction = self.speed_reduction,
		armor = self.armor,
		health = self.health,
		magic_resist = self.magic_resist,
		size = self.size,
		regen = self.regen,
		status_resist = self.status_resist,
		as_reduction = self.as_reduction,
		damage_bonus = self.damage_bonus,
	}
end

function modifier_tidehunter_pf_crunch_buff:HandleCustomTransmitterData( data )
	self.speed_reduction = data.speed_reduction
	self.armor = data.armor
	self.health  = data.health
	self.magic_resist = data.magic_resist
	self.size = data.size
	self.status_resist = data.status_resist
	self.regen = data.regen
	self.as_reduction = data.as_reduction
	self.damage_bonus = data.damage_bonus
end

function modifier_tidehunter_pf_crunch_buff:GetModifierAttackRangeBonus() 
	if not self:GetParent():PassivesDisabled() then
		return 10 * self:GetStackCount()
	end
	return 0
end

function modifier_tidehunter_pf_crunch_buff:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
		return -1 * self.as_reduction * self:GetStackCount()
	end
	return 0
end

function modifier_tidehunter_pf_crunch_buff:GetModifierConstantHealthRegen() 
	if not self:GetParent():PassivesDisabled() then
		return self.regen * self:GetStackCount()
	end
	return 0
end

function modifier_tidehunter_pf_crunch_buff:GetModifierStatusResistance() 
	if not self:GetParent():PassivesDisabled() then
		return self.status_resist * self:GetStackCount()
	end
	return 0
end

function modifier_tidehunter_pf_crunch_buff:GetModifierModelScale() 
	if not self:GetParent():PassivesDisabled() then
		return self.size * self:GetStackCount()
	end
	return 1
end

function modifier_tidehunter_pf_crunch_buff:GetModifierMagicalResistanceBonus() 
	if not self:GetParent():PassivesDisabled() then
		return self.magic_resist * self:GetStackCount()
	end
	return 0
end

function modifier_tidehunter_pf_crunch_buff:GetModifierPhysicalArmorBonus() 
	if not self:GetParent():PassivesDisabled() then
		return self.armor * self:GetStackCount()
	end
	return 0
end

function modifier_tidehunter_pf_crunch_buff:GetModifierExtraHealthBonus() 
	return self.health * self:GetStackCount()
end

function modifier_tidehunter_pf_crunch_buff:GetModifierMoveSpeedBonus_Constant()
	return self.speed_reduction * self:GetStackCount() * -1
end

function modifier_tidehunter_pf_crunch_buff:GetModifierBaseAttack_BonusDamage()
	return self.damage_bonus * self:GetStackCount()
end

function modifier_tidehunter_pf_crunch_buff:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end
