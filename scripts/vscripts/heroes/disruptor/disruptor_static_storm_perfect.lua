disruptor_static_storm_perfect = class({})
LinkLuaModifier( "modifier_disruptor_static_storm_perfect", "heroes/disruptor/disruptor_static_storm_perfect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_kinetic_field_damage_thinker", "heroes/disruptor/disruptor_kinetic_field_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_kinetic_field_heal_thinker", "heroes/disruptor/disruptor_kinetic_field_heal", LUA_MODIFIER_MOTION_NONE )
function disruptor_static_storm_perfect:GetIntrinsicModifierName()
	return "modifier_disruptor_static_storm_perfect"
end


modifier_disruptor_static_storm_perfect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_disruptor_static_storm_perfect:IsHidden()
    return true
end

function modifier_disruptor_static_storm_perfect:IsPurgeException()
    return false
end

function modifier_disruptor_static_storm_perfect:IsPurgable()
    return false
end

function modifier_disruptor_static_storm_perfect:IsPermanent()
    return true
end




function modifier_disruptor_static_storm_perfect:OnCreated(kv)
    if IsServer() then
     
    end
end


function modifier_disruptor_static_storm_perfect:DeclareFunctions()
    return {
        
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
       
    }
end

function modifier_disruptor_static_storm_perfect:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() == "disruptor_static_storm" then
        if self:GetParent():GetHeroFacetID() == 1 then
            local cursorPos = params.ability:GetCursorPosition()
           	self.disruptor_kinetic_field = self:GetParent():FindAbilityByName("disruptor_kinetic_field")
            if not cursorPos then
                return
            end
			local duration = self.disruptor_kinetic_field:GetSpecialValueFor("duration")
            local formationDelay = self.disruptor_kinetic_field:GetSpecialValueFor("formation_time")
			self:GetParent():SetCursorPosition(cursorPos)
			if self.disruptor_kinetic_field and self.disruptor_kinetic_field:GetLevel()>0 then
				self.disruptor_kinetic_field:OnSpellStart()
				if self:GetParent():HasAbility("disruptor_kinetic_field_damage") then
					Timers:CreateTimer(formationDelay, function ()
						CreateModifierThinker( self:GetParent(), self.disruptor_kinetic_field, "modifier_disruptor_kinetic_field_damage_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
					end)
				end
				if self:GetParent():HasAbility("disruptor_kinetic_field_heal") then
					Timers:CreateTimer(formationDelay, function ()
						CreateModifierThinker( self:GetParent(), self.disruptor_kinetic_field, "modifier_disruptor_kinetic_field_heal_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
					end)
				end
			end
           
		else
			local cursorPos = params.ability:GetCursorPosition()
			self.disruptor_kinetic_fence = self:GetParent():FindAbilityByName("disruptor_kinetic_fence")
            if not cursorPos then
                return
            end
			local duration = self.disruptor_kinetic_fence:GetSpecialValueFor("duration")
            local formationDelay = self.disruptor_kinetic_fence:GetSpecialValueFor("formation_time")
			self:GetParent():SetCursorPosition(cursorPos)
			if self.disruptor_kinetic_fence and self.disruptor_kinetic_fence:GetLevel()>0 then
				self.disruptor_kinetic_fence:OnSpellStart()
				
				if self:GetParent():HasAbility("disruptor_kinetic_field_damage") then
					Timers:CreateTimer(formationDelay, function ()
						CreateModifierThinker( self:GetParent(), self.disruptor_kinetic_fence, "modifier_disruptor_kinetic_field_damage_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
					end)
				end
				if self:GetParent():HasAbility("disruptor_kinetic_field_heal") then
					Timers:CreateTimer(formationDelay, function ()
						CreateModifierThinker( self:GetParent(), self.disruptor_kinetic_fence, "modifier_disruptor_kinetic_field_heal_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
					end)
				end
			end
		end
    end
   
            
    
  
    
end



