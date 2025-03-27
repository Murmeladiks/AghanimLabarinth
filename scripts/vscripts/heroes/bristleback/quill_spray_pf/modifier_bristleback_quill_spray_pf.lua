modifier_bristleback_quill_spray_pf = class({})
function modifier_bristleback_quill_spray_pf:IsPurgable()
	return false
end

function modifier_bristleback_quill_spray_pf:OnCreated(kv)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- AbilitySpecials
	self.quill_base_damage = self.ability:GetSpecialValueFor("quill_base_damage")
	self.quill_stack_damage = self.ability:GetSpecialValueFor("quill_stack_damage")
	self.quill_stack_duration = self.ability:GetSpecialValueFor("quill_stack_duration")
	self.max_damage = self.ability:GetSpecialValueFor("max_damage")

	if IsClient() then return end

	self.damageTable = {
		attacker = self.caster,
		victim = self.parent,
		damage = math.min(self.quill_base_damage, self.max_damage),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK,
		ability = self.ability
	}

	if kv.bPassive and kv.bPassive == 1 then
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK + DOTA_DAMAGE_FLAG_REFLECTION
	end

	ApplyDamage(self.damageTable)

	self:AddIndependentStack(1, self.quill_stack_duration, nil, true)

	self.particle =
		ParticleManager:CreateParticle(
		"particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self.parent
	)

	ParticleManager:SetParticleControlEnt(
		self.particle,
		1,
		self.parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		self.parent:GetAbsOrigin(),
		true
	)
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_bristleback_quill_spray_pf:OnRefresh(kv)
	self.quill_base_damage = self.ability:GetSpecialValueFor("quill_base_damage")
	self.quill_stack_damage = self.ability:GetSpecialValueFor("quill_stack_damage")
	self.quill_stack_duration = self.ability:GetSpecialValueFor("quill_stack_duration")
	self.max_damage = self.ability:GetSpecialValueFor("max_damage")

	if IsClient() then return end
	self:AddIndependentStack(1, self.quill_stack_duration * (1 - self.parent:GetStatusResistance()), nil, true)
	self.damageTable.damage = math.min(self.quill_base_damage + (self.quill_stack_damage * self:GetStackCount()), self.max_damage)

	if kv.bPassive and kv.bPassive == 1 then
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK + DOTA_DAMAGE_FLAG_REFLECTION
	else
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK
	end
	
	ApplyDamage(self.damageTable)
end

function modifier_bristleback_quill_spray_pf:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_bristleback_quill_spray_pf:GetModifierTotalDamageOutgoing_Percentage(kv)
	if IsClient() then
		return 0
	end
	local quill_raze_shard = kv.target:FindAbilityByName("pathfinder_bristleback_quill_spray_pokes_from_the_devil")
	if not quill_raze_shard or quill_raze_shard:IsNull() then
		return 0
	end
	if self:GetStackCount() < quill_raze_shard:GetSpecialValueFor("quill_stack_mechanic_threshold") then
		return 0
	end
	return (-1) * quill_raze_shard:GetSpecialValueFor("enemy_damage_reduction")
end

function modifier_bristleback_quill_spray_pf:GetModifierIncomingDamage_Percentage(kv)
	if IsClient() then
		return 0
	end
	local quill_raze_shard = kv.attacker:FindAbilityByName("pathfinder_bristleback_quill_spray_pokes_from_the_devil")
	if not quill_raze_shard or quill_raze_shard:IsNull() then
		return 0
	end
	if self:GetStackCount() < quill_raze_shard:GetSpecialValueFor("quill_stack_mechanic_threshold") then
		return 0
	end
	return quill_raze_shard:GetSpecialValueFor("damage_enemy_increase")
end
