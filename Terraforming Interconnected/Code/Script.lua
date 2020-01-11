local Building_Template_Id = "GHGFactory"
local function FixIcons()
	-- local the building template
	local bt = BuildingTemplates[Building_Template_Id]

	-- building menu icon
	bt.display_icon = "UI/Icons/Buildings/ghg_factory.tga"

end

-- new games
OnMsg.CityStart = FixIcons
-- saved games
OnMsg.LoadGame = FixIcons

math = {}

local function CheckNum(x, name, arg)
	x = tonumber(x)
	if x then
		return x
	else
		print(str.error:format(arg or 1, name, str.nan))
		return 0/0
	end
end

math.floor = rawget(_G, "floatfloor") or function(x)
	x = CheckNum(x, str.floor)

	return x - (x % 1)
end

math.min = Min

function OnMsg.NewHour(hour)

	--Get current terraforming values
	local currentAir = GetTerraformParam("Atmosphere")
	local currentHeat = GetTerraformParam("Temperature")
	local currentWater = GetTerraformParam("Water")
	local currentPlants = GetTerraformParam("Vegetation")
	--Calculate changes
	local airChange = floatfloor((currentPlants/2400)*(150000/(currentPlants+50000)))
	local heatChange = floatfloor((currentAir*0.7-currentHeat)/480)
	local waterChange = floatfloor((currentHeat*0.8-currentWater)/480)
	local plantsChange
	local minEnv = math.min(currentAir,currentHeat,currentWater)
	if minEnv < currentPlants then
		plantsChange = floatfloor((minEnv-currentPlants)/24)
	elseif minEnv >= currentPlants then
		plantsChange = floatfloor((minEnv-currentPlants)*currentPlants/96000000)
	end
	--Apply changes
	ChangeTerraformParam("Atmosphere",airChange)
	ChangeTerraformParam("Temperature",heatChange)
	ChangeTerraformParam("Water",waterChange)
	ChangeTerraformParam("Vegetation",plantsChange)
end