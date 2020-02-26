--Atmosphere production for OpenFarm isn't working

function CarbonateProcessor:GetTerraformingBoostSol()
	local currentAir = GetTerraformParam("Atmosphere")
	if  currentAir < 25000 then
    return self.terraforming_boost_sol*4
	elseif currentAir < 40000 then
	return self.terraforming_boost_sol*3
	elseif currentAir < 55000 then
	return self.terraforming_boost_sol*2
	else
	return self.terraforming_boost_sol
	end
end

function GHGFactory:GetTerraformingBoostSol()
	local currentHeat = GetTerraformParam("Temperature")
	if  currentHeat < 15000 then
    return self.terraforming_boost_sol*4
	elseif currentHeat < 20000 then
	return self.terraforming_boost_sol*3
	elseif currentHeat < 25000 then
	return self.terraforming_boost_sol*2
	else
	return self.terraforming_boost_sol
	end
end

function ForestationPlant:GetTerraformingBoostSol()

	local currentAir = GetTerraformParam("Atmosphere")
	local currentHeat = GetTerraformParam("Temperature")
	local currentWater = GetTerraformParam("Water")
	local minEnv = Min(currentAir,currentHeat,currentWater)

if minEnv > 25000 then
    return self.terraforming_boost_sol*minEnv/25000
end
    return self.terraforming_boost_sol
end

BuildingTemplates.CarbonateProcessor.maintenance_resource_type = "Concrete"
BuildingTemplates.CarbonateProcessor.maintenance_resource_amount = 4000
BuildingTemplates.CarbonateProcessor.terraforming_boost_sol = 100
BuildingTemplates.CarbonateProcessor.electricity_consumption = 20000
BuildingTemplates.CarbonateProcessor.consumption_amount = 30000

BuildingTemplates.OpenFarm.maintenance_resource_type = "MachineParts"
BuildingTemplates.OpenFarm.maintenance_resource_amount = 1000

BuildingTemplates.GHGFactory.maintenance_resource_type = "Metals"
BuildingTemplates.GHGFactory.description = "Produces fluorine compounds that act as potent greenhouse gasses, effectively improving the global Temperature<image UI/Icons/res_temperature.tga 1300>. Has significantly boosted terraforming effect at low Temperature<image UI/Icons/res_temperature.tga 1300>."

BuildingTemplates.ForestationPlant.description = "Consumes Seeds to plant wild vegetation, increasing local Soil Quality. Plants will wither or grow according to local Soil Quality and global Atmosphere<image UI/Icons/res_atmosphere.tga 1300> Temperature<image UI/Icons/res_temperature.tga 1300> and Water <image UI/Icons/res_water_2.tga 1300>. Improves global Vegetation <image UI/Icons/res_vegetation.tga 1300> depending on environmental conditions. Doesn’t work during Dust Storms and Toxic Rains."

local function ChangeBuildings()

BuildingTemplates.CarbonateProcessor.construction_cost_Concrete = 60000
BuildingTemplates.CarbonateProcessor.construction_cost_Metals = 20000
BuildingTemplates.CarbonateProcessor.construction_cost_MachineParts = 10000
ClassTemplates.Building.CarbonateProcessor.construction_cost_Concrete = 60000
ClassTemplates.Building.CarbonateProcessor.construction_cost_Metals = 20000
ClassTemplates.Building.CarbonateProcessor.construction_cost_MachineParts = 10000

BuildingTemplates.OpenFarm.terraforming_param = "Atmosphere"
BuildingTemplates.OpenFarm.terraforming_boost_sol = 50
BuildingTemplates.OpenFarm.water_consumption = 5000

BuildingTemplates.CoreHeatConvector.terraforming_param = ""

end

OnMsg.CityStart = ChangeBuildings
OnMsg.ClassesBuilt = ChangeBuildings
OnMsg.LoadGame = ChangeBuildings

function OnMsg.ClassesPostprocess()
BuildingTemplates.MagneticFieldGenerator.build_category = "Hidden"
BuildingTemplates.MagneticFieldGenerator.Group = "Hidden"
BuildingTemplates.CoreHeatConvector.build_category = "Hidden"
BuildingTemplates.CoreHeatConvector.Group = "Hidden"

end