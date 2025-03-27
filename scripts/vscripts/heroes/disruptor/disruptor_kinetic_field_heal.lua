disruptor_kinetic_field_heal = class({})
LinkLuaModifier( "modifier_disruptor_kinetic_field_heal", "heroes/disruptor/disruptor_kinetic_field_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_kinetic_field_heal_thinker", "heroes/disruptor/disruptor_kinetic_field_heal", LUA_MODIFIER_MOTION_NONE )

function disruptor_kinetic_field_heal:GetIntrinsicModifierName()
	return "modifier_disruptor_kinetic_field_heal"
end


modifier_disruptor_kinetic_field_heal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_kinetic_field_heal:IsHidden()
    return true
end

function modifier_disruptor_kinetic_field_heal:IsPurgeException()
    return false
end

function modifier_disruptor_kinetic_field_heal:IsPurgable()
    return false
end

function modifier_disruptor_kinetic_field_heal:IsPermanent()
    return true
end




function modifier_disruptor_kinetic_field_heal:OnCreated(kv)
    if IsServer() then
     
    end
end


function modifier_disruptor_kinetic_field_heal:DeclareFunctions()
    return {
        
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
       
    }
end

function modifier_disruptor_kinetic_field_heal:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() == "disruptor_kinetic_field" then
        local cursorPos = params.ability:GetCursorPosition()
            
            if not cursorPos then
                return
            end

            local duration = params.ability:GetSpecialValueFor("duration")
            local formationDelay = params.ability:GetSpecialValueFor("formation_time")

            Timers:CreateTimer(formationDelay, function ()
                CreateModifierThinker( self:GetParent(), params.ability, "modifier_disruptor_kinetic_field_heal_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
            end)
    end
    if params.ability:GetAbilityName() == "disruptor_kinetic_fence" then
        local cursorPos = params.ability:GetCursorPosition()
            
            if not cursorPos then
                return
            end

            local duration = params.ability:GetSpecialValueFor("duration")
            local formationDelay = params.ability:GetSpecialValueFor("formation_time")

            Timers:CreateTimer(formationDelay, function ()
                CreateModifierThinker( self:GetParent(), params.ability, "modifier_disruptor_kinetic_field_heal_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
            end)
    end
  
    
end



modifier_disruptor_kinetic_field_heal_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_kinetic_field_heal_thinker:IsHidden()
    return true
end

function modifier_disruptor_kinetic_field_heal_thinker:IsPurgeException()
    return false
end

function modifier_disruptor_kinetic_field_heal_thinker:IsPurgable()
    return false
end

function modifier_disruptor_kinetic_field_heal_thinker:IsPermanent()
    return false
end
function modifier_disruptor_kinetic_field_heal_thinker:OnCreated(kv)
    if IsServer() then
        self.caster = self:GetCaster()
        if self:GetAbility():GetAbilityName() == "disruptor_kinetic_fence" then
            self.radius = self:GetAbility():GetSpecialValueFor( "wall_width" )*0.5
        else

            self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
        end
        self.intellect = self:GetCaster():GetIntellect(false)

        self:OnIntervalThink()
        self:StartIntervalThink( 0.5 )
    end
end

function modifier_disruptor_kinetic_field_heal_thinker:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() then
            self:Destroy()
            return
        end
        
        local allies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetOrigin(),
            nil,
            self.radius + 50, 
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            0,
            FIND_ANY_ORDER,
            false 
        )

        for _,ally in pairs( allies ) do
            if ally and ally:IsAlive() then
                local heal = self.intellect * 0.5

                ally:Heal(heal, self:GetAbility())
                self:PlayHealEffect(ally)
            end
        end

      
    end
end
function modifier_disruptor_kinetic_field_heal_thinker:PlayHealEffect(target)
    local particle_life_steal = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

    -- Create Particle for caster life steal
    local effect_life_steal = ParticleManager:CreateParticle( particle_life_steal, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl( effect_life_steal, 1, target:GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_life_steal )
end

function modifier_disruptor_kinetic_field_heal_thinker:OnDestroy()
    if IsServer() then
        UTIL_Remove(self:GetParent())
    end
end
