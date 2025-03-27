LinkLuaModifier("modifier_bristleback_warpath_pf", 			"heroes/bristleback/warpath_pf/modifier_bristleback_warpath_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_mega_wallop_stun", 	"heroes/bristleback/warpath_pf/modifier_bristleback_mega_wallop_stun", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

bristleback_warpath_pf = class({})

--------------------------------------------------------------------------------

function bristleback_warpath_pf:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_warpath_empower.vpcf", context)
end

--------------------------------------------------------------------------------

function bristleback_warpath_pf:GetIntrinsicModifierName()
	return "modifier_bristleback_warpath_pf"
end

--------------------------------------------------------------------------------

function bristleback_warpath_pf:GetBehavior()
	if self:GetSpecialValueFor("active_duration") > 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return self.BaseClass.GetBehavior(self)
	end
end

--------------------------------------------------------------------------------

function bristleback_warpath_pf:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_bristleback_warpath_active", {duration = self:GetSpecialValueFor("active_duration")})
end