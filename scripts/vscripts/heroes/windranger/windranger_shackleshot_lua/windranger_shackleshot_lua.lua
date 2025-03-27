windranger_shackleshot_lua = class({})

--------------------------------------------------------------------------------

LinkLuaModifier("modifier_shackle_stun", 								"heroes/windranger/windranger_shackleshot_lua/modifier_shackle_stun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_windranger_shackleshot_armour", 				"heroes/windranger/windranger_shackleshot_lua/windranger_shackleshot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_windrunner_pf_shackleshot_self_damage_buff", 	"heroes/windranger/windranger_shackleshot_lua/windranger_shackleshot_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function windranger_shackleshot_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local location = caster:GetOrigin()

	if caster:HasAbility("pathfinder_special_windranger_shackleshot_armor") then
		caster:AddNewModifier(caster, self, "modifier_windranger_shackleshot_armour", {})
	end

	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = "particles/units/heroes/hero_windrunner/windrunner_shackleshot.vpcf",
		iMoveSpeed = self:GetSpecialValueFor( "arrow_speed" ),
		bDodgeable = true,                           -- Optional	

		ExtraData = {
			location_x = location.x,
			location_y = location.y,
			location_z = location.z,
		}
	})

	caster:EmitSound("Hero_Windrunner.ShackleshotCast")
end

--------------------------------------------------------------------------------

function windranger_shackleshot_lua:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target then return end

	if target:TriggerSpellAbsorb( self ) then return end

	-- references
	local hCaster = self:GetCaster()
	local search_radius = self:GetSpecialValueFor( "shackle_distance" )
	local stun_duration = self:GetSpecialValueFor( "stun_duration" )
	local fail_duration = self:GetSpecialValueFor( "fail_stun_duration" )
	local search_angle = self:GetSpecialValueFor( "shackle_angle" )
	local search_count = self:GetSpecialValueFor( "shackle_count" )	

	local nDamagePerUnit = self:GetSpecialValueFor("bonus_damage_per_hero")
	local nCaptainMult = self:GetSpecialValueFor("bonus_damage_per_captain_mult")
	local nBossMult = self:GetSpecialValueFor("bonus_damage_per_boss_mult")
	local nBuffDuration = self:GetSpecialValueFor("damage_buff_duration")
	local nTotalCount = 1

	-- init data
	local shackled = 0
	local location = Vector( ExtraData.location_x, ExtraData.location_y, ExtraData.location_z )
	local target_origin = target:GetOrigin()
	local target_angle = VectorToAngles( target_origin-location ).y

	local latch = false

	-- find nearby enemies
	local enemies = FindUnitsInRadius(
		hCaster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)	

	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			-- check position angle
			local enemy_angle = VectorToAngles( enemy:GetOrigin()-target_origin ).y
			if math.abs( AngleDiff( target_angle, enemy_angle ) ) <= search_angle then
				local nDamageStackValue = 1

				shackled = shackled + 1

				-- stun both units
				target:AddNewModifier(
					hCaster, -- player source
					self, -- ability source
					"modifier_shackle_stun", -- modifier name
					{ duration = stun_duration } -- kv
				)
				enemy:AddNewModifier(
					hCaster, -- player source
					self, -- ability source
					"modifier_shackle_stun", -- modifier name
					{ duration = stun_duration } -- kv
				)

				-- play effects
				self:PlayEffects1( target, enemy, stun_duration )
				latch = true
				
				if enemy:IsConsideredHero() then
					if enemy:IsBoss() or enemy:IsBossCreature() or enemy.bAbsoluteNoCC or enemy.bMotionControlExcluded then
						nDamageStackValue = nBossMult
					else
						nDamageStackValue = nCaptainMult
					end
				end

				nTotalCount = nTotalCount + nDamageStackValue
			end			
			-- in case multiple shackled units allowed
			if shackled>=search_count then break end
		end
	end

	local hPowershot = hCaster:FindAbilityByName("windranger_powershot_lua")

	if hCaster:HasAbility("pathfinder_special_windranger_shackleshot_aoe") and latch == true and hPowershot:IsTrained() then
		hCaster:SetCursorPosition(target:GetAbsOrigin())
		hPowershot.is_first_shot = true
		hPowershot:OnChannelFinish(false)		
	end

	if shackled >= search_count and nDamagePerUnit <= 0 then return end

	-- if enemy not found, find trees
	local trees = GridNav:GetAllTreesAroundPoint(target_origin, search_radius, false) 

	for _, tree in pairs(trees) do
		-- check position angle
		local tree_angle = VectorToAngles( tree:GetOrigin()-target_origin ).y
		if math.abs( AngleDiff( target_angle, tree_angle ) ) <= search_angle then
			shackled = shackled + 1

			target:AddNewModifier(hCaster, self, "modifier_shackle_stun", {duration = stun_duration * (1 - target:GetStatusResistance())})

			self:PlayEffects2( target, tree:GetOrigin(), stun_duration )

			nTotalCount = nTotalCount + 1

			-- only one tree is enough
			latch = true
			if nDamagePerUnit <= 0 then break end
		end
	end

	if hCaster:HasAbility("pathfinder_special_windranger_shackleshot_aoe") and latch == true and hCaster:FindAbilityByName("windranger_powershot_lua"):IsTrained() then
		hCaster:SetCursorPosition(target:GetAbsOrigin())
		hCaster:FindAbilityByName("windranger_powershot_lua"):OnChannelFinish(false)		
	end

	-- Tangled buff
	if nDamagePerUnit > 0 and nTotalCount > 1 then
		hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_pf_shackleshot_self_damage_buff", {duration = nBuffDuration}):SetStackCount(nTotalCount - 1)
	end

	if shackled >= search_count then return end

	-- if no enemy or tree found, it's dud
	target:AddNewModifier(hCaster, self, "modifier_stunned", {duration = fail_duration * (1 - target:GetStatusResistance())})

	-- play effects
	local point = target_origin - location
	point.z = 0
	point = target_origin + point:Normalized() * search_radius

	self:PlayEffects3( target, point )
