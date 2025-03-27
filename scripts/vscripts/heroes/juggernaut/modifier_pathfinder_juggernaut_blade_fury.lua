LinkLuaModifier( "modifier_pathfinder_bonus_strength", "pathfinder/modifier_pathfinder_bonus_strength", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

modifier_pathfinder_juggernaut_blade_fury = class({})

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:OnCreated(kv)
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	self.nAttackSpeedMult = hAbility:GetSpecialValueFor( "blade_fury_aspd_multiplier" )
	self.radius = hAbility:GetSpecialValueFor( "blade_fury_radius" )
	self.nDamagePerTick = hAbility:GetSpecialValueFor( "blade_fury_damage" )
	self.bCanCrit = hAbility:GetSpecialValueFor("can_crit")

	self.nDamageResist = -hCaster:FindTalentValue("pathfinder_special_juggernaut_blade_fury_flying", "damage_reduction")
	self.nSlow = -hCaster:FindTalentValue("pathfinder_special_juggernaut_blade_fury_strength", "slow_pct")

	if IsClient() then return end
	
	hParent:Purge(false, true, false, false, false)

	self.damageTable = {
		attacker = hParent,
		victim = nil,
		damage = self.nDamagePerTick,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}

	self:StartIntervalThink( 1 / hParent:GetAttacksPerSecond(false) / self.nAttackSpeedMult )	

	local nBladeFuryFX = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControl(nBladeFuryFX, 5, Vector( self.radius, 0, 0))
	self:AddParticle(nBladeFuryFX, false, false, -1, false, false)

	hParent:EmitSoundParams("Hero_Juggernaut.BladeFuryStart", -1, 0.55, -1)
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:OnRefresh( kv )
	local hAbility = self:GetAbility()

	self.radius = hAbility:GetSpecialValueFor("blade_fury_radius")
	self.nDamagePerTick = hAbility:GetSpecialValueFor("blade_fury_damage")

	if IsClient() then return end

	self.damageTable.damage = self.nDamagePerTick
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:OnDestroy( kv )
	if IsClient() then return end
	local hParent = self:GetParent()
	
	hParent:StopSound("Hero_Juggernaut.BladeFuryStart")
	hParent:Purge(false, true, false, true, true)
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()

	local hEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	
	for _, hEnemy in pairs(hEnemies) do
		self.damageTable.victim = hEnemy

		if self.bCanCrit > 0 then
			local hBladeDance = hCaster:FindAbilityByName("pathfinder_juggernaut_blade_dance")

			if hBladeDance and hBladeDance:IsTrained() then
				local nChance = hBladeDance:GetSpecialValueFor("blade_dance_crit_chance")
				if RollPseudoRandomPercentage(nChance, DOTA_PSEUDO_RANDOM_JUGG_CRIT, hParent) then
					self.damageTable.damage = self.nDamagePerTick * hBladeDance:GetSpecialValueFor("blade_dance_crit_mult") / 100
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, hEnemy, self.damageTable.damage, nil)
				else
					self.damageTable.damage = self.nDamagePerTick
				end
			end
		end

		ApplyDamage(self.damageTable)

		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		)
	end

	self:StartIntervalThink(1 / hParent:GetAttacksPerSecond(false) / self.nAttackSpeedMult)

	if hCaster:HasShard("pathfinder_special_juggernaut_blade_fury_strength") and #hEnemies > 0 then
		self:ForceRefresh()
	end
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:CheckState()
	local hCaster = self:GetCaster()

	local hState = {
		[MODIFIER_STATE_DEBUFF_IMMUNE] = true,	
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	if hCaster:HasShard("pathfinder_special_juggernaut_blade_fury_flying") then
		hState[MODIFIER_STATE_FLYING] = true
	end	

	if hCaster:HasShard("pathfinder_special_juggernaut_blade_fury_strength") and hCaster:GetUnitName() == "npc_dota_hero_juggernaut" then
		hState[MODIFIER_STATE_DISARMED] = true
	end	

	return hState
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:GetModifierMagicalResistanceBonus()
	return 80
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:GetModifierIncomingDamage_Percentage( params )
	return self.nDamageResist
end

--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:GetModifierMoveSpeedBonus_Percentage( params )
	return self.nSlow
end
--------------------------------------------------------------------------------

function modifier_pathfinder_juggernaut_blade_fury:GetOverrideAnimation( params )
	return ACT_DOTA_OVERRIDE_ABILITY_1
end