LinkLuaModifier("modifier_dragon_knight_pf_elder_dragon_form",			"heroes/dragon_knight/dragon_knight_pf_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_knight_pf_elder_dragon_form_passive",	"heroes/dragon_knight/dragon_knight_pf_elder_dragon_form", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

dragon_knight_pf_elder_dragon_form = class({})

--------------------------------------------------------------------------------

function dragon_knight_pf_elder_dragon_form:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/invoker/glorious_inspiration/invoker_forge_spirit_death_esl_explode.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast.vpcf", context)
end

--------------------------------------------------------------------------------

function dragon_knight_pf_elder_dragon_form:GetAbilityTextureName()
	if not self.sTextureName then
		local nFacetID = self:GetCaster():GetHeroFacetID()
		local sDefault = "dragon_knight_splash"
		
		if nFacetID == 2 then
			sDefault = "dragon_knight_corrosive"
		elseif nFacetID == 3 then
			sDefault = "dragon_knight_frost"
		end

		self.sTextureName = sDefault
	end

	return self.sTextureName
end

--------------------------------------------------------------------------------

function dragon_knight_pf_elder_dragon_form:GetIntrinsicModifierName()
	return "modifier_dragon_knight_pf_elder_dragon_form_passive"
end

--------------------------------------------------------------------------------

function dragon_knight_pf_elder_dragon_form:GetCastRange(vLocation, hTarget)
	return self:GetCaster():FindTalentValue("pathfinder_dk_elder_dragon_form_fear", "radius")
end

--------------------------------------------------------------------------------

function dragon_knight_pf_elder_dragon_form:OnSpellStart()
	local hCaster = self:GetCaster()
	
	hCaster:AddNewModifier(hCaster, self, "modifier_dragon_knight_pf_elder_dragon_form", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_DragonKnight.ElderDragonForm")

	if not hCaster:HasShard("pathfinder_dk_elder_dragon_form_fear") then return end

	local nRadius = hCaster:FindTalentValue("pathfinder_dk_elder_dragon_form_fear", "radius")
	local nDuration = hCaster:FindTalentValue("pathfinder_dk_elder_dragon_form_fear", "duration")
	local nCount = hCaster:FindTalentValue("pathfinder_dk_elder_dragon_form_fear", "breaths")
	local hBreatheFire = hCaster:FindAbilityByName("pathfinder_dk_breathe_fire")
	
	local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), hCaster:GetOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	for _, hEnemy in pairs(hEnemies) do
		hEnemy:AddNewModifier(hCaster, self, "modifier_item_terror_mask_fear", {duration = nDuration})
	end	

	if not hBreatheFire:IsTrained() then return end

	local nRotationAngle = 360 / nCount
	local vOrigin = hCaster:GetOrigin()
	local vForwardPos = vOrigin + hCaster:GetForwardVector() * 500

	for i = 1, nCount do
		local qLeftAngle = QAngle(0,  i * nRotationAngle, 0)

		hCaster:SetCursorPosition(RotatePosition(vOrigin, qLeftAngle, vForwardPos))
		hBreatheFire:OnSpellStart()
	end
end

--------------------------------------------------------------------------------

function dragon_knight_pf_elder_dragon_form:OnProjectileHit(hTarget, vLocation)
	if not hTarget or hTarget:IsNull() or not hTarget:IsAlive() or hTarget:IsInvulnerable() then return end

	local hAttackModifier = self:GetCaster():FindModifierByName("modifier_pathfinder_dk_dragon_tail_attack")
	
	if hAttackModifier then hAttackModifier.bActive = true end
	self:GetCaster():PerformAttack(hTarget, false, true, true, false, false, false, false)
	if hAttackModifier then hAttackModifier.bActive = false end

	hTarget:EmitSound("Hero_DragonKnight.ProjectileImpact")
end

--------------------------------------------------------------------------------

modifier_dragon_knight_pf_elder_dragon_form = class({})

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:OnCreated(kv)
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	self.hAbility = self:GetAbility()

	self.nMoveSpeed = hAbility:GetSpecialValueFor("bonus_movement_speed")
	self.nAttackRange = hAbility:GetSpecialValueFor("bonus_attack_range")
	self.nDamage = hAbility:GetSpecialValueFor("bonus_attack_damage")
	self.nScale = hAbility:GetSpecialValueFor("model_scale")
	self.nSplashRadius = hAbility:GetSpecialValueFor("ranged_splash_radius")
	self.nSplashDamagePct = hAbility:GetSpecialValueFor("ranged_splash_damage_pct") / 100

	self.sTransformParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf"
	self.sDragonID = "default"
	self.sProjectile = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	self.sSoundName = "Hero_DragonKnight.ElderDragonShoot1.Attack"

	if hAbility:GetSpecialValueFor("is_red_dragon") == 1 then
		self.sTransformParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf"
		self.sDragonID = "1"
		self.sProjectile = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
		self.sSoundName = "Hero_DragonKnight.ElderDragonShoot2.Attack"
	elseif hAbility:GetSpecialValueFor("is_blue_dragon") == 1 then
		self.sTransformParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf"
		self.sDragonID = "2"
		self.sProjectile = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
		self.sSoundName = "Hero_DragonKnight.ElderDragonShoot3.Attack"
	end

	if IsClient() then return end
	hParent:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	
	self:StartIntervalThink(FrameTime())
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:OnRefresh()
	if IsClient() then return end
	local hParent = self:GetParent()

	local nTrasnformFX = ParticleManager:CreateParticle(self.sTransformParticle, PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(nTrasnformFX, 1, hParent:GetOrigin() + Vector(0, 0, 80))
	ParticleManager:ReleaseParticleIndex(nTrasnformFX)
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:OnDestroy()
	if IsClient() then return end
	local hParent = self:GetParent()

	hParent:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	hParent:EmitSound("Hero_DragonKnight.ElderDragonForm.Revert")

	local nTrasnformFX = ParticleManager:CreateParticle(self.sTransformParticle, PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(nTrasnformFX, 1, hParent:GetOrigin() + Vector(0, 0, 80))
	ParticleManager:ReleaseParticleIndex(nTrasnformFX)
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:OnIntervalThink()
	self:GetParent():SetMaterialGroup(self.sDragonID)
	self:StartIntervalThink(-1)

	local nTrasnformFX = ParticleManager:CreateParticle(self.sTransformParticle, PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(nTrasnformFX, 1, self:GetParent():GetOrigin() + Vector(0, 0, 80))
	ParticleManager:ReleaseParticleIndex(nTrasnformFX)
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetModifierProcAttack_Feedback(event)
	if IsClient() then return end
	local hAttacker = event.attacker
	local hTarget = event.target

	local tSplashTable = {
		attacker = hAttacker,
		victim = nil,
		damage = event.damage * self.nSplashDamagePct,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
		ability = self.hAbility
	}

	local hEnemies = FindUnitsInRadius(hAttacker:GetTeamNumber(), hTarget:GetOrigin(), nil, self.nSplashRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _, hEnemy in pairs (hEnemies) do
		if hEnemy ~= hTarget then
			tSplashTable.victim = hEnemy
			ApplyDamage(tSplashTable)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetModifierMoveSpeedBonus_Constant(event)
	return self.nMoveSpeed
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetModifierAttackRangeBonus(event)
	return self.nAttackRange
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetModifierPreAttack_BonusDamage(event)
	return self.nDamage
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetModifierModelScale(event)
	return self.nScale
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetModifierModelChange()
	return "models/heroes/dragon_knight/dragon_knight_dragon.vmdl"
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetAttackSound()
	return self.sSoundName
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form:GetModifierProjectileName()
	return self.sProjectile
end

--------------------------------------------------------------------------------

modifier_dragon_knight_pf_elder_dragon_form_passive = class({})

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form_passive:IsPurgable() 	return false end
function modifier_dragon_knight_pf_elder_dragon_form_passive:IsHidden()		return true end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form_passive:InitiateValues()
	local hParent = self:GetParent()

	self.nAttackRadius = hParent:FindTalentValue("pathfinder_dk_elder_dragon_form_attack", "radius")
	self.nRequiredAttacks = hParent:FindTalentValue("pathfinder_dk_elder_dragon_form_attack", "attack")

	self.nCurrentCount = 0
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form_passive:OnAttackLanded(event)
	if IsClient() or event.attacker ~= self:GetParent() or not self:GetParent():HasShard("pathfinder_dk_elder_dragon_form_attack") or event.no_attack_cooldown then return end

	if not self.bValuesInitiated then
		self.bValuesInitiated = true
		self:InitiateValues()
	end

	self.nDamage = 0

	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hTarget = event.target

	if hParent:HasModifier("modifier_dragon_knight_pf_elder_dragon_form") then
		local hDragonModifier = hParent:FindModifierByName("modifier_dragon_knight_pf_elder_dragon_form")

		local hEnemies = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetOrigin(), nil, self.nAttackRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)

		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				ProjectileManager:CreateTrackingProjectile({
					Target = hEnemy,
					Source = hTarget,
					Ability = hAbility,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					EffectName = hDragonModifier.sProjectile,
					iMoveSpeed = hParent:GetProjectileSpeed(),
					bDodgeable = true,
					bIsAttack = true
				})
				break
			end
		end
	else
		if self.nCurrentCount >= self.nRequiredAttacks then
			self.nCurrentCount = 0
			
			ParticleManager:ReleaseParticleIndex(
				ParticleManager:CreateParticle("particles/econ/items/invoker/glorious_inspiration/invoker_forge_spirit_death_esl_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			)
			hTarget:EmitSound("Hero_DragonKnight.ProjectileImpact")
		else
			self.nCurrentCount = self.nCurrentCount + 1

			if self.nCurrentCount >= self.nRequiredAttacks then
				local hBloodModifier = hParent:FindModifierByName("modifier_dragon_knight_pf_dragon_blood")
				if hBloodModifier then hBloodModifier:SetStackCount(1) end
				self.nDamage = hAbility:GetSpecialValueFor("bonus_attack_damage")
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form_passive:OnTakeDamage(event)
	if IsClient() or event.unit ~= self:GetParent() or not self:GetParent():HasShard("pathfinder_dk_elder_dragon_form_cdr") then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	if hAbility:IsCooldownReady() then
		if event.damage >= hParent:GetHealth() then
			local nHeal = hParent:GetMaxHealth() * hParent:FindTalentValue("pathfinder_dk_elder_dragon_form_cdr", "heal") / 100
			hParent:HealWithParams(nHeal, hAbility, false, true, hParent, false)

			hAbility:OnSpellStart()
			hAbility:UseResources(true, false, false, true)
			
			local nProcFX = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:SetParticleControlEnt(nProcFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
			ParticleManager:SetParticleControlEnt(nProcFX, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
			ParticleManager:ReleaseParticleIndex(nProcFX)
			hParent:EmitSound("DOTA_Item.PhoenixAsh.Cast")
		end
	else
		local nRemainingTime = math.max(0, hAbility:GetCooldownTimeRemaining() - hParent:FindTalentValue("pathfinder_dk_elder_dragon_form_cdr", "cdr"))
		hAbility:EndCooldown()
		hAbility:StartCooldown(nRemainingTime)
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_pf_elder_dragon_form_passive:GetModifierPreAttack_BonusDamage()
	return self.nDamage
end