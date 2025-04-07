LinkLuaModifier( "modifier_minor_ability_upgrades", "modifiers/modifier_minor_ability_upgrades", LUA_MODIFIER_MOTION_NONE )

_G.MINOR_ABILITY_UPGRADE_OP_ADD = 1
_G.MINOR_ABILITY_UPGRADE_OP_MUL = 2

_G.MINOR_ABILITY_COOLDOWN_MANACOST_PCT = 7

_G.SPECIAL_ABILITY_UPGRADES_FACET_REPLACEMENTS = {}
_G.MINOR_ABILITY_UPGRADES_FACET_REPLACEMENTS = {}
_G.PURCHASABLE_SHARDS_FACET_ADDITIONS = {}

_G.MINOR_ABILITY_UPGRADES =
{
   npc_dota_hero_snapfire = require( "minor_ability_upgrades/minor_ability_upgrades_snapfire" ),
   npc_dota_hero_disruptor = require( "minor_ability_upgrades/minor_ability_upgrades_disruptor" ),
   npc_dota_hero_tusk = require( "minor_ability_upgrades/minor_ability_upgrades_tusk" ),
   npc_dota_hero_mars = require( "minor_ability_upgrades/minor_ability_upgrades_mars" ),
   npc_dota_hero_viper = require( "minor_ability_upgrades/minor_ability_upgrades_viper" ),
   npc_dota_hero_weaver = require( "minor_ability_upgrades/minor_ability_upgrades_weaver" ),
   npc_dota_hero_omniknight = require( "minor_ability_upgrades/minor_ability_upgrades_omniknight" ),
   npc_dota_hero_slark = require( "minor_ability_upgrades/minor_ability_upgrades_slark" ),
   npc_dota_hero_juggernaut = require( "minor_ability_upgrades/minor_ability_upgrades_juggernaut" ),
   npc_dota_hero_venomancer = require( "minor_ability_upgrades/minor_ability_upgrades_venomancer" ),
   npc_dota_hero_phoenix = require( "minor_ability_upgrades/minor_ability_upgrades_phoenix" ),
   npc_dota_hero_lion = require( "minor_ability_upgrades/minor_ability_upgrades_lion" ),
   npc_dota_hero_drow_ranger = require( "minor_ability_upgrades/minor_ability_upgrades_drow_ranger" ),
   npc_dota_hero_sven = require( "minor_ability_upgrades/minor_ability_upgrades_sven" ),
   npc_dota_hero_gyrocopter = require( "minor_ability_upgrades/minor_ability_upgrades_gyrocopter" ),
   --non hero specific upgrades (bonus HP/mana/damage/etc.)
   base_stats_upgrades = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
}

_G.STAT_UPGRADE_EXCLUDES =
{
   npc_dota_hero_sven = 
   {

   },

   npc_dota_hero_gyrocopter = 
   {
   }, 

   npc_dota_hero_omniknight =
   {
      "aghsfort_minor_stat_upgrade_bonus_attack_speed",
   },

   npc_dota_hero_lion =
   {
   },

   npc_dota_hero_disruptor =
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_drow_ranger =
   {
   },

   npc_dota_hero_snapfire = 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_tusk = 
   {
      "aghsfort_minor_stat_upgrade_bonus_health",
   },

   npc_dota_hero_mars = 
   {
      "aghsfort_minor_stat_upgrade_bonus_health",
   },

   npc_dota_hero_viper = 
   {
      "aghsfort_minor_stat_upgrade_bonus_magic_resist",
   },

   npc_dota_hero_weaver = 
   {
      "aghsfort_minor_stat_upgrade_bonus_spell_amp",
   },

   npc_dota_hero_slark = 
   {
   },
   
   npc_dota_hero_juggernaut = 
   {
      "aghsfort_minor_stat_upgrade_bonus_spell_amp",
   },
   npc_dota_hero_venomancer= 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_phoenix=
   {      
      "aghsfort_minor_stat_upgrade_bonus_attack_speed",
   },
}

-- NOTE: These are substrings to search for in SPECIAL_ABILITY_UPGRADES
_G.ULTIMATE_ABILITY_NAMES =
{
   npc_dota_hero_sven = "remake_sven_gods_strength",
   npc_dota_hero_omniknight = "omniknight_guardian_angel",
   npc_dota_hero_disruptor = "disruptor_static_storm",
   npc_dota_hero_snapfire = "snapfire_mortimer_kisses", 
   npc_dota_hero_tusk = "tusk_walrus_punch",
   npc_dota_hero_mars = "mars_arena_of_blood",
   npc_dota_hero_viper = "_strike", -- Not "viper_viper_strike" because the viper strike names in SPECIAL_ABILITY_UPGRADES are wierd
   npc_dota_hero_weaver = "weaver_time_lapse",
   npc_dota_hero_slark = "slark_shadow_dance",
   npc_dota_hero_juggernaut = "juggernaut_omni_slash",
   npc_dota_hero_venomancer = "venomancer_poison_nova",
   npc_dota_hero_phoenix = "phoenix_supernova",
   npc_dota_hero_lion = "lion_finger_of_death",
   npc_dota_hero_drow_ranger = "drow_ranger_marksmanship",
   npc_dota_hero_gyrocopter = "gyrocopter_call_down",
}

