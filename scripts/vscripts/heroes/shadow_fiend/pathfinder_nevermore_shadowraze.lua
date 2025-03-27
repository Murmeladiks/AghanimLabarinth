LinkLuaModifier("modifier_pathfinder_shadowraze_debuff", "heroes/shadow_fiend/pathfinder_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

pathfinder_nevermore_shadowraze_near = pathfinder_nevermore_shadowraze_near or class({})

--------------------------------------------------------------------------------

function pathfinder_nevermore_shadowraze_near:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nevermore/nevermore_shadowraze_debuff.vpcf", context)		
end

--------------------------------------------------------------------------------

function pathfinder_nevermore_shadowraze_near:GetAbilityTextureName()
	return self:GetAbilityTextureNameFromParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf")
end

--------------------------------------------------------------------------------

function pathfinder_nevermore_shadowraze_near:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local raze_radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
	local raze_distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel() - 1)

	-- Calculate the center point of the raze
	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance
	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)

	if caster:HasAbility("pathfinder_nevermore_special_raze_multi") then
		local raze_angle = 180
		local left_qangle = QAngle(0, raze_angle, 0)		
		local left = RotatePosition(caster:GetAbsOrigin(), left_qangle, raze_point)		
		CastShadowRazeOnPoint(caster, ability, left, raze_radius)		
	end
end

--------------------------------------------------------------------------------

pathfinder_nevermore_shadowraze_medium = pathfinder_nevermore_shadowraze_medium or class({})

--------------------------------------------------------------------------------

function pathfinder_nevermore_shadowraze_medium:GetAbilityTextureName()
	return self:GetAbilityTextureNameFromParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf")
end

function pathfinder_nevermore_shadowraze_medium:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local raze_radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
	local raze_distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel() - 1)

	-- Calculate the center point of the raze
	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance
	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)

	if caster:HasAbility("pathfinder_nevermore_special_raze_multi") then
		local raze_angle = caster:FindAbilityByName("pathfinder_nevermore_special_raze_multi"):GetLevelSpecialValueFor("angle",1)
		local left_qangle = QAngle(0, raze_angle, 0)
		local right_qangle = QAngle(0, raze_angle * (-1), 0)

		local left = RotatePosition(caster:GetAbsOrigin(), left_qangle, raze_point)
		local right = RotatePosition(caster:GetAbsOrigin(), right_qangle, raze_point)

		CastShadowRazeOnPoint(caster, ability, left, raze_radius)
		CastShadowRazeOnPoint(caster, ability, right, raze_radius)		
	end
end

pathfinder_nevermore_shadowraze_far = pathfinder_nevermore_shadowraze_far or class({})

--------------------------------------------------------------------------------

function pathfinder_nevermore_shadowraze_far:GetAbilityTextureName()
	return self:GetAbilityTextureNameFromParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf")
end

function pathfinder_nevermore_shadowraze_far:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local raze_radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
	local raze_distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel() - 1)

	-- Calculate the center point of the raze
	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance
	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)

	if caster:HasAbility("pathfinder_nevermore_special_raze_multi") then
		local raze_angle = caster:FindAbilityByName("pathfinder_nevermore_special_raze_multi"):GetLevelSpecialValueFor("angle",1)
		local left_qangle = QAngle(0, raze_angle, 0)
		local right_qangle = QAngle(0, raze_angle * (-1), 0)

		local left = RotatePosition(caster:GetAbsOrigin(), left_qangle, raze_point)
		local right = RotatePosition(caster:GetAbsOrigin(), right_qangle, raze_point)

		CastShadowRazeOnPoint(caster, ability, left, raze_radius)
		CastShadowRazeOnPoint(caster, ability, right, raze_radius)				

		left = RotatePosition(caster:GetAbsOrigin(), left_qangle, left)
		right = RotatePosition(caster:GetAbsOrigin(), right_qangle, right)

		CastShadowRazeOnPoint(caster, ability, left, raze_radius)
		CastShadowRazeOnPoint(caster, ability, right, raze_radius)	
	end
end

function CastShadowRazeOnPoint(caster, ability, point, radius)
	-- Ability properties
	local sound_raze = "Hero_Nevermore.Shadowraze"
	local particle_raze = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"

	EmitSoundOnLocationWithCaster(point, sound_raze, caster)

	-- Add particle effects. CP0 is location, CP1 is radius
	local particle_raze_fx = ParticleManager:CreateParticle(particle_raze, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle_raze_fx, 0, point)
	ParticleManager:ReleaseParticleIndex(particle_raze_fx)

	-- Find enemy units in radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  point,
									  nil,
									  radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)

	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() then
			ApplyShadowRazeDamage(caster, ability, enemy)
		end
	end
end

function ApplyShadowRazeDamage(caster, ability, enemy)
	local damage = ability:GetSpecialValueFor("damage")
	local modifier_debuff = "modifier_pathfinder_shadowraze_debuff"
	local stack_damage = ability:GetSpecialValueFor("stack_damage")
	local stack_duration = ability:GetSpecialValueFor("stack_duration")

	local debuff_boost = 0		
	if enemy:HasModifier(modifier_debuff) then
		debuff_boost	= stack_damage * enemy:FindModifierByName(modifier_debuff):GetStackCount()
		damage 			= damage + debuff_boost
	end

	local damageTable = {victim = enemy,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = caster,
						ability = ability
						}
	local actualy_damage = ApplyDamage(damageTable)    

	if enemy and not enemy:IsNull() and not enemy:HasModifier(modifier_debuff) then
		enemy:AddNewModifier(caster, ability, modifier_debuff, {duration = stack_duration})
	end
	local debuff = enemy:FindModifierByName(modifier_debuff)
	if debuff then
		debuff:IncrementStackCount()
		debuff:ForceRefresh()
	end
end

function pathfinder_nevermore_shadowraze_far:Spawn()
	self:GetCaster().CastShadowRazeOnPoint = CastShadowRazeOnPoint
end

modifier_pathfinder_shadowraze_debuff = class ({})

--------------------------------------------------------------------------------

function modifier_pathfinder_shadowraze_debuff:IsDebuff() return true end

--------------------------------------------------------------------------------

function modifier_pathfinder_shadowraze_debuff:OnCreated()
	local hAbility = self:GetAbility()

	self.nMoveSlow = -hAbility:GetSpecialValueFor("movement_speed_debuff")
end

--------------------------------------------------------------------------------

function modifier_pathfinder_shadowraze_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_pathfinder_shadowraze_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.nMoveSlow * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_pathfinder_shadowraze_debuff:GetEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_shadowraze_debuff.vpcf"
end