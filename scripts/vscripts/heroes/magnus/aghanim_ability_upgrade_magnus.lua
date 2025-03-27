MINOR_ABILITY_UPGRADES["npc_dota_hero_magnataur"] = {
	{
		description = "aghsfort_magnataur_shockwave_flat_damage",
		ability_name = "magnataur_pf_shockwave",
		facet_ability_name = "magnataur_pf_shockwave_return",
		special_value_name = "shock_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},
	-- {
	-- 	 description = "aghsfort_magnataur_shockwave_flat_shock_width",
	-- 	 ability_name = "magnataur_pf_shockwave",
	--   facet_ability_name = "magnataur_pf_shockwave_return",
	-- 	 special_value_name = "shock_width",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	 value = 50,
	-- },
	
	{
		description = "aghsfort_magnataur_shockwave_flat_slow_duration",
		ability_name = "magnataur_pf_shockwave",
		facet_ability_name = "magnataur_pf_shockwave_return",
		special_value_name = "basic_slow_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.25,
	},
	
	{
		description = "aghsfort_magnataur_shockwave_mana_cost_cooldown",
		ability_name = "magnataur_pf_shockwave",
		facet_ability_name = "magnataur_pf_shockwave_return",
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
		description = "aghsfort_magnataur_empower_flat_damage",
		ability_name = "magnataur_pf_empower",
		special_value_name = "bonus_damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	
	{
		description = "aghsfort_magnataur_empower_flat_cleave",
		ability_name = "magnataur_pf_empower",
		special_value_name = "cleave_damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	
	{
		description = "aghsfort_magnataur_skewer_flat_range_speed",
		ability_name = "magnataur_pf_skewer",
		special_values =
		{
			{
				special_value_name = "range",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 200,
			},
			{
				special_value_name = "skewer_speed",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 200,
			},
		},
	},
	
	{
		description = "aghsfort_magnataur_skewer_flat_damage",
		ability_name = "magnataur_pf_skewer",
		special_value_name = "skewer_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 85,
	},
	
	-- {
	-- 	description = "aghsfort_magnataur_skewer_flat_slow_pct",
	-- 	ability_name = "magnataur_pf_skewer",
	-- 	special_value_name = "slow_pct",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 25,
	-- },
	
	{
		description = "aghsfort_magnataur_skewer_mana_cost_cooldown",
		ability_name = "magnataur_pf_skewer",
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
		description = "aghsfort_magnataur_reverse_polarity_mana_cost_cooldown",
		ability_name = "magnataur_pf_reverse_polarity",
		facet_ability_name = "magnataur_pf_reverse_polarity_polarity",
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
		description = "aghsfort_magnataur_reverse_polarity_flat_damage",
		ability_name = "magnataur_pf_reverse_polarity",
		facet_ability_name = "magnataur_pf_reverse_polarity_polarity",
		special_value_name = "polarity_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 225,
	},
	
	{
		description = "aghsfort_magnataur_reverse_polarity_flat_stun_duration",
		ability_name = "magnataur_pf_reverse_polarity",
		facet_ability_name = "magnataur_pf_reverse_polarity_polarity",
		special_value_name = "hero_stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
	
	{
		description = "aghsfort_magnataur_reverse_polarity_flat_radius",
		ability_name = "magnataur_pf_reverse_polarity",
		facet_ability_name = "magnataur_pf_reverse_polarity_polarity",
		special_value_name = "pull_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 120,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_magnataur"] = {"aghsfort_minor_stat_upgrade_bonus_health"}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_magnataur"] = "magnataur_reverse_polarity"

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_magnataur"] =
{
	"aghsfort_special_magnataur_shockwave_multishot",
	"aghsfort_special_magnataur_shockwave_damage_reduction",
	--"aghsfort_special_magnataur_shockwave_boomerang",
	
	--"aghsfort_special_magnataur_empower_all_allies",
	"special_bonus_unique_magnataur_empower_charges",
	"aghsfort_special_magnataur_empower_lifesteal",
	"aghsfort_special_magnataur_empower_shockwave_on_attack",
	
	--"aghsfort_special_magnataur_skewer_original_scepter",
	--"aghsfort_special_magnataur_friendly_skewer",
	"aghsfort_special_magnataur_skewer_bonus_strength",
	"magnataur_pf_horn_toss",
	"aghsfort_special_magnataur_skewer_shockwave",
	
	--"aghsfort_special_magnataur_reverse_polarity_radius",
	"aghsfort_special_magnataur_reverse_polarity_polarity_dummy",
	"aghsfort_special_magnataur_reverse_polarity_allies_crit",
	"aghsfort_special_magnataur_reverse_polarity_steroid",
}

item_aghsfort_magnataur_shockwave_flat_damage = item_small_scepter_fragment
--item_aghsfort_magnataur_shockwave_pct_mana_cost = item_small_scepter_fragment
item_aghsfort_magnataur_empower_flat_damage = item_small_scepter_fragment
item_aghsfort_magnataur_empower_flat_cleave = item_small_scepter_fragment
item_aghsfort_magnataur_skewer_flat_damage = item_small_scepter_fragment
--item_aghsfort_magnataur_skewer_pct_cooldown = item_small_scepter_fragment
item_aghsfort_magnataur_reverse_polarity_flat_damage = item_small_scepter_fragment
item_aghsfort_magnataur_reverse_polarity_flat_radius = item_small_scepter_fragment

item_aghsfort_magnataur_shockwave_mana_cost_cooldown = item_small_scepter_fragment
item_aghsfort_magnataur_skewer_mana_cost_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_magnataur" ] =
{
	"item_aghsfort_magnataur_shockwave_flat_damage",
	"item_aghsfort_magnataur_shockwave_mana_cost_cooldown",
	"item_aghsfort_magnataur_empower_flat_damage",
	"item_aghsfort_magnataur_empower_flat_cleave",
	"item_aghsfort_magnataur_skewer_flat_damage",
	"item_aghsfort_magnataur_skewer_mana_cost_cooldown",
	"item_aghsfort_magnataur_reverse_polarity_flat_damage",
	"item_aghsfort_magnataur_reverse_polarity_flat_radius",
}