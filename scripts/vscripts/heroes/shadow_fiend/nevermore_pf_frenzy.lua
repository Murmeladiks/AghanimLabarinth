LinkLuaModifier("modifier_nevermore_pf_frenzy", 	"heroes/shadow_fiend/nevermore_pf_frenzy", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

nevermore_pf_frenzy = class({})

--------------------------------------------------------------------------------

function nevermore_pf_frenzy:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_nevermore/nevermore_frenzy_pf.vpcf", context)
end

--------------------------------------------------------------------------------

function nevermore_pf_frenzy:CastFilterResult()
	if self:GetCaster():GetModifierStackCount("modifier_pathfinder_necromastery_souls", self:GetCaster()) < self:GetSpecialValueFor("soul_cost") then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function nevermore_pf_frenzy:GetCustomCastError()
	return "#dota_hud_error_not_enough_souls"
end

--------------------------------------------------------------------------------

function nevermore_pf_frenzy:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_nevermore_pf_frenzy", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_Nevermore.Frenzy")
end

--------------------------------------------------------------------------------

modifier_nevermore_pf_frenzy = class({})

--------------------------------------------------------------------------------

function modifier_nevermore_pf_frenzy:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_nevermore_pf_frenzy:OnCreated()
	local hAbility = self:GetAbility()

	self.nAttackSpeed = hAbility:GetSpecialValueFor("bonus_attack_speed")
	self.nCastSpeed = hAbility:GetSpecialValueFor("cast_speed_pct") - 100
	self.nCost = hAbility:GetSpecialValueFor("soul_cost")
end

--------------------------------------------------------------------------------

function modifier_nevermore_pf_frenzy:OnDestroy()
	if IsClient() then return end

	self:GetParent():FindModifierByName("modifier_pathfinder_necromastery_souls"):RemoveNecromasterySouls(self.nCost)
end

--------------------------------------------------------------------------------

function modifier_nevermore_pf_frenzy:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}
end

--------------------------------------------------------------------------------

function modifier_nevermore_pf_frenzy:GetModifierAttackSpeedBonus_Constant()
	return self.nAttackSpeed
end

--------------------------------------------------------------------------------

function modifier_nevermore_pf_frenzy:GetModifierPercentageCasttime()
	return self.nCastSpeed
end

--------------------------------------------------------------------------------

function modifier_nevermore_pf_frenzy:GetEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_frenzy_pf.vpcf"
end