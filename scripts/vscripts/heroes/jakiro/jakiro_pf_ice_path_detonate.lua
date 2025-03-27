if jakiro_pf_ice_path_detonate == nil then
	jakiro_pf_ice_path_detonate = class({})
end

--------------------------------------------------------------------------------

function jakiro_pf_ice_path_detonate:GetAssociatedPrimaryAbilities()
	return "jakiro_ice_path_lua"
end

--------------------------------------------------------------------------------

function jakiro_pf_ice_path_detonate:IsHiddenWhenStolen()
	return true
end

--------------------------------------------------------------------------------

function jakiro_pf_ice_path_detonate:Spawn()
	if IsClient() then return end
	self:SetLevel(1)
end

--------------------------------------------------------------------------------

function jakiro_pf_ice_path_detonate:OnSpellStart()
	if not self.hThinker or self.hThinker:IsNull() then return end

	self.hThinker:Destroy()
end