end

--------------------------------------------------------------------------------

function windranger_shackleshot_lua:PlayEffects1( target1, target2, duration )
	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_ABSORIGIN_FOLLOW, target1)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target2, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(duration, 0, 0))
	ParticleManager:ReleaseParticleIndex(effect_cast)

	EmitSoundOn("Hero_Windrunner.ShackleshotBind", target1)
	EmitSoundOn("Hero_Windrunner.ShackleshotStun", target1)
	EmitSoundOn("Hero_Windrunner.ShackleshotStun", target2)
end

--------------------------------------------------------------------------------

function windranger_shackleshot_lua:PlayEffects2( target, tree, duration )
	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair_tree.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(effect_cast, 1, tree)
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(duration, 0, 0))
	ParticleManager:ReleaseParticleIndex(effect_cast)

	EmitSoundOn("Hero_Windrunner.ShackleshotBind", target)
	EmitSoundOn("Hero_Windrunner.ShackleshotStun", target)
end

--------------------------------------------------------------------------------

function windranger_shackleshot_lua:PlayEffects3( target, point )
	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_single.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlForward(effect_cast, 2, (point-target:GetOrigin()):Normalized())
	ParticleManager:ReleaseParticleIndex(effect_cast)

	EmitSoundOn("Hero_Windrunner.ShackleshotStun", target)
end

--------------------------------------------------------------------------------

modifier_windranger_shackleshot_armour = class({})

--------------------------------------------------------------------------------

function modifier_windranger_shackleshot_armour:IsHidden() return true end

--------------------------------------------------------------------------------

modifier_windrunner_pf_shackleshot_self_damage_buff = class({})

--------------------------------------------------------------------------------

function modifier_windrunner_pf_shackleshot_self_damage_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_shackleshot_self_damage_buff:OnCreated()
	self.nDamagePerUnit = self:GetAbility():GetSpecialValueFor("bonus_damage_per_hero")
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_shackleshot_self_damage_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_shackleshot_self_damage_buff:GetModifierPreAttack_BonusDamage()
	return self.nDamagePerUnit * self:GetStackCount()
end