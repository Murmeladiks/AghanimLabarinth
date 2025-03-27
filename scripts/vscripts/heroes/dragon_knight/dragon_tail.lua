LinkLuaModifier( "modifier_pathfinder_dk_dragon_tail_attack", "heroes/dragon_knight/dragon_tail", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pathfinder_dk_dragon_tail_chain", "heroes/dragon_knight/dragon_tail", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pathfinder_dk_dragon_tail_chain_unkillable", "heroes/dragon_knight/dragon_tail", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

pathfinder_dk_dragon_tail = class({})

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:GetIntrinsicModifierName()
	return "modifier_pathfinder_dk_dragon_tail_attack"
end

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:GetCastRange( vLocation, hTarget )
	local nLegendaryBonus = self:GetCaster():FindTalentValue("pathfinder_dk_dragon_tail_bounce", "bonus_range")

	if self:GetCaster():HasModifier( "modifier_dragon_knight_pf_elder_dragon_form" ) then
		return self:GetSpecialValueFor("dragon_cast_range") + nLegendaryBonus
	end

	return self.BaseClass.GetCastRange(self, vLocation, hTarget) + nLegendaryBonus
end

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	if self:GetCaster():HasModifier( "modifier_dragon_knight_pf_elder_dragon_form" ) then
		local radius_mult = self:GetSpecialValueFor("dragon_radius_mult") / 100
		radius = radius + (radius * radius_mult)
	end
	return radius
end

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_pf_elder_dragon_form", caster )

	if not modifier and not caster:HasAbility("pathfinder_dk_dragon_tail_bounce") then
		if target:TriggerSpellAbsorb( self ) then return end

		self:Hit( target, false )
		caster:EmitSound("Hero_DragonKnight.DragonTail.Cast.Kindred")

		return
	end

	local bounces = 0
	if caster:HasAbility("pathfinder_dk_dragon_tail_bounce") then
		bounces = caster:FindAbilityByName("pathfinder_dk_dragon_tail_bounce"):GetLevelSpecialValueFor("bounces",1)
	end

	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		Source = caster,
		Ability = self,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
		iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
		bDodgeable = true,
		ExtraData = {
			bounce = bounces
		}
	})
	caster:EmitSound("Hero_DragonKnight.DragonTail.DragonFormCast")
end

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:HitSingle( target )
	if not target or target:IsNull() or not target:IsAlive() then return end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "stun_duration" )

	local hAttackModifier = caster:FindModifierByName("modifier_pathfinder_dk_dragon_tail_attack")

	--instead of applying flat damage, we're making DK attack the affected unit
	if hAttackModifier then
		hAttackModifier.bActive = true
		caster:PerformAttack(target, false, true, true, false, false, false, true)
		hAttackModifier.bActive = false
	end

	local nDamage = self:GetSpecialValueFor("damage")

	local hWyrmWrath = caster:FindAbilityByName("dragon_knight_pf_dragon_blood")

	if hWyrmWrath and hWyrmWrath:IsTrained() then
		nDamage = nDamage + hWyrmWrath:GetSpecialValueFor("spell_damage")
	end

	ApplyDamage({
		attacker = caster,
		victim = target,
		damage = nDamage,
		damage_type = (self:GetSpecialValueFor("physical_damage_type") > 0) and DAMAGE_TYPE_PHYSICAL or DAMAGE_TYPE_MAGICAL,
		ability = self
	})

	target:AddNewModifier(caster, self, "modifier_stunned", {duration = duration})
end

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:Hit( target, dragonform )
	local caster = self:GetCaster()
	target:EmitSound("Hero_DragonKnight.DragonTail.Target")

	if target:TriggerSpellAbsorb( self ) then return end

	local radius = self:GetSpecialValueFor("radius")

	if dragonform then
		local radius_mult = self:GetSpecialValueFor("dragon_radius_mult") / 100
		radius = radius + (radius * radius_mult)
	end

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	for _,enemy in pairs(enemies) do
		self:HitSingle(enemy)
	end

	self:PlayEffects( target, dragonform, radius )

	if caster:HasShard("pathfinder_dk_dragon_tail_chain") and target and target:GetTeamNumber() ~= caster:GetTeamNumber() then
		target:AddNewModifier(caster, self, "modifier_pathfinder_dk_dragon_tail_chain", {duration = caster:FindTalentValue("pathfinder_dk_dragon_tail_chain", "duration")})
	end
