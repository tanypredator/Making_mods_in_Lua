return {

PlaceObj("ModItemTechPreset", {
  SortKey = 15,
  description = T(0, [[New Building: <color em>Geothermal Power Plant</color> (50<image UI/Icons/res_concrete.tga 1300> 200<image UI/Icons/res_metal.tga 1300> 50<image UI/Icons/res_electronics.tga 1300>) Produces power and improves the Temperature <image UI/Icons/res_temperature.tga 1300> of Mars gradually.\n\n<color flavor>"If the world seems cold to you, kindle fires to warm it." \n<right>Lucy Larcom</color><left>]]),
  display_name = T(0, "Geothermal Power Plant"),
  group = "Terraforming",
  icon = "UI/Icons/Research/magnetic_field_generator.tga",
  id = "MagneticFieldGenerator",
  position = range(11, 15),
  save_in = "armstrong",
  PlaceObj("Effect_TechUnlockBuilding", {
    Building = "RDM_GeoPowerPlant"
  })
}),

PlaceObj('ModItemCode', {
	'name', "ScriptParameters",
	'FileName', "Code/ScriptParameters.lua",
}),
PlaceObj('ModItemCode', {
	'name', "ScriptInfopanel",
	'FileName', "Code/ScriptInfopanel.lua",
}),
PlaceObj('ModItemCode', {
	'name', "ScriptBuildings.lua",
	'FileName', "Code/ScriptBuildings.lua",
}),
PlaceObj('ModItemCode', {
	'name', "ScriptTechs.lua",
	'FileName', "Code/ScriptTechs.lua",
}),
PlaceObj('ModItemCode', {
	'name', "ScriptMissions.lua",
	'FileName', "Code/ScriptMissions.lua",
}),
PlaceObj('ModItemCode', {
	'name', "ScriptVegetation.lua",
	'FileName', "Code/ScriptVegetation.lua",
}),
--[[PlaceObj('ModItemCode', {
	'name', "ScriptClasses.lua",
	'FileName', "Code/ScriptClasses.lua",
}),]]

PlaceObj('ModItemActionFXLight', {
	Action = "Working",
	Actor = "RDM_GeoPowerPlant",
	Color = -6161925,
	Color0 = -8987137,
	Color1 = -7208983,
	DetailLevel = 60,
	EndRules = {
		PlaceObj('ActionFXEndRule', {
			'EndMoment', "end",
		}),
	},
	FadeOut = 2,
	FadeOutColor = -4729089,
	FadeOutIntensity = 5,
	Flicker = true,
	GameTimeAnimated = true,
	Intensity = 12,
	Intensity0 = 30,
	Intensity1 = 30,
	Moment = "start",
	Period = 20000,
	Radius = 10000,
	Spot = "Greatsteam",
	StartColor = -1903365,
	behaviors = {
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
	},
	group = "Default",
	handle = 1295485419,
	id = "",
}),
PlaceObj('ModItemActionFXParticles', {
	Action = "Working",
	Actor = "RDM_GeoPowerPlant",
	DetailLevel = 100,
	EndRules = {
		PlaceObj('ActionFXEndRule', {
			'EndMoment', "end",
		}),
	},
	Moment = "start",
	OffsetDir = "SourceAxisZ",
	Particles = "RDM_Greatsteam_1",
	Spot = "Greatsteam",
	SpotsPercent = 100,
	behaviors = {
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
	},
	comment = "Working Greatsteam",
	group = "Default",
	handle = 1785201034,
	id = "",
}),
PlaceObj('ModItemActionFXParticles', {
	Action = "Working",
	Actor = "RDM_GeoPowerPlant",
	Attach = true,
	DetailLevel = 100,
	EndRules = {
		PlaceObj('ActionFXEndRule', {
			'EndMoment', "end",
		}),
	},
	Moment = "start",
	OffsetDir = "SourceAxisZ",
	Particles = "RDM_Faststeam_1",
	Spot = "Steam",
	SpotsPercent = 100,
	behaviors = {
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
	},
	comment = "Working Steam",
	group = "Default",
	handle = 1694435740,
	id = "",
}),
PlaceObj('ModItemBuildingTemplate', {
	'Group', "Power",
	'Id', "RDM_GeoPowerPlant",
	'template_class', "RDM_GeoPowerPlant",
	'pin_rollover_context', "electricity",
	'pin_rollover_hint', T(400692736150, --[[ModItemBuildingTemplate RDM_GeoPowerPlant pin_rollover_hint]] "<image UI/Infopanel/left_click.tga 1400> Select"),
	'pin_rollover_hint_xbox', T(167545854788, --[[ModItemBuildingTemplate RDM_GeoPowerPlant pin_rollover_hint_xbox]] "<image UI/PS4/Cross.tga> View"),
	'construction_cost_Concrete', 25000,
	'construction_cost_MachineParts', 15000,
	'build_points', 5000,
	'is_tall', true,
	'dome_forbidden', true,
	'upgrade1_id', "RDM_GeoPowerPlant_AdvancedTurbine",
	'upgrade1_display_name', T(785141562533, --[[ModItemBuildingTemplate RDM_GeoPowerPlant upgrade1_display_name]] "Advanced Turbine"),
	'upgrade1_description', T(1337001, --[[ModItemBuildingTemplate RDM_GeoPowerPlant upgrade1_description]] "+<upgrade1_mul_value_1>% Power Production."),
	'upgrade1_icon', "UI/Icons/Upgrades/automation_01.tga",
	'upgrade1_upgrade_cost_MachineParts', 15000,
	'upgrade1_mod_label_1', "RDM_GeoPowerPlant",
	'upgrade1_mod_prop_id_1', "electricity_production",
	'upgrade1_mul_value_1', 100,
	'maintenance_resource_type', "MachineParts",
	'maintenance_resource_amount', 2000,
	'display_name', T(240851989374, --[[ModItemBuildingTemplate RDM_GeoPowerPlant display_name]] "Geothermal Power Plant"),
	'display_name_pl', T(120980284584, --[[ModItemBuildingTemplate RDM_GeoPowerPlant display_name_pl]] "Geothermal Power Plants"),
	'description', T(697048727602, --[[ModItemBuildingTemplate RDM_GeoPowerPlant description]] "Generates lot of energy and a small heat area. It requires Engineers and water to work."),
	'build_category', "Power",
	'display_icon', "UI/Icons/Buildings/sGeothermalPowerPlant.tga",
	'build_pos', 5,
	'entity', "RDM_GeoPowerPlant",
	'label1', "OutsideBuildings",
	'label2', "OutsideBuildingsTargets",
	'palette_color1', "mining_base",
	'palette_color2', "mining_accent_1",
	'clear_soil_underneath', true,
	'electricity_production', 60000,
	'max_workers', 3,
	'specialist', "geologist",
	'water_consumption', 1500,
	'air_consumption', 0,
	'terraforming_param', "Atmosphere",
	'terraforming_boost_sol', 50,
}),


PlaceObj('ModItemCode', {
	'name', "Class_RDM_GeoPowerPlant",
	'FileName', "Code/Class_RDM_GeoPowerPlant.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Init",
	'FileName', "Code/Init.lua",
}),
PlaceObj('ModItemCode', {
	'name', "SavegameFix",
	'FileName', "Code/SavegameFix.lua",
}),
PlaceObj('ModItemEntity', {
	'name', "RDM_GeoPowerPlant",
	'entity_name', "RDM_GeoPowerPlant",
	'import', "Entities/RDM_GeoPowerPlant.ent",
}),
PlaceObj('ModItemEntity', {
	'name', "RDM_GeoPowerPlantGenerator",
	'entity_name', "RDM_GeoPowerPlantGenerator",
	'import', "Entities/RDM_GeoPowerPlantGenerator.ent",
}),
PlaceObj('ModItemEntity', {
	'name', "RDM_GeoPowerPlantTurbine",
	'entity_name', "RDM_GeoPowerPlantTurbine",
	'import', "Entities/RDM_GeoPowerPlantTurbine.ent",
}),

PlaceObj('ModItemActionFXSound', {
	Action = "SelectObj",
	Actor = "RDM_GeoPowerPlant",
	Moment = "start",
	Sound = "Object FusionReactor Select",
	comment = "SelectObj",
	group = "Default",
	id = "",
}),
PlaceObj('ModItemActionFXSound', {
	Action = "Working",
	Actor = "RDM_GeoPowerPlant",
	Moment = "start",
	Sound = "Object FusionReactor LoopStart",
	comment = "Working Start",
	group = "Default",
	id = "",
}),
PlaceObj('ModItemActionFXSound', {
	Action = "SelectObj",
	Actor = "RDM_GeoPowerPlant",
	Moment = "start",
	Sound = "UI SelectBuilding",
	Source = "UI",
	comment = "SelectObj UI",
	group = "Default",
	id = "",
}),
PlaceObj('ModItemActionFXSound', {
	Action = "Working",
	Actor = "RDM_GeoPowerPlant",
	Moment = "end",
	Sound = "Object FusionReactor LoopStop",
	comment = "Working End",
	group = "Default",
	id = "",
}),
PlaceObj('ModItemActionFXSound', {
	Action = "Destroyed",
	Actor = "RDM_GeoPowerPlant",
	Moment = "start",
	Sound = "Object FusionReactor Demolition",
	comment = "Destroyed",
	group = "Default",
	id = "",
}),
PlaceObj('ModItemActionFXSound', {
	Action = "Spawn",
	Actor = "RDM_GeoPowerPlant",
	Moment = "start",
	Sound = "UI BuildComplete",
	Source = "UI",
	comment = "Spaw",
	group = "Default",
	id = "",
}),
PlaceObj('ModItemActionFXSound', {
	Action = "Working",
	Actor = "RDM_GeoPowerPlant",
	AttachToObj = true,
	DetailLevel = 60,
	EndRules = {
		PlaceObj('ActionFXEndRule', {
			'EndMoment', "end",
		}),
	},
	FadeIn = 1500,
	FadeOut = 1000,
	Moment = "start",
	Sound = "Building RDM_Factory1 Loop",
	behaviors = {
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
		PlaceObj('ActionFXBehavior', nil),
	},
	comment = "Working",
	group = "Default",
	id = "",
}),
PlaceObj('ModItemActionFXSound', {
	Action = "Breakdown",
	Actor = "RDM_GeoPowerPlant",
	Moment = "start",
	Sound = "Object FusionReactor Fail",
	comment = "Breakdown",
	group = "Default",
	id = "",
}),
PlaceObj("ModItemBuildingTemplate", {
  "Group",  "Hidden",
  "SaveIn",  "armstrong",
  "Id",  "MagneticFieldGenerator",
  "template_class",  "MagneticFieldGenerator",
  "construction_cost_Metals",  250000,
  "construction_cost_Electronics",  50000,
  "build_points",  100000,
  "dome_forbidden",  true,
  "upgrade1_id",  "MagneticFieldGenerator_Amplify",
  "upgrade1_display_name",  T(587908642055, "Amplify"),
  "upgrade1_description",  T(656496435467, "+<upgrade1_mul_value_1>% more reduction; +<power(upgrade1_add_value_2)> Consumption."),
  "upgrade1_icon",  "UI/Icons/Upgrades/amplify_01.tga",
  "upgrade1_upgrade_cost_Polymers",  10000,
  "upgrade1_mod_label_1",  "MagneticFieldGenerator",
  "upgrade1_mod_prop_id_1",  "decay_atmosphere_reduct",
  "upgrade1_mul_value_1",  50,
  "upgrade1_mod_label_2",  "MagneticFieldGenerator",
  "upgrade1_mod_prop_id_2",  "electricity_consumption",
  "upgrade1_add_value_2",  20000,
  "maintenance_resource_type",  "Metals",
  "maintenance_resource_amount",  10000,
  "display_name",  T(337421482752, "Magnetic Field Generator"),
  "display_name_pl",  T(747648281692, "Magnetic Field Generators"),
  "description",  T(832863675408, "Improves the magnetic field of the planet, decreasing the loss of Atmosphere by <resource(decay_atmosphere_reduct,'AtmosphereTP')> per Sol. Generates Research proportionally to the current Atmosphere. May trigger localized Marsquakes."),
  "build_category",  "Hidden",
  "display_icon",  "UI/Icons/Buildings/magnetic_field_generator.tga",
  "build_pos",  7,
  "entity",  "MagneticFieldGenerator",
  "encyclopedia_id",  "MagneticFieldGenerator",
  "encyclopedia_image",  "UI/Encyclopedia/MagneticFieldGenerator.tga",
  "label1",  "OutsideBuildings",
  "label2",  "OutsideBuildingsTargets",
  "label3",  "ResearchBuildings",
  "palette_color1",  "outside_base",
  "palette_color2",  "outside_accent_1",
  "palette_color3",  "outside_metal",
  "demolish_sinking",  range(0, 0),
  "penalty_heat",  100,
  "freeze_heat",  0,
  "electricity_consumption",  100000
})

}
