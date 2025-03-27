local DrowRanger =
{
	{
		 description = "aghsfort2_drow_ranger_frost_arrows_slow_duration",
		 ability_name = "aghsfort2_drow_ranger_frost_arrows",
		 special_value_name = "slow_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
		 linked_minors = {
			{
				ability_name = "aghsfort2_special_drow_ranger_frost_arrows_move_damage",
				special_value_name = "max_stacks",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 1,
			},
		 }
	},
	{
		 description = "aghsfort2_drow_ranger_frost_arrows_dmg_mana",
		 ability_name = "aghsfort2_drow_ranger_frost_arrows",
		 special_values =
		 {
			{
				special_value_name = "damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 15,
			 },
			 {
				 special_value_name = "mana_cost",
				 operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				 value = 12,
			 },
		 },
	},
	-- {
	-- 	 description = "aghsfort2_drow_ranger_frost_arrows_damage",
	-- 	 ability_name = "aghsfort2_drow_ranger_frost_arrows",
	-- 	 special_value_name = "damage",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	 value = 15,
	-- },
	{
		 description = "aghsfort2_drow_ranger_frost_arrows_frost_arrows_movement_speed",
		 ability_name = "aghsfort2_drow_ranger_frost_arrows",
		 special_value_name = "frost_arrows_movement_speed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 10,
		 linked_minors = {
			{
				 ability_name = "aghsfort2_special_drow_ranger_frost_arrows_wave",
				 special_value_name = "wave_chance",
				 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				 value = 5,
			},
			{
				 ability_name = "aghsfort2_special_drow_ranger_frost_arrows_move_damage",
				 special_values =
				 {
					{
						special_value_name = "damage_percent",
						operator = MINOR_ABILITY_UPGRADE_OP_ADD,
						value = 15,
					 },
					 {
						special_value_name = "movement_damage_percent",
						operator = MINOR_ABILITY_UPGRADE_OP_ADD,
						value = 30,
					 },
				 },
			},
		},
	},
	-- {
	-- 	description = "aghsfort2_drow_ranger_wave_of_silence_wave_wid",
	-- 	ability_name = "aghsfort2_drow_ranger_wave_of_silence",
	-- 	special_values =
	-- 	{
	-- 	   {
	-- 			special_value_name = "wave_width",
	-- 			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 			value = 45,
	-- 		},
	-- 		{
	-- 			special_value_name = "wave_length",
	-- 			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 			value = 100,
	-- 		},
	-- 	   {
	-- 			special_value_name = "start_radius",
	-- 			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 			value = 45,
	-- 		},
	-- 	   {
	-- 			special_value_name = "end_radius",
	-- 			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 			value = 45,
	-- 		},
	-- 		{
	-- 			special_value_name = "vec_min",
	-- 			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 			value = 145,
	-- 		},
	-- 		{
	-- 			special_value_name = "vec_max",
	-- 			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 			value = 145,
	-- 		},
	-- 	},
   	-- },
	-- {
	-- 	description = "aghsfort2_drow_ranger_wave_of_silence_wave_width",
	-- 	ability_name = "aghsfort2_drow_ranger_wave_of_silence",
	-- 	special_value_name = "wave_width",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 45,
   	-- },
	{
		description = "aghsfort2_drow_ranger_wave_of_silence_silence_dur",
		ability_name = "aghsfort2_drow_ranger_wave_of_silence",
		special_values =
		{
		   {
				special_value_name = "silence_duration",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 1,
			},
			{
				special_value_name = "knockback_distance_max",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 50,
			},
			{
				special_value_name = "knockback_duration",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 0.2,
			},
		},

		linked_minors = {
			{
				 ability_name = "aghsfort2_special_drow_ranger_wave_of_silence_echo",
				 special_value_name = "agility_duration",
				 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				 value = 2,
			},
			{
				 ability_name = "aghsfort2_special_drow_ranger_wave_of_silence_cooldown",
				 special_value_name = "cooldown_reduction",
				 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				 value = 0.2,
			},
			{
				ability_name = "aghsfort2_special_drow_ranger_marksmanship_aoe",
				special_value_name = "root_duration",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 0.2,
			},
		},
   	},
	{
		description = "aghsfort2_drow_ranger_wave_of_silence_blind_percent",
		ability_name = "aghsfort2_drow_ranger_wave_of_silence",
		special_value_name = "blind_percent",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
		linked_minors = {
			{
				 ability_name = "aghsfort2_special_drow_ranger_wave_of_silence_movement",
				 special_value_name = "movespeed_percent",
				 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				 value = 5,
			},
			{
				 ability_name = "aghsfort2_special_drow_ranger_wave_of_silence_frost",
				 special_value_name = "frost_damage_percent",
				 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				 value = 40,
			},
			{
				 ability_name = "aghsfort2_special_drow_ranger_wave_of_silence_echo",
				 special_values =
				 {
					{
						special_value_name = "agility_per_hit",
						operator = MINOR_ABILITY_UPGRADE_OP_ADD,
						value = 2,
					 },
					 {
						special_value_name = "agility_per_hit",
						operator = MINOR_ABILITY_UPGRADE_OP_ADD,
						value = 4,
					 },
				 },
			},
		},
	},
	{
		description = "aghsfort2_drow_ranger_wave_of_silence_mana_cost_cooldown",
		ability_name = "aghsfort2_drow_ranger_wave_of_silence",
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
		linked_minors = {
			{
				ability_name = "aghsfort2_special_drow_ranger_marksmanship_waveofsilence",
				special_value_name = "delay_time",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = -MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

   	{
	   description = "aghsfort2_drow_ranger_multishot_arrow_count_per_wave",
	   ability_name = "aghsfort2_drow_ranger_multishot",
	   special_value_name = "arrow_count_per_wave",
	   operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	   value = 1,
	   int = true,
	   linked_minors = {
			{
				ability_name = "aghsfort2_special_drow_ranger_multi_shot_side_line",
				special_value_name = "arrows_per_second",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 2,
			},
			-- {
			-- 	ability_name = "aghsfort2_drow_ranger_multishot",
			-- 	special_value_name = "arrow_delay",
			-- 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
			-- 	value = -10,
			-- 	int = true,
			-- },
			-- {
			-- 	ability_name = "aghsfort2_drow_ranger_multishot",
			-- 	special_value_name = "per_arrow_angle",
			-- 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
			-- 	value = -5,
			-- 	int = true,
			-- },
		}
	},
   	{
	   description = "aghsfort2_drow_ranger_multishot_arrow_waves",
	   ability_name = "aghsfort2_drow_ranger_multishot",
	   special_value_name = "wave_count",
	   operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	   value = 1,
	   int = true,
	   linked_minors = {
			{
				ability_name = "aghsfort2_special_drow_ranger_multi_shot_move",
				special_value_name = "movespeed_reduction",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = -10,
			},
			-- {
			-- 	ability_name = "aghsfort2_drow_ranger_multishot",
			-- 	special_value_name = "wave_delay",
			-- 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
			-- 	value = -10,
			-- 	int = true,
			-- },
	   }
	},
   	{
	   description = "aghsfort2_drow_ranger_multishot_arrow_damage_pct",
	   ability_name = "aghsfort2_drow_ranger_multishot",
	   special_value_name = "arrow_damage_pct",
	   operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	   value = 20,
	   linked_minors = {
		{
			ability_name = "aghsfort2_special_drow_ranger_multi_shot_buff",
			special_value_name = "damage_percent",
			operator = MINOR_ABILITY_UPGRADE_OP_ADD,
			value = 5,
		},
   }
	},
	{
		description = "aghsfort2_drow_ranger_multishot_mana_cost_cooldown",
		ability_name = "aghsfort2_drow_ranger_multishot",
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
		description = "aghsfort2_drow_ranger_marksmanship_bonus",
		ability_name = "aghsfort2_drow_ranger_marksmanship",
		special_values =
		{
			{
				special_value_name = "bonus_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 35,
			},
			{
				special_value_name = "bonus_range",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 50,
			},
		},
	},
	-- {
	-- 	description = "aghsfort2_drow_ranger_marksmanship_bonus_damage",
	-- 	ability_name = "aghsfort2_drow_ranger_marksmanship",
	-- 	special_value_name = "bonus_damage",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 30,
	-- },
	-- {
	-- 	description = "aghsfort2_drow_ranger_marksmanship_bonus_range",
	-- 	ability_name = "aghsfort2_drow_ranger_marksmanship",
	-- 	special_value_name = "bonus_range",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 75,
	-- },
	{
		description = "aghsfort2_drow_ranger_marksmanship_charges",
		ability_name = "aghsfort2_drow_ranger_marksmanship",
		special_value_name = "charges",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort2_drow_ranger_marksmanship_mana_cost_cooldown",
		ability_name = "aghsfort2_drow_ranger_marksmanship",
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
		linked_minors = {
			{
				ability_name = "aghsfort2_special_drow_ranger_marksmanship_waveofsilence",
				special_value_name = "delay_time",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = -MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},
	{
		description = "aghsfort2_drow_ranger_marksmanship_aura_agility_multiplier",
		ability_name = "aghsfort2_drow_ranger_marksmanship",
		special_value_name = "aura_agility_multiplier",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
		linked_minors = {
			{
				ability_name = "aghsfort2_special_drow_ranger_marksmanship_aoe",
				special_value_name = "aura_range_percent",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 5,
			},
		},
	},
	-- {
	-- 	description = "aghsfort2_drow_ranger_marksmanship_aura_range",
	-- 	ability_name = "aghsfort2_drow_ranger_marksmanship",
	-- 	special_value_name = "aura_range",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	value = 200,
	-- },
}

return DrowRanger
