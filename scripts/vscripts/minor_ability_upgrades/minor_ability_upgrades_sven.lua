local Sven =
{
	{
		description = "remake_storm_bolt_cooldown_and_mana_shard",
		ability_name = "remake_storm_bolt",
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
		 description = "remake_storm_bolt_damage_shard",
		 ability_name = "remake_storm_bolt",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 135,
	},	

	{
		 description = "remake_great_cleave_damage_talent",
		 ability_name = "remake_great_cleave",
		 special_value_name = "great_cleave_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 15,
	},
	
	{
        description = "remake_sven_warcry_duration_and_ms_talent",
        ability_name = "remake_sven_warcry",
        special_values = {
            {
                special_value_name = "warcry_movespeed",
                operator = MINOR_ABILITY_UPGRADE_OP_ADD,
                value = 5,
            }, 
            {
                special_value_name = "duration",
                operator = MINOR_ABILITY_UPGRADE_OP_ADD,
                value = 1,
            }
        }
    }, 

	{
		 description = "remake_sven_warcry_armor_talent",
		 ability_name = "remake_sven_warcry",
		 special_value_name = "warcry_armor",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 4,
	},
	
    {
		description = "remake_sven_warcry_cooldown_and_mana_shard",
		ability_name = "remake_sven_warcry",
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
		 description = "remake_sven_gods_strength_talent",
		 ability_name = "remake_sven_gods_strength",
		 special_value_name = "gods_strength_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 120,
	},	
	{
		description = "remake_sven_gods_strength_cd_talent",
		ability_name = "remake_sven_gods_strength",
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
	
}

return Sven