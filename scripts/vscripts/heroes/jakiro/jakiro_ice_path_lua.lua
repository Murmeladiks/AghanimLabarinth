-- Created by Elfansoer
jakiro_ice_path_lua = class({})
LinkLuaModifier( "modifier_jakiro_ice_path_lua", "heroes/jakiro/modifier_jakiro_ice_path_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_ice_path_lua_thinker", "heroes/jakiro/modifier_jakiro_ice_path_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jakiro_ice_path_lua:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_ice_path_half.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_ice_path.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_ice_path_b.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_ice_path_b_half.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_dire.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf", context)
end

--------------------------------------------------------------------------------

function jakiro_ice_path_lua:Spawn()
	if IsClient() then return end
	self.hIceProjectiles = {}

	Timers:CreateTimer(FrameTime(), function()
		if self:GetLevelSpecialValueFor("detonate_damage", 1) > 0 then
			self:GetCaster():RemoveAbility("jakiro_ice_path_detonate")
			self:GetCaster():AddAbility("jakiro_pf_ice_path_detonate"):SetAbilityIndex(7)
		end
	end)
end

------------------------------------------------------------------------------------------

function jakiro_ice_path_lua:GetAssociatedSecondaryAbilities()
	return "jakiro_pf_ice_path_detonate"
end

--------------------------------------------------------------------------------

function jakiro_ice_path_lua:GetCastRange(vLocation, hTarget)
	return self:GetLevelSpecialValueFor("range", self:GetLevel() - 1)
end

--------------------------------------------------------------------------------

-- Ability Start
function jakiro_ice_path_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- calculate direction
	local dir = point - caster:GetOrigin()
	dir.z = 0
	dir = dir:Normalized()

	local range = self:GetLevelSpecialValueFor( "range", self:GetLevel() - 1 ) + self:GetCaster():GetCastRangeBonus()
	local start_range = self:GetLevelSpecialValueFor("start_range", self:GetLevel() - 1)
	local a = self:GetCaster():GetOrigin() + dir + start_range
	local b = a + dir * range

	-- create thinker
	local hThinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_jakiro_ice_path_lua_thinker", -- modifier name
		{
			ax = a.x,
			ay = a.y,
			az = a.z,
			bx = b.x,
			by = b.y, 
			bz = b.z,
			main = 1
		}, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)

	if self:GetSpecialValueFor("detonate_damage") > 0 then
		local hDetonate = caster:FindAbilityByName("jakiro_pf_ice_path_detonate")

		if hDetonate then
			hDetonate.hThinker = hThinker
			caster:SwapAbilities(self:GetAbilityName(), "jakiro_pf_ice_path_detonate", false, true)
		end
	end

	if IsServer() and self:GetCaster():HasAbility("pathfinder_jakiro_ice_path_barrier") then			
		local distance = self:GetLevelSpecialValueFor( "range", self:GetLevel() - 1 )	* 0.7		
		local shard_num = distance / 120 --80 is the hull size of the shard
		local direction = dir

		local gap_width = self:GetCaster():FindAbilityByName("pathfinder_jakiro_ice_path_barrier"):GetLevelSpecialValueFor("gap_width",1)

		local shard_pos = self:GetCaster():GetOrigin() + (direction * gap_width / 2)
		
		local left_angle = QAngle(0,90,0) 
		local right_angle = QAngle(0,-90,0) 

		local shard_pos_left = RotatePosition(self:GetCaster():GetAbsOrigin(), left_angle, shard_pos) + (direction * gap_width)
		local shard_pos_right = RotatePosition(self:GetCaster():GetAbsOrigin(), right_angle, shard_pos)  + (direction * gap_width)


		local shard_pos_list_left = {}				
		local shard_pos_list_right = {}				
		local dur = self:GetLevelSpecialValueFor("duration", self:GetLevel() - 1) + self:GetCaster():FindAbilityByName("pathfinder_jakiro_ice_path_barrier"):GetLevelSpecialValueFor("duration_add",1)

		------
		local front_shard_pos = shard_pos + (direction * 50)
		local front_shard_pos_left = RotatePosition(shard_pos, left_angle, front_shard_pos) + (direction * gap_width / 2)
		local front_shard_pos_right = RotatePosition(shard_pos, right_angle, front_shard_pos) + (direction * gap_width / 2)
		local front_blocker_left = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = front_shard_pos_left})		
		local front_blocker_right = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = front_shard_pos_right})

		local front_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
		ParticleManager:SetParticleControl(front_particle,0,Vector(dur ,0,0))
		ParticleManager:SetParticleControl(front_particle,1, front_shard_pos_left)		
		ParticleManager:ReleaseParticleIndex(front_particle)					

		front_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
		ParticleManager:SetParticleControl(front_particle,0,Vector(dur + 0.4 ,0,0))
		ParticleManager:SetParticleControl(front_particle,1, front_shard_pos_right)
		ParticleManager:ReleaseParticleIndex(front_particle)	

		front_blocker_left:EmitSoundParams("Hero_Tusk.IceShards", 0, 0.3,0)

		Timers:CreateTimer(dur, function()
			front_blocker_left:EmitSoundParams("Hero_Tusk.TagTeam.Layer", 0,1,0)
			UTIL_Remove(front_blocker_left)    
			UTIL_Remove(front_blocker_right)    				
		end)
		------

		if shard_num < 3 then return end
		for i = 2,shard_num do	
			shard_pos_list_left[i] = shard_pos_left
			shard_pos_list_right[i] = shard_pos_right

			Timers:CreateTimer(0.1 * i, function()					
				local blocker_left = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = shard_pos_list_left[i]})		
				local blocker_right = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = shard_pos_list_right[i]})		
				
				blocker_left:EmitSoundParams("Hero_Tusk.IceShards", 0, 0.3,0)

				Timers:CreateTimer(dur, function()
					blocker_left:EmitSoundParams("Hero_Tusk.TagTeam.Layer", 0,1,0)
					UTIL_Remove(blocker_left)    
					UTIL_Remove(blocker_right)    				
				end)

				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
				ParticleManager:SetParticleControl(particle,0,Vector(dur ,0,0))
				ParticleManager:SetParticleControl(particle,1, shard_pos_list_left[i])		
				ParticleManager:ReleaseParticleIndex(particle)					

				particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
				ParticleManager:SetParticleControl(particle,0,Vector(dur + 0.4 ,0,0))
				ParticleManager:SetParticleControl(particle,1, shard_pos_list_right[i])
				ParticleManager:ReleaseParticleIndex(particle)					
			end)			
			shard_pos_left = shard_pos_left + (direction * 120)						
			shard_pos_right = shard_pos_right + (direction * 120)						
		end					
	end

