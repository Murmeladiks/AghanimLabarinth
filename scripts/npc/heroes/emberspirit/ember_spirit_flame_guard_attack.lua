ember_spirit_flame_guard_attack = class( {} )

LinkLuaModifier( "modifier_ember_spirit_flame_guard_attack", "heroes/emberspirit/ember_spirit_flame_guard_attack", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ember_spirit_flame_guard_attack:GetIntrinsicModifierName()
	return "modifier_ember_spirit_flame_guard_attack"
end

modifier_ember_spirit_flame_guard_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ember_spirit_flame_guard_attack:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", context )
	
end
function modifier_ember_spirit_flame_guard_attack:IsHidden()
	return true
end

function modifier_ember_spirit_flame_guard_attack:IsPurgeException()
	return false
end

function modifier_ember_spirit_flame_guard_attack:IsPurgable()
	return false
end

function modifier_ember_spirit_flame_guard_attack:IsPermanent()
	return true
end



function modifier_ember_spirit_flame_guard_attack:OnCreated(kv)
    if IsServer() then
       
    end
end

function modifier_ember_spirit_flame_guard_attack:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
        
    }
end


function modifier_ember_spirit_flame_guard_attack:OnAttackLanded( params )
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
            self.ability = Attacker:FindAbilityByName("ember_spirit_flame_guard")
            local range = self.ability:GetSpecialValueFor("radius")
            local duration = self.ability:GetSpecialValueFor("duration")
            local absorb_amount = self.ability:GetSpecialValueFor("absorb_amount")
        
            local damage = absorb_amount
            
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
                                    ability = self.ability, --Optional.
                                }
                                ApplyDamage( damageTable )
                
                            end
                        end
            
            
            local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, Vector(255,255,255))
            ParticleManager:DestroyParticle( particle, false )  
        end
 
    end

    return 0
end

