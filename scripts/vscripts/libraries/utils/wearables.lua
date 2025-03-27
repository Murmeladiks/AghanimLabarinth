LinkLuaModifier("modifier_generic_wearable_hide", "libraries/utils/wearables.lua", LUA_MODIFIER_MOTION_NONE)

function Set_Wearable_Hide(hNPC, iSlot, bHide)
    if IsValid(hNPC) then
        local wearable = hNPC:GetTogglableWearable(iSlot)
        if wearable then
            if bHide then
                wearable:AddEffects(EF_NODRAW)
            else
                wearable:RemoveEffects(EF_NODRAW)
            end
        end
    end
end

modifier_generic_wearable_hide = {}

function modifier_generic_wearable_hide:IsHidden()
    return true
end

function modifier_generic_wearable_hide:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_wearable_hide:IsPurgable()
    return false
end

function modifier_generic_wearable_hide:OnCreated(kv)
    if IsServer() then
        self.parent = self:GetParent()
        if not self.parent:IsHero() then
            self:Destroy()
            return
        end
        self.wearable = self.parent:GetTogglableWearable(kv.slot)
        if self.wearable then
            self.wearable:AddEffects(EF_NODRAW)
        else
            self:Destroy()
        end
    end
end

function modifier_generic_wearable_hide:OnRemoved()
    if IsServer() then
        if self.wearable then
            self.wearable:RemoveEffects(EF_NODRAW)
        end
    end
end