end

function jakiro_ice_path_lua:IceFromAToB(a,b, nMult)
	-- unit identifier
	local caster = self:GetCaster()	


	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_jakiro_ice_path_lua_thinker", -- modifier name
		{
			ax = a.x,
			ay = a.y,
			az = a.z,
			bx = b.x,
			by = b.y,
			bz = b.z,
			nMult = nMult or 100
		}, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)

	if IsServer() and self:GetCaster():HasAbility("pathfinder_jakiro_ice_path_barrier") then			
		local distance = self:GetLevelSpecialValueFor( "range", self:GetLevel() - 1 )	* 0.7	
		local shard_num = distance / 120 --80 is the hull size of the shard

		if shard_num < 3 then return end

		local direction = (b - a):Normalized()
		direction.z = 0

		local gap_width = self:GetCaster():FindAbilityByName("pathfinder_jakiro_ice_path_barrier"):GetLevelSpecialValueFor("gap_width",1)

		local shard_pos = a + (direction * gap_width / 2)
		
		local left_angle = QAngle(0,90,0) 
		local right_angle = QAngle(0,-90,0) 

		local shard_pos_left = RotatePosition(a, left_angle, shard_pos)  + (direction * gap_width)
		local shard_pos_right = RotatePosition(a, right_angle, shard_pos)  + (direction * gap_width)


		local shard_pos_list_left = {}				
		local shard_pos_list_right = {}				
		local dur = self:GetLevelSpecialValueFor("duration", self:GetLevel() - 1) + self:GetCaster():FindAbilityByName("pathfinder_jakiro_ice_path_barrier"):GetLevelSpecialValueFor("duration_add",1)

		------
		local front_shard_pos = shard_pos + (direction * 50)
		local front_shard_pos_left = RotatePosition(shard_pos, left_angle, front_shard_pos) + (direction * gap_width / 2)
		local front_shard_pos_right = RotatePosition(shard_pos, right_angle, front_shard_pos) + (direction * gap_width / 2)
		local front_blocker_left = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = front_shard_pos_left})		
		local front_blocker_right = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = front_shard_pos_right})

		local front_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
		ParticleManager:SetParticleControl(front_particle,0,Vector(dur ,0,0))
		ParticleManager:SetParticleControl(front_particle,1, front_shard_pos_left)		
		ParticleManager:ReleaseParticleIndex(front_particle)					

		front_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
		ParticleManager:SetParticleControl(front_particle,0,Vector(dur + 0.4 ,0,0))
		ParticleManager:SetParticleControl(front_particle,1, front_shard_pos_right)
		ParticleManager:ReleaseParticleIndex(front_particle)	

		front_blocker_left:EmitSoundParams("Hero_Tusk.IceShards", 0, 0.3,0)

		Timers:CreateTimer(dur, function()
			front_blocker_left:EmitSoundParams("Hero_Tusk.TagTeam.Layer", 0,1,0)
			UTIL_Remove(front_blocker_left)    
			UTIL_Remove(front_blocker_right)    				
		end)
		------

		for i = 1,shard_num do	
			shard_pos_list_left[i] = shard_pos_left
			shard_pos_list_right[i] = shard_pos_right

			Timers:CreateTimer(0.1 * i, function()					
				local blocker_left = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = shard_pos_list_left[i]})		
				local blocker_right = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = shard_pos_list_right[i]})		
				
				blocker_left:EmitSoundParams("Hero_Tusk.IceShards", 0, 0.3,0)

				Timers:CreateTimer(dur, function()
					blocker_left:EmitSoundParams("Hero_Tusk.TagTeam.Layer", 0,1,0)
					UTIL_Remove(blocker_left)    
					UTIL_Remove(blocker_right)    				
				end)

				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
				ParticleManager:SetParticleControl(particle,0,Vector(dur ,0,0))
				ParticleManager:SetParticleControl(particle,1, shard_pos_list_left[i])		
				ParticleManager:ReleaseParticleIndex(particle)					

				particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
				ParticleManager:SetParticleControl(particle,0,Vector(dur + 0.4 ,0,0))
				ParticleManager:SetParticleControl(particle,1, shard_pos_list_right[i])
				ParticleManager:ReleaseParticleIndex(particle)					
			end)			
			shard_pos_left = shard_pos_left + (direction * 120)						
			shard_pos_right = shard_pos_right + (direction * 120)						
		end					
	end
