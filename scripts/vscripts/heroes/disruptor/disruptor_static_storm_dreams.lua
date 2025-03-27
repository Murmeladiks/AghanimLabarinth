disruptor_static_storm_dreams = class( {} )

LinkLuaModifier( "modifier_disruptor_static_storm_dreams", "heroes/disruptor/disruptor_static_storm_dreams", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_static_storm_dreams_buff", "heroes/disruptor/disruptor_static_storm_dreams", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function disruptor_static_storm_dreams:GetIntrinsicModifierName()
	return "modifier_disruptor_static_storm_dreams"
end

modifier_disruptor_static_storm_dreams = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_static_storm_dreams:IsHidden()
	return true
end

function modifier_disruptor_static_storm_dreams:IsPurgeException()
	return false
end

function modifier_disruptor_static_storm_dreams:IsPurgable()
	return false
end

function modifier_disruptor_static_storm_dreams:IsPermanent()
	return true
end



function modifier_disruptor_static_storm_dreams:OnCreated(kv)
    if IsServer() then
		self.cancrit = false
        local connectedPlayers = CAghanim:GetConnectedPlayers()
			for _, nPlayerID in pairs(connectedPlayers) do
				if PlayerResource:IsValidPlayerID(nPlayerID) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                    if hero ~= self:GetParent() then
					    hero:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_disruptor_static_storm_dreams_buff",{})
                    end
				end
			end
    end
end

function modifier_disruptor_static_storm_dreams:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end


function modifier_disruptor_static_storm_dreams:OnAttackStart( params )
    if IsServer() then
      

        if params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
            return
        end
        if params.target:HasModifier("modifier_disruptor_static_storm") then
            print("attack enemy")
            if RollPseudoRandomPercentage(30, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                self.cancrit = true
            end
        end
       
            
    end


end
function modifier_disruptor_static_storm_dreams:GetModifierPreAttack_CriticalStrike( params ) 
    if self.cancrit then
        self.cancrit = false
        return 150   
    end   
end
--------------------------------------------------------------------------------


modifier_disruptor_static_storm_dreams_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_static_storm_dreams_buff:IsHidden()
	return true
end

function modifier_disruptor_static_storm_dreams_buff:IsPurgeException()
	return false
end

function modifier_disruptor_static_storm_dreams_buff:IsPurgable()
	return false
end

function modifier_disruptor_static_storm_dreams_buff:IsPermanent()
	return true
end
function modifier_disruptor_static_storm_dreams_buff:OnCreated(kv)
    if IsServer() then
		self.cancrit = false
      
    end
end

function modifier_disruptor_static_storm_dreams_buff:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end


function modifier_disruptor_static_storm_dreams_buff:OnAttackStart( params )
    if IsServer() then
      

        if params.attacker ~= self:GetParent() then
            return
        end
        if params.target:HasModifier("modifier_disruptor_static_storm") then
            print("attack enemy")
            if RollPseudoRandomPercentage(30, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                self.cancrit = true
            end
        end
       
            
    end


end
function modifier_disruptor_static_storm_dreams_buff:GetModifierPreAttack_CriticalStrike( params ) 
    if self.cancrit then
        self.cancrit = false
        return 150   
    end   
end