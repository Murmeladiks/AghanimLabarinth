ember_spirit_flame_guard_ally = class( {} )

LinkLuaModifier( "modifier_ember_spirit_flame_guard_ally", "heroes/emberspirit/ember_spirit_flame_guard_ally", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ember_spirit_flame_guard_ally_heal", "heroes/emberspirit/ember_spirit_flame_guard_ally", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ember_spirit_flame_guard_attack_ally_buff", "heroes/emberspirit/ember_spirit_flame_guard_ally", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ember_spirit_flame_guard_ally:GetIntrinsicModifierName()
	return "modifier_ember_spirit_flame_guard_ally"
end


modifier_ember_spirit_flame_guard_ally = class({})
function modifier_ember_spirit_flame_guard_ally:IsPurgable()	return false end
function modifier_ember_spirit_flame_guard_ally:IsPermanent()	return true end
function modifier_ember_spirit_flame_guard_ally:IsHidden()   return true end

function modifier_ember_spirit_flame_guard_ally:OnCreated(kv)
  
end

function modifier_ember_spirit_flame_guard_ally:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_ember_spirit_flame_guard_ally:OnAbilityFullyCast(params)
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
    local Range = 600
    local heroes = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),	-- int, your team number
        self:GetParent():GetAbsOrigin(),	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )
    
        
            for _, hero in pairs(heroes) do
                if hero and not hero:IsNull() and not hero:IsInvulnerable()  then
                    hero:AddNewModifier(self:GetParent(),self.ability,"modifier_ember_spirit_flame_guard",{duration = duration})  
                    if self:GetParent():HasAbility("ember_spirit_flame_guard_heal") then
                        if not hero:HasModifier("modifier_ember_spirit_flame_guard_ally_heal") then
                            hero:AddNewModifier(self:GetParent(),self.ability,"modifier_ember_spirit_flame_guard_ally_heal",{duration = duration})
                        else
                            hero:RemoveModifierByName("modifier_ember_spirit_flame_guard_ally_heal")
                            hero:AddNewModifier(self:GetCaster(),self.ability,"modifier_ember_spirit_flame_guard_ally_heal",{duration = duration}) 
                        end 
                    end
                    if self:GetParent():HasAbility("ember_spirit_flame_guard_attack") then
                        hero:AddNewModifier(self:GetParent(),self.ability,"modifier_ember_spirit_flame_guard_attack_ally_buff",{duration = duration})
                    end
                end
            end
        
        
   
        
end

modifier_ember_spirit_flame_guard_ally_heal = class({})
function modifier_ember_spirit_flame_guard_ally_heal:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end
function modifier_ember_spirit_flame_guard_ally_heal:IsPurgable()	return false end
function modifier_ember_spirit_flame_guard_ally_heal:IsPermanent()	return false end
function modifier_ember_spirit_flame_guard_ally_heal:IsHidden()   return true end
function modifier_ember_spirit_flame_guard_ally_heal:OnCreated(kv)
    if  IsServer() then
        self:OnIntervalThink()
	    self:StartIntervalThink( 0.2 )
        
    end
   
    
   
end
function modifier_ember_spirit_flame_guard_ally_heal:OnIntervalThink()
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


modifier_ember_spirit_flame_guard_attack_ally_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ember_spirit_flame_guard_attack_ally_buff:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", context )
	
end
function modifier_ember_spirit_flame_guard_attack_ally_buff:IsHidden()
	return true
end

function modifier_ember_spirit_flame_guard_attack_ally_buff:IsPurgeException()
	return false
end

function modifier_ember_spirit_flame_guard_attack_ally_buff:IsPurgable()
	return false
end

function modifier_ember_spirit_flame_guard_attack_ally_buff:IsPermanent()
	return true
end



function modifier_ember_spirit_flame_guard_attack_ally_buff:OnCreated(kv)
    if IsServer() then
       
    end
end

function modifier_ember_spirit_flame_guard_attack_ally_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_ember_spirit_flame_guard_attack_ally_buff:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target

        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end
        
        if Attacker:HasModifier("modifier_ember_spirit_flame_guard") then
            --self.ability = Attacker:FindAbilityByName("ember_spirit_flame_guard")
            local range = self:GetAbility():GetSpecialValueFor("radius")
            local duration = self:GetAbility():GetSpecialValueFor("duration")
            local damage_per_second = self:GetAbility():GetSpecialValueFor("damage_per_second")
        
            local damage = duration*damage_per_second*0.5
            
            local enemies = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),	-- int, your team number
                            self:GetParent():GetAbsOrigin(),	-- point, center point
                            nil,	-- handle, cacheUnit. (not known)
                            range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,	-- int, order filter
                            false
                        )
                        for _, enemy in pairs(enemies) do
                            if enemy and not enemy:IsNull() and not enemy:IsInvulnerable()  and not enemy:IsMagicImmune() then
                                local damageTable = {
                                    victim = enemy,
                                    attacker = self:GetCaster(),
                                    damage = damage,
                                    damage_type = DAMAGE_TYPE_MAGICAL,
                                    ability = self:GetAbility(), --Optional.
                                }
                                ApplyDamage( damageTable )
                
                            end
                        end
            
            
            local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, Vector(255,255,255))
            ParticleManager:DestroyParticle( particle, false )  
        end
 
    end

    return 0
end

