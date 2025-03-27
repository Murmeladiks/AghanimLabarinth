mars_spear_boomstick = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_mars_spear_boomstick", "heroes/mars/mars_spear_boomstick", LUA_MODIFIER_MOTION_NONE )
function mars_spear_boomstick:GetIntrinsicModifierName()
	return "modifier_mars_spear_boomstick"
end
function mars_spear_boomstick:OnSpellStart()
    local caster = self:GetCaster()
	local point = self:GetCursorPosition()
    local projectile_name = "particles/units/heroes/hero_mars/mars_spear.vpcf"
    self.aghsfort_mars_spear =self:GetCaster():FindAbilityByName("aghsfort_mars_spear")
	local projectile_distance = self.aghsfort_mars_spear:GetSpecialValueFor("spear_range")
	local projectile_speed = self.aghsfort_mars_spear:GetSpecialValueFor("spear_speed")
	local projectile_radius = self.aghsfort_mars_spear:GetSpecialValueFor("spear_width")
	local projectile_vision = self.aghsfort_mars_spear:GetSpecialValueFor("spear_vision")

	-- calculate direction
	local direction = caster:GetOrigin() - point
	direction.z = 0
	direction = direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = point,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius =projectile_radius,
		vVelocity = direction * projectile_speed,
	
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		fVisionDuration = 10,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- play effects
	local sound_cast = "Hero_Mars.Spear.Cast"
	EmitSoundOn( sound_cast, caster )
	local sound_cast = "Hero_Mars.Spear"
	EmitSoundOn( sound_cast, caster )
end
function mars_spear_boomstick:OnProjectileHitHandle( target, location, projectile )
	if not target then return end

	local damage = self.aghsfort_mars_spear:GetSpecialValueFor("damage")
    print(damage)
	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
end
modifier_mars_spear_boomstick = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_spear_boomstick:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end

function modifier_mars_spear_boomstick:IsHidden()
	return true
end

function modifier_mars_spear_boomstick:IsPurgeException()
	return false
end

function modifier_mars_spear_boomstick:IsPurgable()
	return false
end

function modifier_mars_spear_boomstick:IsPermanent()
	return true
end




function modifier_mars_spear_boomstick:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_mars_spear_boomstick:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_mars_spear_boomstick:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
   
    if params.ability:GetAbilityName() == "aghsfort_mars_spear" then
        local positon = params.unit:GetAbsOrigin()
        local spear_range = params.ability:GetSpecialValueFor("spear_range")
        print(spear_range)
        local targetpos = positon + params.unit:GetForwardVector()*spear_range
        local ability = self:GetAbility()
        params.unit:SetCursorPosition(targetpos)
        ability:OnSpellStart()
		
    end
    

    
       
    

  

    
end