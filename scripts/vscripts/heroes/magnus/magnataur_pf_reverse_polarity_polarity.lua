magnataur_pf_reverse_polarity_polarity = class({})

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity_polarity:Precache( context )
    PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_polarity.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_push.vpcf", context)
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity_polarity:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("pull_radius")
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity_polarity:CanAbilityBeUpgraded()
	return false
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity_polarity:OnAbilityUpgrade(hUpgradeAbility)
	if hUpgradeAbility and hUpgradeAbility:GetName() == "magnataur_pf_reverse_polarity" then
		self:SetLevel(hUpgradeAbility:GetLevel())
	end
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity_polarity:OnAbilityPhaseStart()
	if IsServer() then
		local hCaster = self:GetCaster()

		self.nPolarityFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_polarity.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControl(self.nPolarityFX, 1, Vector(self:GetSpecialValueFor("pull_radius"), 0, 0))
		ParticleManager:SetParticleControl(self.nPolarityFX, 2, Vector(self:GetCastPoint(), 0, 0))
		ParticleManager:SetParticleControlEnt(self.nPolarityFX, 3, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	end

	return true
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity_polarity:OnAbilityPhaseInterrupted()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.nPolarityFX, true)
	ParticleManager:ReleaseParticleIndex(self.nPolarityFX)
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity_polarity:OnSpellStart()
	ParticleManager:ReleaseParticleIndex(self.nPolarityFX)

	local hCaster = self:GetCaster()
	local vOrigin = hCaster:GetOrigin()

	local nRadius = self:GetSpecialValueFor("pull_radius")

	local nStunDuration = self:GetSpecialValueFor("hero_stun_duration")
	local nPushDuration = self:GetSpecialValueFor("pull_duration")

	local tDamageTable = {
		attacker = hCaster,
		victim = nil,
		damage = self:GetSpecialValueFor("polarity_damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}

	local tKV =
	{
		center_x = vOrigin.x,
		center_y = vOrigin.y,
		center_z = vOrigin.z,
		should_stun = false, 
		duration = nPushDuration,
		knockback_duration = nPushDuration,
		knockback_distance = 0,
		knockback_height = self:GetSpecialValueFor("knockback_height"),
	}

	local hEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(), vOrigin, nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	for _, hEnemy in pairs(hEnemies) do
		local bAllowed = not hEnemy:IsBoss() and not hEnemy.bAbsoluteNoCC and not hEnemy.bMotionControlExcluded

		local vInitPos = hEnemy:GetOrigin()
		tDamageTable.victim = hEnemy
		ApplyDamage(tDamageTable)

		local nDistance = (hEnemy:GetOrigin() - vOrigin):Length2D()
		tKV.knockback_distance = nRadius - nDistance

		hEnemy:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nStunDuration * (1 - hEnemy:GetStatusResistance())})
		
		if bAllowed then
			hEnemy:AddNewModifier(hCaster, self, "modifier_knockback", tKV)
		end

		local nPushFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_push.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControl(nPushFX, 0, hEnemy:GetOrigin())
		ParticleManager:SetParticleControl(nPushFX, 1, vInitPos)
		ParticleManager:ReleaseParticleIndex(nPushFX)

		if bAllowed then
			Timers:CreateTimer(nPushDuration + FrameTime(), function()
				FindClearSpaceForUnit(hEnemy, hEnemy:GetOrigin(), true)
			end)
		end

		hEnemy:EmitSound("Hero_Magnataur.ReversePolarity.Stun")

		if hCaster:HasShard("aghsfort_special_magnataur_reverse_polarity_allies_crit") then
			hEnemy:AddNewModifier(hCaster, self, "modifier_magnataur_pf_reverse_polarity_crit", {duration = nStunDuration * (1 - hEnemy:GetStatusResistance())})
		end
	end

	if hCaster:HasShard("aghsfort_special_magnataur_reverse_polarity_steroid") then
		hCaster:AddNewModifier(hCaster, self, "modifier_magnataur_pf_reverse_polarity_steroid", {duration = hCaster:FindTalentValue("aghsfort_special_magnataur_reverse_polarity_steroid", "buff_duration"), nMult = 1})
	end

	hCaster:EmitSound("Hero_Magnataur.ReversePolarity.Cast")
end