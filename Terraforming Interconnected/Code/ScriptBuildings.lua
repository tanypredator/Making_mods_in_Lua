--Atmosphere production for OpenFarm isn't working

--Water and power production / consumption don't seem to be editable here either

--Scaling for lakes and forestation plants needs implementing

--Upgrade for magnetic field generator needs to be changed

--Some things ONLY seem to work if declared outside function?!

BuildingTemplates.CoreHeatConvector.terraforming_param = "Water"
BuildingTemplates.CoreHeatConvector.terraforming_boost_sol = 200

local function ChangeBuildings()

BuildingTemplates.GHGFactory.maintenance_resource_type = "Metals"
BuildingTemplates.GHGFactory.description = "Produces fluorine compounds that act as potent greenhouse gasses, effectively improving the global Temperature<image UI/Icons/res_temperature.tga 1300>. Has significantly boosted terraforming effect at low Temperature<image UI/Icons/res_temperature.tga 1300>."

BuildingTemplates.CarbonateProcessor.maintenance_resource_type = "Concrete"
BuildingTemplates.CarbonateProcessor.maintenance_resource_amount = 4000
BuildingTemplates.CarbonateProcessor.construction_cost_Concrete = 60000
BuildingTemplates.CarbonateProcessor.construction_cost_Metals = 20000
BuildingTemplates.CarbonateProcessor.construction_cost_MachineParts = 10000

BuildingTemplates.OpenFarm.maintenance_resource_type = "MachineParts"
BuildingTemplates.OpenFarm.maintenance_resource_amount = 1000
BuildingTemplates.OpenFarm.terraforming_param = "Atmosphere"
BuildingTemplates.OpenFarm.terraforming_boost_sol = 50
BuildingTemplates.OpenFarm.water_consumption = 5000

BuildingTemplates.CoreHeatConvector.display_name = "Deep Aquifer Extractor"
BuildingTemplates.CoreHeatConvector.display_name_pl = "Deep Aquifer Extractors"
BuildingTemplates.CoreHeatConvector.description = "Extracts water from aquifers deep below the Martian surface and releases it into the atmosphere, improving global Water<image UI/Icons/res_water.tga 1300>. Provides clean Water for the colony."
BuildingTemplates.CoreHeatConvector.construction_cost_Concrete = 100000
BuildingTemplates.CoreHeatConvector.construction_cost_Metals = 150000
BuildingTemplates.CoreHeatConvector.construction_cost_Polymers = 50000
BuildingTemplates.CoreHeatConvector.maintenance_resource_amount = 4000
BuildingTemplates.CoreHeatConvector.terraforming_param = "Water"
BuildingTemplates.CoreHeatConvector.terraforming_boost_sol = 200
BuildingTemplates.CoreHeatConvector.water_consumption = 0
BuildingTemplates.CoreHeatConvector.water_production = 10000

BuildingTemplates.MagneticFieldGenerator.display_name = "Geothermal Heat Exchanger"
BuildingTemplates.MagneticFieldGenerator.display_name_pl = "Geothermal Heat Exchangers"
BuildingTemplates.MagneticFieldGenerator.description = "By drilling deep into the Martian crust, internal heat can be brought to the surface. The geothermal heat exchanger improves global Temperature<image UI/Icons/res_temperature.tga 1300>, protects against cold waves and provides a source of power for the colony."
BuildingTemplates.MagneticFieldGenerator.construction_cost_Concrete = 50000
BuildingTemplates.MagneticFieldGenerator.construction_cost_Metals = 200000
BuildingTemplates.MagneticFieldGenerator.construction_cost_Electronics = 50000
BuildingTemplates.MagneticFieldGenerator.maintenance_resource_type = "Metals"
BuildingTemplates.MagneticFieldGenerator.maintenance_resource_amount = 5000
BuildingTemplates.MagneticFieldGenerator.terraforming_param = "Temperature"
BuildingTemplates.MagneticFieldGenerator.terraforming_boost_sol = 200
BuildingTemplates.MagneticFieldGenerator.electricity_consumption = 0
BuildingTemplates.MagneticFieldGenerator.electricity_production = 100000

end

OnMsg.CityStart = ChangeBuildings
OnMsg.ClassesBuilt = ChangeBuildings
OnMsg.LoadGame = ChangeBuildings

function CarbonateProcessor:GetTerraformingBoostSol()
  if GetTerraformParamPct(self.terraforming_param) < 25 then
    return self.terraforming_boost_sol
  end
  return self.terraforming_boost_sol*0.25
end