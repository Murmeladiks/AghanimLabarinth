ember_spirit_searing_chains_stack = class( {} )

LinkLuaModifier( "modifier_ember_spirit_searing_chains_stack", "heroes/emberspirit/ember_spirit_searing_chains_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ember_spirit_searing_chains_fake", "heroes/emberspirit/ember_spirit_searing_chains_stack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ember_spirit_searing_chains_stack:GetIntrinsicModifierName()
	return "modifier_ember_spirit_searing_chains_stack"
end

modifier_ember_spirit_searing_chains_stack = class({})

--------------------------------------------------------------------------------
-- Classifications


function modifier_ember_spirit_searing_chains_stack:IsHidden()
	return true
end

function modifier_ember_spirit_searing_chains_stack:IsPurgeException()
	return false
end

function modifier_ember_spirit_searing_chains_stack:IsPurgable()
	return false
end

function modifier_ember_spirit_searing_chains_stack:IsPermanent()
	return true
end



function modifier_ember_spirit_searing_chains_stack:OnCreated(kv)
    if IsServer() then
		
    end
end

function modifier_ember_spirit_searing_chains_stack:DeclareFunctions()
	return {
	
        --MODIFIER_EVENT_ON_MODIFIER_ADDED,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end


--------------------------------------------------------------------------------

--  function modifier_ember_spirit_searing_chains_stack:OnModifierAdded( params )
--      if IsServer() then
--         if params.added_buff:GetName() == "modifier_ember_spirit_searing_chains" then
--              if params.unit and params.unit:IsAlive() and not params.unit:IsNull() and not params.unit:IsInvulnerable() and not params.unit:IsMagicImmune()  then
--                 if  params.unit:HasModifier("modifier_ember_spirit_searing_chains") then
--                     self.ability = self:GetParent():FindAbilityByName("ember_spirit_searing_chains")
--                     local duration = self.ability:GetSpecialValueFor("duration")    
--                     params.unit:AddNewModifier( self:GetParent(), self.ability, "modifier_ember_spirit_searing_chains_fake", { duration = duration } )
                       
--                 end  
                
--              end
--          end
--      end
--  end
function modifier_ember_spirit_searing_chains_stack:OnAbilityFullyCast(params)

	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
   
	if params.ability:GetAbilityName() == "ember_spirit_searing_chains" then
        self.ability = self:GetParent():FindAbilityByName("ember_spirit_searing_chains")
        local duration = self.ability:GetSpecialValueFor("duration")
        local radius = params.ability:GetSpecialValueFor("radius")
        local pos = self:GetParent():GetAbsOrigin()
        local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), pos, self:GetParent(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        
            for _,enemy in pairs( enemies ) do
                if enemy ~= nil and not enemy:IsNull() and not enemy:IsInvulnerable() and not enemy:IsMagicImmune() and enemy:IsAlive() then
                    if enemy:HasModifier("modifier_ember_spirit_searing_chains") or enemy:HasModifier("modifier_ember_spirit_searing_chains_fake") then
                        enemy:AddNewModifier( self:GetParent(), self.ability, "modifier_ember_spirit_searing_chains_fake", { duration = duration } )
                        local sound_cast = "Hero_EmberSpirit.SearingChains.Target"
	                    EmitSoundOn( sound_cast, enemy )
                    end 
                    
                end
            end
        
    end
    
end
modifier_ember_spirit_searing_chains_fake = class({})



function modifier_ember_spirit_searing_chains_fake:IsHidden()
	return false
end

function modifier_ember_spirit_searing_chains_fake:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_ember_spirit_searing_chains_fake:IsPurgable()
	return false
end
function modifier_ember_spirit_searing_chains_fake:OnCreated(kv)
    if IsServer() then
		self:StartIntervalThink(0.5)
        self:OnIntervalThink()
    end
end
function modifier_ember_spirit_searing_chains_fake:OnIntervalThink()
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
function modifier_ember_spirit_searing_chains_fake:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end