end

--------------------------------------------------------------------------------

function jakiro_ice_path_lua:IceProjectile(hTarget)
	if not self:IsTrained() then return end
	local hCaster = self:GetCaster()
	local vSourceLoc = hCaster:GetOrigin()

	local nProjectileID = ProjectileManager:CreateTrackingProjectile({
		Target = hTarget,
		Source = hCaster,
		Ability = self,
		EffectName = "",
		iMoveSpeed = hCaster:GetProjectileSpeed(),
		vSourceLoc = vSourceLoc,
		bDodgeable = false,
		bProvidesVision = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bIgnoreObstructions = true,
		--bSuppressTargetCheck = true,
	})

	self.hIceProjectiles[nProjectileID] = {
		nCount = 0,
		vOrigin = vSourceLoc
	}

	hCaster:EmitSound("Hero_Jakiro.IcePath.Cast")
end

--------------------------------------------------------------------------------

function jakiro_ice_path_lua:OnProjectileThinkHandle(iProjectileHandle)
	local vLocation = ProjectileManager:GetTrackingProjectileLocation(iProjectileHandle)
	local nDistance = (vLocation - self.hIceProjectiles[iProjectileHandle]["vOrigin"]):Length2D()

	if math.floor(nDistance / (self:GetSpecialValueFor("path_radius") * 0.5)) <= self.hIceProjectiles[iProjectileHandle]["nCount"] then return end

	self.hIceProjectiles[iProjectileHandle]["nCount"] = self.hIceProjectiles[iProjectileHandle]["nCount"] + 1

	self:IceFromAToB(vLocation, vLocation, self:GetCaster():FindTalentValue("pathfinder_special_jakiro_glacial_path", "strength"))
end