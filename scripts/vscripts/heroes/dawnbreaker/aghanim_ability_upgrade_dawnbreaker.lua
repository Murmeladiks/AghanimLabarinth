MINOR_ABILITY_UPGRADES["npc_dota_hero_dawnbreaker"] = {
	{
		description = "dawnbreaker_starbreaker_lua_swipe_damage",
		ability_name = "dawnbreaker_starbreaker_lua",
		special_value_name = "swipe_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
   },
   {
		description = "dawnbreaker_starbreaker_lua_smash_damage",
		ability_name = "dawnbreaker_starbreaker_lua",
		special_value_name = "smash_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 60,
   },
   {
		description = "dawnbreaker_starbreaker_lua_smash_radius",
		ability_name = "dawnbreaker_starbreaker_lua",
		special_value_name = "smash_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 65,
   },
   {
		description = "dawnbreaker_starbreaker_lua_smash_stun_duration",
		ability_name = "dawnbreaker_starbreaker_lua",
		special_value_name = "smash_stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.7,
   },
   {
		description = "dawnbreaker_starbreaker_lua_smash_pct_cooldown",
		ability_name = "dawnbreaker_starbreaker_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
   },




   {
		description = "dawnbreaker_celestial_hammer_lua_hammer_damage",
		ability_name = "dawnbreaker_celestial_hammer_lua",
		special_value_name = "hammer_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 35,
   },
   {
		description = "dawnbreaker_celestial_hammer_lua_flare_burn_damage",
		ability_name = "dawnbreaker_celestial_hammer_lua",
		special_value_name = "burn_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
   },
   {
		description = "dawnbreaker_celestial_hammer_lua_range",
		ability_name = "dawnbreaker_celestial_hammer_lua",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 200,
   },
   {
		description = "dawnbreaker_celestial_hammer_lua_flare_debuff_duration",
		ability_name = "dawnbreaker_celestial_hammer_lua",
		special_value_name = "flare_debuff_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
   },
   {
		description = "dawnbreaker_celestial_hammer_lua_pct_cooldown",
		ability_name = "dawnbreaker_celestial_hammer_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
   },




   {
		description = "dawnbreaker_luminosity_lua_heal_pct",
		ability_name = "dawnbreaker_luminosity_lua",
		special_value_name = "heal_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
   },
   {
		description = "dawnbreaker_luminosity_lua_bonus_damage",
		ability_name = "dawnbreaker_luminosity_lua",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
   },
   {
		description = "dawnbreaker_luminosity_lua_heal_radius",
		ability_name = "dawnbreaker_luminosity_lua",
		special_value_name = "heal_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 175,
   },




   {
		description = "dawnbreaker_solar_guardian_lua_airtime_duration",
		ability_name = "dawnbreaker_solar_guardian_lua",
		special_value_name = "airtime_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
   },
   {
		description = "dawnbreaker_solar_guardian_lua_radius",
		ability_name = "dawnbreaker_solar_guardian_lua",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 85,
   },
   {
		description = "dawnbreaker_solar_guardian_lua_base_damage",
		ability_name = "dawnbreaker_solar_guardian_lua",
		special_value_name = "base_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
   },
   {
		description = "dawnbreaker_solar_guardian_lua_base_heal",
		ability_name = "dawnbreaker_solar_guardian_lua",
		special_value_name = "base_heal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
   },
   {
		description = "dawnbreaker_solar_guardian_lua_land_stun_duration",
		ability_name = "dawnbreaker_solar_guardian_lua",
		special_value_name = "land_stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.2,
   },
   {
		description = "dawnbreaker_solar_guardian_lua_pct_cooldown",
		ability_name = "dawnbreaker_solar_guardian_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
   },
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_dawnbreaker"] = {
	"aghsfort_minor_stat_upgrade_bonus_evasion"
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_dawnbreaker"] = "dawnbreaker_solar_guardian"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_dawnbreaker"] =
{
	"dawnbreaker_starbreaker_lua_solar_pulse",
	"dawnbreaker_starbreaker_lua_max_luminosity",
	"dawnbreaker_starbreaker_lua_smash_sleep",

	"dawnbreaker_celestial_hammer_lua_skewer",
	"dawnbreaker_celestial_hammer_lua_illusion",
	"dawnbreaker_celestial_hammer_lua_trail_heal",

	"dawnbreaker_luminosity_lua_charge",
	"dawnbreaker_luminosity_lua_stacking",
	"dawnbreaker_luminosity_lua_explosion",

	"dawnbreaker_solar_guardian_lua_charges",
	"dawnbreaker_solar_guardian_lua_permanent_dummy",
	"dawnbreaker_solar_guardian_lua_capture",
}


