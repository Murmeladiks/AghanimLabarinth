-- keys
-- modifier: the modifier to increase stack
-- duration: stack duration
-- destroy_no_layer : if destroy when no layer
function IncreaseStack(kv)
    if IsValid(kv.modifier) then
        local ability = kv.modifier:GetAbility()
        local caster = ability:GetCaster()
        local duration = kv.duration or 0
        if kv.stacks == nil then
            local modifier_layer = kv.modifier:GetParent():AddNewModifier(caster, ability, "modifier_generic_layer_stack", {
                duration = duration,
                purgable = kv.modifier:IsPurgable(),
                destroy_no_layer = kv.destroy_no_layer,
                stacks = 1,
                -- buff = kv.buff
            })
            if IsValid(modifier_layer) then 
                modifier_layer.modifier = kv.modifier
                kv.modifier:IncrementStackCount()
            end
        else
            local modifier_layer = kv.modifier:GetParent():AddNewModifier(caster, ability, "modifier_generic_layer_stack", {
                duration = duration,
                purgable = kv.modifier:IsPurgable(),
                destroy_no_layer = kv.destroy_no_layer,
                stacks = kv.stacks,
                -- buff = kv.buff
            })
            if IsValid(modifier_layer) then 
                modifier_layer.modifier = kv.modifier
                kv.modifier:SetStackCount(kv.modifier:GetStackCount() + kv.stacks)
            end
        end
    end
end

function DecreaseStack(kv)
    if IsValid(kv.modifier) then
        kv.modifier:SetStackCount(kv.modifier:GetStackCount() - kv.stacks)

        local destroy_no_layer = kv.destroy_no_layer or 1
        if destroy_no_layer > 0 and kv.modifier:GetStackCount() <= 0 then
            kv.modifier:Destroy()
        end
    end
end

function AddModifierConsiderResist(hTarget, hCaster, hAbility, szModifierName, kv)
    -- if hCaster ~= nil and not hCaster:IsNull() then
    --     print("debuff amp:"..hCaster:)
    -- end
    if IsValid(hTarget) then
        local duration_pct = 1 - hTarget:GetStatusResistance()
        kv.duration = kv.duration * duration_pct
        if kv.tick_interval ~= nil then
            -- print(kv.tick_interval.."dsfdsf"..duration_pct)
            kv.tick_interval = math.max(kv.tick_interval * duration_pct, FrameTime())
            -- print(kv.tick_damage)
        end
        return hTarget:AddNewModifier(hCaster, hAbility, szModifierName, kv)
    end
    return nil
end

function ApplyMotionController2AbsoluteNoCC(hTarget, hCaster, hAbility, szModifierName, kv, bConsiderResist)
    local ctrl_mod = hTarget:AddNewModifier(hTarget, nil, "modifier_expecially_motion_ctrlable", {duration = 0.1})
    if bConsiderResist then
        AddModifierConsiderResist(hTarget, hCaster, hAbility, szModifierName, kv)
    else
        hTarget:AddNewModifier( hCaster, hAbility, szModifierName, kv )
    end
    if IsValid(ctrl_mod) then
        ctrl_mod:Destroy()
    end
end

function UpdateDurationUnderResist(hTarget, hCaster, hModifier, fDelta, fMax)
    local duration_pct = (100 - hTarget:GetStatusResistance()) * 0.01
    local new_duration = math.min(fMax*duration_pct, hModifier:GetDuration() + fDelta * duration_pct)

    hModifier:SetDuration(new_duration, true)
end

function RescaleSlowUnderResist(hNPC, slow)
    local resist = 0
    if IsValid(hNPC) then
        resist = hNPC:GetStatusResistance()
    end
    return slow * (1 - resist)
end

function RescaleDamageUnderResist(hNPC, damage)
    local resist = math.max(0.1, 1 - hNPC:GetStatusResistance())
    return damage / resist
end


function AddNewModifierWhenPossible(hTarget, hCaster, hAbility, pszScriptName, hModifierTable)
	Timers:CreateTimer(0.1, function()
		if not IsValid(hTarget) then
            return nil
        end
        if not hTarget:IsAlive() or (IsEnemy(hTarget, hCaster) and hTarget:IsInvulnerable()) then
			return 0.1
		else
			hTarget:AddNewModifier(hCaster, hAbility, pszScriptName, hModifierTable)
		end			
	end)
end

-- 强控限制
-- 部分技能能强控精英级以上具有霸体的单位使之完全无法行动，但是这类控制在短时间内多次作用持续时间会急速缩短，并且叠加次数多了以后直接无法生效
function AddAbsoluteCCModifier(hTarget, hCaster, hAbility, pszScriptName, hModifierTable, bConsiderSR)
    -- local max_dur = _G.EXT_CC_RESIST_DUR or 60
    if hTarget.bAbsoluteNoCC then
        local max_dur = 60
        -- local boss_stack = 3
        -- local elite_stack = 5
        local r_mod
        if hTarget:IsBoss() or hTarget:IsBossCreature() then
            r_mod = hTarget:AddNewModifier(hTarget, nil, "modifier_ext_cc_resist", {duration = 60, max_stacks = 4, stacks = 1})
        else
            r_mod = hTarget:AddNewModifier(hTarget, nil, "modifier_ext_cc_resist", {duration = 60, max_stacks = 6, stacks = 1})
        end
        if r_mod then
            if r_mod:IsOverMaxStack(false) then
                local vMaxs = hTarget:GetBoundingMaxs()
                local vMins = hTarget:GetBoundingMins()
                local flFXScale = ( vMaxs.z - vMins.z / 1.5 )
                local nFxIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/disable_resist.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
                ParticleManager:SetParticleControlEnt( nFxIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
                ParticleManager:SetParticleControl( nFxIndex, 1, Vector( flFXScale, flFXScale, flFXScale ) )
                ParticleManager:ReleaseParticleIndex( nFxIndex )
                
                EmitSoundOn( "DisableResistance.EarlyDebuffEnd", hTarget )  
                return nil
            end 
            if hModifierTable.duration then
                local stack = r_mod:GetStackCount()
                if stack > 1 then
                    for i = 1, stack, 1 do
                        hModifierTable.duration = hModifierTable.duration / 2
                    end
                    hModifierTable.duration = math.max(hModifierTable.duration, 0.5)
                end
            end
        else
        end
    end
    if bConsiderSR then
        return AddModifierConsiderResist(hTarget, hCaster, hAbility, pszScriptName, hModifierTable)
    else
        return hTarget:AddNewModifier(hCaster, hAbility, pszScriptName, hModifierTable)
    end
end

function RemoveModifierSafe(hTarget, szModifierName)
    if IsValid(hTarget) then
        hTarget:RemoveModifierByName(szModifierName)
    end
end
