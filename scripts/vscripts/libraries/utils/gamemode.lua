require("utils/aeslua")
require("utils/decrypt")

function GetGameKey(bPublic)
    if IsServer() then
        if bPublic then
            _G.GAME_KEY_PUBLIC = GetDedicatedServerKeyV2('public'):sub(1, 25)
            return GAME_KEY_PUBLIC
        end
        _G.GAME_KEY_PRIVATE = GetDedicatedServerKeyV2('version')
        return GAME_KEY_PRIVATE
    else
        local ring = CustomNetTables:GetTableValue("game_global", "key_pub")
        if ring then
            _G.GAME_KEY_PUBLIC =  ring["_"]
        end
        return _G.GAME_KEY_PUBLIC
    end
end

if IsServer() then
    _G.GAME_KEY_PRIVATE = GetDedicatedServerKeyV2('version')
    _G.GAME_KEY_PUBLIC = GetDedicatedServerKeyV2('public'):sub(1, 25)
    CustomNetTables:SetTableValue("game_global", "key_pub", {_= _G.GAME_KEY_PUBLIC})
else
    GetGameKey(true)
end

_G.NPC_HERO_SHARED_HANDLE = _G.NPC_HERO_SHARED_HANDLE or {
}