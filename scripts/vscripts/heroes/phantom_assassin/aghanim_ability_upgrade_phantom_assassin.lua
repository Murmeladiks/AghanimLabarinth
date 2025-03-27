MINOR_ABILITY_UPGRADES["npc_dota_hero_phantom_assassin"] = {
	{
		description = "phantom_assassin_stifling_dagger_lua_base_damage",
		ability_name = "phantom_assassin_stifling_dagger_lua",
		special_value_name = "base_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 60,
	},
	{
		description = "phantom_assassin_stifling_dagger_lua_attack_factor",
		ability_name = "phantom_assassin_stifling_dagger_lua",
		special_value_name = "attack_factor",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},
	
	{
		description = "phantom_assassin_stifling_dagger_lua_duration",
		ability_name = "phantom_assassin_stifling_dagger_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
	
	{
		description = "phantom_assassin_coup_de_grace_lua_crit_chance",
		ability_name = "phantom_assassin_coup_de_grace_lua",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		special_values =
		{
			{
				special_value_name = "crit_chance",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 3,
			},
			{
				special_value_name = "dagger_crit_chance",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 3,
			},
		},
		required_facet = 3
	},
	
	{
		description = "phantom_assassin_coup_de_grace_lua_crit_bonus",
		ability_name = "phantom_assassin_coup_de_grace_lua",
		special_value_name = "crit_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
		facet_changes = {
			facet_id = 2,
			value_mult = 1.25
		}
	},
	
	{
		description = "phantom_assassin_phantom_strike_lua_bonus_attack_speed",
		ability_name = "phantom_assassin_phantom_strike_lua",
		special_value_name = "bonus_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30
	},
	
	{
		description = "phantom_assassin_phantom_strike_lua_duration",
		ability_name = "phantom_assassin_phantom_strike_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	
	{
		description = "phantom_assassin_phantom_strike_lua_range",
		ability_name = "phantom_assassin_phantom_strike_lua",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 200,
	},
	
	{
		description = "phantom_assassin_blur_lua_bonus_evasion",
		ability_name = "phantom_assassin_blur_lua",
		special_value_name = "bonus_evasion",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	
	{
		description = "phantom_assassin_blur_lua_cooldown",
		ability_name = "phantom_assassin_blur_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	
	{
		description = "phantom_assassin_blur_lua_duration",
		ability_name = "phantom_assassin_blur_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 8,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_phantom_assassin"] = {
	"aghsfort_minor_stat_upgrade_bonus_evasion",
	"aghsfort_minor_stat_upgrade_bonus_spell_amp"
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_phantom_assassin"] = "phantom_assassin_coup_de_grace"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_phantom_assassin"] =
{
	"pathfinder_special_pa_dagger_bouncing",
	"phantom_assassin_dagger_global_dummy",
	"pathfinder_special_pa_blink_illusion",
	"pathfinder_special_pa_blink_aoe",
	"pathfinder_special_pa_blur_cdr",
	"pathfinder_special_pa_blur_block",
	"pathfinder_special_pa_blur_aoe",
	"pathfinder_special_pa_blur_regen",
	"pathfinder_special_pa_crit_lifesteal",
	"pathfinder_special_pa_crit_fear",
	"pathfinder_special_pa_crit_dagger",
	
	--"pathfinder_special_pa_dagger_freeze",
}

item_phantom_assassin_stifling_dagger_lua_attack_factor = item_small_scepter_fragment
item_phantom_assassin_stifling_dagger_lua_duration = item_small_scepter_fragment
item_phantom_assassin_stifling_dagger_lua_base_damage = item_small_scepter_fragment

item_phantom_assassin_coup_de_grace_lua_crit_chance = item_small_scepter_fragment
item_phantom_assassin_coup_de_grace_lua_crit_bonus = item_small_scepter_fragment

item_phantom_assassin_phantom_strike_lua_bonus_attack_speed = item_small_scepter_fragment
item_phantom_assassin_phantom_strike_lua_duration = item_small_scepter_fragment
item_phantom_assassin_phantom_strike_lua_range = item_small_scepter_fragment

item_phantom_assassin_blur_lua_bonus_evasion = item_small_scepter_fragment
item_phantom_assassin_blur_lua_duration = item_small_scepter_fragment
item_phantom_assassin_blur_lua_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_phantom_assassin" ] =
{
	"item_phantom_assassin_stifling_dagger_lua_attack_factor",
	"item_phantom_assassin_stifling_dagger_lua_duration",
	"item_phantom_assassin_stifling_dagger_lua_base_damage",
	
	"item_phantom_assassin_coup_de_grace_lua_crit_chance",
	"item_phantom_assassin_coup_de_grace_lua_crit_bonus",
	
	"item_phantom_assassin_phantom_strike_lua_bonus_attack_speed",
	"item_phantom_assassin_phantom_strike_lua_duration",
	"item_phantom_assassin_phantom_strike_lua_range",
	
	"item_phantom_assassin_blur_lua_bonus_evasion",   
	"item_phantom_assassin_blur_lua_duration",
	"item_phantom_assassin_blur_lua_cooldown",
}