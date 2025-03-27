aghsfort_special_mars_gods_rebuke_strength_buff = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_mars_gods_rebuke_strength", "heroes/mars/mars_gods_rebuke_strength", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_strength_buff", "heroes/mars/mars_gods_rebuke_strength", LUA_MODIFIER_MOTION_NONE )

function aghsfort_special_mars_gods_rebuke_strength_buff:GetIntrinsicModifierName()
	return "modifier_mars_gods_rebuke_strength"
end

modifier_mars_gods_rebuke_strength = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_gods_rebuke_strength:Precache( context )
	
	
end

function modifier_mars_gods_rebuke_strength:IsHidden()
	return true
end

function modifier_mars_gods_rebuke_strength:IsPurgeException()
	return false
end

function modifier_mars_gods_rebuke_strength:IsPurgable()
	return false
end

function modifier_mars_gods_rebuke_strength:IsPermanent()
	return true
end




function modifier_mars_gods_rebuke_strength:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_mars_gods_rebuke_strength:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_mars_gods_rebuke_strength:OnDeath(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
   
    if params.inflictor and params.inflictor:GetAbilityName() == "aghsfort_mars_gods_rebuke" then
        
		local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_gods_rebuke_strength_buff", {duration = 10})
        if buff then
            buff:AddStack()
        end
    end
 
end
function modifier_mars_gods_rebuke_strength:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
   
    if params.inflictor and params.inflictor:GetAbilityName() == "aghsfort_mars_gods_rebuke" then
        if params.unit and params.unit:IsAlive() then
            local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_gods_rebuke_strength_buff", {duration = 10})
            if buff then
                buff:AddStack()
            end
        end
    end
 
end

modifier_mars_gods_rebuke_strength_buff = class({})


function modifier_mars_gods_rebuke_strength_buff:IsPurgable()
	return false
end

function modifier_mars_gods_rebuke_strength_buff:IsPurgeException()
	return false
end

function modifier_mars_gods_rebuke_strength_buff:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_mars_gods_rebuke_strength_buff:OnCreated( kv )
	self.str  = 4
	
end
function modifier_mars_gods_rebuke_strength_buff:OnRefresh( kv )
	self.str  = 4
   
end
--------------------------------------------------------------------------------

function modifier_mars_gods_rebuke_strength_buff:OnRefresh( kv )
	
end
function modifier_mars_gods_rebuke_strength_buff:AddStack()
   
	self:IncrementStackCount()

	
    Timers:CreateTimer(10, function()
        if(self and not self:IsNull()) then
            self:DecrementStackCount()
        end
    end)
   
   
end


function modifier_mars_gods_rebuke_strength_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		
	}

	return funcs
end



function modifier_mars_gods_rebuke_strength_buff:GetModifierBonusStats_Strength(params)
	return self.str*self:GetStackCount()
end



--------------------------------------------------------------------------------

