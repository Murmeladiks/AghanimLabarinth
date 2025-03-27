MINOR_ABILITY_UPGRADES["npc_dota_hero_windrunner"] = {
	{
		description = "windranger_shackleshot_lua_stun_duration",
		ability_name = "windranger_shackleshot_lua",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.7,
	},
	
	{
		description = "windranger_shackleshot_lua_shackle_distance",
		ability_name = "windranger_shackleshot_lua",
		special_value_name = "shackle_distance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	{
		description = "windranger_shackleshot_lua_shackle_angle",
		ability_name = "windranger_shackleshot_lua",
		special_value_name = "shackle_angle",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},
	{
		description = "windranger_shackleshot_lua_shackle_shackle_count",
		ability_name = "windranger_shackleshot_lua",
		special_value_name = "shackle_count",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "windranger_shackleshot_lua_cooldown",
		ability_name = "windranger_shackleshot_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	{
		description = "windranger_powershot_lua_powershot_damage",
		ability_name = "windranger_powershot_lua",
		special_value_name = "powershot_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 70,
	},

	{
		description = "windranger_powershot_lua_cooldown",
		ability_name = "windranger_powershot_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	{
		description = "windranger_powershot_lua_slow",
		ability_name = "windranger_powershot_lua",
		special_value_name = "slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 8,
	},

	{
		description = "windranger_powershot_lua_arrow_range",
		ability_name = "windranger_powershot_lua",
		special_value_name = "arrow_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 200,
	},
	
	{
		description = "windranger_windrun_lua_duration",
		ability_name = "windranger_windrun_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	
	{
		description = "windranger_windrun_lua_movespeed_bonus_pct",
		ability_name = "windranger_windrun_lua",
		special_value_name = "movespeed_bonus_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 5,
	},	

	{
		description = "windranger_focus_fire_lua_bonus_attack_speed",
		ability_name = "windranger_focus_fire_lua",
		special_value_name = "bonus_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	{
		description = "windranger_focus_fire_lua_cooldown",
		ability_name = "windranger_focus_fire_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}

--[[MINOR_ABILITY_UPGRADES_FACET_REPLACEMENTS["npc_dota_hero_windrunner"] = {
	["windranger_focus_fire_lua_bonus_attack_speed"] = {
		RequiredFacetID = 3,
		ReplacedMinor = {
			description = "windranger_focus_fire_lua_attacks_per_second",
			ability_name = "windranger_focus_fire_lua",
			special_value_name = "attacks_per_second",
			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
			value = 1,
			ability_image = "windrunner_whirlwind"
		}
	}
}]]

STAT_UPGRADE_EXCLUDES["npc_dota_hero_windrunner"] = {"aghsfort_minor_stat_upgrade_bonus_evasion"}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_windrunner"] = "windrunner_focusfire"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_windrunner"] =
{
	"pathfinder_special_windranger_shackleshot_aoe",
	"pathfinder_special_windranger_shackleshot_sleep",
	"pathfinder_special_windranger_shackleshot_armor",
	
	"pathfinder_special_windranger_powershot_multishot",
	"pathfinder_special_windranger_powershot_attacks",
	"pathfinder_special_windranger_powershot_repeating",
	
	"pathfinder_special_windranger_windrun_aoe", 
	"pathfinder_special_windranger_windrun_cyclone",
	"pathfinder_special_windranger_windrun_invis",
	
	"pathfinder_special_windranger_focusfire_trueshot",
	"pathfinder_special_windranger_focusfire_global",
	"pathfinder_special_windranger_focusfire_lifesteal",
	
	--"pathfinder_special_windranger_powershot_ricochet",	
}

--[[SPECIAL_ABILITY_UPGRADES_FACET_REPLACEMENTS["npc_dota_hero_windrunner"] = {
	["pathfinder_special_windranger_focusfire_trueshot"] = {
		RequiredFacetID = 3,
		ReplacedSpecial = "pathfinder_special_windranger_whirlwind_trueshot"
	},
	["pathfinder_special_windranger_focusfire_global"] = {
		RequiredFacetID = 3,
		ReplacedSpecial = "pathfinder_special_windranger_whirlwind_global"
	},
	["pathfinder_special_windranger_focusfire_lifesteal"] = {
		RequiredFacetID = 3,
		ReplacedSpecial = "pathfinder_special_windranger_whirlwind_lifesteal"
	},
}]]

item_windranger_shackleshot_lua_stun_duration = item_small_scepter_fragment
item_windranger_shackleshot_lua_shackle_distance = item_small_scepter_fragment
item_windranger_shackleshot_lua_shackle_angle = item_small_scepter_fragment

item_windranger_windrun_lua_duration = item_small_scepter_fragment
item_windranger_windrun_lua_movespeed_bonus_pct = item_small_scepter_fragment

item_windranger_powershot_lua_powershot_damage = item_small_scepter_fragment

item_windranger_focus_fire_lua_bonus_attack_speed = item_small_scepter_fragment
--item_windranger_focus_fire_lua_attacks_per_second = item_small_scepter_fragment
item_windranger_focus_fire_lua_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_windrunner" ] =
{
	"item_windranger_shackleshot_lua_stun_duration",
	"item_windranger_shackleshot_lua_shackle_distance",
	"item_windranger_shackleshot_lua_shackle_angle",
	"item_windranger_windrun_lua_duration",
	"item_windranger_windrun_lua_movespeed_bonus_pct",
	"item_windranger_powershot_lua_powershot_damage",
	"item_windranger_focus_fire_lua_cooldown",
	"item_windranger_focus_fire_lua_bonus_attack_speed",
}


--[[PURCHASABLE_SHARDS_FACET_ADDITIONS["npc_dota_hero_windrunner"] = {
	[2] = {
		"item_windranger_focus_fire_lua_bonus_attack_speed",
	},
	[3] = {
		"item_windranger_focus_fire_lua_attacks_per_second",
	},
}]]