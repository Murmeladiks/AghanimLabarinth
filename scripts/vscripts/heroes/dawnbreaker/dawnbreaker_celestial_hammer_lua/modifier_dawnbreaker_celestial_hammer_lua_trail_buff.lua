modifier_dawnbreaker_celestial_hammer_lua_trail_buff = class({})

function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:IsHidden() 	return true end
function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:IsPurgable() 	return false end

function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "flare_radius" )

	if not IsServer() then return end

	self.prev_pos = Vector( kv.x, kv.y, 0 )
	self.prev_pos = GetGroundPosition( self.prev_pos, self:GetParent() )
end

function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:IsAura() 				return true end
function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:GetAuraRadius() 		return self.radius end
function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:GetAuraDuration() 	return 1 end
function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:GetModifierAura()		return "modifier_dawnbreaker_celestial_hammer_lua_buff" end
function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_dawnbreaker_celestial_hammer_lua_trail_buff:GetAuraSearchType() 	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end