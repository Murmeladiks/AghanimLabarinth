disruptor_glimpse_past = class({})
LinkLuaModifier( "modifier_disruptor_glimpse_past", "heroes/disruptor/disruptor_glimpse_past", LUA_MODIFIER_MOTION_NONE )


function disruptor_glimpse_past:GetIntrinsicModifierName()
	return "modifier_disruptor_glimpse_past"
end


modifier_disruptor_glimpse_past = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_glimpse_past:IsHidden()
    return true
end

function modifier_disruptor_glimpse_past:IsPurgeException()
    return false
end

function modifier_disruptor_glimpse_past:IsPurgable()
    return false
end

function modifier_disruptor_glimpse_past:IsPermanent()
    return true
end




function modifier_disruptor_glimpse_past:OnCreated(kv)
    if IsServer() then
        
    end
end


function modifier_disruptor_glimpse_past:DeclareFunctions()
    return {
        
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
    }
end



function modifier_disruptor_glimpse_past:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    
    if params.attacker ~= self:GetParent() then
        return
    end
    

   
  
    if params.inflictor and params.inflictor:GetAbilityName() == "disruptor_glimpse" then
        
        if params.unit then
            local pos = params.unit:GetAbsOrigin()
            local radius = 250
            local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), pos, self:GetParent(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
            local damage = self:GetParent():GetIntellect(false)*170/100
            print("int")
            print(damage)
            local damagetable = 
            {
                --victim = params.unit,
                attacker = self:GetParent(),
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility()
            }
           
            for _, enemy in pairs(enemies) do
                if enemy and not enemy:IsNull() and enemy~=params.unit then
                   print("count")
                    damagetable.victim = enemy
                    ApplyDamage(damagetable)
                end
            end
           
          
        end
    end
   
    
   
  
end

