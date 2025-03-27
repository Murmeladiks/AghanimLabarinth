MINOR_ABILITY_UPGRADES["npc_dota_hero_nevermore"] = {
	{
		description = "pathfinder_nevermore_shadowraze_damage",
		ability_name = "pathfinder_nevermore_shadowraze_medium",
		other_abilities = {
			"pathfinder_nevermore_shadowraze_near",
			"pathfinder_nevermore_shadowraze_far"
		},
		special_values =
		{
			{
				special_value_name = "damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 50,
			},
			{
				special_value_name = "stack_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 10,
			},
		},
	},
	
	{
		description = "pathfinder_nevermore_shadowraze_cooldown_value",
		ability_name = "pathfinder_nevermore_shadowraze_medium",
		other_abilities = {
			"pathfinder_nevermore_shadowraze_near",
			"pathfinder_nevermore_shadowraze_far"
		},
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	
	
	{
		description = "pathfinder_nevermore_necromastery_damage_per_soul",
		ability_name = "pathfinder_nevermore_necromastery",
		special_value_name = "damage_per_soul",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "pathfinder_nevermore_necromastery_max_souls",
		ability_name = "pathfinder_nevermore_necromastery",
		special_value_name = "max_souls",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	-- {
	-- 	 description = "pathfinder_nevermore_necromastery_souls_per_kill",
	-- 	 ability_name = "pathfinder_nevermore_necromastery",
	-- 	 special_value_name = "souls_per_kill",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	 value = 1,
	-- },


	{
		description = "nevermore_pf_frenzy_attack_speed",
		ability_name = "nevermore_pf_frenzy",
		special_value_name = "bonus_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},
	
	----------
	{
		description = "pathfinder_nevermore_dark_lord_aura_radius",
		ability_name = "pathfinder_nevermore_dark_lord",
		special_value_name = "aura_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 175,
	},
	{
		description = "pathfinder_nevermore_dark_lord_armor_reduction",
		ability_name = "pathfinder_nevermore_dark_lord",
		special_value_name = "armor_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	
	----------
	
	{
		description = "pathfinder_nevermore_requiem_damage",
		ability_name = "pathfinder_nevermore_requiem",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},

	{
		description = "pathfinder_nevermore_requiem_travel_distance",
		ability_name = "pathfinder_nevermore_requiem",
		special_values =
		{
			{
				special_value_name = "travel_distance",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 200,
			},
			{
				special_value_name = "lines_travel_speed",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 100,
			},
		},
	},
	{
		description = "pathfinder_nevermore_requiem_ms_slow_pct",
		ability_name = "pathfinder_nevermore_requiem",
		special_value_name = "ms_slow_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},
	-- {
	-- 	 description = "pathfinder_nevermore_requiem_requiem_slow_duration",
	-- 	 ability_name = "pathfinder_nevermore_requiem",
	-- 	 special_value_name = "slow_duration",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	 value = 0.8,
	-- },
	{
		description = "pathfinder_nevermore_requiem_pct_cooldown",
		ability_name = "pathfinder_nevermore_requiem",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}
STAT_UPGRADE_EXCLUDES["npc_dota_hero_nevermore"] = {
}
ULTIMATE_ABILITY_NAMES["npc_dota_hero_nevermore"] = "nevermore_requiem"
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_nevermore"] =
{
	"pathfinder_nevermore_special_raze_multi",   
	"pathfinder_nevermore_special_dark_lord_raze",
	
	"pathfinder_nevermore_special_requiem_attack",
	"pathfinder_nevermore_special_requiem_soul_projectile",
	"pathfinder_nevermore_special_requiem_sleep",
	
	"pathfinder_nevermore_special_necromastery_revenant",   
	"pathfinder_nevermore_special_necromastery_attack_soul",   
	"pathfinder_nevermore_special_necromastery_lifesteal",
	
	"pathfinder_nevermore_special_dark_lord_friendly",
	"pathfinder_nevermore_special_dark_lord_split_attack",
}

item_pathfinder_nevermore_shadowraze_damage = item_small_scepter_fragment
item_pathfinder_nevermore_shadowraze_cooldown_value = item_small_scepter_fragment

item_pathfinder_nevermore_necromastery_damage_per_soul = item_small_scepter_fragment
item_pathfinder_nevermore_necromastery_max_souls = item_small_scepter_fragment
-- item_pathfinder_nevermore_necromastery_souls_per_kill = item_small_scepter_fragment   

item_pathfinder_nevermore_dark_lord_aura_radius = item_small_scepter_fragment   
item_pathfinder_nevermore_dark_lord_armor_reduction = item_small_scepter_fragment   

item_pathfinder_nevermore_requiem_damage = item_small_scepter_fragment   
item_pathfinder_nevermore_requiem_travel_distance = item_small_scepter_fragment   
item_pathfinder_nevermore_requiem_ms_slow_pct = item_small_scepter_fragment   
-- item_pathfinder_nevermore_requiem_requiem_slow_duration = item_small_scepter_fragment   
item_pathfinder_nevermore_requiem_pct_cooldown = item_small_scepter_fragment   

PURCHASABLE_SHARDS[ "npc_dota_hero_nevermore" ] =
{
	"item_pathfinder_nevermore_shadowraze_damage",
	"item_pathfinder_nevermore_shadowraze_cooldown_value",
	
	"item_pathfinder_nevermore_necromastery_damage_per_soul",
	"item_pathfinder_nevermore_necromastery_max_souls",
	-- "item_pathfinder_nevermore_necromastery_souls_per_kill",
	
	"item_pathfinder_nevermore_dark_lord_aura_radius",   
	"item_pathfinder_nevermore_dark_lord_armor_reduction",
	
	"item_pathfinder_nevermore_requiem_damage",   
	"item_pathfinder_nevermore_requiem_travel_distance",
	"item_pathfinder_nevermore_requiem_ms_slow_pct",
	
	-- "item_pathfinder_nevermore_requiem_requiem_slow_duration",
	"item_pathfinder_nevermore_requiem_pct_cooldown",
}
