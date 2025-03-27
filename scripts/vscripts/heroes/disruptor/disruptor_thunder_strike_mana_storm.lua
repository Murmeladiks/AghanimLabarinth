disruptor_thunder_strike_mana_storm = class({})
LinkLuaModifier( "modifier_disruptor_thunder_strike_mana_storm", "heroes/disruptor/disruptor_thunder_strike_mana_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_thunder_strike_mana_storm_buff", "heroes/disruptor/disruptor_thunder_strike_mana_storm", LUA_MODIFIER_MOTION_NONE )

function disruptor_thunder_strike_mana_storm:GetIntrinsicModifierName()
	return "modifier_disruptor_thunder_strike_mana_storm"
end


modifier_disruptor_thunder_strike_mana_storm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_thunder_strike_mana_storm:IsHidden()
    return true
end

function modifier_disruptor_thunder_strike_mana_storm:IsPurgeException()
    return false
end

function modifier_disruptor_thunder_strike_mana_storm:IsPurgable()
    return false
end

function modifier_disruptor_thunder_strike_mana_storm:IsPermanent()
    return true
end




function modifier_disruptor_thunder_strike_mana_storm:OnCreated(kv)
    if IsServer() then
        print("hello")
        self.target = nil
    end
end


function modifier_disruptor_thunder_strike_mana_storm:DeclareFunctions()
    return {
        
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
    }
end

function modifier_disruptor_thunder_strike_mana_storm:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "disruptor_thunder_strike" then
        return
    end
    self.target = params.ability:GetCursorTarget()
  
    
end

function modifier_disruptor_thunder_strike_mana_storm:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    
    if params.attacker ~= self:GetParent() then
        return
    end
    

   
  
    if params.inflictor and params.inflictor:GetAbilityName() == "disruptor_thunder_strike" then
        
        if params.unit and self.target and params.unit == self.target then
            local Range = 450
            local heroes = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),	-- int, your team number
                params.unit:GetAbsOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_CLOSEST,	-- int, order filter
                false
            )
            
                
            for _, hero in pairs(heroes) do
                if hero and not hero:IsNull()  then
                    local mana = hero:GetMaxMana()*8/100
                    hero:GiveMana(mana)
   
                end
            end
            if not self:GetParent():HasModifier("modifier_disruptor_thunder_strike_mana_storm_buff") then
                self:GetParent():AddNewModifier(self:GetParent(),params.inflictor,"modifier_disruptor_thunder_strike_mana_storm_buff",{duration = 25})
            else
                local buff  = self:GetParent():FindModifierByName("modifier_disruptor_thunder_strike_mana_storm_buff")
                if buff then
                    print("buff")
                    buff:SetStackCount(buff:GetStackCount()+1)
                    buff:ForceRefresh()
                end
            end
               
        end
    end
   
    
   
  
end

modifier_disruptor_thunder_strike_mana_storm_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_thunder_strike_mana_storm_buff:IsHidden()
    return true
end

function modifier_disruptor_thunder_strike_mana_storm_buff:IsPurgeException()
    return false
end

function modifier_disruptor_thunder_strike_mana_storm_buff:IsPurgable()
    return false
end

function modifier_disruptor_thunder_strike_mana_storm_buff:IsPermanent()
    return false
end
function modifier_disruptor_thunder_strike_mana_storm_buff:OnCreated(kv)
    if IsServer() then
        self.int = 2
        self:SetHasCustomTransmitterData( true )
    end
end

function modifier_disruptor_thunder_strike_mana_storm_buff:AddCustomTransmitterData()
	-- on server
	local data = {
		
        int =  self.int,
	}

	return data
end
function modifier_disruptor_thunder_strike_mana_storm_buff:HandleCustomTransmitterData( data )
	-- on client
	self.int = data.int
end
function modifier_disruptor_thunder_strike_mana_storm_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_disruptor_thunder_strike_mana_storm_buff:GetModifierBonusStats_Intellect(params)
    return self.int*(self:GetStackCount()+1)
end
