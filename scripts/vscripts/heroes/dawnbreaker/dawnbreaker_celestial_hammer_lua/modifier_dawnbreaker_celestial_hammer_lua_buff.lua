modifier_dawnbreaker_celestial_hammer_lua_buff = class({})

--------------------------------------------------------------------------------

function modifier_dawnbreaker_celestial_hammer_lua_buff:OnCreated( kv )
	self.nMoveSpeed = self:GetAbility():GetSpecialValueFor("fire_trail_move_speed")
end

--------------------------------------------------------------------------------

function modifier_dawnbreaker_celestial_hammer_lua_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_dawnbreaker_celestial_hammer_lua_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.nMoveSpeed
end

--------------------------------------------------------------------------------

function modifier_dawnbreaker_celestial_hammer_lua_buff:GetEffectName()
	return "particles/units/heroes/hero_dawnbreaker/dawnbreaker_converge_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_dawnbreaker_celestial_hammer_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
