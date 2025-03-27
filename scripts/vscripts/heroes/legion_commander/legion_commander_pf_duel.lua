LinkLuaModifier("modifier_legion_commander_pf_duel_taunted", 		"heroes/legion_commander/legion_commander_pf_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_duel_taunted_target", "heroes/legion_commander/legion_commander_pf_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_duel_bonus", 			"heroes/legion_commander/legion_commander_pf_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_duel_purge", 			"heroes/legion_commander/legion_commander_pf_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pathfinder_lc_soldier_passive", 			"heroes/legion_commander/legion_commander_pf_duel", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

legion_commander_pf_duel = class({})

--------------------------------------------------------------------------------

function legion_commander_pf_duel:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_duel_buff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_legion_commander_duel.vpcf", context)
	PrecacheResource("particle", "particles/items_fx/gem_truesight_aura.vpcf", context)
end

--------------------------------------------------------------------------------

function legion_commander_pf_duel:Spawn()
	if IsClient() then return end
	
	Timers:CreateTimer(2, function()
		local hCaster = self:GetCaster()
		if not hCaster:HasShard("pathfinder_special_lc_duel_legion") then return 2 end

		for i = 0, hCaster:FindTalentValue("pathfinder_special_lc_duel_legion", "soldier_count") - 1 do
			local vLoc = hCaster:GetOrigin() + RandomVector( 165 )

			local hSoldier = CreateUnitByName( "pathfinder_lc_soldier", vLoc, true, nil, nil, DOTA_TEAM_GOODGUYS)
			hSoldier:AddNewModifier(hCaster, self, "modifier_pathfinder_lc_soldier_passive", {})		

			FindClearSpaceForUnit(hSoldier, hSoldier:GetOrigin(), false)				
		end
	end)
end

--------------------------------------------------------------------------------

function legion_commander_pf_duel:OnSpellStart()		
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local nDuration = self:GetSpecialValueFor("duration")

	if hTarget:TriggerSpellAbsorb(self) then return end

	hCaster.main_duel_target = hTarget
	

	hCaster.taunt_target = hTarget
	hTarget.taunt_caster = hCaster
	

	hCaster:MoveToTargetToAttack( hTarget ) -- for heroes
	hCaster:SetForceAttackTarget( hTarget ) -- for creeps	
	hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_pf_duel_taunted", {duration = nDuration})

	if hTarget:GetUnitName() ~= "npc_dota_boss_aghanim" then
		hTarget:MoveToTargetToAttack( hCaster ) -- for heroes
		hTarget:SetForceAttackTarget(hCaster ) -- for creeps
		hTarget:AddNewModifier(hCaster, self, "modifier_legion_commander_pf_duel_taunted_target", {duration = nDuration})			
	end	

	hCaster:EmitSound("Hero_LegionCommander.Duel.Cast")
	hCaster:EmitSound("Hero_LegionCommander.Duel")
	hCaster:EmitSound("Hero_LegionCommander.Duel.FP")
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_duel_taunted = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	if hCaster:HasTalent("pathfinder_special_lc_duel_purge") then
		hCaster:AddNewModifier(hCaster, hAbility, "modifier_legion_commander_pf_duel_purge", {duration = hAbility:GetSpecialValueFor("duration")})
	end

	if hCaster:HasTalent("pathfinder_special_lc_duel_arrows") and hCaster:FindAbilityByName("legion_commander_pf_overwhelming_odds"):IsTrained() then
		self:StartIntervalThink(hCaster:FindTalentValue("pathfinder_special_lc_duel_arrows", "interval"))
	end

	-- Approx final duel pos, doesnt take account of a few stuff though.
	local hTarget = hCaster.taunt_target
	local vCasterPos = hCaster:GetOrigin()
	local vTargetPos = hTarget:GetOrigin()
	local nDist = (vCasterPos - vTargetPos):Length2D()
	local vDir = (vTargetPos - vCasterPos):Normalized()
	local nReqDistance = hCaster:Script_GetAttackRange() > hTarget:Script_GetAttackRange() and hTarget:Script_GetAttackRange() or hCaster:Script_GetAttackRange()
	local nCombinedMS =  hCaster:GetMoveSpeedModifier(hCaster:GetBaseMoveSpeed(), false) + hTarget:GetMoveSpeedModifier(hTarget:GetBaseMoveSpeed(), false)
	local nOffset = (nDist - nReqDistance) / 2

	local vRingPos = hCaster:GetOrigin() + vDir * nOffset

	local nDuelFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(nDuelFX, 0, vRingPos)
	ParticleManager:SetParticleControlForward(nDuelFX, 0, hCaster:GetForwardVector())
	self:AddParticle(nDuelFX, false, false, -1, false, false)
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent() 
	local hCaster = self:GetCaster()

	hParent:SetForceAttackTarget( nil )
	hCaster:StopSound("Hero_LegionCommander.Duel")
	hCaster:StopSound("Hero_LegionCommander.Duel.FP")

	if hCaster:HasShard("pathfinder_special_lc_duel_purge") and self.purge_ring then					
		ParticleManager:DestroyParticle(self.purge_ring, false)
		ParticleManager:ReleaseParticleIndex(self.purge_ring)			
	end
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:OnIntervalThink()
	self:GetCaster():FindAbilityByName("legion_commander_pf_overwhelming_odds"):OnSpellStart()
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_IGNORING_STOP_ORDERS] = true,
		[MODIFIER_STATE_TAUNTED] = true
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:OnDeath(kv)
	if IsServer() and self:GetParent() == kv.unit then						
		if self:GetCaster().taunt_target:HasModifier("modifier_legion_commander_pf_duel_taunted") then
			self:GetCaster().taunt_target:RemoveModifierByName("modifier_legion_commander_pf_duel_taunted")
		end
	end
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:GetEffectName()	
	return "particles/units/heroes/hero_legion_commander/legion_commander_duel_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:GetStatusEffectName()
	return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_duel_taunted_target = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:OnCreated()
	if IsClient() then return end
	self.hParticipatingUnits = {}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:OnDestroy()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_TAUNTED] = true,
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:OnTakeDamage(event)
	if IsClient() or event.unit ~= self:GetParent() then return end
	local hUnit = event.unit
	local hAttacker = event.attacker
	
	if hAttacker == nil or hAttacker:IsBuilding() or hAttacker:IsIllusion() then
		return 0
	end

	if hAttacker == self:GetParent() or hAttacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return 0
	end

	if bit.band( event.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end

	self.hParticipatingUnits[hAttacker:entindex()] = true
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:OnDeath(kv)
	if IsClient() or self:GetParent() ~= kv.unit then return end

	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	
	local nBonusDamage = hParent:IsConsideredHero() and hAbility:GetSpecialValueFor("reward_damage_hero") or hAbility:GetSpecialValueFor("reward_damage_creep")
	
	hCaster:AddNewModifier(hCaster, hAbility, "modifier_legion_commander_pf_duel_bonus", {nBonusDamage = nBonusDamage})

	if hParent.taunt_caster:HasModifier("modifier_legion_commander_pf_duel_taunted") then
		hParent.taunt_caster:RemoveModifierByName("modifier_legion_commander_pf_duel_taunted")
	end

	hCaster:EmitSound("Hero_LegionCommander.Duel.Victory")
	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, hCaster)
	)

	if hAbility:GetSpecialValueFor("assist_reward_damage") > 0 then
		local hPTA = hCaster:FindAbilityByName("legion_commander_pf_press_the_attack")

		if hPTA and hPTA:IsTrained() then
			hPTA:PTA(hCaster)
		end

		local nAssistDamage = nBonusDamage * hAbility:GetSpecialValueFor("assist_reward_damage") / 100
		
		for nEntityID, _ in pairs(self.hParticipatingUnits) do
			local hUnit = EntIndexToHScript(nEntityID)

			if hUnit and not hUnit:IsNull() and hUnit ~= hCaster then
				hUnit:AddNewModifier(hCaster, hAbility, "modifier_legion_commander_pf_duel_bonus", {nBonusDamage = nAssistDamage})

				if hPTA and hPTA:IsTrained() then
					hPTA:PTA(hUnit)
				end
			end
		end
	end

	self:Destroy()
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:GetEffectName()	
	return "particles/units/heroes/hero_legion_commander/legion_commander_duel_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:GetStatusEffectName()
	return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_taunted_target:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_duel_bonus = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_bonus:IsPurgable() 		return false end