end

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end
	self:Hit( target, true )

	if self:GetCaster():HasAbility("pathfinder_dk_dragon_tail_bounce") then

		if target == self:GetCaster() then
			return true
		end

		local shard = self:GetCaster():FindAbilityByName("pathfinder_dk_dragon_tail_bounce")
		local range = shard:GetLevelSpecialValueFor("bonus_range", 1)

		local this = self
		local bounces = extraData.bounce - 1
		Timers(0.1, function()

			local info = {
				Target = this:GetCaster(),
				Source = target,
				Ability = self,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
				iMoveSpeed = this:GetSpecialValueFor( "projectile_speed" ),
				bDodgeable = true,
				ExtraData = {
					bounce = bounces
				}
			}

			local enemies = FindUnitsInRadius( this:GetCaster():GetTeamNumber(), location, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false )
			if bounces > 0 and (#enemies > 1 or (#enemies == 1 and enemies[1] ~= target)) then			
				local i = 1
				local new_target = enemies[i]
				while new_target == target do
					i = i+1
					new_target = enemies[i]
				end

				info.Target = new_target				
			end

			ProjectileManager:CreateTrackingProjectile(info)
		end)
	end	
	return true
end

--------------------------------------------------------------------------------

function pathfinder_dk_dragon_tail:PlayEffects( target, dragonform, radius )
	local vec = target:GetOrigin()-self:GetCaster():GetOrigin()

	local attach = "attach_attack1"
	if dragonform then
		attach = "attach_attack2"
	end

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		target
	)
	ParticleManager:SetParticleControl( effect_cast, 3, vec )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0),
		true 
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( nFXIndex, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

--------------------------------------------------------------------------------

modifier_pathfinder_dk_dragon_tail_attack = class({})

--------------------------------------------------------------------------------

function modifier_pathfinder_dk_dragon_tail_attack:IsHidden()		return true end
function modifier_pathfinder_dk_dragon_tail_attack:IsPurgable()		return false end
function modifier_pathfinder_dk_dragon_tail_attack:RemoveOnDeath()	return false end
function modifier_pathfinder_dk_dragon_tail_attack:IsPermanent()	return true end

--------------------------------------------------------------------------------

function modifier_pathfinder_dk_dragon_tail_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

--------------------------------------------------------------------------------

function modifier_pathfinder_dk_dragon_tail_attack:GetAttackSound()
	if self.bActive then return "" end
end

--------------------------------------------------------------------------------

function modifier_pathfinder_dk_dragon_tail_attack:GetModifierBaseDamageOutgoing_Percentage( params )
	if self.bActive then
		return self:GetAbility():GetSpecialValueFor("attack_damage") - 100
	end
end

--------------------------------------------------------------------------------

function modifier_pathfinder_dk_dragon_tail_attack:OnAttackLanded(event)
	if IsClient() or event.target ~= self:GetParent() or not self:GetParent():HasShard("pathfinder_dk_dragon_tail_passive") then return end
	local hParent = self:GetParent()

	if RollPseudoRandomPercentage(hParent:FindTalentValue("pathfinder_dk_dragon_tail_passive", "chance"), DOTA_PSEUDO_RANDOM_CUSTOM_GAME_3, hParent) then
		local old_target = hParent:GetCursorCastTarget()

		hParent:SetCursorCastTarget(event.attacker)
		self:GetAbility():OnSpellStart()
		hParent:SetCursorCastTarget(old_target)
	end
end

--------------------------------------------------------------------------------

-------------------

modifier_pathfinder_dk_dragon_tail_chain	= class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return true end,		
})

function modifier_pathfinder_dk_dragon_tail_chain:OnCreated()
	if not IsServer() then return end

	self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )

	local shard = self:GetCaster():FindAbilityByName("pathfinder_dk_dragon_tail_chain")
		
	self.tick = 0.25
	-- self.heal = self:GetCaster():GetMaxHealth() / 100 * shard:GetLevelSpecialValueFor("hp_drain",1) * self.tick
	self.reflect = shard:GetLevelSpecialValueFor("reflect_percentage",1)
	self.max_dist = shard:GetLevelSpecialValueFor("max_distance",1)

	local bound = self:GetParent():entindex()
	local duration = self:GetRemainingTime()

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pathfinder_dk_dragon_tail_chain_unkillable", {bound = bound, duration = duration})

	self:StartIntervalThink(self.tick)
end

function modifier_pathfinder_dk_dragon_tail_chain:OnIntervalThink()
	if not IsServer() then return end

	if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.max_dist then
		self:Destroy()
	end
end

function modifier_pathfinder_dk_dragon_tail_chain:OnDestroy()
	if not IsServer() then return end

	self:GetCaster():RemoveModifierByName("modifier_pathfinder_dk_dragon_tail_chain_unkillable")

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_pathfinder_dk_dragon_tail_chain:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE 
	}
end

function modifier_pathfinder_dk_dragon_tail_chain:OnTakeDamage(params)
	if IsServer() and self:GetCaster() == params.unit and bitand(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bitand(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local damageTable = {
			victim = self:GetParent(),
			attacker = params.unit,
			damage = params.damage / 100 * self.reflect,
			damage_type = params.damage_type,
			damage_flag = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			ability = self:GetAbility(),
		}
		ApplyDamage(damageTable)

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_cast_soulchain_arc.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
	end
end


-----

modifier_pathfinder_dk_dragon_tail_chain_unkillable	= class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
})

function modifier_pathfinder_dk_dragon_tail_chain_unkillable:OnCreated(kv)
	if not IsServer() then return end
	
	self.bound_target = EntIndexToHScript(kv.bound)
	if not self.bound_target then
		self:Destroy()
	end
end

function modifier_pathfinder_dk_dragon_tail_chain_unkillable:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end

function modifier_pathfinder_dk_dragon_tail_chain_unkillable:GetModifierAvoidDamage(params)
	if IsServer() and params.unit == self:GetParent() and params.damage >= self:GetParent():GetHealth() then
		return 1
	end
end
