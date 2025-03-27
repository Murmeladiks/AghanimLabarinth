disruptor_static_storm_pacific = class( {} )

LinkLuaModifier( "modifier_disruptor_static_storm_pacific", "heroes/disruptor/disruptor_static_storm_pacific", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_static_storm_pacific_aura", "heroes/disruptor/disruptor_static_storm_pacific", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_static_storm_pacific_aura_buff", "heroes/disruptor/disruptor_static_storm_pacific", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function disruptor_static_storm_pacific:GetIntrinsicModifierName()
	return "modifier_disruptor_static_storm_pacific"
end


modifier_disruptor_static_storm_pacific = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_static_storm_pacific:IsHidden()
	return true
end

function modifier_disruptor_static_storm_pacific:IsPurgeException()
	return false
end

function modifier_disruptor_static_storm_pacific:IsPurgable()
	return false
end

function modifier_disruptor_static_storm_pacific:IsPermanent()
	return true
end



function modifier_disruptor_static_storm_pacific:OnCreated(kv)
    if IsServer() then
       
    end
end

function modifier_disruptor_static_storm_pacific:DeclareFunctions()
    local funcs = 
    {  
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
    return funcs
end
function modifier_disruptor_static_storm_pacific:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end
    if params.ability:GetAbilityName() == "disruptor_static_storm" then
        local cursorPos = params.ability:GetCursorPosition()
        local duration = params.ability:GetSpecialValueFor("duration")
        CreateModifierThinker( self:GetParent(), params.ability, "modifier_disruptor_static_storm_pacific_aura", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
    end
end




modifier_disruptor_static_storm_pacific_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_static_storm_pacific_aura:IsHidden()
	return true
end
function modifier_disruptor_static_storm_pacific_aura:IsAura()
	return true
end

function modifier_disruptor_static_storm_pacific_aura:GetModifierAura()
	return "modifier_disruptor_static_storm_pacific_aura_buff"
end

function modifier_disruptor_static_storm_pacific_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_disruptor_static_storm_pacific_aura:GetAuraSearchTeam()	
    return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_disruptor_static_storm_pacific_aura:GetAuraSearchType()
	
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	
	
	
end

function modifier_disruptor_static_storm_pacific_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_disruptor_static_storm_pacific_aura:IsPurgable()
	return false
end


modifier_disruptor_static_storm_pacific_aura_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_static_storm_pacific_aura_buff:IsHidden()
	return true
end



function modifier_disruptor_static_storm_pacific_aura_buff:IsPurgable()
	return false
end

function modifier_disruptor_static_storm_pacific_aura_buff:OnCreated( kv )
    if IsServer() then  
        self.damage_reduction = -30
    end
end
function modifier_disruptor_static_storm_pacific_aura_buff:DeclareFunctions()
    local funcs = 
    {  
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end
function modifier_disruptor_static_storm_pacific_aura_buff:GetModifierDamageOutgoing_Percentage( params )
    return self.damage_reduction
end
