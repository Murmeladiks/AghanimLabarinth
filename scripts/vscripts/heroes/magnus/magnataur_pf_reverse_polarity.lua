LinkLuaModifier("modifier_magnataur_pf_reverse_polarity_crit", 		"heroes/magnus/magnataur_pf_reverse_polarity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magnataur_pf_reverse_polarity_steroid", 	"heroes/magnus/magnataur_pf_reverse_polarity", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

magnataur_pf_reverse_polarity = class({})

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity:Precache( context )
    PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_steroid.vpcf", context)
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("pull_radius")
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity:OnAbilityPhaseStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		self.nPolarityFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControl(self.nPolarityFX, 1, Vector(self:GetSpecialValueFor("pull_radius"), 0, 0))
		ParticleManager:SetParticleControl(self.nPolarityFX, 2, Vector(self:GetCastPoint(), 0, 0))
		ParticleManager:SetParticleControlEnt(self.nPolarityFX, 3, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	end

	return true
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity:OnAbilityPhaseInterrupted()
	if IsClient() then return end
	ParticleManager:DestroyParticle(self.nPolarityFX, true)
	ParticleManager:ReleaseParticleIndex(self.nPolarityFX)
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity:OnSpellStart()
	ParticleManager:ReleaseParticleIndex(self.nPolarityFX)
	
	self:ReversePolarity(self:GetCaster(), 1)
end

--------------------------------------------------------------------------------

function magnataur_pf_reverse_polarity:ReversePolarity(hOrigin, nStrength)
	local hCaster = self:GetCaster()
	local vOrigin = hOrigin:GetOrigin()
	local vFinalPos = vOrigin + hOrigin:GetForwardVector() * 150
	local nStunDuration = self:GetSpecialValueFor("hero_stun_duration") * nStrength

	local tDamageTable = {
		attacker = hCaster,
		victim = nil,
		damage = self:GetSpecialValueFor("polarity_damage") * nStrength,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}

	local hEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(), vOrigin, nil, self:GetSpecialValueFor("pull_radius") * nStrength, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

	for _, hEnemy in pairs(hEnemies) do
		local nPullFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControl(nPullFX, 0, vFinalPos)
		ParticleManager:SetParticleControl(nPullFX, 1, hEnemy:GetOrigin())
		ParticleManager:ReleaseParticleIndex(nPullFX)

		tDamageTable.victim = hEnemy
		ApplyDamage(tDamageTable)

		hEnemy:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nStunDuration * (1 - hEnemy:GetStatusResistance())})

		if not hEnemy:IsBoss() and not hEnemy.bAbsoluteNoCC and not hEnemy.bMotionControlExcluded then
			FindClearSpaceForUnit(hEnemy, vFinalPos, false)
		end

		hEnemy:EmitSound("Hero_Magnataur.ReversePolarity.Stun")

		if hCaster:HasShard("aghsfort_special_magnataur_reverse_polarity_allies_crit") then
			hEnemy:AddNewModifier(hCaster, self, "modifier_magnataur_pf_reverse_polarity_crit", {duration = nStunDuration * (1 - hEnemy:GetStatusResistance())})
		end
	end

	EmitSoundOnLocationWithCaster(vOrigin, "Hero_Magnataur.ReversePolarity.Cast", hCaster)

	if hCaster:HasShard("aghsfort_special_magnataur_reverse_polarity_steroid") then
		hCaster:AddNewModifier(hCaster, self, "modifier_magnataur_pf_reverse_polarity_steroid", {duration = hCaster:FindTalentValue("aghsfort_special_magnataur_reverse_polarity_steroid", "buff_duration") * nStrength, nMult = nStrength})
	end
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_reverse_polarity_crit = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_crit:IsPurgable()	return false end
function modifier_magnataur_pf_reverse_polarity_crit:IsHidden()		return true end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_crit:OnCreated(kv)
	self.nCritMult = self:GetCaster():FindTalentValue("aghsfort_special_magnataur_reverse_polarity_allies_crit", "value")
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_crit:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_crit:GetModifierPreAttack_Target_CriticalStrike(event)
	return self.nCritMult
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_reverse_polarity_steroid = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:IsPurgable()	return false end
function modifier_magnataur_pf_reverse_polarity_steroid:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:OnCreated(kv)
	if IsClient() then return end
	local hCaster = self:GetCaster()

	self.nMoveSpeed = hCaster:FindTalentValue("aghsfort_special_magnataur_reverse_polarity_steroid", "move_speed_percent")
	self.nAttackSpeed = hCaster:FindTalentValue("aghsfort_special_magnataur_reverse_polarity_steroid", "attack_speed")

	local nStrength = kv.nMult

	hCaster:EmitSound("Hero_Magnataur.ReversePolarity.Steroid")

	self.nMoveSpeed = self.nMoveSpeed * nStrength
	self.nAttackSpeed = self.nAttackSpeed * nStrength

	self:SetHasCustomTransmitterData(true)
end

-------------------------- ------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:AddCustomTransmitterData()
	return {
		nMoveSpeed = self.nMoveSpeed,
		nAttackSpeed = self.nAttackSpeed
	}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:HandleCustomTransmitterData(data)
	self.nMoveSpeed = data.nMoveSpeed
	self.nAttackSpeed = data.nAttackSpeed
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:GetModifierMoveSpeedBonus_Percentage()
	return self.nMoveSpeed
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:GetModifierAttackSpeedBonus_Constant()
	return self.nAttackSpeed
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_reverse_polarity_steroid:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_steroid.vpcf"
end
