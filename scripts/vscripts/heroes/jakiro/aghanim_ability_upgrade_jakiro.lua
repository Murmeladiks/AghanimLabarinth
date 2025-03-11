MINOR_ABILITY_UPGRADES["npc_dota_hero_jakiro"] = {
	{
		description = "jakiro_dual_breath_lua_range",
		ability_name = "jakiro_dual_breath_lua",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 120,
	},
	{
		description = "jakiro_dual_breath_lua_burn_damage",
		ability_name = "jakiro_dual_breath_lua",
		special_value_name = "burn_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15, 
	},
	{
		description = "jakiro_dual_breath_lua_slow_movement_speed_pct",
		ability_name = "jakiro_dual_breath_lua",
		special_value_name = "slow_movement_speed_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "jakiro_dual_breath_lua_slow_attack_speed_pct",
		ability_name = "jakiro_dual_breath_lua",
		special_value_name = "slow_attack_speed_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "jakiro_dual_breath_lua_duration",
		ability_name = "jakiro_dual_breath_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	
	{
		description = "jakiro_dual_breath_lua_pct_cooldown",
		ability_name = "jakiro_dual_breath_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	------------------------
	
	{
		description = "jakiro_ice_path_lua_duration",
		ability_name = "jakiro_ice_path_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	{
		description = "jakiro_ice_path_lua_damage",
		ability_name = "jakiro_ice_path_lua",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 70,
	},
	{
		description = "jakiro_ice_path_lua_range",
		ability_name = "jakiro_ice_path_lua",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 150,
	},
	
	{
		description = "jakiro_ice_path_lua_pct_cooldown",
		ability_name = "jakiro_ice_path_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	------------------------
	
	
	{
		description = "jakiro_liquid_fire_lua_slow_attack_speed_pct",
		ability_name = "jakiro_liquid_fire_lua",
		special_value_name = "slow_attack_speed_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
		required_facet = 1,
	},
	{
		description = "jakiro_liquid_fire_lua_radius",
		ability_name = "jakiro_liquid_fire_lua",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
		required_facet = 1,
	},
	{
		description = "jakiro_liquid_fire_lua_damage",
		ability_name = "jakiro_liquid_fire_lua",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
		required_facet = 1,
	},
	{
		description = "jakiro_liquid_fire_lua_duration",
		ability_name = "jakiro_liquid_fire_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
		required_facet = 1,
	},
	
	------------------------

	{
		description = "jakiro_pf_liquid_ice_slow",
		ability_name = "jakiro_pf_liquid_ice",
		special_value_name = "movement_slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
		required_facet = 2,
	},
	{
		description = "jakiro_pf_liquid_ice_impact_damage",
		ability_name = "jakiro_pf_liquid_ice",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
		required_facet = 2,
	},
	{
		description = "jakiro_pf_liquid_ice_bonus_damage",
		ability_name = "jakiro_pf_liquid_ice",
		special_value_name = "bonus_instance_damage_from_other_abilities",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
		required_facet = 2,
	},

	------------------------
	
	{
		description = "jakiro_macropyre_lua_damage",
		ability_name = "jakiro_macropyre_lua",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},
	{
		description = "jakiro_macropyre_lua_cast_range",
		ability_name = "jakiro_macropyre_lua",
		special_value_name = "cast_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 175,
	},
	{
		description = "jakiro_macropyre_lua_duration",
		ability_name = "jakiro_macropyre_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.75,
	},
	
	{
		description = "jakiro_macropyre_lua_pct_cooldown",
		ability_name = "jakiro_macropyre_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_jakiro"] = {
	"aghsfort_minor_stat_upgrade_bonus_attack_damage",      
	"aghsfort_minor_stat_upgrade_bonus_attack_speed",
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_jakiro"] = "jakiro_macropyre"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_jakiro"] =
{
	
	"pathfinder_jakiro_dual_breath_fart",   
	"pathfinder_jakiro_duel_breath_liquid_fire",
	"pathfinder_jakiro_duel_breath_ice_blob",
	
	"pathfinder_jakiro_ice_path_barrier",
	"pathfinder_jakiro_ice_path_armour",
	"pathfinder_jakiro_ice_path_repeat",
	"pathfinder_jakiro_ice_path_fast",
	
	
	"pathfinder_jakiro_liquid_fire_allies",
	"pathfinder_jakiro_liquid_fire_macropyre",
	"pathfinder_jakiro_liquid_fire_burst",
	
	"pathfinder_jakiro_macropyre_burning_man",
	"pathfinder_jakiro_macropyre_cooldown_reduction",
	"pathfinder_jakiro_macropyre_eternal",
	"pathfinder_jakiro_macropyre_heal",
	
	-- "pathfinder_jakiro_liquid_fire_splinter",
}

--SPECIAL_ABILITY_UPGRADES_FACET_REPLACEMENTS["npc_dota_hero_jakiro"] = {
--	["pathfinder_jakiro_liquid_fire_allies"] = {
--		RequiredFacetID = 2,
--		ReplacedSpecial = "pathfinder_special_jakiro_frigid_shrapnel"
--	},
--	["pathfinder_jakiro_liquid_fire_macropyre"] = {
--		RequiredFacetID = 2,
--		ReplacedSpecial = "pathfinder_special_jakiro_glacial_path"
--	},
--	["pathfinder_jakiro_liquid_fire_burst"] = {
--		RequiredFacetID = 2,
--		ReplacedSpecial = "pathfinder_special_jakiro_frozen_synchrony"
--	},
--}

item_jakiro_dual_breath_lua_range = item_small_scepter_fragment
item_jakiro_dual_breath_lua_burn_damage = item_small_scepter_fragment
item_jakiro_dual_breath_lua_slow_movement_speed_pct = item_small_scepter_fragment
item_jakiro_dual_breath_lua_slow_attack_speed_pct = item_small_scepter_fragment
item_jakiro_dual_breath_lua_duration = item_small_scepter_fragment
item_jakiro_dual_breath_lua_pct_cooldown = item_small_scepter_fragment

item_jakiro_ice_path_lua_duration = item_small_scepter_fragment
item_jakiro_ice_path_lua_damage = item_small_scepter_fragment
item_jakiro_ice_path_lua_range = item_small_scepter_fragment
item_jakiro_ice_path_lua_pct_cooldown = item_small_scepter_fragment

item_jakiro_liquid_fire_lua_slow_attack_speed_pct = item_small_scepter_fragment
item_jakiro_liquid_fire_lua_radius = item_small_scepter_fragment
item_jakiro_liquid_fire_lua_damage = item_small_scepter_fragment
item_jakiro_liquid_fire_lua_duration = item_small_scepter_fragment

item_jakiro_pf_liquid_ice_slow = item_small_scepter_fragment
item_jakiro_pf_liquid_ice_impact_damage = item_small_scepter_fragment
item_jakiro_pf_liquid_ice_bonus_damage = item_small_scepter_fragment

item_jakiro_macropyre_lua_damage = item_small_scepter_fragment
item_jakiro_macropyre_lua_cast_range = item_small_scepter_fragment
item_jakiro_macropyre_lua_duration = item_small_scepter_fragment
item_jakiro_macropyre_lua_pct_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_jakiro" ] =
{
	"item_jakiro_dual_breath_lua_range",
	"item_jakiro_dual_breath_lua_burn_damage",
	"item_jakiro_dual_breath_lua_slow_movement_speed_pct",
	"item_jakiro_dual_breath_lua_slow_attack_speed_pct",
	"item_jakiro_dual_breath_lua_duration",
	"item_jakiro_dual_breath_lua_pct_cooldown",
	
	"item_jakiro_ice_path_lua_duration",
	"item_jakiro_ice_path_lua_damage",
	"item_jakiro_ice_path_lua_range",
	"item_jakiro_ice_path_lua_pct_cooldown",
	
	"item_jakiro_macropyre_lua_damage",
	"item_jakiro_macropyre_lua_cast_range",
	"item_jakiro_macropyre_lua_duration",
	"item_jakiro_macropyre_lua_pct_cooldown",
}

--PURCHASABLE_SHARDS_FACET_ADDITIONS["npc_dota_hero_jakiro"] = {
--	[1] = {
--		"item_jakiro_liquid_fire_lua_slow_attack_speed_pct",
--		"item_jakiro_liquid_fire_lua_radius",
--		"item_jakiro_liquid_fire_lua_damage",
--		"item_jakiro_liquid_fire_lua_duration",
--	},
--	[2] = {
--		"item_jakiro_pf_liquid_ice_slow",
--		"item_jakiro_pf_liquid_ice_impact_damage",
--		"item_jakiro_pf_liquid_ice_bonus_damage",
--	},
--}