LinkLuaModifier("modifier_windranger_focus_fire_lua", 		"heroes/windranger/windranger_focus_fire_lua/modifier_windranger_focus_fire_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_focus_fire_target", 				"heroes/windranger/windranger_focus_fire_lua/modifier_focus_fire_target", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_windrunner_pf_whirlwind", 		"heroes/windranger/windranger_focus_fire_lua/windranger_focus_fire_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

windranger_focus_fire_lua = class({})

--------------------------------------------------------------------------------
--[[
function windranger_focus_fire_lua:GetAbilityTextureName()
	return self:GetCaster():GetHeroFacetID() == 2 and "windrunner_focusfire" or "windrunner_whirlwind"
end

--------------------------------------------------------------------------------

function windranger_focus_fire_lua:GetBehavior()
	if self:GetCaster():GetHeroFacetID() == 3 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end

	return self.BaseClass.GetBehavior(self)
end

--------------------------------------------------------------------------------

function windranger_focus_fire_lua:GetCastRange(vLocation, hTarget)
	if self:GetCaster():GetHeroFacetID() == 3 then
		return 0
	end

	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end]]

--------------------------------------------------------------------------------

function windranger_focus_fire_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	self:FocusFire(self:GetCursorTarget())
	--[[if hCaster:GetHeroFacetID() == 2 then
		self:FocusFire(self:GetCursorTarget())
	else
		self:Whirlwind()
	end]]
end

--------------------------------------------------------------------------------

function windranger_focus_fire_lua:Whirlwind()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_pf_whirlwind", {duration = self:GetSpecialValueFor("whirlwind_duration")})
	hCaster:EmitSound("Ability.Focusfire")

	if hCaster:HasShard("pathfinder_special_windranger_whirlwind_lifesteal") then
		local hWindrun = hCaster:FindAbilityByName("windranger_windrun_lua")
		if hWindrun and hWindrun:IsTrained() then
			hWindrun:OnSpellStart()
		end
	end
end

--------------------------------------------------------------------------------

function windranger_focus_fire_lua:FocusFire(hTarget)
	if hTarget:TriggerSpellAbsorb( self ) then return end

	local hCaster = self:GetCaster()
	local nDuration = self:GetSpecialValueFor("focusfire_duration_tooltip")
	local bFound = false

	-- this version of Focus Fire allows multiple target
	-- check existing modifiers
	local hModifiers = hCaster:FindAllModifiersByName("modifier_windranger_focus_fire_lua")
	for _, hModifier in pairs(hModifiers) do
		if hModifier.target == hTarget then
			-- if already exist for current target, refresh
			hModifier:ForceRefresh()
			bFound = true
			break
		end
	end

	if not bFound then -- add modifier to new targets
		local nEntityID = hTarget:entindex()
		
		hCaster:AddNewModifier(hCaster, self, "modifier_windranger_focus_fire_lua", {duration = nDuration, target = nEntityID})
	end

	if hCaster:HasAbility("pathfinder_special_windranger_focusfire_trueshot") then
		hTarget:AddNewModifier(hCaster, self, "modifier_focus_fire_target", {duration = nDuration})
	end

	if hCaster:HasAbility("pathfinder_special_windranger_focusfire_lifesteal") then
		if hCaster:FindAbilityByName("windranger_windrun_lua"):IsTrained() then
			hCaster:FindAbilityByName("windranger_windrun_lua"):OnSpellStart()
		end
	end
	
	hCaster:EmitSound("Ability.Focusfire")
end

--------------------------------------------------------------------------------

--[[modifier_windrunner_pf_whirlwind = class({})

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:OnCreated()
	local hAbility = self:GetAbility()
	self.nInitRange = self:GetParent():Script_GetAttackRange()
	self.nDamageReduction = hAbility:GetSpecialValueFor("focusfire_damage_reduction")
	self.nAttackRange = math.max(self:GetCaster():FindTalentValue("pathfinder_special_windranger_whirlwind_global", "range_mult") - 100, 0)

	if IsClient() then return end

	local hParent = self:GetParent()

	self.nAttacksPerSecond = hAbility:GetSpecialValueFor("attacks_per_second")
	self.nBreakDuration = hParent:FindTalentValue("pathfinder_special_windranger_whirlwind_trueshot", "break_duration")

	self.nCycleCount = self.nAttacksPerSecond
	self.nInterval = 1 / self.nAttacksPerSecond
	self.nAnglePerAttack = 360 / self.nAttacksPerSecond
	self.nCurrentAttackCount = 0

	self.hTargetsPerCycle = {}

	self:StartIntervalThink(self.nInterval)


	local nWhirlwindFX = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_unfocusedfire.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(nWhirlwindFX, 0, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	self:AddParticle(nWhirlwindFX, false, false, -1, true, false)
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:OnIntervalThink()
	local hParent = self:GetParent()
	local nRange = hParent:Script_GetAttackRange()
	local bAttacked = false

	local hEnemyHeroes = FindUnitsInRadius(hParent:GetTeam(), hParent:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	local hEnemyCreeps = FindUnitsInRadius(hParent:GetTeam(), hParent:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	local hEnemies = table.concat(hEnemyHeroes, hEnemyCreeps)

	for _, hEnemy in pairs(hEnemies) do
		if not self.hTargetsPerCycle[hEnemy:entindex()] then
			self.hTargetsPerCycle[hEnemy:entindex()] = true

			hParent:PerformAttack(hEnemy, false, true, true, false, true, false, false)
			bAttacked = true
			break
		end
	end

	if not bAttacked then
		local nAngle = ((self.nAttacksPerSecond - self.nCycleCount) * self.nAnglePerAttack) - 360
		local nAngleRad = nAngle * (math.pi / 180)
		local vShotPos = hParent:GetOrigin() + Vector(math.cos(nAngleRad), math.sin(nAngleRad), 0) * self.nInitRange
		local hThinker = CreateModifierThinker(hParent, self:GetAbility(), "", {duration = 1}, GetGroundPosition(vShotPos, nil), hParent:GetTeam(), false)

		local nID = ProjectileManager:CreateTrackingProjectile({
			Target = hThinker,
			Source = hParent,
			Ability = self:GetAbility(),
			EffectName = "particles/units/heroes/hero_windrunner/windrunner_focusfire_attack.vpcf",
			iMoveSpeed = hParent:GetProjectileSpeed(),
			vSourceLoc = hParent:GetAttachmentOrigin(hParent:ScriptLookupAttachment("attach_attack1")),
			bDodgeable = false,
			bProvidesVision = false,
			flExpireTime = GameRules:GetGameTime() + 1,
			bSuppressTargetCheck = true,
		})

		-- if you're here to steal the code, make sure you steal this part too. 
		-- otherwise the projectile wont be cleaned up properly, and it'll cause fps and frame time drops over time
		Timers:CreateTimer(1 - FrameTime() * 2, function()
			UTIL_Remove(hThinker)
			ProjectileManager:DestroyTrackingProjectile(nID)
		end)
	end

	self.nCycleCount = self.nCycleCount - 1
	self.nCurrentAttackCount = self.nCurrentAttackCount + 1

	if self.nCycleCount <= 0 then
		self.nCycleCount = self.nAttacksPerSecond
		
	end
	
	if self.nCurrentAttackCount >= 4 then
		self.hTargetsPerCycle = {}
		self.nCurrentAttackCount = 0
	end

	if hParent:HasShard("pathfinder_special_windranger_whirlwind_lifesteal") and hParent:HasModifier("modifier_windranger_windrun_lua") then
		hParent:FindModifierByName("modifier_windranger_windrun_lua"):ForceRefresh()
	end
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
	}
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:GetModifierDamageOutgoing_Percentage()
	return self.nDamageReduction
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:GetModifierAttackRangeBonusPercentage()
	return self.nAttackRange
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:GetActivityTranslationModifiers()	
	return "focusfire"
end

--------------------------------------------------------------------------------

function modifier_windrunner_pf_whirlwind:OnAttacked(event)
	if IsClient() then return end
	local hAttacker = event.attacker
	local hTarget = event.target


	if hAttacker ~= self:GetParent() or not hTarget or hTarget:IsBuilding() or hTarget:IsOther() then return end

	if hAttacker:HasShard("pathfinder_special_windranger_whirlwind_lifesteal") then
		local nHeal = event.damage * hAttacker:FindTalentValue("pathfinder_special_windranger_whirlwind_lifesteal", "lifesteal") / 100
		hAttacker:HealWithParams(nHeal, self:GetAbility(), true, true, hAttacker, false)
	end
	
	if not hAttacker:HasShard("pathfinder_special_windranger_whirlwind_trueshot") then return end

	hTarget:AddNewModifier(hAttacker, self:GetAbility(), "modifier_bashed", {duration = 0.01})
	hTarget:AddNewModifier(hAttacker, self:GetAbility(), "modifier_break", {duration = self.nBreakDuration * (1 - hTarget:GetStatusResistance())})
	hTarget:EmitSound("DOTA_Item.MKB.Minibash")
end]]