item_dawnbreaker_starbreaker_lua_swipe_damage = item_small_scepter_fragment
item_dawnbreaker_starbreaker_lua_smash_damage = item_small_scepter_fragment
item_dawnbreaker_starbreaker_lua_smash_radius = item_small_scepter_fragment
item_dawnbreaker_starbreaker_lua_smash_stun_duration = item_small_scepter_fragment
item_dawnbreaker_starbreaker_lua_smash_pct_cooldown = item_small_scepter_fragment
item_dawnbreaker_celestial_hammer_lua_hammer_damage = item_small_scepter_fragment
item_dawnbreaker_celestial_hammer_lua_flare_burn_damage = item_small_scepter_fragment
item_dawnbreaker_celestial_hammer_lua_range = item_small_scepter_fragment
item_dawnbreaker_celestial_hammer_lua_flare_debuff_duration = item_small_scepter_fragment
item_dawnbreaker_celestial_hammer_lua_pct_cooldown = item_small_scepter_fragment
item_dawnbreaker_luminosity_lua_heal_pct = item_small_scepter_fragment
item_dawnbreaker_luminosity_lua_bonus_damage = item_small_scepter_fragment
item_dawnbreaker_luminosity_lua_heal_radius = item_small_scepter_fragment
item_dawnbreaker_solar_guardian_lua_airtime_duration = item_small_scepter_fragment
item_dawnbreaker_solar_guardian_lua_radius = item_small_scepter_fragment
item_dawnbreaker_solar_guardian_lua_base_damage = item_small_scepter_fragment
item_dawnbreaker_solar_guardian_lua_base_heal = item_small_scepter_fragment
item_dawnbreaker_solar_guardian_lua_land_stun_duration = item_small_scepter_fragment
item_dawnbreaker_solar_guardian_lua_pct_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_dawnbreaker" ] =
{
	"item_dawnbreaker_starbreaker_lua_swipe_damage",
	"item_dawnbreaker_starbreaker_lua_smash_damage",
	"item_dawnbreaker_starbreaker_lua_smash_radius",
	"item_dawnbreaker_starbreaker_lua_smash_stun_duration",
	"item_dawnbreaker_starbreaker_lua_smash_pct_cooldown",
 
	"item_dawnbreaker_celestial_hammer_lua_hammer_damage",
	"item_dawnbreaker_celestial_hammer_lua_flare_burn_damage",
	"item_dawnbreaker_celestial_hammer_lua_range",
	"item_dawnbreaker_celestial_hammer_lua_flare_debuff_duration",
	"item_dawnbreaker_celestial_hammer_lua_pct_cooldown",
 
	"item_dawnbreaker_luminosity_lua_heal_pct",
	"item_dawnbreaker_luminosity_lua_bonus_damage",
	"item_dawnbreaker_luminosity_lua_heal_radius",
 
	"item_dawnbreaker_solar_guardian_lua_airtime_duration",
	"item_dawnbreaker_solar_guardian_lua_radius",
	"item_dawnbreaker_solar_guardian_lua_base_damage",
	"item_dawnbreaker_solar_guardian_lua_base_heal",
	"item_dawnbreaker_solar_guardian_lua_land_stun_duration",
	"item_dawnbreaker_solar_guardian_lua_pct_cooldown",
}