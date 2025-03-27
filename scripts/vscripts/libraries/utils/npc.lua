_G.MS_ACTS_NAME = {
    "walk",
    "run",
    "run_fast",
}

function InitAttackCapacityTransform(hNPC)
    if hNPC._atk_cap_list == nil then
        hNPC._atk_cap_list = {}
    end
    local kv = GetUnitKeyValuesByName(hNPC:GetUnitName())
    if kv then
        -- print(kv.AttackCapabilities)
        -- print(_G[kv.AttackCapabilities])
        hNPC._default_atk_cap = _G[kv.AttackCapabilities]
    end
end
function UpdateAttackCapacityTransform(hNPC)
    if hNPC._atk_cap_list == nil then
        InitAttackCapacityTransform(hNPC)
    end   
    if #hNPC._atk_cap_list > 0 then
        table.sort(hNPC._atk_cap_list, function (a, b)
            return a.prior > b.prior
        end)
        hNPC:SetAttackCapability(hNPC._atk_cap_list[1].cap)
        return
    end
    hNPC:SetAttackCapability(hNPC._default_atk_cap or DOTA_UNIT_CAP_NO_ATTACK)
    return
end
function AddAttackCapacityTransform(hNPC, szTransformName, iCapacity, iPriority)
    if hNPC._atk_cap_list == nil then
        InitAttackCapacityTransform(hNPC)
    end
    for i = 1, #hNPC._atk_cap_list do
        if hNPC._atk_cap_list[i].name == szTransformName then
            hNPC._atk_cap_list[i].cap = iCapacity
            hNPC._atk_cap_list[i].prior = iPriority
            UpdateAttackCapacityTransform(hNPC)
            return
        end
    end
    table.insert(hNPC._atk_cap_list, {name = szTransformName, cap = iCapacity, prior = iPriority})
    UpdateAttackCapacityTransform(hNPC)
end
function RemoveAttackCapacityTransform(hNPC, szTransformName)
    if hNPC._atk_cap_list == nil then
        InitAttackCapacityTransform(hNPC)
    else
        for i = 1, #hNPC._atk_cap_list do
            if hNPC._atk_cap_list[i].name == szTransformName then
                table.remove(hNPC._atk_cap_list, i)
                break
            end
        end
    end
    UpdateAttackCapacityTransform(hNPC)
end

function SetCreatureExAdditionalAbilities( hEnemyCreature, szAbilityNames, nLevel )
    for _, szAbilityName in pairs(szAbilityNames) do
        local hAbility = hEnemyCreature:AddAbility(szAbilityName)
        if IsValid(hAbility) then
            if nLevel then
                hAbility:SetLevel(nLevel - 1)
            end
            hAbility:UpgradeAbility(true)
        end
    end
end 

function AddDamageRefraction( hEnemyCreature, nInstances )
    local hAbility = hEnemyCreature:AddAbility("generic_refraction_once")
    if IsValid(hAbility) then
        if nInstances then
            hAbility:SetLevel(nInstances - 1)
        end
        hAbility:UpgradeAbility(true)
        hAbility:OnSpellStart()
    end
end 
