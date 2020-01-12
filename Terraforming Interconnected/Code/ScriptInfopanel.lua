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


local AtmChange = Presets.TerraformingParam.Default[Atmosphere]
	table.insert(
		AtmChange.Factors,
		#AtmChange.Factors+1,
		PlaceObj("TerraformingFactorItem", {
      "Id",
      "AtmosphereChange",
      "display_name",
      T(0, "AtmosphereChange"),
      "GetFactorValue",
      function(self)
        return 25*FindAtmosphereChange()
      end
    })
)
