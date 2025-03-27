mars_bulwark_bastion = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_mars_bulwark_bastion", "heroes/mars/mars_bulwark_bastion", LUA_MODIFIER_MOTION_NONE )


function mars_bulwark_bastion:GetIntrinsicModifierName()
	return "modifier_mars_bulwark_bastion"
end

modifier_mars_bulwark_bastion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_bulwark_bastion:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	
end

function modifier_mars_bulwark_bastion:IsHidden()
	return true
end

function modifier_mars_bulwark_bastion:IsPurgeException()
	return false
end

function modifier_mars_bulwark_bastion:IsPurgable()
	return false
end

function modifier_mars_bulwark_bastion:IsPermanent()
	return true
end




function modifier_mars_bulwark_bastion:OnCreated(kv)
    if IsServer() then


        self:StartIntervalThink(16)
    end
end
function modifier_mars_bulwark_bastion:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
       
    }
end
function modifier_mars_bulwark_bastion:OnIntervalThink()
   
    if not self.bastion then
        self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 50, 50, 50 ) )
        ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )
    end
    self.bastion = true
end
function modifier_mars_bulwark_bastion:OnModifierAdded(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
   if not self.bastion then  return 0 end
   
    if params.added_buff:GetName() == "modifier_mars_bulwark_active" then
        self.aghsfort_mars_spear = self:GetCaster():FindAbilityByName("aghsfort_mars_spear")
       
        if self.aghsfort_mars_spear:GetLevel()>0 then
            for i = 1, 6, 1 do
                Timers:CreateTimer(i*0.1, function()
                    if(self and not self:IsNull()) then
                        local positon = self:GetCaster():GetAbsOrigin()
                        local direction = self:GetCaster():GetForwardVector()
                        local targetpos = positon + direction*50
                        self:GetCaster():SetCursorPosition(targetpos)
                        self.aghsfort_mars_spear:OnSpellStart()
                    end
                end)
            end
            ParticleManager:DestroyParticle( self.nPreviewFX, false )  
            
            self.bastion = false
            
           
        end
    
    end
 
end













--------------------------------------------------------------------------------

