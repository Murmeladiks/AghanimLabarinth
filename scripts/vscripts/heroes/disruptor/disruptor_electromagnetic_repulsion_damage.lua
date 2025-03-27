disruptor_electromagnetic_repulsion_damage = class({})
LinkLuaModifier( "modifier_disruptor_electromagnetic_repulsion_damage", "heroes/disruptor/disruptor_electromagnetic_repulsion_damage", LUA_MODIFIER_MOTION_NONE )


function disruptor_electromagnetic_repulsion_damage:GetIntrinsicModifierName()
	return "modifier_disruptor_electromagnetic_repulsion_damage"
end


modifier_disruptor_electromagnetic_repulsion_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_electromagnetic_repulsion_damage:IsHidden()
    return true
end

function modifier_disruptor_electromagnetic_repulsion_damage:IsPurgeException()
    return false
end

function modifier_disruptor_electromagnetic_repulsion_damage:IsPurgable()
    return false
end

function modifier_disruptor_electromagnetic_repulsion_damage:IsPermanent()
    return true
end




function modifier_disruptor_electromagnetic_repulsion_damage:OnCreated(kv)
    if IsServer() then
       
    end
end
function modifier_disruptor_electromagnetic_repulsion_damage:DeclareFunctions()
    return {
        
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
       
       
    }
end
function modifier_disruptor_electromagnetic_repulsion_damage:OnModifierAdded(params)
    if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
        return
    end

    if params.added_buff:GetName() =="modifier_knockback" then
        if params.added_buff:GetCaster() == self:GetParent() then
            --print(params.added_buff:GetCaster():GetName())
            local heal = self:GetParent():GetIntellect(false) * 0.5
            self:GetParent():Heal(heal, self:GetAbility())
            local damage = {
                victim = params.unit,
                attacker = self:GetParent(),
                damage = heal,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility()
            }

            ApplyDamage( damage )
        end
    end
end