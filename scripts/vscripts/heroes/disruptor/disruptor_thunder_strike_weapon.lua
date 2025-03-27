disruptor_thunder_strike_weapon = class( {} )

LinkLuaModifier( "modifier_disruptor_thunder_strike_weapon", "heroes/disruptor/disruptor_thunder_strike_weapon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_thunder_strike_mana_storm_buff", "heroes/disruptor/disruptor_thunder_strike_mana_storm", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function disruptor_thunder_strike_weapon:GetIntrinsicModifierName()
	return "modifier_disruptor_thunder_strike_weapon"
end

modifier_disruptor_thunder_strike_weapon = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_thunder_strike_weapon:IsHidden()
	return true
end

function modifier_disruptor_thunder_strike_weapon:IsPurgeException()
	return false
end

function modifier_disruptor_thunder_strike_weapon:IsPurgable()
	return false
end

function modifier_disruptor_thunder_strike_weapon:IsPermanent()
	return true
end



function modifier_disruptor_thunder_strike_weapon:OnCreated(kv)
    if IsServer() then
        self.chance = 60
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_disruptor_thunder_strike_weapon:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_disruptor_thunder_strike_weapon:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_disruptor_thunder_strike_weapon:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_disruptor_thunder_strike_weapon:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target

        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end
        if Target then
            self.ability = Attacker:FindAbilityByName("disruptor_thunder_strike")
            if self.ability and self.ability:GetLevel()>0 then
                if RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                    Attacker:SetCursorCastTarget(Target)
                    self.ability:OnSpellStart()
                    if self:GetParent():HasAbility("disruptor_thunder_strike_mana_storm") then
                        local Range = 450
                        local heroes = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),	-- int, your team number
                            Target:GetAbsOrigin(),	-- point, center point
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
                            self:GetParent():AddNewModifier(self:GetParent(),self.ability,"modifier_disruptor_thunder_strike_mana_storm_buff",{duration = 25})
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
        end
        

        
    end

    return 0
end

