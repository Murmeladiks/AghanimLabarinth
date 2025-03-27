ember_spirit_searing_chains_attack = class( {} )

LinkLuaModifier( "modifier_ember_spirit_searing_chains_attack", "heroes/emberspirit/ember_spirit_searing_chains_attack", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_ember_spirit_searing_chains_another_another_fake", "heroes/emberspirit/ember_spirit_searing_chains_attack", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ember_spirit_searing_chains_attack:GetIntrinsicModifierName()
	return "modifier_ember_spirit_searing_chains_attack"
end

modifier_ember_spirit_searing_chains_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ember_spirit_searing_chains_attack:IsHidden()
	return true
end

function modifier_ember_spirit_searing_chains_attack:IsPurgeException()
	return false
end

function modifier_ember_spirit_searing_chains_attack:IsPurgable()
	return false
end

function modifier_ember_spirit_searing_chains_attack:IsPermanent()
	return true
end



function modifier_ember_spirit_searing_chains_attack:OnCreated(kv)
    if IsServer() then
        self.chance = 25
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_ember_spirit_searing_chains_attack:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_ember_spirit_searing_chains_attack:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_ember_spirit_searing_chains_attack:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_ember_spirit_searing_chains_attack:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target

        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end
        self.ability = Attacker:FindAbilityByName("ember_spirit_searing_chains")
        if self.ability and self.ability:GetLevel()>0 then
            if RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                
                local duration = self.ability:GetSpecialValueFor("duration")
                   
                        if Target ~= nil and not Target:IsNull() and not Target:IsInvulnerable() and not Target:IsMagicImmune() and Target:IsAlive() then
                            if self:GetParent():HasAbility("ember_spirit_searing_chains_stack") then
                                if not Target:HasModifier("modifier_ember_spirit_searing_chains") then
                                    Target:AddNewModifier( self:GetParent(), self.ability, "modifier_ember_spirit_searing_chains", { duration = duration } )
                                    local sound_cast = "Hero_EmberSpirit.SearingChains.Target"
	                                EmitSoundOn( sound_cast, Target )
                                elseif Target:HasModifier("modifier_ember_spirit_searing_chains") then
                                    Target:AddNewModifier( self:GetParent(), self.ability, "modifier_ember_spirit_searing_chains_another_another_fake", { duration = duration } )
                                    local sound_cast = "Hero_EmberSpirit.SearingChains.Target"
	                                EmitSoundOn( sound_cast, Target )
                                end  
                            else
                                Target:AddNewModifier( self:GetParent(), self.ability, "modifier_ember_spirit_searing_chains", { duration = duration } )
                                local sound_cast = "Hero_EmberSpirit.SearingChains.Target"
	                            EmitSoundOn( sound_cast, Target )
                            end
                        end
                    
                
            end
        end

        

        
    end

    return 0
end

modifier_ember_spirit_searing_chains_another_another_fake = class({})



function modifier_ember_spirit_searing_chains_another_another_fake:IsHidden()
	return false
end

function modifier_ember_spirit_searing_chains_another_another_fake:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_ember_spirit_searing_chains_another_another_fake:IsPurgable()
	return false
end
function modifier_ember_spirit_searing_chains_another_another_fake:OnCreated(kv)
    if IsServer() then
		self:StartIntervalThink(0.5)
        self:OnIntervalThink()
    end
end
function modifier_ember_spirit_searing_chains_another_another_fake:OnIntervalThink()
    if IsServer() then
		local damage = math.floor(self:GetAbility():GetSpecialValueFor("damage_per_second")*0.5)
        local damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(), --Optional.
        }
        ApplyDamage( damageTable )
    end
end
function modifier_ember_spirit_searing_chains_another_another_fake:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end