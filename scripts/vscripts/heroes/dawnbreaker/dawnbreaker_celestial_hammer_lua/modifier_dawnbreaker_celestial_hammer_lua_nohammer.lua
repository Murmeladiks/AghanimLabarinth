-- Created by Elfansoer
modifier_dawnbreaker_celestial_hammer_lua_nohammer = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dawnbreaker_celestial_hammer_lua_nohammer:IsHidden() 		return true end
function modifier_dawnbreaker_celestial_hammer_lua_nohammer:IsPurgable() 	return false end
function modifier_dawnbreaker_celestial_hammer_lua_nohammer:GetActivityTranslationModifiers() return "no_hammer" end

function modifier_dawnbreaker_celestial_hammer_lua_nohammer:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_dawnbreaker_celestial_hammer_lua_nohammer:OnDeath(kv)
	if not IsServer() then return end
	if kv.attacker == self:GetParent() and kv.inflictor == nil then
		local punch_voiceline = {
			"dawnbreaker_valora_punch_01",
			"dawnbreaker_valora_punch_02",
			"dawnbreaker_valora_punch_05",
			"dawnbreaker_valora_punch_06",
			"dawnbreaker_valora_punch_07",
			"dawnbreaker_valora_punch_kill_01",
			"dawnbreaker_valora_punch_kill_02",
			"dawnbreaker_valora_punch_kill_03",
			"dawnbreaker_valora_punch_kill_04",
			"dawnbreaker_valora_punch_kill_05",
			"dawnbreaker_valora_punch_kill_06",
			
		}
		self:GetParent():EmitSound(punch_voiceline[RandomInt(1, #punch_voiceline)])
	end
end

function modifier_dawnbreaker_celestial_hammer_lua_nohammer:OnCreated( kv )
	if not IsServer() then return end
	self:IncrementStackCount()

	local hammer = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
	if hammer ~= nil then
		hammer:AddEffects( EF_NODRAW )
	end
end

function modifier_dawnbreaker_celestial_hammer_lua_nohammer:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_dawnbreaker_celestial_hammer_lua_nohammer:OnDestroy()
	if not IsServer() then return end
	local hammer = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
	if hammer ~= nil then
		hammer:RemoveEffects( EF_NODRAW )
	end
end

--------------------------------------------------------------------------------
-- Other
function modifier_dawnbreaker_celestial_hammer_lua_nohammer:Decrement()
	self:DecrementStackCount()
	if self:GetStackCount()<1 then
		self:Destroy()
	end
end