-- Lists for ability upgrades go here
_G.SPECIAL_ABILITY_UPGRADES = {}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_sven"] = 
{
   "remake_storm_bolt_storm",
   "remake_storm_bolt_rush", 
   "remake_storm_bolt_crit",
   "remake_great_cleave_focus",
   "remake_great_cleave_great",
   "remake_great_cleave_lifesteal",   
   "remake_sven_warcry_protect",      
   "remake_sven_warcry_destruction",
   "remake_sven_warcry_magic",
   "remake_sven_gods_strength_berserker",
   "remake_sven_gods_strength_anger", 
   "remake_sven_gods_strength_focus",   
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_phoenix"] =
{         
   "pathfinder_icarus_dive_loop",
   "pathfinder_icarus_dive_flyby",
   "pathfinder_icarus_dive_bkb",

   "pathfinder_fire_spirit_sun_strike",
   "pathfinder_fire_spirit_shell",
   "pathfinder_fire_spirit_baby",

   "pathfinder_sun_ray_star",
   "pathfinder_sun_ray_infinite",

   "pathfinder_supernova_allies",
   "pathfinder_supernova_blackhole",   
   "pathfinder_supernova_heal_bkb",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_drow_ranger"] =
{
   "aghsfort2_special_drow_ranger_frost_arrows_split",
   "aghsfort2_special_drow_ranger_frost_arrows_move_damage",
   "aghsfort2_special_drow_ranger_frost_arrows_wave",

   "aghsfort2_special_drow_ranger_wave_of_silence_echo",
   "aghsfort2_special_drow_ranger_wave_of_silence_movement",
   "aghsfort2_special_drow_ranger_wave_of_silence_cooldown",
   "aghsfort2_special_drow_ranger_wave_of_silence_frost",

   "aghsfort2_special_drow_ranger_multi_shot_move",
   "aghsfort2_special_drow_ranger_multi_shot_side_line",
   "aghsfort2_special_drow_ranger_multi_shot_buff",

   "aghsfort2_special_drow_ranger_marksmanship_waveofsilence",
   "aghsfort2_special_drow_ranger_marksmanship_aoe",
   
   -- "aghsfort2_special_drow_ranger_multi_shot_refire",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_juggernaut"] =
{
   "pathfinder_special_juggernaut_blade_fury_ward",   
   "pathfinder_special_juggernaut_blade_fury_flying",
   "pathfinder_special_juggernaut_blade_fury_strength",

   "pathfinder_special_juggernaut_blade_dance_illusion",
   "pathfinder_special_juggernaut_blade_dance_reduce_omnislash_cooldown",

   "pathfinder_special_juggernaut_healing_ward_earthshock",
   "pathfinder_special_juggernaut_healing_ward_allies",
   "pathfinder_special_juggernaut_healing_ward_creep",
   -- "pathfinder_special_juggernaut_healing_ward_radiance",
   
   "pathfinder_special_juggernaut_wind_breathing_dummy",
   --"pathfinder_special_juggernaut_omni_tiny_slash",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_venomancer"] =
{
   "pathfinder_special_venomancer_ward_global_attack",
   "pathfinder_special_venomancer_ward_lifesteal",
   "pathfinder_special_venomancer_ward_nova",   
   "pathfinder_special_venomancer_bigass_ward_dummy",   
   "pathfinder_special_venomancer_ward_corpse",
   "pathfinder_special_venomancer_gale_attack",
   "special_bonus_unique_venomancer_ward_bonus_damage",
  -- "pathfinder_special_venomancer_gale_bkb",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_omniknight"] =
{
	"aghsfort_special_omniknight_purification_cast_radius",
	--"aghsfort_special_omniknight_purification_charges",
	"aghsfort_special_omniknight_purification_cooldown_reduction",
	"aghsfort_special_omniknight_purification_multicast",

   "aghsfort_special_omniknight_repel_procs_purification",
   "aghsfort_special_omniknight_repel_outgoing_damage",
   --"aghsfort_special_omniknight_repel_applies_degen_aura", --needs some re-write to make it work in all cases and doesn't seem interesting anyway
   "aghsfort_special_omniknight_repel_damage_instance_refraction",
   "aghsfort_special_omniknight_repel_knockback_on_cast",

   --"aghsfort_special_omniknight_degen_aura_toggle",
   --"aghsfort_special_omniknight_degen_aura_buff",
   --"aghsfort_special_omniknight_degen_aura_damage",
   --"aghsfort_special_omniknight_degen_aura_restoration",

   "aghsfort_special_omniknight_guardian_angel_purification",
   "aghsfort_special_omniknight_guardian_angel_immune_flight",
   --"aghsfort_special_omniknight_guardian_angel_single_target",
   --"aghsfort_special_omniknight_guardian_angel_single_target_dummy",

}

-- SPECIAL_ABILITY_UPGRADES["npc_dota_hero_luna"] =
-- {
-- 	"omniknight_guardian_angel",
-- 	"aghsfort_special_omniknight_purification_cast_radius",
-- 	"omniknight_purification",
-- }

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_disruptor"] =
{
	"special_bonus_unique_disruptor_thunder_strike_cover",
	--"aghsfort_special_disruptor_thunder_strike_mana_restore",
	"disruptor_thunder_strike_critical",
   "disruptor_thunder_strike_weapon",

--	"aghsfort_special_disruptor_glimpse_cast_aoe",
	"disruptor_glimpse_past",
	--"aghsfort_special_disruptor_glimpse_travel_damage",

	--"aghsfort_special_disruptor_kinetic_field_instant_setup",
	"disruptor_kinetic_field_damage",
   "disruptor_kinetic_field_heal",
   "disruptor_kinetic_field_ring",
	--"aghsfort_special_disruptor_kinetic_field_allied_attack_buff",
   "disruptor_static_storm_perfect",
   "disruptor_static_storm_dreams",
   "disruptor_static_storm_pacific",
   "special_bonus_unique_disruptor_electromagnetic_repulsion_no_cooldown",
   "disruptor_electromagnetic_repulsion_damage",

	--"aghsfort_special_disruptor_static_storm_kinetic_field_on_cast",
	--"aghsfort_special_disruptor_static_storm_crits_on_attacks",
	--"aghsfort_special_disruptor_static_storm_damage_reduction",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_snapfire"] =
{
   --"pathfinder_special_snapfire_gobble",
   "aghsfort_special_snapfire_scatterblast_double_barrel",
   --"aghsfort_special_snapfire_scatterblast_knockback",
  -- "aghsfort_special_snapfire_scatterblast_fullrange_pointblank",
   "aghsfort_special_snapfire_scatterblast_barrage",

   "aghsfort_special_snapfire_firesnap_cookie_multicookie",
   --"aghsfort_special_snapfire_firesnap_cookie_enemytarget",
   "aghsfort_special_snapfire_firesnap_cookie_allied_buff",

   "aghsfort_special_snapfire_lil_shredder_explosives",
   "aghsfort_special_snapfire_lil_shredder_ally_cast",
   --"aghsfort_special_snapfire_lil_shredder_upgrade",
   --"aghsfort_special_snapfire_lil_shredder_bouncing_bullets",

  -- "aghsfort_special_snapfire_mortimer_kisses_fragmentation",
   "snapfire_special_bonus_mortimer_kisses_projectile_count",
--   "aghsfort_special_snapfire_mortimer_kisses_fire_trail",
  -- "aghsfort_special_snapfire_mortimer_kisses_autoattack",
  -- "aghsfort_special_snapfire_mortimer_kisses_incoming_damage_reduction",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_tusk"] =
{
   --"aghsfort_special_tusk_ice_shards_circle",
   "aghsfort_special_tusk_ice_shards_secondary",
   "aghsfort_special_tusk_ice_shards_explode",
   --"aghsfort_special_tusk_ice_shards_stun",
   "aghsfort_special_tusk_ice_shards_snowball",

   "aghsfort_special_tusk_snowball_heal",
   "aghsfort_special_tusk_snowball_end_damage",
   "aghsfort_special_tusk_snowball_global",

   "aghsfort_special_tusk_tag_team_lifesteal",
   "aghsfort_special_tusk_tag_team_toggle",
   "aghsfort_special_tusk_tag_team_global",

   "tusk_frozen_sigil_pf",

   "aghsfort_special_tusk_walrus_punch_reset",
   "aghsfort_special_tusk_walrus_punch_land_damage",
   "aghsfort_special_tusk_walrus_punch_wallop",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_mars"] = 
{
   --"special_bonus_unique_mars_spear_impale_targets",
   "mars_spear_boomstick",
   "mars_spear_trail_blazer",
   "special_bonus_unique_mars_spear_distance",

   "special_bonus_unique_mars_gods_rebuke_circle",
   "aghsfort_special_mars_gods_rebuke_stun",
   "aghsfort_special_mars_gods_rebuke_strength_buff",

   "mars_bulwark_retort",
   --"aghsfort_special_mars_bulwark_healing",
   --"aghsfort_special_mars_bulwark_return",
   "mars_bulwark_bastion",
   "mars_bulwark_scepter",

   --"aghsfort_special_mars_arena_of_blood_outside_perimeter",
   --"aghsfort_special_mars_arena_of_blood_fear",
   "special_bonus_unique_mars_arena_range",
   "aghsfort_special_mars_arena_of_blood_attack_buff",
   "special_bonus_unique_mars_arena_spear_distance",
}
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_viper"] = 
{
   "aghsfort_special_viper_poison_attack_spread",
   "aghsfort_special_viper_poison_attack_explode",
   "aghsfort_special_viper_poison_snap",

   "aghsfort_special_viper_nethertoxin_lifesteal",
   "aghsfort_special_viper_nethertoxin_charges",
   "aghsfort_special_viper_nethertoxin_persist",

   "aghsfort_special_viper_corrosive_skin_speed_steal",
   "aghsfort_special_viper_corrosive_skin_flying",
   "aghsfort_special_viper_corrosive_skin_aura",

   "aghsfort_special_viper_viper_strike_allies",
   --"aghsfort_special_viper_channeled_viper_strike",
   "aghsfort_special_viper_periodic_strike",
   "aghsfort_special_viper_chain_viper_strike",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_weaver"] = 
{
   "aghsfort_special_weaver_swarm_allies",
   "aghsfort_special_weaver_swarm_explosion",
   "aghsfort_special_weaver_swarm_damage_transfer",

   "aghsfort_special_weaver_geminate_attack_splitshot",
   "aghsfort_special_weaver_geminate_attack_applies_swarm",  
   "aghsfort_special_weaver_geminate_attack_lifesteal",
  -- "aghsfort_special_weaver_geminate_attack_knockback",



  -- "aghsfort_special_weaver_shukuchi_pull",
  "aghsfort_special_weaver_shukuchi_trail",
  --"aghsfort_special_weaver_shukuchi_heal",
  "aghsfort_special_weaver_shukuchi_attack_on_completion",
  "aghsfort_special_weaver_shukuchi_swarm",
  --"aghsfort_special_weaver_shukuchi_greater_invisibility",

  "aghsfort_special_weaver_time_lapse_allies",
  "aghsfort_special_weaver_time_lapse_restoration",
  "aghsfort_special_weaver_time_lapse_explosion",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_slark"] =
{
   "aghsfort_special_slark_dark_pact_essence_shift",
   "aghsfort_special_slark_dark_pact_push_stun",
   --"aghsfort_special_slark_dark_pact_dispells_allies",
   "aghsfort_special_slark_dark_pact_unit_target",

   "aghsfort_special_slark_pounce_attack_all",
   "aghsfort_special_slark_pounce_projectiles",
   "aghsfort_special_slark_pounce_leashed_bonus",

   "aghsfort_special_slark_essence_shift_aoe_attack",
   "aghsfort_special_slark_essence_shift_leash_chance",
   "aghsfort_special_slark_essence_shift_allied_buff",

   "aghsfort_special_slark_shadow_dance_essence_shift_bonus",
   "aghsfort_special_slark_shadow_dance_dark_pact_pulses",
   "aghsfort_special_slark_shadow_dance_leash",

}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_lion"] = 
{
   "aghsfort_lion_legend_impale_split",
   "aghsfort_lion_legend_impale_shred",
   "aghsfort_lion_legend_impale_tripple",

   "aghsfort_lion_legend_voodoo_gold",
   "aghsfort_lion_legend_voodoo_aoe",
   "aghsfort_lion_legend_voodoo_death",

   "aghsfort_lion_legend_drain_ally",
   "aghsfort_lion_legend_drain_tripple",
   "aghsfort_lion_legend_drain_amp",

   "aghsfort_lion_legend_finger_charge",
   "aghsfort_lion_legend_finger_aoe",
   "aghsfort_lion_legend_finger_doom",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_gyrocopter" ] =
{
   "gyrocopter_rocket_barrage_attack",
   "gyrocopter_rocket_barrage_turret",
   "gyrocopter_rocket_barrage_shard",
   "gyrocopter_flak_cannon_scepter",
   "gyrocopter_homing_missile_calldown",
   "gyrocopter_homing_missile_minimissiles",
   "gyrocopter_flak_cannon_missile", 
   "gyrocopter_homing_missile_sledmissiles",
   "gyrocopter_call_down_strafe",
}

require( "items/item_small_scepter_fragment" )

_G.PURCHASABLE_SHARDS = {}

item_phoenix_icarus_dive_pf_cooldown = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_dash_length = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_burn_duration = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_damage_per_second = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_slow_movement_speed_pct = item_small_scepter_fragment

item_phoenix_fire_spirits_pf_cooldown = item_small_scepter_fragment
item_phoenix_fire_spirits_pf_duration = item_small_scepter_fragment
item_phoenix_fire_spirits_pf_damage_per_second = item_small_scepter_fragment
item_phoenix_fire_spirits_pf_attackspeed_slow = item_small_scepter_fragment

item_phoenix_sun_ray_pf_cooldown = item_small_scepter_fragment
item_phoenix_sun_ray_pf_hp_cost_perc_per_second = item_small_scepter_fragment
item_phoenix_sun_ray_pf_base_damage = item_small_scepter_fragment
item_phoenix_sun_ray_pf_hp_perc_heal = item_small_scepter_fragment
item_phoenix_sun_ray_pf_beam_range = item_small_scepter_fragment

item_phoenix_supernova_pf_cooldown = item_small_scepter_fragment
item_phoenix_supernova_pf_damage_per_sec = item_small_scepter_fragment
item_phoenix_supernova_pf_max_health_for_egg = item_small_scepter_fragment
item_phoenix_supernova_pf_stun_duration = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_phoenix" ] =
{
   "item_phoenix_icarus_dive_pf_cooldown",
   "item_phoenix_icarus_dive_pf_dash_length",
   "item_phoenix_icarus_dive_pf_burn_duration",
   "item_phoenix_icarus_dive_pf_damage_per_second",
   "item_phoenix_icarus_dive_pf_slow_movement_speed_pct",

   "item_phoenix_fire_spirits_pf_cooldown",
   "item_phoenix_fire_spirits_pf_duration",
   "item_phoenix_fire_spirits_pf_damage_per_second",
   "item_phoenix_fire_spirits_pf_attackspeed_slow",

   "item_phoenix_sun_ray_pf_cooldown",
   "item_phoenix_sun_ray_pf_hp_cost_perc_per_second",
   "item_phoenix_sun_ray_pf_base_damage",
   "item_phoenix_sun_ray_pf_hp_perc_heal",
   "item_phoenix_sun_ray_pf_beam_range",

   "item_phoenix_supernova_pf_cooldown",
   "item_phoenix_supernova_pf_damage_per_sec",
   "item_phoenix_supernova_pf_max_health_for_egg",
   "item_phoenix_supernova_pf_stun_duration",
   
}

--Sven
item_remake_storm_bolt_cooldown = item_small_scepter_fragment
item_remake_sven_gods_strength_cooldown = item_small_scepter_fragment
item_remake_storm_bolt_damage_talent = item_small_scepter_fragment
item_remake_great_cleave_damage_talent = item_small_scepter_fragment
item_remake_great_cleave_radius_talent = item_small_scepter_fragment
item_remake_sven_warcry_talent = item_small_scepter_fragment
item_remake_sven_warcry_duration_talent = item_small_scepter_fragment
item_remake_sven_gods_strength_talent = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_sven" ] =
{
   "item_remake_storm_bolt_cooldown",
   "item_remake_sven_gods_strength_cooldown",
   "item_remake_storm_bolt_damage_talent",
   -- "item_remake_great_cleave_damage_talent",
   "item_remake_great_cleave_radius_talent",
   "item_remake_sven_warcry_talent",
   "item_remake_sven_warcry_duration_talent",
   "item_remake_sven_gods_strength_talent",
}

--Venomancer
item_venomancer_venomous_gale_datadriven_tick_damage = item_small_scepter_fragment
item_venomancer_venomous_gale_datadriven_distance = item_small_scepter_fragment
item_venomancer_venomous_gale_datadriven_movement_slow = item_small_scepter_fragment
item_venomancer_venomous_gale_datadriven_cooldown = item_small_scepter_fragment
item_venomancer_plague_ward_datadriven_duration = item_small_scepter_fragment
item_venomancer_plague_ward_datadriven_attack_speed = item_small_scepter_fragment
item_venomancer_poison_sting_datadriven_damage = item_small_scepter_fragment
item_venomancer_poison_sting_datadriven_movement_speed = item_small_scepter_fragment
item_venomancer_poison_nova_datadriven_duration = item_small_scepter_fragment
item_venomancer_poison_nova_datadriven_cooldown = item_small_scepter_fragment
item_venomancer_poison_nova_datadriven_radius = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_venomancer" ] =
{
   "item_venomancer_venomous_gale_datadriven_tick_damage",
   "item_venomancer_venomous_gale_datadriven_distance",
   "item_venomancer_venomous_gale_datadriven_movement_slow",
   "item_venomancer_venomous_gale_datadriven_cooldown",   
   "item_venomancer_plague_ward_datadriven_duration",
   "item_venomancer_plague_ward_datadriven_attack_speed",
   "item_venomancer_poison_sting_datadriven_damage",
   "item_venomancer_poison_sting_datadriven_movement_speed",   
   "item_venomancer_poison_nova_datadriven_duration",
   "item_venomancer_poison_nova_datadriven_cooldown",
   "item_venomancer_poison_nova_datadriven_radius",
}

--Juggernaut
item_pathfinder_juggernaut_blade_fury_damage = item_small_scepter_fragment
item_pathfinder_juggernaut_blade_fury_radius = item_small_scepter_fragment
item_pathfinder_juggernaut_blade_fury_percent_cooldown = item_small_scepter_fragment
item_pathfinder_juggernaut_blade_fury_duration = item_small_scepter_fragment
item_pathfinder_juggernaut_summon_healing_ward_percent_cooldown = item_small_scepter_fragment
item_pathfinder_juggernaut_summon_healing_ward_duration = item_small_scepter_fragment
item_pathfinder_juggernaut_summon_healing_ward_max_health_regen = item_small_scepter_fragment
item_pathfinder_juggernaut_summon_healing_ward_radius = item_small_scepter_fragment
item_pathfinder_juggernaut_blade_dance_crit_chance = item_small_scepter_fragment
item_pathfinder_juggernaut_blade_dance_crit_mult = item_small_scepter_fragment
item_pathfinder_juggernaut_omni_slash_cooldown = item_small_scepter_fragment
item_pathfinder_juggernaut_omni_slash_bounce_radius = item_small_scepter_fragment
item_pathfinder_juggernaut_omni_slash_duration = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_juggernaut" ] =
{
   "item_pathfinder_juggernaut_blade_fury_damage",
   "item_pathfinder_juggernaut_blade_fury_radius",
   "item_pathfinder_juggernaut_blade_fury_percent_cooldown",
   "item_pathfinder_juggernaut_blade_fury_duration",
   "item_pathfinder_juggernaut_summon_healing_ward_percent_cooldown",
   "item_pathfinder_juggernaut_summon_healing_ward_duration",
   "item_pathfinder_juggernaut_summon_healing_ward_max_health_regen",
   "item_pathfinder_juggernaut_summon_healing_ward_radius",
   "item_pathfinder_juggernaut_blade_dance_crit_chance",
   "item_pathfinder_juggernaut_blade_dance_crit_mult",
   "item_pathfinder_juggernaut_omni_slash_cooldown",
   "item_pathfinder_juggernaut_omni_slash_bounce_radius",
   "item_pathfinder_juggernaut_omni_slash_duration",
}

--Disruptor
item_aghsfort_disruptor_thunder_strike_flat_strikes = item_small_scepter_fragment
item_aghsfort_disruptor_thunder_strike_flat_strike_damage = item_small_scepter_fragment
item_aghsfort_disruptor_glimpse_flat_bonus_damage = item_small_scepter_fragment
item_aghsfort_disruptor_glimpse_flat_cast_radius = item_small_scepter_fragment
item_aghsfort_disruptor_kinetic_field_flat_duration = item_small_scepter_fragment
item_aghsfort_disruptor_kinetic_field_formation_time = item_small_scepter_fragment
item_aghsfort_disruptor_static_storm_flat_duration = item_small_scepter_fragment
item_aghsfort_disruptor_static_storm_flat_damage_max = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_disruptor" ] =
{
   "item_aghsfort_disruptor_thunder_strike_flat_strikes",
   "item_aghsfort_disruptor_thunder_strike_flat_strike_damage",
   "item_aghsfort_disruptor_glimpse_flat_bonus_damage",
   "item_aghsfort_disruptor_glimpse_flat_cast_radius",
   "item_aghsfort_disruptor_kinetic_field_flat_duration",
   "item_aghsfort_disruptor_kinetic_field_formation_time",
   "item_aghsfort_disruptor_static_storm_flat_duration",
   "item_aghsfort_disruptor_static_storm_flat_damage_max",
}

--Mars
item_aghsfort_mars_spear_flat_damage = item_small_scepter_fragment
item_aghsfort_mars_spear_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_mars_gods_rebuke_percent_cooldown = item_small_scepter_fragment
item_aghsfort_mars_gods_rebuke_flat_crit_mult = item_small_scepter_fragment
item_aghsfort_mars_bulwark_damage_reduction_front = item_small_scepter_fragment
item_aghsfort_mars_bulwark_active_duration = item_small_scepter_fragment
item_aghsfort_mars_arena_of_blood_duration = item_small_scepter_fragment
item_aghsfort_mars_arena_of_blood_spear_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_mars" ] =
{
   "item_aghsfort_mars_spear_flat_damage",
   "item_aghsfort_mars_spear_flat_stun_duration",
   "item_aghsfort_mars_gods_rebuke_percent_cooldown",
   "item_aghsfort_mars_gods_rebuke_flat_crit_mult",
   "item_aghsfort_mars_bulwark_damage_reduction_front",
   "item_aghsfort_mars_bulwark_active_duration",
   "item_aghsfort_mars_arena_of_blood_duration",
   "item_aghsfort_mars_arena_of_blood_spear_damage",
}

--Omni
item_aghsfort_omniknight_purification_manacost = item_small_scepter_fragment
item_aghsfort_omniknight_purification_flat_heal = item_small_scepter_fragment
item_aghsfort_omniknight_repel_flat_duration = item_small_scepter_fragment
item_aghsfort_omniknight_repel_flat_damage_reduction = item_small_scepter_fragment
item_aghsfort_omniknight_degen_aura_flat_radius = item_small_scepter_fragment
item_aghsfort_omniknight_degen_aura_flat_move_speed_bonus = item_small_scepter_fragment
item_aghsfort_omniknight_guardian_angel_flat_duration = item_small_scepter_fragment
item_aghsfort_omniknight_guardian_angel_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_omniknight" ] =
{
   "item_aghsfort_omniknight_purification_manacost",
   "item_aghsfort_omniknight_purification_flat_heal",
   "item_aghsfort_omniknight_repel_flat_duration",
   "item_aghsfort_omniknight_repel_flat_damage_reduction",
   "item_aghsfort_omniknight_degen_aura_flat_radius",
   "item_aghsfort_omniknight_degen_aura_flat_move_speed_bonus",
   "item_aghsfort_omniknight_guardian_angel_flat_duration",
   "item_aghsfort_omniknight_guardian_angel_cooldown",
}

--Slark
item_aghsfort_slark_dark_pact_cooldown = item_small_scepter_fragment
item_aghsfort_slark_dark_pact_total_damage = item_small_scepter_fragment
item_aghsfort_slark_pounce_distance = item_small_scepter_fragment
item_aghsfort_slark_pounce_damage = item_small_scepter_fragment
item_aghsfort_slark_essence_shift_agi_gain = item_small_scepter_fragment
item_aghsfort_slark_essence_shift_max_stacks = item_small_scepter_fragment
item_aghsfort_slark_shadow_dance_duration = item_small_scepter_fragment
item_aghsfort_slark_shadow_dance_bonus_bonus_regen_pct = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_slark" ] =
{
   "item_aghsfort_slark_dark_pact_cooldown",
   "item_aghsfort_slark_dark_pact_total_damage",
   "item_aghsfort_slark_pounce_distance",
   "item_aghsfort_slark_pounce_damage",
   "item_aghsfort_slark_essence_shift_agi_gain",
   "item_aghsfort_slark_essence_shift_max_stacks",
   "item_aghsfort_slark_shadow_dance_duration",
   "item_aghsfort_slark_shadow_dance_bonus_bonus_regen_pct",
}

--Snapfire
item_aghsfort_snapfire_scatterblast_flat_damage = item_small_scepter_fragment
item_aghsfort_snapfire_scatterblast_pct_cooldown = item_small_scepter_fragment
item_aghsfort_snapfire_firesnap_cookie_flat_impact_damage = item_small_scepter_fragment
item_aghsfort_snapfire_firesnap_cookie_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_snapfire_lil_shredder_flat_damage = item_small_scepter_fragment
item_aghsfort_snapfire_lil_shredder_flat_attacks = item_small_scepter_fragment
item_aghsfort_snapfire_mortimer_kisses_flat_projectile_count = item_small_scepter_fragment
item_aghsfort_snapfire_mortimer_kisses_flat_burn_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_snapfire" ] =
{
   "item_aghsfort_snapfire_scatterblast_flat_damage",
   "item_aghsfort_snapfire_scatterblast_pct_cooldown",
   "item_aghsfort_snapfire_firesnap_cookie_flat_impact_damage",
   "item_aghsfort_snapfire_firesnap_cookie_flat_stun_duration",
   "item_aghsfort_snapfire_lil_shredder_flat_damage",
   "item_aghsfort_snapfire_lil_shredder_flat_attacks",
   "item_aghsfort_snapfire_mortimer_kisses_flat_projectile_count",
   "item_aghsfort_snapfire_mortimer_kisses_flat_burn_damage",
}

--Tusk
item_aghsfort_tusk_ice_shards_flat_damage = item_small_scepter_fragment
item_aghsfort_tusk_ice_shards_flat_shard_duration = item_small_scepter_fragment
item_aghsfort_tusk_snowball_flat_snowball_damage = item_small_scepter_fragment
item_aghsfort_tusk_snowball_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_tusk_tag_team_flat_damage = item_small_scepter_fragment
item_aghsfort_tusk_tag_team_pct_cooldown = item_small_scepter_fragment
item_aghsfort_tusk_walrus_punch_pct_cooldown = item_small_scepter_fragment
item_aghsfort_tusk_walrus_punch_flat_crit_multiplier = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_tusk" ] =
{
   "item_aghsfort_tusk_ice_shards_flat_damage",
   "item_aghsfort_tusk_ice_shards_flat_shard_duration",
   "item_aghsfort_tusk_snowball_flat_snowball_damage",
   "item_aghsfort_tusk_snowball_flat_stun_duration",
   "item_aghsfort_tusk_tag_team_flat_damage",
   "item_aghsfort_tusk_tag_team_pct_cooldown",
   "item_aghsfort_tusk_walrus_punch_pct_cooldown",
   "item_aghsfort_tusk_walrus_punch_flat_crit_multiplier",
}

--Viper
item_aghsfort_viper_poison_attack_damage = item_small_scepter_fragment
item_aghsfort_viper_poison_attack_magic_resistance = item_small_scepter_fragment
item_aghsfort_viper_nethertoxin_max_damage = item_small_scepter_fragment
item_aghsfort_viper_nethertoxin_radius = item_small_scepter_fragment
item_aghsfort_viper_corrosive_skin_bonus_magic_resistance = item_small_scepter_fragment
item_aghsfort_viper_corrosive_skin_damage = item_small_scepter_fragment
item_aghsfort_viper_viper_strike_duration = item_small_scepter_fragment
item_aghsfort_viper_viper_strike_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_viper" ] =
{
   "item_aghsfort_viper_poison_attack_damage",
   "item_aghsfort_viper_poison_attack_magic_resistance",
   "item_aghsfort_viper_nethertoxin_max_damage",
   "item_aghsfort_viper_nethertoxin_radius",
   "item_aghsfort_viper_corrosive_skin_bonus_magic_resistance",
   "item_aghsfort_viper_corrosive_skin_damage",
   "item_aghsfort_viper_viper_strike_duration",
   "item_aghsfort_viper_viper_strike_damage",
}

--Weaver
item_aghsfort_weaver_the_swarm_flat_armor_reduction = item_small_scepter_fragment
item_aghsfort_weaver_the_swarm_flat_damage = item_small_scepter_fragment
item_aghsfort_weaver_the_swarm_percent_cooldown = item_small_scepter_fragment
item_aghsfort_weaver_shukuchi_flat_damage = item_small_scepter_fragment
item_aghsfort_weaver_shukuchi_duration = item_small_scepter_fragment
item_aghsfort_weaver_geminate_attack_cooldown = item_small_scepter_fragment
item_aghsfort_weaver_geminate_attack_flat_bonus_damage = item_small_scepter_fragment
item_aghsfort_weaver_time_lapse_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_weaver" ] =
{
   "item_aghsfort_weaver_the_swarm_flat_armor_reduction",
   "item_aghsfort_weaver_the_swarm_flat_damage",
   "item_aghsfort_weaver_the_swarm_percent_cooldown",
   "item_aghsfort_weaver_shukuchi_flat_damage",
   "item_aghsfort_weaver_shukuchi_duration",
   "item_aghsfort_weaver_geminate_attack_cooldown",
   "item_aghsfort_weaver_geminate_attack_flat_bonus_damage",
   "item_aghsfort_weaver_time_lapse_cooldown",
}

require("heroes/shadow_fiend/aghanim_ability_upgrade_constants")
require("heroes/zuus/aghanim_ability_upgrade_constants")
require("heroes/medusa/aghanim_ability_upgrade_constants")
require("heroes/marci/aghanim_ability_upgrade_constants")
require("heroes/bristleback/aghanim_ability_upgrade_constants")
require("heroes/sniper/aghanim_ability_upgrade_sniper")
require("heroes/queenofpain/aghanim_ability_upgrade_queenofpain")
require("heroes/winter_wyvern/aghanim_ability_upgrade_winter_wyvern")
require("heroes/magnus/aghanim_ability_upgrade_magnus")
require("heroes/lich/aghanim_ability_upgrade_lich")
require("heroes/lina/aghanim_ability_upgrade_lina")
require("heroes/luna/aghanim_ability_upgrade_luna")
require("heroes/templar_assassin/aghanim_ability_upgrade_templar_assassin")
require("heroes/axe/aghanim_ability_upgrade_axe")
require("heroes/witch_doctor/aghanim_ability_upgrade_witch_doctor")
require("heroes/dawnbreaker/aghanim_ability_upgrade_dawnbreaker")
require("heroes/windranger/aghanim_ability_upgrade_windranger")
require("heroes/phantom_assassin/aghanim_ability_upgrade_phantom_assassin")
require("heroes/legion_commander/aghanim_ability_upgrade_legion_commander")
require("heroes/ogre_magi/aghanim_ability_upgrade_ogre_magi")
require("heroes/tidehunter/aghanim_ability_upgrade_tidehunter")
require("heroes/furry/aghanim_ability_upgrade_hoodwink")
require("heroes/jakiro/aghanim_ability_upgrade_jakiro")
require("heroes/dragon_knight/aghanim_ability_upgrade_dragon_knight")
require("heroes/dazzle/aghanim_ability_upgrade_dazzle")
require("heroes/void_spirit/aghanim_ability_upgrade_void_spirit")
require("heroes/ursa/aghanim_ability_upgrade_ursa")