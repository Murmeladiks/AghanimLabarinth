LinkLuaModifier( "modifier_phoenix_pf_blinding_sun", "heroes/phoenix/phoenix_pf_blinding_sun.lua", LUA_MODIFIER_MOTION_NONE )

---------------------------------------------------------------------

if phoenix_pf_blinding_sun == nil then
	phoenix_pf_blinding_sun = class({})
end

---------------------------------------------------------------------

if modifier_phoenix_pf_blinding_sun == nil then
	modifier_phoenix_pf_blinding_sun = class({})
end

---------------------------------------------------------------------
function modifier_phoenix_pf_blinding_sun:OnCreated(params)
	local hAbility = self:GetAbility()
	
	self.nBlindPerSecond = hAbility:GetSpecialValueFor("blind_per_second")
	self.nMaxStacks = hAbility:GetSpecialValueFor("max_stacks")

	if IsClient() then return end

	self.vecDebuffModifiers = {
		"modifier_phoenix_fire_spirits_pf_debuff",
		"modifier_phoenix_icarus_dive_slow_debuff_pf",
		"modifier_phoenix_sun_ray_pf_debuff",
		"modifier_phoenix_supernova_pf_dmg"
	}

	self:OnIntervalThink()
	self:StartIntervalThink(1 / self.nBlindPerSecond)
end

---------------------------------------------------------------------

function modifier_phoenix_pf_blinding_sun:OnRefresh(params)
	local hAbility = self:GetAbility()
	
	self.nBlindPerSecond = hAbility:GetSpecialValueFor("blind_per_second")
	self.nMaxStacks = hAbility:GetSpecialValueFor("max_stacks")
end

---------------------------------------------------------------------

function modifier_phoenix_pf_blinding_sun:OnIntervalThink()
	local hParent = self:GetParent()
	for _, pszScriptName in pairs(self.vecDebuffModifiers) do
		if hParent:HasModifier(pszScriptName) then
			self:SetStackCount(math.min(self:GetStackCount() + 1, self.nMaxStacks))
			self:SetDuration(self:GetDuration(), true)
		end
	end
end

---------------------------------------------------------------------

function modifier_phoenix_pf_blinding_sun:DeclareFunctions()
	return {MODIFIER_PROPERTY_MISS_PERCENTAGE}
end

---------------------------------------------------------------------

function modifier_phoenix_pf_blinding_sun:GetModifierMiss_Percentage()
	return self:GetStackCount()
end