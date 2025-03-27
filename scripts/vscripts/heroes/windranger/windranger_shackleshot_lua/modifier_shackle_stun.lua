LinkLuaModifier( "modifier_universal_sleep", "heroes/dawnbreaker/dawnbreaker_starbreaker_lua/modifier_dawnbreaker_starbreaker_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

modifier_shackle_stun = class({})

--------------------------------------------------------------------------------

function modifier_shackle_stun:IsDebuff() 	return true end
function modifier_shackle_stun:IsPurgable() return true end

--------------------------------------------------------------------------------

function modifier_shackle_stun:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

--------------------------------------------------------------------------------

function modifier_shackle_stun:OnCreated(table)
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_DISABLED)
	end
	self:StartIntervalThink(0.2)
end

--------------------------------------------------------------------------------

function modifier_shackle_stun:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
		if self:GetAbility():GetCaster():HasAbility("pathfinder_special_windranger_shackleshot_sleep") then
			local sleep_duration = self:GetAbility():GetCaster():FindAbilityByName("pathfinder_special_windranger_shackleshot_sleep"):GetLevelSpecialValueFor("duration", 1)
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_universal_sleep", {duration = sleep_duration})
		end
	end
end

--------------------------------------------------------------------------------

function modifier_shackle_stun:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_shackle_stun:OnAttacked( params )
	if not IsServer() then return end
	
	if self:GetAbility():GetCaster():HasAbility("pathfinder_special_windranger_shackleshot_armor") and params.attacker ~= nil and params.attacker == self:GetAbility():GetCaster() and params.target ~= self:GetParent() and not params.no_attack_cooldown then
		params.attacker:PerformAttack(self:GetParent(), false, true, true, true, true, false, false)
	end		
end

--------------------------------------------------------------------------------


function modifier_shackle_stun:OnIntervalThink()
	if IsServer() and self:GetParent():IsStunned() == false then
		self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
	end
end