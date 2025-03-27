disruptor_kinetic_field_damage = class({})
LinkLuaModifier( "modifier_disruptor_kinetic_field_damage", "heroes/disruptor/disruptor_kinetic_field_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_kinetic_field_damage_thinker", "heroes/disruptor/disruptor_kinetic_field_damage", LUA_MODIFIER_MOTION_NONE )

function disruptor_kinetic_field_damage:GetIntrinsicModifierName()
	return "modifier_disruptor_kinetic_field_damage"
end


modifier_disruptor_kinetic_field_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_kinetic_field_damage:IsHidden()
    return true
end

function modifier_disruptor_kinetic_field_damage:IsPurgeException()
    return false
end

function modifier_disruptor_kinetic_field_damage:IsPurgable()
    return false
end

function modifier_disruptor_kinetic_field_damage:IsPermanent()
    return true
end




function modifier_disruptor_kinetic_field_damage:OnCreated(kv)
    if IsServer() then
     
    end
end


function modifier_disruptor_kinetic_field_damage:DeclareFunctions()
    return {
        
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
       
    }
end

function modifier_disruptor_kinetic_field_damage:OnAbilityFullyCast(params)
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
                CreateModifierThinker( self:GetParent(), params.ability, "modifier_disruptor_kinetic_field_damage_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
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
                CreateModifierThinker( self:GetParent(), params.ability, "modifier_disruptor_kinetic_field_damage_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
            end)
    end
  
    
end



modifier_disruptor_kinetic_field_damage_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_kinetic_field_damage_thinker:IsHidden()
    return true
end

function modifier_disruptor_kinetic_field_damage_thinker:IsPurgeException()
    return false
end

function modifier_disruptor_kinetic_field_damage_thinker:IsPurgable()
    return false
end

function modifier_disruptor_kinetic_field_damage_thinker:IsPermanent()
    return false
end
function modifier_disruptor_kinetic_field_damage_thinker:OnCreated(kv)
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

function modifier_disruptor_kinetic_field_damage_thinker:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() then
            self:Destroy()
            return
        end
        
        --enemies
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(), 
            self:GetParent():GetOrigin(), 
            nil, 
            self.radius + 50, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            0, 
            false 
        )

        for _,enemy in pairs( enemies ) do
            if enemy and not enemy:IsNull() and not enemy:IsInvulnerable() then

                local damage = {
                    victim = enemy,
                    attacker = self.caster,
                    damage = self.intellect * 0.5,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                }
        
                ApplyDamage( damage )
            end
        end

      
    end
end


function modifier_disruptor_kinetic_field_damage_thinker:OnDestroy()
    if IsServer() then
        UTIL_Remove(self:GetParent())
    end
end
