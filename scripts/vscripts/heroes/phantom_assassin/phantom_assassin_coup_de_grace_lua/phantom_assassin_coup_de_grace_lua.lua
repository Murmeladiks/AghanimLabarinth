LinkLuaModifier("modifier_phantom_assassin_pf_coupdegrace", 	"heroes/phantom_assassin/phantom_assassin_coup_de_grace_lua/phantom_assassin_coup_de_grace_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_pf_coup_counter", 	"heroes/phantom_assassin/phantom_assassin_coup_de_grace_lua/phantom_assassin_coup_de_grace_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_pf_mark_of_death", 	"heroes/phantom_assassin/phantom_assassin_coup_de_grace_lua/phantom_assassin_coup_de_grace_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_large_frostbitten_icicle", 			"modifiers/modifier_large_frostbitten_icicle", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

phantom_assassin_coup_de_grace_lua = class({})

--------------------------------------------------------------------------------

function phantom_assassin_coup_de_grace_lua:Spawn()
	if IsClient() then return end
	self.bCanProcDagger = true
end

--------------------------------------------------------------------------------

function phantom_assassin_coup_de_grace_lua:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_mark_overhead_counter.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_mark_overhead.vpcf", context)
end

--------------------------------------------------------------------------------

function phantom_assassin_coup_de_grace_lua:GetIntrinsicModifierName()
	return "modifier_phantom_assassin_pf_coupdegrace"
end

--------------------------------------------------------------------------------

function phantom_assassin_coup_de_grace_lua:DaggerHit(hTarget)
	local hCaster = self:GetCaster()
	if not self:IsTrained() then return end

	if self:GetSpecialValueFor("crit_chance") > 0 then
		if not RollPseudoRandomPercentage(self:GetSpecialValueFor("dagger_crit_chance"), DOTA_PSEUDO_RANDOM_PHANTOMASSASSIN_DAGGER, hCaster) then return end

		hCaster:AddNewModifier(hCaster, self, "modifier_phantom_assassin_pf_mark_of_death", {duration = self:GetSpecialValueFor("duration")})
	else
		hTarget:AddNewModifier(hCaster, self, "modifier_phantom_assassin_pf_coup_counter", {duration = self:GetSpecialValueFor("duration"), nStacks = 2})
	end
end

--------------------------------------------------------------------------------

modifier_phantom_assassin_pf_coupdegrace = class({})

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coupdegrace:IsHidden() 		return true end
function modifier_phantom_assassin_pf_coupdegrace:IsPurgable() 		return false end
function modifier_phantom_assassin_pf_coupdegrace:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coupdegrace:OnCreated()
	if IsClient() then return end
	self.nFocusDuration = self:GetAbility():GetSpecialValueFor("duration")
	self.bDaggerMode = false
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coupdegrace:OnRefresh()
	self.nFocusDuration = self:GetAbility():GetSpecialValueFor("duration")
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coupdegrace:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coupdegrace:OnAttackLanded(event)
	if IsClient() or self.bDaggerMode then return end
	local hTarget = event.target
	local hAttacker = event.attacker
	local hAbility = self:GetAbility()

	if hAttacker ~= self:GetParent() or hAttacker:PassivesDisabled() or not hTarget or hTarget:IsBuilding() or hTarget:IsOther() then return end

	if hAbility:GetSpecialValueFor("crit_chance") > 0 then
		if not RollPseudoRandomPercentage(hAbility:GetSpecialValueFor("crit_chance"), DOTA_PSEUDO_RANDOM_PHANTOMASSASSIN_CRIT, hAttacker) then return end

		hAttacker:AddNewModifier(hAttacker, hAbility, "modifier_phantom_assassin_pf_mark_of_death", {duration = self.nFocusDuration})
	elseif not hAttacker:IsIllusion() then
		hTarget:AddNewModifier(hAttacker, hAbility, "modifier_phantom_assassin_pf_coup_counter", {duration = self.nFocusDuration, nStacks = 1})
	end
end

--------------------------------------------------------------------------------

modifier_phantom_assassin_pf_coup_counter = class({})

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coup_counter:IsPurgable() 		return false end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coup_counter:OnCreated(kv)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	if IsServer() then
		local nStacks = kv.nStacks

		self.nAttacksToProc = hParent:IsConsideredHero() and hAbility:GetSpecialValueFor("attacks_to_proc") or hAbility:GetSpecialValueFor("attacks_to_proc_creeps")
		self.nMarkDuration = hAbility:GetSpecialValueFor("duration")
		
		self:SetStackCount(nStacks)
	end
	
	if IsClient() then
		self.nStackFX = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_mark_overhead_counter.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		ParticleManager:SetParticleControl(self.nStackFX, 1, Vector(0, self:GetStackCount(), 0))
		self:AddParticle(self.nStackFX, false, false, -1, false, true)
		return
	end
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coup_counter:OnRefresh(kv)
	if IsClient() then return end

	if self.bDestroy then
		self:Destroy()
		return
	end

	self:SetStackCount(self:GetStackCount() + kv.nStacks)

	if self:GetStackCount() >= self.nAttacksToProc -1 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_phantom_assassin_pf_mark_of_death", {duration = self.nMarkDuration})
		self.bDestroy = true
		return
	end
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coup_counter:OnStackCountChanged(iStackCount)
	if IsServer() then return end
	ParticleManager:SetParticleControl(self.nStackFX, 1, Vector(0, self:GetStackCount(), 0))
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_coup_counter:ShouldUseOverheadOffset()
	return true
end

--------------------------------------------------------------------------------

modifier_phantom_assassin_pf_mark_of_death = class({})

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()

	self.nCritMult = self:GetAbility():GetSpecialValueFor("crit_bonus")

	self.nLifestealValue = hCaster:FindTalentValue("pathfinder_special_pa_crit_lifesteal", "percent") / 100
	self.nFearDuration = hCaster:FindTalentValue("pathfinder_special_pa_crit_fear", "duration")
	self.nFearRadius = hCaster:FindTalentValue("pathfinder_special_pa_crit_fear", "radius")
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:GetModifierPreAttack_CriticalStrike(event)
	if self:GetParent() ~= self:GetCaster() or IsClient() or self:GetParent():PassivesDisabled() then return end
	self.nAttackRecord = event.record

	return self.nCritMult
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:GetModifierPreAttack_Target_CriticalStrike(event)
	if self:GetParent() == self:GetCaster() or IsClient() or self:GetParent():PassivesDisabled() or event.attacker ~= self:GetCaster() then return end
	self.nAttackRecord = event.record

	return self.nCritMult
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:OnAttackLanded(event)
	if IsClient() or event.record ~= self.nAttackRecord then return end
	local hAttacker = self:GetCaster()
	local hTarget = event.target
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	if self.nLifestealValue > 0 then
		hAttacker:HealWithParams(self.nLifestealValue * event.damage, hAbility, true, true, hCaster, false)
		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
		)
	end

	if self.nFearRadius > 0 then
		local hEnemies = FindUnitsInRadius(hAttacker:GetTeamNumber(), hTarget:GetOrigin(), nil, self.nFearRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)

		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				local nFrostFX = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_frostbite.vpcf", PATTACH_ABSORIGIN_FOLLOW, hEnemy)
				ParticleManager:SetParticleControlEnt(nFrostFX, 1, hEnemy, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), false)
				ParticleManager:ReleaseParticleIndex(nFrostFX)
				hEnemy:EmitSound("IceDragonMaw.Trigger")

				hEnemy:AddNewModifier(hCaster, hAbility, "modifier_large_frostbitten_icicle", {duration = self.nFearDuration})		
			end
		end	
	end

	if hCaster:HasShard("pathfinder_special_pa_crit_dagger") and hTarget:HasModifier("modifier_phantom_assassin_pf_stiflingdagger") and hAbility.bCanProcDagger then
		hAbility.bCanProcDagger = false
		local hDagger = hCaster:FindAbilityByName("phantom_assassin_stifling_dagger_lua")
		local hEnemies = FindUnitsInRadius(hAttacker:GetTeamNumber(), hTarget:GetOrigin(), nil, hDagger:GetSpecialValueFor("tooltip_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				hDagger:LaunchDagger(hTarget, hEnemy, 0)
				break
			end
		end

		Timers:CreateTimer(0.4, function()
			hAbility.bCanProcDagger = true
		end)
	end
	
	local vDir = (hAttacker:GetOrigin() - hTarget:GetOrigin()):Normalized()
	local nImpactFX = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, hAttacker)
	ParticleManager:SetParticleControlEnt(nImpactFX, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
	ParticleManager:SetParticleControl(nImpactFX, 1, hTarget:GetOrigin())
	ParticleManager:SetParticleControlForward(nImpactFX, 1, vDir)
	ParticleManager:SetParticleControlEnt(nImpactFX, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:ReleaseParticleIndex(nImpactFX)
	hTarget:EmitSound("Hero_PhantomAssassin.CoupDeGrace")

	self:Destroy()
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_mark_overhead.vpcf"
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_mark_of_death:ShouldUseOverheadOffset()
	return true
end