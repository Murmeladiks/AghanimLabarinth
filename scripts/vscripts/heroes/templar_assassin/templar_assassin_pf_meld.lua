LinkLuaModifier("modifier_templar_assassin_pf_meld", 		"heroes/templar_assassin/templar_assassin_pf_meld", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_pf_meld_armor", 	"heroes/templar_assassin/templar_assassin_pf_meld", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

templar_assassin_pf_meld = class({})

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_start.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_meld_overhead.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_blink.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_blink_end.vpcf", context)
end

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:GetBehavior()
	if self:GetCaster():HasShard("aghsfort_special_templar_assassin_meld_teleport") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
	end

	return self.BaseClass.GetBehavior(self)
end

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasShard("aghsfort_special_templar_assassin_meld_teleport") then
		return IsClient() and self:GetCaster():FindTalentValue("aghsfort_special_templar_assassin_meld_teleport", "value") or 10000
	end

	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:OnSpellStart()
	local hCaster = self:GetCaster()
	local nDuration = self:GetSpecialValueFor("duration")

	hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_pf_meld", {duration = self:GetSpecialValueFor("meld_duration")})

	hCaster:EmitSound("Hero_TemplarAssassin.Meld")

	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_start.vpcf", PATTACH_ABSORIGIN, hCaster)
	)

	if hCaster:HasShard("aghsfort_special_templar_assassin_meld_teleport") then
		self:CelestialStep()
	end

	hCaster:Stop()
end

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:CelestialStep()
	local hCaster = self:GetCaster()
	local vPos = self:GetCursorPosition()
	local vOrigin = hCaster:GetOrigin()
	local nDistance = (vOrigin - vPos):Length2D()
	local nRange = self:GetCaster():FindTalentValue("aghsfort_special_templar_assassin_meld_teleport", "value")

	if (vPos - vOrigin):Length2D() > nRange + hCaster:GetCastRangeBonus() then
		local nDistance = (nRange + hCaster:GetCastRangeBonus())
	
		vPos = vOrigin + (vPos - vOrigin):Normalized() * nDistance
	end

	local nStartFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_blink.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(nStartFX, 0, vOrigin)
	ParticleManager:ReleaseParticleIndex(nStartFX)

	FindClearSpaceForUnit(hCaster, vPos, true)
	ProjectileManager:ProjectileDodge(hCaster)

	local nEndFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_blink_end.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(nEndFX, 0, vPos)
	ParticleManager:ReleaseParticleIndex(nEndFX)
end

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:MeldAttack(hSource, hTarget)
	local hCaster = self:GetCaster()
	local nAttachment = hSource == self:GetCaster() and DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 or DOTA_PROJECTILE_ATTACHMENT_HITLOCATION

	ProjectileManager:CreateTrackingProjectile({
		Target = hTarget,
		Source = hSource,
		Ability = self,
		EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
		bDodgable = true,
		bProvidesVision = false,
		iMoveSpeed = hCaster:GetProjectileSpeed(),
		iSourceAttachment = nAttachment,
		bIsAttack = true
	})
