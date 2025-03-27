LinkLuaModifier("modifier_templar_assassin_pf_refraction_damage", 	"heroes/templar_assassin/templar_assassin_pf_refraction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_pf_refraction_absorb", 	"heroes/templar_assassin/templar_assassin_pf_refraction", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

templar_assassin_pf_refraction = class({})

--------------------------------------------------------------------------------

function templar_assassin_pf_refraction:Precache( context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refract_plasma_contact_warp.vpcf", context)	
end

--------------------------------------------------------------------------------

function templar_assassin_pf_refraction:GetBehavior()
	if self:GetSpecialValueFor("cast_while_disabled") > 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	end

	return self.BaseClass.GetBehavior(self)
end

--------------------------------------------------------------------------------

function templar_assassin_pf_refraction:OnSpellStart()
	local hCaster = self:GetCaster()
	local nDuration = self:GetSpecialValueFor("duration")
	local nStacks = self:GetSpecialValueFor("instances")

	if self:GetSpecialValueFor("dispels") > 0 then
		hCaster:Purge(false, true, false, false, false)
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_pf_refraction_damage", {duration = nDuration, stacks = nStacks, force = 1})
	hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_pf_refraction_absorb", {duration = nDuration, stacks = nStacks, force = 1})

	hCaster:EmitSound("Hero_TemplarAssassin.Refraction")

	if not hCaster:HasShard("aghsfort_special_templar_assassin_refraction_detonate_trap") then return end
	local hTrapAbility = hCaster:FindAbilityByName("templar_assassin_pf_psionic_trap")

	if not hTrapAbility or not hTrapAbility:IsTrained() then return end
	hTrapAbility:CreateTrap(hCaster:GetOrigin())
end

--------------------------------------------------------------------------------

modifier_templar_assassin_pf_refraction_damage = class({})

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:OnCreated(kv)
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()

	self.nDamage = hAbility:GetSpecialValueFor("bonus_damage")

	if IsClient() then return end

	local nDamageFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_dmg.vpcf", PATTACH_CUSTOMORIGIN, hParent)
	ParticleManager:SetParticleControlEnt(nDamageFX, 2, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControlEnt(nDamageFX, 3, hParent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0, 0, 0), true)
	self:AddParticle(nDamageFX, false, false, -1, false, false)

	if kv.force and kv.force == 1 then
		self:SetStackCount(kv.stacks)
	else
		self:SetStackCount(self:GetStackCount() + kv.stacks)
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:OnRefresh(kv)
	local hAbility = self:GetAbility()

	self.nDamage = hAbility:GetSpecialValueFor("bonus_damage")

	if IsClient() then return end
	
	if kv.force and kv.force == 1 then
		self:SetStackCount(kv.stacks)
	else
		self:SetStackCount(self:GetStackCount() + kv.stacks)
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:GetModifierPreAttack_BonusDamage(event)
	return self.nDamage
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:OnAttackLanded(event)
	local hAttacker = event.attacker
	local hTarget = event.target

	if hAttacker == self:GetParent() and hTarget and hTarget:GetTeam() ~= hAttacker:GetTeam() then	
		hTarget:EmitSound("Hero_TemplarAssassin.Refraction.Damage")
		
		self:DecrementStackCount()

		if self:GetStackCount() < 1 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:OnDeath(event)
	if IsClient() or event.attacker ~= self:GetParent() or not self:GetCaster():HasShard("aghsfort_special_templar_assassin_refraction_kill_refresh") then return end
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_templar_assassin_pf_refraction_absorb", {duration = self:GetAbility():GetSpecialValueFor("duration"), stacks = 1})
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_damage:GetTexture()
	return "templar_assassin_refraction_damage"
end

--------------------------------------------------------------------------------

modifier_templar_assassin_pf_refraction_absorb = class({})

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:IsPurgable() 	return false end
function modifier_templar_assassin_pf_refraction_absorb:GetPriority()	return MODIFIER_PRIORITY_HIGH end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:OnCreated(kv)
	if IsClient() then return end
	
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()

	self.nMaxAbsorb = hAbility:GetSpecialValueFor("max_damage_absorb")
	self.nShieldValue = hAbility:GetSpecialValueFor("shield_per_instance")
	self.nMaxShield = self.nShieldValue

	self:SetHasCustomTransmitterData(true)

	local nShieldFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(nShieldFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	self:AddParticle(nShieldFX, false, false, -1, false, false)

	if kv.force and kv.force == 1 then
		self:SetStackCount(kv.stacks)
	else
		self:SetStackCount(self:GetStackCount() + kv.stacks)
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:OnRefresh(kv)
	if IsClient() then return end
	local hAbility = self:GetAbility()

	self.nMaxAbsorb = hAbility:GetSpecialValueFor("max_damage_absorb")
	self.nShieldValue = hAbility:GetSpecialValueFor("shield_per_instance")

	self:SendBuffRefreshToClients()

	if kv.force and kv.force == 1 then
		self:SetStackCount(kv.stacks)
	else
		self:SetStackCount(self:GetStackCount() + kv.stacks)
	end
end

-----------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:AddCustomTransmitterData()
	return {
		nShieldValue = self.nShieldValue,
		nMaxShield = self.nMaxShield
	}
end

-----------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:HandleCustomTransmitterData(data)
	self.nShieldValue = data.nShieldValue
	self.nMaxShield = data.nMaxShield
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:GetModifierIncomingDamageConstant(event)
	if IsServer() then
		if bit.band(event.damage_flags, DAMAGE_TYPE_HP_REMOVAL) == DAMAGE_TYPE_HP_REMOVAL then return 0 end
		
		local hAttacker = event.attacker
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local nDamage = event.damage
		local nReduction = event.damage - self.nMaxAbsorb
		local nShieldReduction = event.damage - self.nShieldValue
		self.nShieldValue = math.max(0, self.nShieldValue - nDamage)

		if self.nShieldValue < 1 then
			self:DecrementStackCount()

			if self:GetStackCount() > 0 then
				self.nShieldValue = self.nMaxShield
			end

			self:SendBuffRefreshToClients()
			
			if hAbility:GetSpecialValueFor("bonus_damage_per_instance_burn") > 0 then
				hParent:AddNewModifier(self:GetCaster(), hAbility, "modifier_templar_assassin_pf_refraction_damage", {duration = hAbility:GetSpecialValueFor("duration"), stacks = 1})
			end

			hParent:EmitSound("Hero_TemplarAssassin.Refraction.Absorb")

			local nHitFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:SetParticleControl(nHitFX, 1, hAttacker:GetOrigin())
			ParticleManager:SetParticleControlForward(nHitFX, 1, (hParent:GetOrigin() - hAttacker:GetOrigin()):Normalized())
			ParticleManager:SetParticleControlEnt(nHitFX, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
			ParticleManager:ReleaseParticleIndex(nHitFX)
			return -self.nMaxAbsorb
		else
			self:SendBuffRefreshToClients()
			return nShieldReduction
		end
	else
		return event.report_max and self.nMaxShield or self.nShieldValue
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_refraction_absorb:OnStackCountChanged(iStackCount)
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	if self:GetStackCount() < 1 then 
		self:Destroy()
	end
end