MINOR_ABILITY_UPGRADES["npc_dota_hero_dragon_knight"] = {
	{
		description = "dragon_knight_pf_inherited_vigor_armor_regen",
		ability_name = "dragon_knight_pf_inherited_vigor",
		special_values =
		{
			{
				special_value_name = "base_health_regen",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 2,
			},
			{
				special_value_name = "base_armor",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 2,
			},
		},
	},

	---------------------------------------------------------------

	{
		description = "pathfinder_dk_breathe_fire_range",
		ability_name = "pathfinder_dk_breathe_fire",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 150,
	},
	
	{
		description = "pathfinder_dk_breathe_fire_reduction",
		ability_name = "pathfinder_dk_breathe_fire",
		special_value_name = "reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	
	{
		description = "pathfinder_dk_breathe_fire_duration",
		ability_name = "pathfinder_dk_breathe_fire",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
	
	{
		description = "pathfinder_dk_breathe_fire_damage",
		ability_name = "pathfinder_dk_breathe_fire",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},
	
	{
		description = "pathfinder_dk_breathe_fire_pct_cooldown",
		ability_name = "pathfinder_dk_breathe_fire",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	
	---------------------------------------------------------------
	
	{
		description = "pathfinder_dk_dragon_tail_stun_duration",
		ability_name = "pathfinder_dk_dragon_tail",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	
	{
		description = "pathfinder_dk_dragon_tail_attack_damage",
		ability_name = "pathfinder_dk_dragon_tail",
		special_values =
		{
			{
				special_value_name = "damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 40,
			},
			{
				special_value_name = "attack_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 12,
			},
		},
		value = 12,
	},
	
	{
		description = "pathfinder_dk_dragon_tail_radius",
		ability_name = "pathfinder_dk_dragon_tail",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},
	
	{
		description = "pathfinder_dk_dragon_tail_pct_cooldown",
		ability_name = "pathfinder_dk_dragon_tail",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	
	---------------------------------------------------------------
	
	{
		description = "dragon_knight_pf_dragon_blood_cleave_damage",
		ability_name = "dragon_knight_pf_dragon_blood",
		special_value_name = "magic_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 6,
		required_facet = 1
	},

	{
		description = "dragon_knight_pf_dragon_blood_corrosive_breath_damage",
		ability_name = "dragon_knight_pf_dragon_blood",
		special_value_name = "corrosive_breath_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
		required_facet = 2
	},

	{
		description = "dragon_knight_pf_dragon_blood_corrosive_breath_armor_reduction",
		ability_name = "dragon_knight_pf_dragon_blood",
		special_value_name = "corrosive_breath_armor_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
		required_facet = 2
	},

	{
		description = "dragon_knight_pf_dragon_blood_frost_bonus_attack_speed",
		ability_name = "dragon_knight_pf_dragon_blood",
		special_value_name = "frost_bonus_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -10,
		required_facet = 3
	},

	{
		description = "dragon_knight_pf_dragon_blood_frost_movespeed_heal",
		ability_name = "dragon_knight_pf_dragon_blood",
		special_values =
		{
			{
				special_value_name = "frost_bonus_movement_speed",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = -10,
			},
			{
				special_value_name = "frost_healing_reduction",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 10,
			},
		},
		required_facet = 3
	},
	
	------------------------------------------------------------------
	
	{
		description = "pathfinder_dk_elder_dragon_form_duration",
		ability_name = "dragon_knight_pf_elder_dragon_form",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	
	{
		description = "pathfinder_dk_elder_dragon_form_bonus_movement_speed",
		ability_name = "dragon_knight_pf_elder_dragon_form",
		special_value_name = "bonus_movement_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	
	{
		description = "pathfinder_dk_elder_dragon_form_bonus_attack_range",
		ability_name = "dragon_knight_pf_elder_dragon_form",
		special_value_name = "bonus_attack_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	{
		description = "pathfinder_dk_elder_dragon_form_bonus_attack_damage",
		ability_name = "dragon_knight_pf_elder_dragon_form",
		special_value_name = "bonus_attack_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	
	{
		description = "pathfinder_dk_elder_dragon_form_pct_cooldown",
		ability_name = "dragon_knight_pf_elder_dragon_form",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_dragon_knight"] = {
	"aghsfort_minor_stat_upgrade_bonus_evasion",
	"aghsfort_minor_stat_upgrade_bonus_armor",
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_dragon_knight"] = "dragon_knight_elder_dragon_form"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_dragon_knight"] =
{
	"pathfinder_dk_breathe_fire_stun",
	"pathfinder_dk_breathe_fire_macropyre",
	"pathfinder_dk_breathe_fire_crit_lifesteal",
	
	"pathfinder_dk_dragon_tail_passive",
	"pathfinder_dk_dragon_tail_bounce",
	"pathfinder_dk_dragon_tail_chain",
	
	"pathfinder_dk_dragon_blood_damage",
	"pathfinder_dk_dragon_blood_gold",
	"pathfinder_dk_dragon_blood_active",
	
	"pathfinder_dk_elder_dragon_form_attack",
	"pathfinder_dk_elder_dragon_form_fear",   
	"pathfinder_dk_elder_dragon_form_cdr",
}


item_pathfinder_dk_breathe_fire_range = item_small_scepter_fragment
item_pathfinder_dk_breathe_fire_reduction = item_small_scepter_fragment
item_pathfinder_dk_breathe_fire_duration = item_small_scepter_fragment
item_pathfinder_dk_breathe_fire_damage = item_small_scepter_fragment
item_pathfinder_dk_breathe_fire_pct_cooldown = item_small_scepter_fragment

item_pathfinder_dk_dragon_tail_stun_duration = item_small_scepter_fragment
item_pathfinder_dk_dragon_tail_attack_damage = item_small_scepter_fragment
item_pathfinder_dk_dragon_tail_radius = item_small_scepter_fragment
item_pathfinder_dk_dragon_tail_pct_cooldown = item_small_scepter_fragment

item_dragon_knight_pf_inherited_vigor_armor_regen = item_small_scepter_fragment

item_dragon_knight_pf_dragon_blood_cleave_damage = item_small_scepter_fragment
item_dragon_knight_pf_dragon_blood_corrosive_breath_damage = item_small_scepter_fragment
item_dragon_knight_pf_dragon_blood_corrosive_breath_armor_reduction = item_small_scepter_fragment
item_dragon_knight_pf_dragon_blood_frost_bonus_attack_speed = item_small_scepter_fragment
item_dragon_knight_pf_dragon_blood_frost_movespeed_heal = item_small_scepter_fragment

item_pathfinder_dk_elder_dragon_form_duration = item_small_scepter_fragment
item_pathfinder_dk_elder_dragon_form_bonus_movement_speed = item_small_scepter_fragment
item_pathfinder_dk_elder_dragon_form_bonus_attack_range = item_small_scepter_fragment
item_pathfinder_dk_elder_dragon_form_bonus_attack_damage = item_small_scepter_fragment
item_pathfinder_dk_elder_dragon_form_pct_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_dragon_knight" ] =
{
	"item_pathfinder_dk_breathe_fire_range",
	"item_pathfinder_dk_breathe_fire_reduction",
	"item_pathfinder_dk_breathe_fire_duration",
	"item_pathfinder_dk_breathe_fire_damage",
	"item_pathfinder_dk_breathe_fire_pct_cooldown",
	
	"item_pathfinder_dk_dragon_tail_stun_duration",
	"item_pathfinder_dk_dragon_tail_attack_damage",
	"item_pathfinder_dk_dragon_tail_radius",
	"item_pathfinder_dk_dragon_tail_pct_cooldown",
	
	"item_dragon_knight_pf_inherited_vigor_armor_regen",
	
	"item_pathfinder_dk_elder_dragon_form_duration",
	"item_pathfinder_dk_elder_dragon_form_bonus_movement_speed",
	"item_pathfinder_dk_elder_dragon_form_bonus_attack_range",
	"item_pathfinder_dk_elder_dragon_form_bonus_attack_damage",
	"item_pathfinder_dk_elder_dragon_form_pct_cooldown",
}

PURCHASABLE_SHARDS_FACET_ADDITIONS["npc_dota_hero_dragon_knight"] = {
	[1] = {
		"item_dragon_knight_pf_dragon_blood_cleave_damage"
	},
	[2] = {
		"item_dragon_knight_pf_dragon_blood_corrosive_breath_damage",
		"item_dragon_knight_pf_dragon_blood_corrosive_breath_armor_reduction"
	},
	[3] = {
		"item_dragon_knight_pf_dragon_blood_frost_bonus_attack_speed",
		"item_dragon_knight_pf_dragon_blood_frost_movespeed_heal"
	}
}