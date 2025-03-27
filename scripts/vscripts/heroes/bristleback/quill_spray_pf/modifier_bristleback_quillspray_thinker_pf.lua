modifier_bristleback_quillspray_thinker_pf = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_quillspray_thinker_pf:OnCreated(kv)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- AbilitySpecials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.quill_base_damage = self.ability:GetSpecialValueFor("quill_base_damage")
	self.quill_stack_damage =
		self.ability:GetSpecialValueFor("quill_stack_damage") +
		self.caster:FindTalentValue("special_bonus_unique_bristleback_2")
	self.quill_stack_duration = self.ability:GetSpecialValueFor("quill_stack_duration")
	self.max_damage = self.ability:GetSpecialValueFor("max_damage")
	-- self.projectile_speed		= self.ability:GetSpecialValueFor("projectile_speed")

	self.angle = 360
	local directional_quills = self.caster:FindAbilityByName("pathfinder_bristleback_quill_spray_directional_quills")
	if directional_quills and directional_quills:GetLevel() > 0 then
		self.angle = directional_quills:GetSpecialValueFor("angle")
		self.radius = self.radius * (1 + directional_quills:GetSpecialValueFor("range_increase_pct")/100)
	end

	if not IsServer() then return end
	self.owner = kv.quilly and EntIndexToHScript(kv.quilly) or self.caster
	self.attempt_bleeding = kv.bPassive == 1 and self.caster:HasShard("pathfinder_bristleback_bristleback_magical_bleed")
	self.bPassiveSpray = kv.bPassive == 1 or 0

	-- Establish table to populate hit enemies with (so they only get hit once per quill spray)
	self.hit_enemies = {}
	self.direction = Vector(kv.dx, kv.dy, 0)


	if self.angle == 360 then
		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN, self.parent)
		)
	else
		local directional_fx = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_bristleback/bristleback_quill_spray_directional.vpcf",
			PATTACH_ABSORIGIN,
			self.parent
		)
		ParticleManager:SetParticleControl( directional_fx, 0, self.parent:GetOrigin() )
		ParticleManager:SetParticleControlOrientation(directional_fx, 0, -self.direction, -self.owner:GetRightVector(), self.owner:GetUpVector())
		
		--ParticleManager:SetParticleControl(directional_fx, 1, Vector(self.angle, self.radius, 0))
		ParticleManager:ReleaseParticleIndex(directional_fx)
	end

	self:StartIntervalThink(FrameTime())
end

--------------------------------------------------------------------------------

function modifier_bristleback_quillspray_thinker_pf:OnIntervalThink()
	-- From 0 to 1 to track how far the quills have spread and the damage radius
	local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)
	local bristleback = self.caster:FindAbilityByName("bristleback_bristleback_pf")
	local bleed_chance = self.caster:FindTalentValue("pathfinder_bristleback_bristleback_magical_bleed", "chance")
	local bleed_duration = self.caster:FindTalentValue("pathfinder_bristleback_bristleback_magical_bleed", "duration")
	local bDirectionalQuills =  self.caster:HasShard("pathfinder_bristleback_quill_spray_directional_quills")
	local nAttackChance = self.caster:FindTalentValue("pathfinder_bristleback_quill_spray_directional_quills", "attack_projectile_chance")

	local enemies =
		FindUnitsInRadius(
		self.parent:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.radius * radius_pct,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do	
		local attackDirection = (enemy:GetAbsOrigin() - self.owner:GetAbsOrigin()):Normalized()
		local angle = math.deg(math.acos(DotProduct(self.direction, attackDirection)))
		angle = tostring(angle) == "nan" and 0 or angle
		
		if 180 - angle <= self.angle / 2 and not self.hit_enemies[enemy:entindex()] then
			self.hit_enemies[enemy:entindex()] = true

			if self.attempt_bleeding and RollPercentage(bleed_chance) then
				enemy:AddNewModifier(self.caster, bristleback, "modifier_bristleback_magical_bleed", {duration = bleed_duration * (1 - enemy:GetStatusResistance())})
			end

			-- Blood particle is smaller than vanilla...but IDK how much people care about this
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			enemy:EmitSound("Hero_Bristleback.QuillSpray.Target")

			enemy:AddNewModifier(
				self.caster,
				self.ability,
				"modifier_bristleback_quill_spray_pf",
				{duration = self.quill_stack_duration, bPassive = self.bPassiveSpray}
			)

			
			if bDirectionalQuills and RollPseudoRandomPercentage(nAttackChance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_3, self.caster) then
				self.ability:DirectionalQuillProjectile(enemy)
			end
		end
	end
end

--------------------------------------------------------------------------------

-- IDK if I really need this but I'm hearing potential horror stories
function modifier_bristleback_quillspray_thinker_pf:OnDestroy()
	if not IsServer() then
		return
	end

	self.parent:RemoveSelf()
end