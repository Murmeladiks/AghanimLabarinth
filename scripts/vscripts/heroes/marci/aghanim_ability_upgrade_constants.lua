MINOR_ABILITY_UPGRADES["npc_dota_hero_marci"] = {
	{
		description = "marci_grapple_pf_stun",
		ability_name = "marci_grapple_pf",
		special_value_name = "debuff_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.75,
	},
	{
		description = "marci_grapple_pf_damage",
		ability_name = "marci_grapple_pf",
		special_value_name = "impact_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 95,
	},
	{
		description = "marci_grapple_pf_radius",
		ability_name = "marci_grapple_pf",
		special_value_name = "landing_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 90,
	},
	{
		description = "marci_grapple_pf_cooldown",
		ability_name = "marci_grapple_pf",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},
	
	{
		description = "marci_companion_run_pf_damage",
		ability_name = "marci_companion_run_pf",
		special_value_name = "impact_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 90,
	},
	{
		description = "marci_companion_run_pf_jump",
		ability_name = "marci_companion_run_pf",
		special_value_name = "max_jump_distance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 150,
	},
	{
		description = "marci_companion_run_pf_debuff_duration",
		ability_name = "marci_companion_run_pf",
		special_value_name = "debuff_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.4,
	},
	{
		description = "marci_companion_run_pf_cooldown",
		ability_name = "marci_companion_run_pf",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},
	
	--[[
	{
		description = "marci_guardian_pf_lifesteal",
		ability_name = "marci_pf_guardian",
		special_value_name = "lifesteal_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2.5,
		required_facet = 1,
	},
	{
		description = "marci_guardian_pf_damage",
		ability_name = "marci_pf_guardian",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
		required_facet = 1,
	},
	{
		description = "marci_guardian_pf_cooldown",
		ability_name = "marci_pf_guardian",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
		required_facet = 1,
	},

	]]
	
	{
		description = "marci_bodyguard_duration",
		ability_name = "marci_pf_bodyguard",
		special_value_name = "bodyguard_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
		required_facet = 2,
	},
	{
		description = "marci_bodyguard_lifesteal",
		ability_name = "marci_pf_bodyguard",
		special_value_name = "lifesteal_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2.5,
		required_facet = 2,
	},
	{
		description = "marci_bodyguard_damage",
		ability_name = "marci_pf_bodyguard",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
		required_facet = 2,
	},
	--[[{
		description = "marci_bodyguard_armor",
		ability_name = "marci_pf_bodyguard",
		special_value_name = "bonus_armor",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
		required_facet = 2,
	},]]
	{
		description = "marci_bodyguard_cooldown",
		ability_name = "marci_pf_bodyguard",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
		required_facet = 2,
	},
	
	{
		description = "marci_unleash_lua_duration",
		ability_name = "marci_unleash_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	{
		description = "marci_unleash_lua_charges",
		ability_name = "marci_unleash_lua",
		special_value_name = "charges_per_flurry",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "marci_unleash_lua_flurries_cd",
		ability_name = "marci_unleash_lua",
		special_value_name = "time_between_flurries",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = -25,
	},
	{
		description = "marci_unleash_lua_damage",
		ability_name = "marci_unleash_lua",
		special_value_name = "pulse_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 70,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_marci"] = {
	
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_marci"] = "marci_unleash_lua"

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_marci"] = {
	"pathfinder_marci_grapple_throw",
	"pathfinder_marci_grapple_mass",
	"pathfinder_marci_grapple_stun",
	
	--"pathfinder_marci_companion_run_unleash",
	"pathfinder_marci_companion_run_leap",
	"pathfinder_marci_companion_run_global",
	
	--"pathfinder_marci_guardian_permanent",
	"special_bonus_unique_marci_bodyguard_enemy",
	"pathfinder_marci_bodyguard_kick",
	
	"pathfinder_marci_unleash_passive",
	"pathfinder_marci_unleash_pulse",
	"pathfinder_marci_unleash_bash_bodyguard",
}

--[[SPECIAL_ABILITY_UPGRADES_FACET_REPLACEMENTS["npc_dota_hero_marci"] = {
	["pathfinder_marci_guardian_enemy"] = {
		RequiredFacetID = 2,
		ReplacedSpecial = "special_bonus_unique_marci_bodyguard_enemy"
	},
	["pathfinder_marci_guardian_kick"] = {
		RequiredFacetID = 2,
		ReplacedSpecial = "pathfinder_marci_bodyguard_kick"
	},
	["pathfinder_marci_unleash_bash"] = {
		RequiredFacetID = 2,
		ReplacedSpecial = "pathfinder_marci_unleash_bash_bodyguard"
	},
}]]

item_marci_grapple_pf_stun = item_small_scepter_fragment
item_marci_grapple_pf_damage = item_small_scepter_fragment
item_marci_grapple_pf_radius = item_small_scepter_fragment
item_marci_grapple_pf_cooldown = item_small_scepter_fragment
item_marci_companion_run_pf_damage = item_small_scepter_fragment
item_marci_companion_run_pf_jump = item_small_scepter_fragment
item_marci_companion_run_pf_debuff_duration = item_small_scepter_fragment
item_marci_companion_run_pf_cooldown = item_small_scepter_fragment
item_marci_guardian_pf_lifesteal = item_small_scepter_fragment
item_marci_guardian_pf_damage = item_small_scepter_fragment
item_marci_guardian_pf_cooldown = item_small_scepter_fragment
item_marci_bodyguard_lifesteal = item_small_scepter_fragment
item_marci_bodyguard_damage = item_small_scepter_fragment
item_marci_bodyguard_cooldown = item_small_scepter_fragment
item_marci_unleash_lua_duration = item_small_scepter_fragment
item_marci_unleash_lua_charges = item_small_scepter_fragment
item_marci_unleash_lua_flurries_cd = item_small_scepter_fragment
item_marci_unleash_lua_damage = item_small_scepter_fragment



PURCHASABLE_SHARDS["npc_dota_hero_marci"] = {
	"item_marci_grapple_pf_stun",
	"item_marci_grapple_pf_damage",
	"item_marci_grapple_pf_radius",
	"item_marci_grapple_pf_cooldown",
	"item_marci_companion_run_pf_damage",
	"item_marci_companion_run_pf_jump",
	"item_marci_companion_run_pf_debuff_duration",
	"item_marci_companion_run_pf_cooldown",
	"item_marci_bodyguard_lifesteal",
	"item_marci_bodyguard_damage",
	"item_marci_bodyguard_cooldown",
	"item_marci_unleash_lua_duration",
	"item_marci_unleash_lua_charges",
	"item_marci_unleash_lua_flurries_cd",
	"item_marci_unleash_lua_damage",
}

--[[PURCHASABLE_SHARDS_FACET_ADDITIONS["npc_dota_hero_marci"] = {
	[1] = {
		"item_marci_guardian_pf_lifesteal",
		"item_marci_guardian_pf_damage",
		"item_marci_guardian_pf_cooldown",
	},
	[2] = {
		"item_marci_bodyguard_lifesteal",
		"item_marci_bodyguard_damage",
		"item_marci_bodyguard_cooldown",
	},
}]]