function modifier_legion_commander_pf_duel_bonus:RemoveOnDeath() 	return false end
function modifier_legion_commander_pf_duel_bonus:IsPermanent()		return true end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_bonus:OnCreated(kv)
	if IsClient() then return end
	self:SetStackCount(kv.nBonusDamage)
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_bonus:OnRefresh(kv)
	if IsClient() then return end
	self:SetStackCount(self:GetStackCount() + kv.nBonusDamage)
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_bonus:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("death_loss")
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_bonus:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_bonus:OnDeath(event)
	if IsClient() or event.unit ~= self:GetParent() then return end

	local nAfterDeathValue = 1 - (self:GetAbility():GetSpecialValueFor("death_loss") / 100)

	self:SetStackCount(self:GetStackCount() * nAfterDeathValue)
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_duel_purge = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_purge:IsHidden() return true end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_purge:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()

	if hCaster:HasAbility("pathfinder_special_lc_duel_purge") and hCaster == self:GetParent() then
		self.nHealPct = hCaster:FindTalentValue("pathfinder_special_lc_duel_purge", "max_health_heal") / 100
		self.nRadius = hCaster:FindTalentValue("pathfinder_special_lc_duel_purge", "radius") / 100

		local nPurgeFX =  ParticleManager:CreateParticle( "particles/items_fx/gem_truesight_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(nPurgeFX, 1, Vector(hCaster:FindTalentValue("pathfinder_special_lc_duel_purge", "radius"), 0 ,0))
		self:AddParticle(nPurgeFX, false, false, -1, false, false)

		self:StartIntervalThink(1)
	end
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_duel_purge:OnIntervalThink()
	local hCaster = self:GetCaster()

	if not hCaster:HasModifier("modifier_legion_commander_pf_duel_taunted") then
		self:Destroy()
		return
	end

	local nHeal = hCaster:GetMaxHealth() * self.nHealPct
	local hPTA = hCaster:FindAbilityByName("legion_commander_pf_press_the_attack")
	local bApplyPTA = hPTA and hPTA:IsTrained()

	local hAllies = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetOrigin(), nil, self.nRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

	for _, hAlly in pairs(hAllies) do
		if bApplyPTA then
			hPTA:PTA(hAlly)
		end

		hAlly:HealWithParams(nHeal, self:GetAbility(), false, true, hCaster, false)
	end
end

--------------------------------------------------------------------------------

modifier_pathfinder_lc_soldier_passive = class({})

function modifier_pathfinder_lc_soldier_passive:IsHidden() 		return true end
function modifier_pathfinder_lc_soldier_passive:IsPurgable() 	return false end
function modifier_pathfinder_lc_soldier_passive:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_pathfinder_lc_soldier_passive:OnCreated()
	if IsClient() then return end
	self.nDamagePct = self:GetCaster():FindTalentValue("pathfinder_special_lc_duel_legion", "stat_percent") / 100
	self.nRewardPct = self:GetCaster():FindTalentValue("pathfinder_special_lc_duel_legion", "reward_percent") / 100
	self:StartIntervalThink(2)	
end

--------------------------------------------------------------------------------

function modifier_pathfinder_lc_soldier_passive:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	if hParent:IsAlive() and hCaster and hCaster:IsAlive() and not hCaster:PassivesDisabled()then
		local nDamage = hCaster:GetAverageTrueAttackDamage(nil) * self.nDamagePct
		hParent:SetBaseDamageMax(nDamage)
		hParent:SetBaseDamageMin(nDamage)


		if not hParent:GetAggroTarget() then
			ExecuteOrderFromTable({
				UnitIndex = hParent:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hCaster:GetOrigin() + RandomVector(Script_RandomFloat(200, 600))
			})
		end
	end
end

--------------------------------------------------------------------------------

function modifier_pathfinder_lc_soldier_passive:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_STUNNED] = not self:GetCaster():IsAlive(),
	}
