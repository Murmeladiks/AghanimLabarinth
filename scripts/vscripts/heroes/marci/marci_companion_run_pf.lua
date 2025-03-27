---@class marci_companion_run_pf:CDOTA_Ability_Lua
marci_companion_run_pf = class({})

local landing_target_fx_name = "particles/ui_mouseactions/range_finder_generic_aoe_nocenter.vpcf"
local target_fx_name = "particles/ui_mouseactions/range_finder_generic_aoe_moving_dash.vpcf"

LinkLuaModifier( "modifier_marci_companion_run_pf", "heroes/marci/modifier_marci_companion_run_pf", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_marci_companion_run_pf_buff", "heroes/marci/modifier_marci_companion_run_pf_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_pf_leap", "heroes/marci/modifier_marci_companion_run_pf_leap", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_arc_lua", "libraries/modifiers/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "marci_alt_check", "heroes/marci/marci_companion_run_pf", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------

function marci_companion_run_pf:Precache(context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_marci.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_charge_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasShard("pathfinder_marci_companion_run_global") then
		return 10000
	end

	return self:GetSpecialValueFor("max_jump_distance")
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:GetIntrinsicModifierName()
	return "marci_alt_check"
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:OnAbilityPhaseStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hIntrinsic = hCaster:FindModifierByName(self:GetIntrinsicModifierName())

		if not hIntrinsic then self.bAltCast = false return end

		self.bAltCast = hIntrinsic:GetStackCount() > 0 and true or false
	end
	return true
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:IsAltCasted()
	return self.bAltCast
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:GetBehavior()
	if self:GetSpecialValueFor("ally_impact_damage_pct") > 0 then
		return self.BaseClass.GetBehavior(self)
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:CastFilterResultTarget(hTarget)
	if self:GetCaster() == hTarget then
		if self:GetCaster():HasTalent("pathfinder_marci_companion_run_leap") then
			if IsServer() then
				if self:FindNextLeapTarget() then
					return UF_SUCCESS
				else
					return UF_FAIL_CUSTOM
				end
			end
		else
			return UF_FAIL_CUSTOM
		end
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	self.target_cast = hTarget
	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:CastFilterResultLocation(vLocation)
	self.pointcast = vLocation

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:GetCustomCastErrorTarget(hTarget)
	if IsServer() then
		return "#dota_hud_error_target_no_dark_rift"
	end

	return "#dota_hud_error_cant_cast_on_self"
end

--------------------------------------------------------------------------------

function marci_companion_run_pf:OnVectorTargetingStart(location, cursor_targets)
	if not self.target_cast then return end

	if self.landing_target_fx then
		ParticleManager:DestroyParticle(self.landing_target_fx, true)
		self.landing_target_fx = nil
	end

	if self.target_fx then
		ParticleManager:DestroyParticle(self.target_fx, true)
		self.target_fx = nil
	end

	self.landing_radius = self:GetSpecialValueFor("landing_radius")

	self:DrawTargetFX(self.target_cast)
	self:DrawLandingFX(self.target_cast, location, cursor_targets)
end

function marci_companion_run_pf:OnVectorTargetingThink(location, cursor_targets)
	if not location then return end

	self:DrawTargetFX(self.target_cast)
	self:DrawLandingFX(self.target_cast, location, cursor_targets)
end


function marci_companion_run_pf:OnVectorTargetingEnd(location, cursor_targets)
	ParticleManager:DestroyParticle(self.landing_target_fx, true)
	ParticleManager:DestroyParticle(self.target_fx, true)
end

function marci_companion_run_pf:ClampLandingLocation(location, target, cursor_targets)
	local min_distance = self:GetSpecialValueFor("min_jump_distance")
	local max_distance = self:GetSpecialValueFor("max_jump_distance") 
		+ self:GetCaster():FindTalentValue("special_bonus_unique_marci_lunge_range")

	if self:GetCaster() == target then
		min_distance = 0
	end

	local target_entindex = target:entindex()
	local target_pos = target:GetAbsOrigin()

	if cursor_targets and table.contains(cursor_targets, target_entindex) then
		local caster_pos = self:GetAbsOrigin()
		local dir = (target_pos - caster_pos):Normalized()
		location = target_pos + dir
	end

	local diff = location - target_pos
	diff.z = 0
	local distance = Clamp(diff:Length2D(), min_distance, max_distance)
	local direction = diff:Normalized()

	return target_pos + direction * distance
end

function marci_companion_run_pf:DrawLandingFX(target, location, cursor_targets)
	local target_origin = target:GetAbsOrigin()
	location = self:ClampLandingLocation(location, target, cursor_targets)

	if not self.landing_target_fx then
		self.landing_target_fx = ParticleManager:CreateParticle(landing_target_fx_name, PATTACH_WORLDORIGIN, self)
		ParticleManager:SetParticleControl(self.landing_target_fx, 3, Vector(self.landing_radius, 0, 0))
	end

	ParticleManager:SetParticleControl(self.landing_target_fx, 0, target_origin)
	ParticleManager:SetParticleControl(self.landing_target_fx, 1, target_origin)
	ParticleManager:SetParticleControl(self.landing_target_fx, 2, location)
	

	location = location + ((target_origin - location):Normalized() * self.landing_radius * 0.97)
	location.z = target_origin.z
	ParticleManager:SetParticleControl(self.landing_target_fx, 12, location)
end

function marci_companion_run_pf:DrawTargetFX(target)
	local target_origin = target:GetAbsOrigin()
	local caster_origin = self:GetAbsOrigin()
	
	local diff = caster_origin - target_origin
	local distance = diff:Length2D()
	local green_start = caster_origin
	local red_start = caster_origin

	local cast_range_overflow = distance - self:GetEffectiveCastRange(target_origin, self.target_cast)
	if cast_range_overflow > 0 then
		green_start = green_start - diff:Normalized() * cast_range_overflow
	end

	if not self.target_fx then
		self.target_fx = ParticleManager:CreateParticle(target_fx_name, PATTACH_WORLDORIGIN, self)
	end

	ParticleManager:SetParticleControl(self.target_fx, 0, red_start)
	ParticleManager:SetParticleControl(self.target_fx, 1, green_start)
	ParticleManager:SetParticleControl(self.target_fx, 2, target_origin)
end

function marci_companion_run_pf:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self.pointcast

	self.selfcast = false

	if VectorDistanceSq(point, target:GetAbsOrigin()) < 1 then
		point = self:ClampLandingLocation(point, target, { target:entindex() })
	else
		point = self:ClampLandingLocation(point, target)
	end

	point = GetGroundPosition(point, caster)

	local leap_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_leap")
	if leap_shard and target == caster then
		self.selfcast = true
		self.previous_targets = {}
		target = self:FindNextLeapTarget(self.previous_targets, true)
	end

	local forward = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	caster:SetForwardVector(forward)

	local speed = self:GetSpecialValueFor("move_speed")

	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		iMoveSpeed = speed,
		bDodgeable = true,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		EffectName = "particles/units/heroes/hero_marci/marci_rebound_charge_projectile.vpcf",
	}
	local proj = ProjectileManager:CreateTrackingProjectile(info)

	self.modifier = caster:AddNewModifier(
		caster,
		self,
		"modifier_marci_companion_run_pf",
		{
			proj = tostring(proj),
			target = target:entindex(),
		} 
	)

	self.target = target
	self.point = point
	self.landing_particle = nil
end


function marci_companion_run_pf:OnProjectileHit( target, location )
	if not self.modifier:IsNull() then
		if not target then
			self.modifier.interrupted = true
		end
		self.modifier:Destroy()
	end
end

function marci_companion_run_pf:OnProjectileThink(location)
	local caster = self:GetCaster()

	if caster:GetRangeToUnit(self.target) <= self.BaseClass.GetCastRange(self, self.point, self.target) and not self.landing_particle then
		local orientation = self.point - self.target:GetAbsOrigin()
		orientation.z = 0
		orientation = orientation:Normalized()
		local fx_target = self.point - orientation * self:GetSpecialValueFor("impact_position_offset")
		self:PlayEffects(fx_target, orientation, self:GetSpecialValueFor("landing_radius"))
		self.landing_particle = true
	end
end

function marci_companion_run_pf:OnTargetReached(target)
	local caster = self:GetCaster()

	if self.selfcast then
		self:OnTargetReachedSelfCast(target, true)
		return
	end

	local buff = self:GetSpecialValueFor("ally_buff_duration")

	-- add buff to ally
	local allied = self.target:GetTeamNumber() == caster:GetTeamNumber()
	if allied then
		self.target:AddNewModifier(caster, self, "modifier_marci_companion_run_pf_buff", { duration = buff })

		if self:IsAltCasted() then
			self:LeapToPoint(self.target)
		end

		--[[local unleash_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_unleash")
		if unleash_shard then
			local guardian = caster:FindAbilityByName("marci_guardian_pf")

			if guardian and guardian:IsTrained() then
				local duration = guardian:GetSpecialValueFor("buff_duration")
				target:AddNewModifier(caster, guardian, "modifier_marci_guardian_pf", { duration = duration })
			end
		end]]
	end

	self:ThrowUnitsToDestination(target, self.point)
	self:LeapToPoint(caster)
end

function marci_companion_run_pf:ThrowUnitsToDestination(target, point)
	local caster = self:GetCaster()
	local global_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_global")
	if global_shard then
		local grapple = caster:FindAbilityByName("marci_grapple_pf")
		if grapple and grapple:IsTrained() then

			local origin = caster:GetOrigin()
			local direction = point - origin
			local distance = direction:Length2D()
			direction.z = 0
			direction = direction:Normalized()

			local height = self:GetSpecialValueFor("min_height_above_highest")

			local arrival_point = origin + direction * distance + direction * 150
			grapple.override_cast_location = arrival_point
			grapple.override_max_distance = 9999
			grapple.override_height = height + 200
			grapple.companion_run_inflictor = true
			caster:SetCursorCastTarget(target)
			grapple:OnSpellStart()
		end
	end
end

function marci_companion_run_pf:LeapToPoint(hUnit)
	local caster = self:GetCaster()

	if not hUnit:IsAlive() then return end

	local origin = hUnit:GetOrigin()
	local direction = self.point - origin
	local distance = direction:Length2D()
	direction.z = 0
	direction = direction:Normalized()

	hUnit:SetForwardVector(direction)

	local duration = 0.5
	local height = self:GetSpecialValueFor("min_height_above_highest")
	local offset = self:GetSpecialValueFor("impact_position_offset")
	local distance = distance - offset
	local landing_pos = origin + distance * direction

	local arc = hUnit:AddNewModifier(
		caster,
		self,
		"modifier_generic_arc_lua",
		{ 
			target_x = landing_pos.x,
			target_y = landing_pos.y,
			duration = duration,
			distance = distance,
			height = height,
			fix_end = false,
			isStun = true,
			isForward = true,
			activity = caster == hUnit and ACT_DOTA_OVERRIDE_ABILITY_2 or 0,
		} 
	)

	arc:SetEndCallback(function(interrupted)
		if hUnit == caster then
			self:OnFinalLanding(self.point, self.target)
		else
			self:OnAllyFinalLanding(self.point, self.target, hUnit)
		end
	end)

	Timers:CreateTimer(duration - 0.1, function()
		if hUnit == caster then
			caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
		end
		hUnit:FaceTowards(self.point)
	end)

	-- play effects
	if hUnit == caster then
		self:PlayEffects3(caster, arc)
	end
end

function marci_companion_run_pf:OnFinalLanding(location, target)
	local caster = self:GetCaster()

	local radius = self:GetSpecialValueFor("landing_radius")
	local damage = self:GetSpecialValueFor("impact_damage")
	local debuff = self:GetSpecialValueFor("debuff_duration")
	local allied = target:GetTeamNumber() == caster:GetTeamNumber()
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		enemy:AddNewModifier(caster, self, "modifier_stunned", { duration = debuff })
	end

	self:PlayEffects2(location, radius)

	--local unleash_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_unleash")
	if self:GetSpecialValueFor("postjump_flurry_charges") > 0 then
		--local guardian = caster:FindAbilityByName("marci_guardian_pf")
		local unleash = caster:FindAbilityByName("marci_unleash_lua")

		--[[if allied and guardian and guardian:IsTrained() then
			local duration = guardian:GetSpecialValueFor("buff_duration")
			caster:AddNewModifier(caster, guardian, "modifier_marci_guardian_pf", {duration = duration})
		end]]

		if unleash and unleash:IsTrained() then
			local hUnleashActive = caster:FindModifierByName("modifier_marci_unleash_lua")
			if hUnleashActive then
				hUnleashActive:SetDuration(hUnleashActive:GetRemainingTime() + self:GetSpecialValueFor("postjump_unleash_duration"), true)
			else
				caster:AddNewModifier(caster, unleash, "modifier_marci_unleash_lua_fury", {type = MARCI_UNLEASH_STACK_COMPANION_RUN})
			end
		end
	end

	local global_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_global")
	if global_shard then
		local heal = caster:GetMaxHealth() * global_shard:GetSpecialValueFor("heal_percent") * 0.01
		caster:Heal(heal, global_shard)
	end
end

function marci_companion_run_pf:OnAllyFinalLanding(location, target, hUnit)
	local caster = self:GetCaster()

	local radius = self:GetSpecialValueFor("landing_radius")
	local damage = self:GetSpecialValueFor("impact_damage")
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	local damageTable = {
		attacker = caster,
		damage = damage * self:GetSpecialValueFor("ally_impact_damage_pct") / 100,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
end

function marci_companion_run_pf:PlayEffects(center, orientation, radius)
	local particle_cast = "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf"

	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, center + Vector(0,0,25))
	ParticleManager:SetParticleControlOrientation(effect_cast, 0, orientation, Vector(0,0,0), Vector(0,0,0))
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(effect_cast)
end

function marci_companion_run_pf:PlayEffects2(center, radius)
	local particle_cast = "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf"
	local sound_cast = "Hero_Marci.Rebound.Impact"

	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, center)
	ParticleManager:SetParticleControl(effect_cast, 1, center)
	ParticleManager:SetParticleControl(effect_cast, 9, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(effect_cast, 10, center)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	EmitSoundOnLocationWithCaster(center, sound_cast, self:GetCaster())
end

function marci_companion_run_pf:PlayEffects3(caster, buff)
	local particle_cast = "particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf"
	local sound_cast = "Hero_Marci.Rebound.Leap"

	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0),
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)

	buff:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	EmitSoundOn(sound_cast, caster)
