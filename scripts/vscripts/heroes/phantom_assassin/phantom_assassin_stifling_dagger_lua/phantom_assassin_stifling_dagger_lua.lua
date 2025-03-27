LinkLuaModifier("modifier_phantom_assassin_pf_stiflingdagger", 			"heroes/phantom_assassin/phantom_assassin_stifling_dagger_lua/phantom_assassin_stifling_dagger_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_pf_stiflingdagger_caster", 	"heroes/phantom_assassin/phantom_assassin_stifling_dagger_lua/phantom_assassin_stifling_dagger_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_pf_dagger_recast", 			"heroes/phantom_assassin/phantom_assassin_stifling_dagger_lua/phantom_assassin_stifling_dagger_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

phantom_assassin_stifling_dagger_lua = class({})

--------------------------------------------------------------------------------

function phantom_assassin_stifling_dagger_lua:GetIntrinsicModifierName()
	return "modifier_phantom_assassin_pf_stiflingdagger_caster"
end

--------------------------------------------------------------------------------

function phantom_assassin_stifling_dagger_lua:OnSpellStart()
	self:LaunchDagger(self:GetCaster(), self:GetCursorTarget(), 0)
end

--------------------------------------------------------------------------------

function phantom_assassin_stifling_dagger_lua:LaunchDagger(hSource, hTarget, nBounces, bRecast)
	local nAttachment = hSource == self:GetCaster() and DOTA_PROJECTILE_ATTACHMENT_ATTACK_2 or DOTA_PROJECTILE_ATTACHMENT_HITLOCATION

	bRecast = bRecast and 1 or 0

	ProjectileManager:CreateTrackingProjectile({
		Target = hTarget,
		Source = hSource,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("dagger_speed"),
		bReplaceExisting = false,
		bProvidesVision = true,
		iSourceAttachment = nAttachment,
		iVisionRadius = 450,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData = {
			nCurrentBounces = nBounces,
			bRecast = bRecast
		},
	})

	hSource:EmitSound("Hero_PhantomAssassin.Dagger.Cast")
end

--------------------------------------------------------------------------------

function phantom_assassin_stifling_dagger_lua:OnProjectileHit_ExtraData(hTarget, vLocation, hExtra)
	if not hTarget or hTarget:IsNull() or hTarget:IsInvulnerable() or hTarget:TriggerSpellAbsorb(self) then return end

	local hCaster = self:GetCaster()
	local target_pos = hTarget:GetAbsOrigin()

	local hCoupAbility = hCaster:FindAbilityByName("phantom_assassin_coup_de_grace_lua")
	local hInstrinsic = hCaster:FindModifierByName("modifier_phantom_assassin_pf_stiflingdagger_caster")
	local hCoupModifier = hCaster:FindModifierByName("modifier_phantom_assassin_pf_coupdegrace")
	local nSlowDuration = self:GetSpecialValueFor("duration")
	local nRecastTime = self:GetSpecialValueFor("dagger_recast_time")
	local bRecast = hExtra.bRecast == 1

	if bRecast then nSlowDuration = nSlowDuration * self:GetSpecialValueFor("dagger_secondary_reduce") / 100 end

	hInstrinsic.bDaggerRecast = bRecast
	hInstrinsic.bDaggerAttack = true
	if hCoupModifier then hCoupModifier.bDaggerMode = true end

	hCaster:PerformAttack(hTarget, false, true, true, false, false, false, true)

	hInstrinsic.bDaggerAttack = false
	hInstrinsic.bDaggerRecast = false
	if hCoupModifier then hCoupModifier.bDaggerMode = false end

	if nRecastTime > 0 then
		hTarget:AddNewModifier(hCaster, self, "modifier_phantom_assassin_pf_dagger_recast", {duration = nRecastTime})
	end

	if hCoupAbility then
		hCoupAbility:DaggerHit(hTarget)
	end

	if hCaster:HasAbility("phantom_assassin_dagger_global") then
		hCaster:Heal(hCaster:GetAverageTrueAttackDamage(nil), hCaster)		
	end

	if not hTarget:IsMagicImmune() then
		hTarget:AddNewModifier(hCaster, self, "modifier_phantom_assassin_pf_stiflingdagger", {duration = nSlowDuration})
	end

	if hCaster:HasShard("pathfinder_special_pa_dagger_bouncing") then	
		self:BounceDagger(hTarget, hExtra)
	end

	if hCaster:HasShard("pathfinder_special_pa_dagger_freeze") and not hTarget:IsMagicImmune() then
		hTarget:AddNewModifier(hCaster, self, "modifier_hexxed", {duration = hCaster:FindTalentValue("pathfinder_special_pa_dagger_freeze", "duration") * (1 - hTarget:GetStatusResistance())})		
	end

	hTarget:EmitSound("Hero_PhantomAssassin.Dagger.Target")
end

--------------------------------------------------------------------------------

function phantom_assassin_stifling_dagger_lua:BounceDagger(hTarget, hExtra)
	local hCaster = self:GetCaster()
	local nBounces = hCaster:FindTalentValue("pathfinder_special_pa_dagger_bouncing", "bounces")
	local nRange = hCaster:FindTalentValue("pathfinder_special_pa_dagger_bouncing", "range")

	if hExtra.nCurrentBounces < nBounces then			
		local hEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				self:LaunchDagger(hTarget, hEnemy, hExtra.nCurrentBounces + 1)
				break
			end
		end		
	end
end

--------------------------------------------------------------------------------

modifier_phantom_assassin_pf_stiflingdagger = class({})

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger:OnCreated()
	self.nMoveSlow = self:GetCaster():HasShard("pathfinder_special_pa_dagger_bouncing") and 0 or self:GetAbility():GetSpecialValueFor("move_slow")
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger:DeclareFunctions() 
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger:GetModifierMoveSpeedBonus_Percentage()
	return self.nMoveSlow
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf"
end

--------------------------------------------------------------------------------

modifier_phantom_assassin_pf_stiflingdagger_caster = class({})

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger_caster:IsHidden() 		return true end
function modifier_phantom_assassin_pf_stiflingdagger_caster:IsPurgable() 	return false end
function modifier_phantom_assassin_pf_stiflingdagger_caster:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger_caster:OnCreated()
	if IsClient() then return end
	self.bDaggerAttack = false
	self.bDaggerRecast = false

	self.nDaggerRecastMult = self:GetAbility():GetSpecialValueFor("dagger_secondary_reduce") / 100
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_stiflingdagger_caster:GetModifierDamageOutgoing_Percentage( params )
	if self.bDaggerRecast then
		return (-1 * (100 - self:GetAbility():GetSpecialValueFor("attack_factor"))) / self.nDaggerRecastMult
	end
	if self.bDaggerAttack then
		return -1 * (100 - self:GetAbility():GetSpecialValueFor("attack_factor"))
	end
end

--------------------------------------------------------------------------------

-- base damage will get reduced, so multiply it by its inverse
function modifier_phantom_assassin_pf_stiflingdagger_caster:GetModifierPreAttack_BonusDamage( params )
	if self.bDaggerRecast then
		return (self:GetAbility():GetSpecialValueFor("base_damage") / self:GetAbility():GetSpecialValueFor("attack_factor") * 100) * self.nDaggerRecastMult
	end
	if self.bDaggerAttack then
		return self:GetAbility():GetSpecialValueFor("base_damage") / self:GetAbility():GetSpecialValueFor("attack_factor") * 100 
	end
end

--------------------------------------------------------------------------------

modifier_phantom_assassin_pf_dagger_recast = class({})

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_dagger_recast:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_dagger_recast:OnCreated()
	local hAbility = self:GetAbility()

	self.hParent = self:GetParent()

	if IsClient() then return end
	self.nRange = hAbility:GetEffectiveCastRange(self.hParent:GetOrigin(), self.hParent)
	self:SetStackCount(1)
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_dagger_recast:OnRefresh()
	if IsClient() then return end
	self:IncrementStackCount()
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_dagger_recast:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH}
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_pf_dagger_recast:OnDeath(event)
	if event.unit ~= self.hParent or IsClient() then return end
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local nStacks = self:GetStackCount()

	local hEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(), self.hParent:GetOrigin(), nil, self.nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

	while nStacks > 0 do
		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= self.hParent then
				hAbility:LaunchDagger(self.hParent, hEnemy, 0, true)
				nStacks = nStacks - 1
				if nStacks < 1 then break end
			end
		end
	end
end