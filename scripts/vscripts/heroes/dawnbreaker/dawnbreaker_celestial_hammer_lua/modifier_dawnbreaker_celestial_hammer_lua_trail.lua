-- Created by Elfansoer
modifier_dawnbreaker_celestial_hammer_lua_trail = class({})

function modifier_dawnbreaker_celestial_hammer_lua_trail:IsHidden() 	return true end
function modifier_dawnbreaker_celestial_hammer_lua_trail:IsDebuff() 	return false end
function modifier_dawnbreaker_celestial_hammer_lua_trail:IsPurgable() 	return false end

function modifier_dawnbreaker_celestial_hammer_lua_trail:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "flare_radius" )

	if not IsServer() then return end

	self.prev_pos = Vector( kv.x, kv.y, 0 )
	self.prev_pos = GetGroundPosition( self.prev_pos, self:GetParent() )

	self:PlayEffects( kv.duration )
end

function modifier_dawnbreaker_celestial_hammer_lua_trail:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_dawnbreaker_celestial_hammer_lua_trail:IsAura() 			return true end
function modifier_dawnbreaker_celestial_hammer_lua_trail:GetAuraRadius() 	return self.radius end
function modifier_dawnbreaker_celestial_hammer_lua_trail:GetAuraDuration() 	return 0.5 end

function modifier_dawnbreaker_celestial_hammer_lua_trail:GetModifierAura()
	return self.sAuraModifier
end

function modifier_dawnbreaker_celestial_hammer_lua_trail:GetAuraSearchTeam()
	if not self:GetCaster() or self:GetCaster():IsNull() then return end
	if self:GetCaster():HasAbility("dawnbreaker_celestial_hammer_lua_trail_heal") and not self:GetCaster():PassivesDisabled() then
		return DOTA_UNIT_TARGET_TEAM_BOTH
	end
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_dawnbreaker_celestial_hammer_lua_trail:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dawnbreaker_celestial_hammer_lua_trail:GetAuraEntityReject(hEntity)
	if hEntity:GetTeam() == self:GetCaster():GetTeam() then
		self.sAuraModifier = "modifier_dawnbreaker_celestial_hammer_lua_buff"
	else
		self.sAuraModifier = "modifier_dawnbreaker_celestial_hammer_lua_debuff"
	end
end

function modifier_dawnbreaker_celestial_hammer_lua_trail:PlayEffects( duration )
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_converge_burning_trail.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.prev_pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
