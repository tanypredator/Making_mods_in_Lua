--[[local GetParamDescription = function(name)
  local param = Presets.TerraformingParam.Default[name]
  if not param then
    return ""
  end
  local res = name .. "TP"
  local tmp = {}
  for template_name, template in sorted_pairs(BuildingTemplates) do
    local classdef = g_Classes[template.template_class]
    if IsKindOf(classdef, "TerraformingBuildingBase") and template.terraforming_param == name then
      local sum = 0
      for _, building in ipairs(UICity.labels.TerraformingBuilding or empty_table) do
        if building.terraforming_param == name and building.template_name == template_name then
          sum = sum + building:GetTerraformingBoost()
        end
      end
      local display_name = template.display_name_pl
      tmp[#tmp + 1] = {
        text = display_name,
        value = T({
          12553,
          "From <building> <right><resource(sum, res)> per Sol<newline><left>",
          building = display_name,
          sum = sum,
          res = res
        })
      }
    end
  end
  TSort(tmp, "text")
  local description = {}
  for i = 1, #tmp do
    description[#description + 1] = tmp[i].value
  end
  for _, factor in ipairs(param.Factors or empty_table) do
    local name = factor.display_name
    local value = factor:GetFactorValue()
    local units = factor.units
    local str
    if units == "PerSol" then
      str = T({
        12554,
        "<name><right><resource(value,res)> per Sol<newline><left>",
        name = name,
        value = value,
        res = res
      })
    else
      str = T({
        12555,
        "<name><right><value><newline><left>",
        name = name,
        value = value
      })
    end
    description[#description + 1] = str
  end
  if param.description then
    description[#description + 1] = T(316, "<newline>")
    description[#description + 1] = param.description or nil
  end
  return table.concat(description, "")
end]]

function OnMsg.ClassesPostprocess()
local AtmChange = Presets.TerraformingParam.Default["Atmosphere"]

--[[if AtmChange.Factors[AtmosphereChange]  then
       table.remove(AtmChange.Factors, AtmosphereChange)
end]]

AtmChange.Factors = {
    PlaceObj("TerraformingFactorItem", {
      "Id",
      "AtmosphereDecay",
      "display_name",
      T(206931232175, "Loss of atmosphere"),
      "units",
      "PerSol",
      "GetFactorValue",
      function(self)
        return GetSolAtmosphereDecay()
      end
    }),
    PlaceObj("TerraformingFactorItem", {
      "Id",
      "MagneticShields",
      "display_name",
      T(277656568245, "Magnetic Shields"),
      "GetFactorValue",
      function(self)
        return GetMagneticShieldsCount()
      end
    }),
PlaceObj("TerraformingFactorItem", {
      "Id",
      "AtmosphereChange",
      "display_name",
      T(0, "Atmosphere Change"),
      "units",
      "PerSol",
      "GetFactorValue",
      function(self)
        return 0.24*FindAtmosphereChange()
      end
    })
  }

local TempChange = Presets.TerraformingParam.Default["Temperature"]

TempChange.Factors = {
		PlaceObj("TerraformingFactorItem", {
      "Id",
      "TemperatureChange",
      "display_name",
      T(0, "Temperature Change"),
      "units",
      "PerSol",
      "GetFactorValue",
      function(self)
        return 0.24*FindTemperatureChange()
      end
    })
}

local WaterChange = Presets.TerraformingParam.Default["Water"]

WaterChange.Factors = {
		PlaceObj("TerraformingFactorItem", {
      "Id",
      "WaterChange",
      "display_name",
      T(0, "Water Change"),
      "units",
      "PerSol",
      "GetFactorValue",
      function(self)
        return 0.24*FindWaterChange()
      end
    })
}

local VegChange = Presets.TerraformingParam.Default["Vegetation"]

VegChange.Factors = {
		PlaceObj("TerraformingFactorItem", {
      "Id",
      "VegetationChange",
      "display_name",
      T(0, "Vegetation Change"),
      "units",
      "PerSol",
      "GetFactorValue",
      function(self)
        return 0.24*FindVegetationChange()
      end
    })
}

end