end

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:ApplyMeldEffects(hTarget)
	local hCaster = self:GetCaster()

	hTarget:AddNewModifier(hCaster, self, "modifier_templar_assassin_pf_meld_armor", {duration = self:GetDuration() * (1 - hTarget:GetStatusResistance())})

	ApplyDamage({
		attacker = hCaster,
		victim = hTarget,
		damage = self:GetSpecialValueFor("bonus_damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	})

	hTarget:EmitSound("Hero_TemplarAssassin.Meld.Attack")

	if self:GetSpecialValueFor("bash_duration") > 0 then
		hTarget:AddNewModifier(hCaster, self, "modifier_bashed", {duration = self:GetSpecialValueFor("bash_duration") * (1 - hTarget:GetStatusResistance())})
		hTarget:EmitSound("DOTA_Item.SkullBasher")
	end
end

--------------------------------------------------------------------------------

function templar_assassin_pf_meld:OnProjectileHit(hTarget, vLocation)
	self:ApplyMeldEffects(hTarget)
	self:GetCaster():PerformAttack(hTarget, false, true, true, false, false, false, false)
end

--------------------------------------------------------------------------------

modifier_templar_assassin_pf_meld = class({})

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:IsPurgable() return false end
function modifier_templar_assassin_pf_meld:IsHidden() return self:GetStackCount() > 0 end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnCreated()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()

	self.nMaxAttackRange = hAbility:GetSpecialValueFor("attack_range_increase_max")
	self.nRangeIncreaseTime = hAbility:GetSpecialValueFor("attack_range_increase_time")

	if IsClient() then return end
	self.ActiveRecords = {}
	self.bStartedAttack = false

	local nMeldFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(nMeldFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	self:AddParticle(nMeldFX, false, false, -1, false, false)

	self:StartIntervalThink(0.1)

	self.hAttackProjectile = {
		Target = nil,
		Source = hParent,
		Ability = self:GetAbility(),
		EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
		bDodgable = true,
		bProvidesVision = false,
		iMoveSpeed = hParent:GetProjectileSpeed(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		bIsAttack = true
	}
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnRefresh()
	self.bStartedAttack = false
	
	if IsServer() then self:SetStackCount(0) end	
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnIntervalThink()
	if self:GetParent():IsCurrentlyHorizontalMotionControlled() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_EVENT_ON_UNIT_MOVED,

		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = self:GetStackCount() == 0,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:GetModifierAttackRangeBonus()
	return self.nMaxAttackRange * math.min(self:GetElapsedTime() / self.nRangeIncreaseTime, 1)
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnAbilityFullyCast(event)
	if event.unit == self:GetParent() and event.ability ~= self:GetAbility() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnUnitMoved(event)
	if event.unit == self:GetParent() and not self.bStartedAttack then
		self:GetParent():EmitSound("Hero_TemplarAssassin.Meld.Move")
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnAttackRecord(event)
	if event.attacker == self:GetParent() and not event.no_attack_cooldown then
		self.ActiveRecords[event.record] = true
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnAttack(event)
	if IsClient() or event.no_attack_cooldown or event.attacker ~= self:GetParent() or not self:GetCaster():HasShard("aghsfort_special_templar_assassin_meld_attack_on_activation") or self.bShardAttacked then return end
	self.bShardAttacked = true

	local hAttacker = self:GetParent()
	local hTarget = event.target
	local hAbility = self:GetAbility()

	local nRadius = self:GetCaster():FindTalentValue("aghsfort_special_templar_assassin_meld_attack_on_activation", "value")

	local hEnemies = FindUnitsInRadius(hAttacker:GetTeam(), hAttacker:GetOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)

	for _, hEnemy in pairs(hEnemies) do
		if hEnemy ~= hTarget then
			hAbility:MeldAttack(hAttacker, hEnemy)
		end
	end
end


--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnAttackFail(event)
	if event.attacker == self:GetParent() and self.ActiveRecords[event.record] then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnAttackLanded(event)
	local hAttacker = event.attacker
	local hTarget = event.target

	if hAttacker == self:GetParent() and self.ActiveRecords[event.record] and hTarget and hTarget:GetTeam() ~= hAttacker:GetTeam() and not hTarget:IsBuilding() and not hTarget:IsOther() and not event.no_attack_cooldown then	
		self:GetAbility():ApplyMeldEffects(hTarget)

		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:GetModifierInvisibilityLevel()
	if self:GetStackCount() == 0 then
		return 1
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:GetModifierProjectileName()
	local hTarget = self:GetParent():GetAttackTarget()
	if hTarget and not hTarget:IsBuilding() and not hTarget:IsOther() and not self.bAlreadyAttacked then
		--if IsServer() then self:GetAbility():MeldAttack(self:GetParent(), hTarget) end
		return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf"
	end
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:OnAttackFinished(event)
	if event.attacker == self:GetParent() and not event.no_attack_cooldown then
		self.bStartedAttack = true
		self.bAlreadyAttacked = true
		if IsServer() then
			self:SetStackCount(1)
		end
	end	
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld:GetActivityTranslationModifiers()
	if not self.bStartedAttack then
		return "meld"
	end
end

--------------------------------------------------------------------------------

modifier_templar_assassin_pf_meld_armor = class({})

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld_armor:OnCreated()
	self.nArmorReduction = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if IsClient() then return end

	local nOverheadFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_meld_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(nOverheadFX, false, false, -1, false, true)
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_DEATH,
	}
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld_armor:GetModifierPhysicalArmorBonus()
	return self.nArmorReduction
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld_armor:OnDeath(event)
	if IsClient() or event.unit ~= self:GetParent() or not self:GetCaster():HasShard("aghsfort_special_templar_assassin_meld_refraction_on_kill") then return end
	local hUnit = event.unit
	local hCaster = self:GetCaster()

	local hRefraction = hCaster:FindAbilityByName("templar_assassin_pf_refraction")
	if not hRefraction or not hRefraction:IsTrained() then return end

	hCaster:AddNewModifier(hCaster, hRefraction, "modifier_templar_assassin_pf_refraction_damage", {duration = hRefraction:GetSpecialValueFor("duration"), stacks = 1})
end

--------------------------------------------------------------------------------

function modifier_templar_assassin_pf_meld_armor:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf"
end