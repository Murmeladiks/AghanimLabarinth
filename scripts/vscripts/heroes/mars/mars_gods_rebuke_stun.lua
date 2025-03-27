aghsfort_special_mars_gods_rebuke_stun = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_mars_gods_rebuke_stun", "heroes/mars/mars_gods_rebuke_stun", LUA_MODIFIER_MOTION_NONE )
function aghsfort_special_mars_gods_rebuke_stun:GetIntrinsicModifierName()
	return "modifier_mars_gods_rebuke_stun"
end

modifier_mars_gods_rebuke_stun = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_gods_rebuke_stun:Precache( context )
	
	
end

function modifier_mars_gods_rebuke_stun:IsHidden()
	return true
end

function modifier_mars_gods_rebuke_stun:IsPurgeException()
	return false
end

function modifier_mars_gods_rebuke_stun:IsPurgable()
	return false
end

function modifier_mars_gods_rebuke_stun:IsPermanent()
	return true
end




function modifier_mars_gods_rebuke_stun:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_mars_gods_rebuke_stun:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_mars_gods_rebuke_stun:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
   
    if params.ability:GetAbilityName() == "aghsfort_mars_gods_rebuke" then
        local positon = params.unit:GetAbsOrigin()
        local radius = params.ability:GetSpecialValueFor("radius")
		local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),   -- int, your team number
            positon,   -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            radius + 25,   -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  -- int, flag filter
            FIND_ANY_ORDER,  -- int, order filter
            false   -- bool, can grow cache
        )
		for _,enemy in pairs(enemies) do
			if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
				if enemy:HasModifier("modifier_mars_gods_rebuke_slow") then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 2})
				end
			end
		end
    end
    

    
       
    

  

    
end