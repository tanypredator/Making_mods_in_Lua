--[[PlaceObj("POI", {
  OnCompletion = function(self, object, city, idx)
    local id = "spacemirror" .. idx
    city:SetLabelModifier("SolarPanelBase", id, Modifier:new({
      prop = "electricity_production",
      percent = 10,
      id = "spacemirror" .. idx
    }))
  end,
  PrerequisiteToCreate = function(self, city, idx)
    city = city or UICity
    return city:IsTechResearched(self.activation_by_tech_research) and GetTerraformParamPct("Temperature") < 100
  end,
  activation_by_tech_research = "MegaSatellites",
  consume_rocket = true,
  description = T(480263489895, "Launch a highly reflective surface to focus more sunlight on the surface of the planet, increasing the global Temperature and the power production of all Solar Panels."),
  display_icon = "UI/Icons/pm_ launch_space_mirror.tga",
  display_name = T(327750605010, "Launch Space Mirror"),
  group = "Default",
  id = "LaunchSpaceMirror",
  is_terraforming = true,
  max_projects_of_type = 1,
  rocket_required_resources = {
    PlaceObj("ResourceAmount", {
      "resource",
      "Metals",
      "amount",
      100000
    }),
    PlaceObj("ResourceAmount", {
      "resource",
      "Fuel",
      "amount",
      35000
    }),
    PlaceObj("ResourceAmount", {
      "resource",
      "Electronics",
      "amount",
      15000
    })
  },
  save_in = "armstrong",
  spawn_period = range(25, 50),
  terraforming_changes = {
    PlaceObj("TerraformingParamAmount", {
      "param",
      "Temperature",
      "amount",
      10000
    })
  }
})
]]

function OnMsg.ClassesPostprocess()
	local bt = POIPresets

	bt.LaunchSpaceMirror.terraforming_changes = {}
	--[[bt.LaunchSpaceMirror.PrerequisiteToCreate = function(self, city, idx)
    city = city or UICity
    return city:IsTechResearched(self.activation_by_tech_research)and true
  end]]
	bt.LaunchSpaceMirror.spawn_period = range(1, 5)
	bt.LaunchSpaceMirror.consume_rocket = false
	bt.LaunchSpaceMirror.rocket_required_resources = {
    PlaceObj("ResourceAmount", {
      "resource",
      "Metals",
      "amount",
      250000
    }),
    PlaceObj("ResourceAmount", {
      "resource",
      "Fuel",
      "amount",
      100000
    }),
    PlaceObj("ResourceAmount", {
      "resource",
      "Electronics",
      "amount",
      100000
    })
  	}
end

function SpaceMirrorsCount()
return g_SpecialProjectCompleted and g_SpecialProjectCompleted.LaunchSpaceMirror or 0
end