end

--------------------------------------------------------------------------------

function modifier_pathfinder_lc_soldier_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, 
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
	}
end

--------------------------------------------------------------------------------

function modifier_pathfinder_lc_soldier_passive:GetActivityTranslationModifiers()
	return "bulwark"
end

--------------------------------------------------------------------------------

function modifier_pathfinder_lc_soldier_passive:OnTakeDamageKillCredit(event)
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local hAttacker = event.attacker
	local hTarget = event.target
	local nDamage = event.damage

	if hAttacker ~= self:GetParent() or not hTarget or hTarget:IsBuilding() or hTarget:IsOther() or hTarget:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK or event.damage < hTarget:GetHealth() then return end

	hAttacker:EmitSound("Hero_LegionCommander.Duel.Victory")
	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, hAttacker)
	)

	local nBonusDamage = hTarget:IsConsideredHero() and hAbility:GetSpecialValueFor("reward_damage_hero") or hAbility:GetSpecialValueFor("reward_damage_creep")
	nBonusDamage = nBonusDamage * self.nRewardPct

	hCaster:AddNewModifier(hCaster, hAbility, "modifier_legion_commander_pf_duel_bonus", {nBonusDamage = nBonusDamage})

	if hTarget:IsAlive() then
		-- honestly what the fuck is this for, keeping just in case
		ApplyDamage({
			attacker = hCaster,
			victim = hTarget,
			damage = 1,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = hAbility
		})
	end
end