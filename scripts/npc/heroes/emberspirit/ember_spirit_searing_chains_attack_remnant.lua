ember_spirit_searing_chains_attack_remnant = class( {} )

LinkLuaModifier( "modifier_ember_spirit_searing_chains_attack_remnant", "heroes/emberspirit/ember_spirit_searing_chains_attack_remnant", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ember_spirit_searing_chains_attack_remnant:GetIntrinsicModifierName()
	return "modifier_ember_spirit_searing_chains_attack_remnant"
end

modifier_ember_spirit_searing_chains_attack_remnant = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ember_spirit_searing_chains_attack_remnant:IsHidden()
	return true
end

function modifier_ember_spirit_searing_chains_attack_remnant:IsPurgeException()
	return false
end

function modifier_ember_spirit_searing_chains_attack_remnant:IsPurgable()
	return false
end

function modifier_ember_spirit_searing_chains_attack_remnant:IsPermanent()
	return true
end



function modifier_ember_spirit_searing_chains_attack_remnant:OnCreated(kv)
    if IsServer() then
        self.chance = 20
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_ember_spirit_searing_chains_attack_remnant:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_ember_spirit_searing_chains_attack_remnant:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_ember_spirit_searing_chains_attack_remnant:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_ember_spirit_searing_chains_attack_remnant:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target

        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end
        if Target:HasModifier("modifier_ember_spirit_searing_chains") then
            self.ability = Attacker:FindAbilityByName("ember_spirit_fire_remnant")
            local pos = Target:GetAbsOrigin()
            if self.ability and self.ability:GetLevel()>0 then
                if RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                    Attacker:SetCursorPosition(pos)
                    self.ability:OnSpellStart()
                    self.ember_spirit_searing_chains = Attacker:FindAbilityByName("ember_spirit_searing_chains")
                    local damage = self.ember_spirit_searing_chains:GetSpecialValueFor("damage_per_second")
                    if Target and not Target:IsNull() and not Target:IsInvulnerable() and  Target:IsAlive() and not Target:IsMagicImmune() then
                        local damageTable = {
                            victim = Target,
                            attacker = Attacker,
                            damage = damage ,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self, --Optional.
                        }
                        ApplyDamage( damageTable )
                    end
                end
            end
        end
        

        
    end

    return 0
end

