return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 9,
		}),
	},
	"title", "Place-a-RainLake",
	"version", 1,
	"version_major", 0,
	"version_minor", 0,
	"saved", 0,
	"image", "Preview.png",
	"id", "Place-a-RainLake",
	"steam_id", "1743037328",
	"pops_any_uuid", "9f01952e-daec-4fc8-a10b-f8754a147663",
	"author", "Tanypredator and ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a marker for a future lake. It will be filled with rains when they start. At the beginning water surface will look ugly because of "waves" effect. You can elevate the water level with a button, until it looks OK. The lake will improve the "Water" teraforming parameter and local soil quality, when the rains fill in enough water.]],
	"TagTerraforming", true,
	"TagLandscaping", true,
})