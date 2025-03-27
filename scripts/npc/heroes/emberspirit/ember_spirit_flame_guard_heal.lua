ember_spirit_flame_guard_heal = class( {} )

LinkLuaModifier( "modifier_ember_spirit_flame_guard_heal", "heroes/emberspirit/ember_spirit_flame_guard_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ember_spirit_flame_guard_heal_buff", "heroes/emberspirit/ember_spirit_flame_guard_heal", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ember_spirit_flame_guard_heal:GetIntrinsicModifierName()
	return "modifier_ember_spirit_flame_guard_heal"
end


modifier_ember_spirit_flame_guard_heal = class({})
function modifier_ember_spirit_flame_guard_heal:IsPurgable()	return false end
function modifier_ember_spirit_flame_guard_heal:IsPermanent()	return true end
function modifier_ember_spirit_flame_guard_heal:IsHidden()   return true end

function modifier_ember_spirit_flame_guard_heal:OnCreated(kv)
  
end

function modifier_ember_spirit_flame_guard_heal:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_ember_spirit_flame_guard_heal:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "ember_spirit_flame_guard" then
        return
    end
    self.ability = self:GetParent():FindAbilityByName("ember_spirit_flame_guard")
    local duration = self.ability:GetSpecialValueFor("duration")
    if not  self:GetParent():HasModifier("modifier_ember_spirit_flame_guard_heal_buff") then
        self:GetParent():AddNewModifier(self:GetCaster(),self.ability,"modifier_ember_spirit_flame_guard_heal_buff",{duration = duration})
    else
        self:GetParent():RemoveModifierByName("modifier_ember_spirit_flame_guard_heal_buff")
        self:GetParent():AddNewModifier(self:GetCaster(),self.ability,"modifier_ember_spirit_flame_guard_heal_buff",{duration = duration})
    end
        
end




modifier_ember_spirit_flame_guard_heal_buff = class({})
function modifier_ember_spirit_flame_guard_heal_buff:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end
function modifier_ember_spirit_flame_guard_heal_buff:IsPurgable()	return false end
function modifier_ember_spirit_flame_guard_heal_buff:IsPermanent()	return false end
function modifier_ember_spirit_flame_guard_heal_buff:IsHidden()   return true end
function modifier_ember_spirit_flame_guard_heal_buff:OnCreated(kv)
    if  IsServer() then
        self:OnIntervalThink()
	    self:StartIntervalThink( 0.2 )
        
    end
   
    
   
end
function modifier_ember_spirit_flame_guard_heal_buff:OnIntervalThink()
    if  IsServer() then
        if self:GetParent():HasModifier("modifier_ember_spirit_flame_guard") then
            --self.ability = self:GetCaster():FindAbilityByName("ember_spirit_flame_guard")
            local heal = self:GetAbility():GetSpecialValueFor("damage_per_second")*0.2
            self:GetParent():Heal( heal, nil )
           
        else
           
                     
            --放在这里并没有什么意义 modifier已经到时间被移除了  
            self:StartIntervalThink( -1 )
        end
    end
  
end