end



-- Leap shard
function marci_companion_run_pf:OnTargetReachedSelfCast(target, is_first)
	local caster = self:GetCaster()
	local leap_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_leap")

	if IsValidEntity(target) and target:IsAlive() then
		caster:PerformAttack(target, true, true, true, false, false, false, true)
		target:AddNewModifier(caster, self, "modifier_stunned", { duration = leap_shard:GetSpecialValueFor("stun_duration") })

		if is_first then
			self:ThrowUnitsToDestination(target, self.point)
		end
	end

	local unleash_passive = caster:FindModifierByName("modifier_marci_unleash_lua_passive")
	if unleash_passive then
		unleash_passive:Pulse(caster:GetAbsOrigin())
		unleash_passive:BashPulse(caster:GetAbsOrigin())
	end

	local next_target = self:FindNextLeapTarget(self.previous_targets)

	if next_target then
		self.previous_targets[target] = true
		caster:AddNewModifier(caster, self, "modifier_marci_companion_run_pf_leap", { target = next_target:entindex() })
	else
		self:LeapToPoint(caster)
	end

end

function marci_companion_run_pf:FindNextLeapTarget(ignore, is_first)
	local caster = self:GetCaster()
	local leap_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_leap")
	if not leap_shard then return end
	
	local radius = leap_shard:GetSpecialValueFor("max_leap_distance")
	local min = is_first and 0 or 150 --leap_shard:GetSpecialValueFor("min_leap_distance")

	local targets = FindUnitsInRadius(caster:GetTeam(), 
		caster:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		is_first and FIND_CLOSEST or FIND_FARTHEST, true)

	for _, unit in pairs(targets) do
		if (ignore == nil or ignore[unit] == nil) and caster:GetRangeToUnit(unit) >= min then
			return unit
		end
	end

end

--------------------------------------------------------------------------------

marci_alt_check = class({})

--------------------------------------------------------------------------------

function marci_alt_check:IsHidden()	return true end
function marci_alt_check:IsPurgable()	return false end
function marci_alt_check:IsPermanent()	return true end
function marci_alt_check:RemoveOnDeath()	return false end

function marci_alt_check:OnCreated()
	if IsClient() then return end
	self:SetStackCount(-1)
end

--------------------------------------------------------------------------------

function marci_alt_check:DeclareFunctions( kv )
	return {MODIFIER_EVENT_ON_ORDER}
end

--------------------------------------------------------------------------------

function marci_alt_check:OnOrder(event)
	if IsClient() or event.unit ~= self:GetParent() then return end

	if event.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_ALT then
		self:SetStackCount(-self:GetStackCount())
	end
end