modifier_dawnbreaker_starbreaker_lua_blaze_buff = class({})

----------------------------------------------------------------------

function modifier_dawnbreaker_starbreaker_lua_blaze_buff:OnCreated( kv )
	local hCaster = self:GetCaster()
	local hParent = self:GetCaster()
	local hAbility = self:GetAbility()

	print(hCaster == hParent)

	self.nAttackSpeed = hCaster == hParent and hAbility:GetSpecialValueFor("movespeed_bonus_self_max") or hAbility:GetSpecialValueFor("movespeed_bonus_ally_max")
end

----------------------------------------------------------------------

function modifier_dawnbreaker_starbreaker_lua_blaze_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

----------------------------------------------------------------------

function modifier_dawnbreaker_starbreaker_lua_blaze_buff:GetModifierAttackSpeedBonus_Constant()
	return self.nAttackSpeed * self:GetStackCount()
end