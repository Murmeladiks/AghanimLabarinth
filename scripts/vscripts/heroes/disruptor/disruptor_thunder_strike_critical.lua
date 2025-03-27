disruptor_thunder_strike_critical = class({})
LinkLuaModifier( "modifier_disruptor_thunder_strike_critical", "heroes/disruptor/disruptor_thunder_strike_critical", LUA_MODIFIER_MOTION_NONE )


function disruptor_thunder_strike_critical:GetIntrinsicModifierName()
	return "modifier_disruptor_thunder_strike_critical"
end


modifier_disruptor_thunder_strike_critical = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_thunder_strike_critical:IsHidden()
    return true
end

function modifier_disruptor_thunder_strike_critical:IsPurgeException()
    return false
end

function modifier_disruptor_thunder_strike_critical:IsPurgable()
    return false
end

function modifier_disruptor_thunder_strike_critical:IsPermanent()
    return true
end




function modifier_disruptor_thunder_strike_critical:OnCreated(kv)
    if IsServer() then
        self.chance = 25
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_disruptor_thunder_strike_critical:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_disruptor_thunder_strike_critical:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end

function modifier_disruptor_thunder_strike_critical:DeclareFunctions()
    return {
        
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
    }
end



function modifier_disruptor_thunder_strike_critical:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    
    if params.attacker ~= self:GetParent() then
        return
    end
    

   
  
    if params.inflictor and params.inflictor:GetAbilityName() == "disruptor_thunder_strike" then
        
        if params.unit then
            
            local damage = params.damage*75/100
            local damagetable = 
            {
                victim = params.unit,
                attacker = self:GetParent(),
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = params.inflictor
            }
            if RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                ApplyDamage(damagetable)
            end
        end
    end
   
    
   
  
end

