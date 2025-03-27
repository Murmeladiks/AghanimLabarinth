aghsfort_special_mars_arena_of_blood_attack_buff = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_mars_arena_buff", "heroes/mars/mars_arena_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_buff_thinker", "heroes/mars/mars_arena_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_buff_buffer", "heroes/mars/mars_arena_buff", LUA_MODIFIER_MOTION_NONE )
 
function aghsfort_special_mars_arena_of_blood_attack_buff:GetIntrinsicModifierName()
	return "modifier_mars_arena_buff"
end

modifier_mars_arena_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_arena_buff:Precache( context )
	
	
end

function modifier_mars_arena_buff:IsHidden()
	return true
end

function modifier_mars_arena_buff:IsPurgeException()
	return false
end

function modifier_mars_arena_buff:IsPurgable()
	return false
end

function modifier_mars_arena_buff:IsPermanent()
	return true
end



function modifier_mars_arena_buff:OnCreated(kv)
    if IsServer() then


       
    end
end

function modifier_mars_arena_buff:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_mars_arena_buff:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "aghsfort_mars_arena_of_blood" then
        return
    end

    self.aghsfort_mars_arena_of_blood =self:GetParent():FindAbilityByName("aghsfort_mars_arena_of_blood")
    local duration = self.aghsfort_mars_arena_of_blood:GetSpecialValueFor("duration")
    local radius = self.aghsfort_mars_arena_of_blood:GetSpecialValueFor("radius")
    local castpos = params.ability:GetCursorPosition()
    print(duration)
    CreateModifierThinker( self:GetParent(), params.ability, "modifier_mars_arena_buff_thinker", { duration = duration }, castpos, self:GetParent():GetTeamNumber(), false )

end


modifier_mars_arena_buff_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_mars_arena_buff_thinker:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self:OnIntervalThink()
		self:StartIntervalThink( 0.25 )
	end
end

function modifier_mars_arena_buff_thinker:GetTexture()
	return "mars_arena_of_blood"
end

----------------------------------------------------------------------------------------

function modifier_mars_arena_buff_thinker:OnIntervalThink()
	if IsServer() then
		if not self.caster or self.caster:IsNull() then
			self:Destroy()
			return
		end
		
		local allies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetOrigin(),
            nil,
            self.radius + 50, 
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO,
            0,
            FIND_ANY_ORDER,
            false 
        )

        for _,ally in pairs( allies ) do
            if ally and ally:IsAlive() then
                if not ally:HasModifier("modifier_mars_arena_buff_buffer") then
                    ally:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_mars_arena_buff_buffer",{duration = 10})
                end
            end
        end	
	end
end


function modifier_mars_arena_buff_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

----------------------------------------------------------------------------------------

modifier_mars_arena_buff_buffer = class({})
function modifier_mars_arena_buff_buffer:IsHidden()
	return false
end

function modifier_mars_arena_buff_buffer:IsPurgeException()
	return false
end

function modifier_mars_arena_buff_buffer:IsPurgable()
	return false
end

function modifier_mars_arena_buff_buffer:IsPermanent()
	return false
end
function modifier_mars_arena_buff_buffer:OnCreated( kv )
	if IsServer() then
		self.damage = 35
        self.attackspeed = 25
	end
end
function modifier_mars_arena_buff_buffer:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end
function modifier_mars_arena_buff_buffer:GetModifierAttackSpeedBonus_Constant(params)
	return 25
end
function modifier_mars_arena_buff_buffer:GetModifierPreAttack_BonusDamage(params)
	return 35
end