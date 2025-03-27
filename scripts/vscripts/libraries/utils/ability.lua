function GetParentAbilityManaCost(hSelfAbility)
    hSelfAbility.parent_ability = hSelfAbility:GetCaster():FindAbilityByName(hSelfAbility.parent_ability_name)
    if hSelfAbility.parent_ability ~= nil then
        return hSelfAbility.parent_ability:GetManaCost(hSelfAbility.parent_ability:GetLevel() - 1)
    else
        return hSelfAbility.BaseClass.GetManaCost(iLevel)
    end
end

function GetParentAbilityCooldown(hSelfAbility)
    hSelfAbility.parent_ability = hSelfAbility:GetCaster():FindAbilityByName(hSelfAbility.parent_ability_name)
    if hSelfAbility.parent_ability ~= nil then
        return hSelfAbility.parent_ability:GetCooldown(hSelfAbility.parent_ability:GetLevel() - 1)
    else
        return hSelfAbility.BaseClass.GetCooldown(hSelfAbility.parent_ability:GetLevel() - 1)
    end
end

function GetParentAbility(hSelfAbility)
    if hSelfAbility.parent_ability ~= nil then
        return hSelfAbility.parent_ability
    else
        hSelfAbility.parent_ability = hSelfAbility:GetCaster():FindAbilityByName(hSelfAbility.parent_ability_name)
        return hSelfAbility.parent_ability
    end
end

-- Server only
function AddCooldown(hAbility, flSeconds)
    local cooldown = hAbility:GetCooldownTimeRemaining()
    cooldown = cooldown + flSeconds
    hAbility:EndCooldown()
    hAbility:StartCooldown(cooldown)
    return cooldown
end

function GetLongestCooldownRemainingAbility(hNPC)
    -- local n = hNPC:GetAbilityCount()
    local result = {
        ability = nil,
        cd = -1
    }
    local i = 0
    local ability = hNPC:GetAbilityByIndex(i)
    while IsValid(ability) do
        print(i)
        local cd = ability:GetCooldownTimeRemaining()
        if cd > result.cd then
            result.cd = cd
            result.ability = ability
        end
        i = i + 1
        ability = hNPC:GetAbilityByIndex(i)

    end
    return result
end

function TriggerStandardTargetSpell(hTarget, hAbility)
    hTarget:TriggerSpellReflect(hAbility)
    return hTarget:TriggerSpellAbsorb(hAbility)
end

function CreateFakeAttackProjectileAbility(hTarget, hAttacker, hAbility, sOverrideProjectile)
    local info = {
        Target = hTarget,
        Source = hAttacker,
        Ability = hAbility,	
        EffectName = sOverrideProjectile or hAttacker:GetRangedProjectileName(),
        iMoveSpeed = hAttacker:GetProjectileSpeed() or 900,
        bDodgeable = true,                   -- Optional
        bIsAttack = true,
        ExtraData = {
            attacker_id = hAttacker:entindex(),
        }
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

-- Orb
LinkLuaModifier("modifier_generic_orb_effect_lua", "modifiers/ext/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
function IsOrbAbility(hAbility)
    return hAbility:GetIntrinsicModifierName() == "modifier_generic_orb_effect_lua"
end
function SetOrbOn(hAbility, bOn)
    local mods = hAbility:GetCaster():FindAllModifiersByName("modifier_generic_orb_effect_lua")
    for _, mod in pairs(mods) do
        if mod:GetAbility() == hAbility then
            mod.cast = bOn
        end
    end
end
LinkLuaModifier("modifier_autocast_helper", "modifiers/ext/modifier_autocast_helper", LUA_MODIFIER_MOTION_NONE)
function SetAbilityHasClientAutocast(hAbility)
    hAbility:GetCaster():AddNewModifier(hAbility:GetCaster(), hAbility,"modifier_autocast_helper", {})
end
function GetAutocastState(hAbility)
    if IsServer() then
        return hAbility:GetAutoCastState()
    end
    return hAbility._isAutocast == true
end