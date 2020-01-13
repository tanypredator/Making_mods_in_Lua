function FindAtmosphereChange()
	local currentPlants = GetTerraformParam("Vegetation")
	return floatfloor((currentPlants/2400)*(150000/(currentPlants+50000)))
end

function FindTemperatureChange()
	local SpaceMirrors = 400*SpaceMirrorsCount()/24
	local currentAir = GetTerraformParam("Atmosphere")
	local currentHeat = GetTerraformParam("Temperature")
	return floatfloor((currentAir*0.7-currentHeat)/480)+SpaceMirrors
end

function FindWaterChange()
	local currentWater = GetTerraformParam("Water")
	local currentHeat = GetTerraformParam("Temperature")
	return floatfloor((currentHeat*0.8-currentWater)/480)
end

function FindVegetationChange()
	local currentPlants = GetTerraformParam("Vegetation")
	local currentWater = GetTerraformParam("Water")
	local currentHeat = GetTerraformParam("Temperature")
	local currentAir = GetTerraformParam("Atmosphere")

	local minEnv = Min(currentAir,currentHeat,currentWater)
	if minEnv < currentPlants then
		return floatfloor((minEnv-currentPlants)/24)
	elseif minEnv >= currentPlants then
		return floatfloor((minEnv-currentPlants)*currentPlants/96000000)
	end
end

function OnMsg.NewHour(hour)

	--Get current terraforming values

	local airChange = FindAtmosphereChange ()
	local heatChange = FindTemperatureChange()
	local waterChange = FindWaterChange()
	local plantsChange = FindVegetationChange()
	--Apply changes
	ChangeTerraformParam("Atmosphere",airChange)
	ChangeTerraformParam("Temperature",heatChange)
	ChangeTerraformParam("Water",waterChange)
	ChangeTerraformParam("Vegetation",plantsChange)
end