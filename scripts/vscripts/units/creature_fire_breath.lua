creature_fire_breath = class({})

--------------------------------------------------------------------------------

function creature_fire_breath:Precache( context )
	PrecacheResource("particle", "particles/neutral_fx/mini_rosh_fire.vpcf", context)
end

--------------------------------------------------------------------------------

function creature_fire_breath:OnSpellStart()
	self.rotation_angle = self:GetSpecialValueFor( "rotation_angle" )
	self.radius = self:GetSpecialValueFor( "radius" )
	self.speed = self:GetSpecialValueFor( "speed" )
	self.damage = self:GetSpecialValueFor( "damage" )
	self.projectile_count = self:GetSpecialValueFor( "projectile_count" )
	
	self.fChannelStartTime = GameRules:GetGameTime()
	
	self.vRightVector = self:GetCaster():GetRightVector()
	
	EmitSoundOn("Creature.FireBreath.Cast", self:GetCaster())
end

--------------------------------------------------------------------------------

function creature_fire_breath:OnChannelThink( fInterval )
	local fClampedVal = Script_RemapValClamped(GameRules:GetGameTime(), self.fChannelStartTime, self.fChannelStartTime + self:GetChannelTime(), 0.0, 1.0)
	
	local angle_offset = (fClampedVal * self.rotation_angle) - (self.rotation_angle / 2)
	local vForward = self:GetCaster():GetForwardVector()

	local rotated_dir = RotatePosition(Vector(0,0,0), QAngle(0, angle_offset, 0), vForward)

	local vVel = rotated_dir * self.speed
	
	local info = {
		EffectName = "particles/neutral_fx/mini_rosh_fire.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = self.radius,
		fEndRadius = self.radius,
		vVelocity = vVel,
		fDistance = self:GetCastRange(self:GetCaster():GetOrigin(), nil),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + self:GetCastRange(self:GetCaster():GetOrigin(), nil) / self.speed
	}
	
	ProjectileManager:CreateLinearProjectile(info)
end

--------------------------------------------------------------------------------

function creature_fire_breath:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget and hTarget:IsInvulnerable() == false then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self
			}
			ApplyDamage( damage )
		end
	end
	
	return false
end

--------------------------------------------------------------------------------


--[[
//-----------------------------------------------------------------------------
// Ability: Fire Breath
//-----------------------------------------------------------------------------
#ifdef CLIENT_DLL
#define CDOTA_Ability_Creature_Fire_Breath C_DOTA_Ability_Creature_Fire_Breath
#endif
schema class CDOTA_Ability_Creature_Fire_Breath : public CDOTABaseAbility
{
DECLARE_ENTITY_CLASS( CDOTA_Ability_Creature_Fire_Breath, CDOTABaseAbility, "creature_fire_breath" );
public:

void OnSpellStart( void ) OVERRIDE;

bool OnProjectileHit( EHANDLE hTarget, const Vector &vLocation ) OVERRIDE;

#ifdef SERVER_DLL
virtual void OnChannelThink( float flInterfClampedVal ) OVERRIDE;
#endif

public:

int speed;
int projectile_count;
float rotation_angle;
float damage;
float radius;
CountdownTimer ctTimer;
Vector m_vecStartRot;
Vector m_vecEndRot;
};


LINK_ENTITY_TO_CLASS( creature_fire_breath, CDOTA_Ability_Creature_Fire_Breath );


//-----------------------------------------------------------------------------

void CDOTA_Ability_Creature_Fire_Breath::OnSpellStart( void )
{
#ifdef SERVER_DLL
DOTA_ABILITY_RETRIEVE_VALUE( rotation_angle );
DOTA_ABILITY_RETRIEVE_VALUE( radius );
DOTA_ABILITY_RETRIEVE_VALUE( speed );
DOTA_ABILITY_RETRIEVE_VALUE( damage );
DOTA_ABILITY_RETRIEVE_VALUE( projectile_count );

QAngle angles = GetCaster()->GetAbsAngles();
Vector vecFwd;
AngleVectors( angles, &vecFwd );
matrix3x4_t matRot;
Vector vecRotAxis = Vector ( 0, 0, 1 );
MatrixBuildRotationAboutAxis ( vecRotAxis, -rotation_angle/2, matRot );
VectorRotate( vecFwd, matRot, m_vecStartRot );
MatrixBuildRotationAboutAxis ( vecRotAxis, rotation_angle/2, matRot );
VectorRotate( vecFwd, matRot, m_vecEndRot );

float flTiming = GetChannelTime() / float( projectile_count );
ctTimer.Start( flTiming );

DOTA_EmitSound( DOTA_EMIT_SOUND_FLAGS_NEARBY | DOTA_EMIT_SOUND_FLAGS_VISIBLE, "Creature.FireBreath.Cast", GetCaster() );
#endif
}

//-----------------------------------------------------------------------------
#ifdef SERVER_DLL
void CDOTA_Ability_Creature_Fire_Breath::OnChannelThink( float flInterfClampedVal )
{
BaseClass::OnChannelThink( flInterfClampedVal );
if ( !ctTimer.IsElapsed() )
return;

ctTimer.Reset();

Vector vDirection = VectorLerp( m_vecStartRot, m_vecEndRot, RemapValClamped( GetGameTime(), GetChannelStartTime(),  GetChannelStartTime() + GetChannelTime(), 0.0f, 1.0f  ));

VectorNormalize( vDirection );

sLinearProjectileCreateInfo info;
info.pszEffectName = "particles/neutral_fx/mini_rosh_fire.vpcf";
info.bStickyFoWReveal = true;
info.pAbility = this;
info.vVelocity = vDirection * speed;
info.vSpawnOrigin = GetCaster()->GetAbsOrigin();
info.fDistance = GetCastRange();
info.fStartRadius = radius;
info.fEndRadius = radius;
info.hSource = GetCaster();
info.iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY;
info.iUnitTargetType = DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC;
info.iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES;
info.iVisionTeamNumber = GetCaster()->GetTeamNumber();

g_DOTAProjectileManager.CreateLinearProjectile( info );

}
#endif


//-----------------------------------------------------------------------------

bool CDOTA_Ability_Creature_Fire_Breath::OnProjectileHit( EHANDLE hTarget, const Vector &vLocation )
{
#ifdef SERVER_DLL
CDOTA_BaseNPC *pTarget = ToDOTABaseNPC( hTarget );
if ( pTarget && !pTarget->IsInvulnerable() && !pTarget->IsAncient() )
{
ApplyDamage( GetCaster(), pTarget, this, damage, DAMAGE_TYPE_MAGICAL );
}
#endif

return false;
}
]]
