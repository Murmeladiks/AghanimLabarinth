ember_spirit_sleight_of_fist_crit = class( {} )

LinkLuaModifier( "modifier_ember_spirit_sleight_of_fist_crit", "heroes/emberspirit/ember_spirit_sleight_of_fist_crit", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ember_spirit_sleight_of_fist_crit:GetIntrinsicModifierName()
	return "modifier_ember_spirit_sleight_of_fist_crit"
end

modifier_ember_spirit_sleight_of_fist_crit = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ember_spirit_sleight_of_fist_crit:IsHidden()
	return true
end

function modifier_ember_spirit_sleight_of_fist_crit:IsPurgeException()
	return false
end

function modifier_ember_spirit_sleight_of_fist_crit:IsPurgable()
	return false
end

function modifier_ember_spirit_sleight_of_fist_crit:IsPermanent()
	return true
end



function modifier_ember_spirit_sleight_of_fist_crit:OnCreated(kv)
    if IsServer() then
		
    end
end

function modifier_ember_spirit_sleight_of_fist_crit:DeclareFunctions()
	return {
	
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end


--------------------------------------------------------------------------------

function modifier_ember_spirit_sleight_of_fist_crit:GetModifierPreAttack_CriticalStrike( params )
    if IsServer() then
        local hTarget = params.target
        local hAttacker = params.attacker
        self.ability = params.attacker:FindAbilityByName("ember_spirit_searing_chains")
        local critpct = self.ability:GetSpecialValueFor("unit_count")*100
        print("critpct")
        print(critpct)
        if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
            if  hTarget:HasModifier("modifier_ember_spirit_sleight_of_fist_marker")  then
                return critpct
            end
        end
    end
end
