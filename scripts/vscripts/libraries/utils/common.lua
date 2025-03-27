function IsValidNPC(npc)
    return npc ~= nil and not npc:IsNull()
end

function IsValid(cobject)
    return cobject ~= nil and not cobject:IsNull()
end

function IsImmortalHero(hHero)
    return hHero.bImmortal or false
end

function SetImmortalHero(hHero, bImmortal)
    hHero.bImmortal = bImmortal
end

function IsReincarnating(hHero)
    return hHero._bReincarnating or false
end

function SetReincarnating(hHero, bReincarnating)
    hHero._bReincarnating = bReincarnating
end

function IsEnemy(unit1, unit2)
	if unit1:GetTeamNumber() == unit2:GetTeamNumber() then
		return false
	else
		return true
	end
end

function DirectionVector(fpos,spos)
    local DIR=( fpos - spos)
    DIR.z=0
    return DIR:Normalized()
end
function DirectionAngles(fpos,spos)
    return VectorAngles(DirectionVector(fpos,spos))
end

function VectorDistance2D(fpos,spos)
    return ( fpos - spos):Length2D()
end
function IsAghanimConsideredHero(hNPC)
	return hNPC:IsConsideredHero() or hNPC:IsBossCreature() or hNPC:IsCreepHero() or hNPC:IsHero()
end
-- 	return UnitFilter(hNPC, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, hNPC:GetTeamNumber())
function IsAghanimConsideredCreature(hNPC)
	if not IsValid(hNPC) then
		return false
	end
   return (hNPC:IsCreature() or hNPC:GetUnitName():find("npc_dota_warlock_golem")) and hNPC:GetTeamNumber() == DOTA_TEAM_BADGUYS
end
function CannotCastAscensionAbility(hNPC)
	if IsServer() then
		return hNPC:HasModifier("modifier_aghs2_warlock_word_ascension") or hNPC:HasModifier("modifier_nyx_assassin_vendetta")
	end
	return true
end
function IsIgnoredIllusion(hNPC)
	return hNPC:IsIllusion() and not hNPC:IsTempestDouble()
end

function IsAbsoluteResist(hNPC)
	return hNPC.bAbsoluteNoCC ~= nil and hNPC.bAbsoluteNoCC == true
end

function PopupNumbers(hTarget, pfx, color, lifetime, number, presymbol, postsymbol)
	--[[
	POPUP_SYMBOL_PRE_PLUS = 0
	POPUP_SYMBOL_PRE_MINUS = 1
	POPUP_SYMBOL_PRE_SADFACE = 2
	POPUP_SYMBOL_PRE_BROKENARROW = 3
	POPUP_SYMBOL_PRE_SHADES = 4
	POPUP_SYMBOL_PRE_MISS = 5
	POPUP_SYMBOL_PRE_EVADE = 6
	POPUP_SYMBOL_PRE_DENY = 7
	POPUP_SYMBOL_PRE_ARROW = 8

	POPUP_SYMBOL_POST_EXCLAMATION = 0
	POPUP_SYMBOL_POST_POINTZERO = 1
	POPUP_SYMBOL_POST_MEDAL = 2
	POPUP_SYMBOL_POST_DROP = 3
	POPUP_SYMBOL_POST_LIGHTNING = 4
	POPUP_SYMBOL_POST_SKULL = 5
	POPUP_SYMBOL_POST_EYE = 6
	POPUP_SYMBOL_POST_SHIELD = 7
	POPUP_SYMBOL_POST_POINTFIVE = 8
	]]
	local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
	local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN, hTarget) -- target:GetOwner()

	local digits = 0
	if number ~= nil then
		digits = #tostring(number)
	end
	if presymbol ~= nil then
		digits = digits + 1
	end
	if postsymbol ~= nil then
		digits = digits + 1
	end
	local a = postsymbol or 0
	ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), a))
	ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
	ParticleManager:SetParticleControl(pidx, 3, color)
	ParticleManager:ReleaseParticleIndex(pidx)
end

function RandomCVString(prefix, iMax)
	local int = RandomInt(1, iMax)
	if int > 9 then
		return prefix.."_"..int
	else
		return prefix.."_0"..int
	end
end

function Num2Bool(num)
	if num and num ~= 0 then
		return true
	end
	return false
end

-- function GetTypeParamsFromBoolSet(bHero, bCreep, bBuilding)
-- end

Modlist = Modlist or class({})

function Modlist:constructor()
    self._list = {}
    self._count = 0
end
function Modlist:Index(i)
	return self._list[i]
end
function Modlist:Length()
	return self._count
end
function Modlist:Append(mod)
	if IsValid(mod) then
		self._count = self._count + 1
		self._list[self._count] = mod
		-- print(mod:GetName())
	end
	return self._count
end
function Modlist:RemoveAll()
	for i = 1, self._count, 1 do
		if IsValid(self._list[i]) then
			self._list[i]:Destroy()
		end
	end
	self._count = 0
end
function Modlist:IsAnyValid()
	-- print(self._count)
	for i = 1, self._count, 1 do
		if IsValid(self._list[i])  then
			-- print(self._list[i]:GetName())
			return true
		end
	end
	return false
end
