function OnMsg.ClassesPostprocess()

	local bt = POIPresets

	bt.LaunchSpaceMirror.OnCompletion = function(self, object, city, idx)
    local id = "spacemirror" .. idx
    city:SetLabelModifier("SolarPanelBase", id, Modifier:new({
      prop = "electricity_production",
      percent = 10,
      id = "spacemirror" .. idx
    }))
	local SMcount = SpaceMirrorsCount()
	if SMcount<10 then
	self.rocket = false
	local init = not g_SpecialProjectSpawnNextIdx[bt.LaunchSpaceMirror]
	SpawnSpecialProject(LaunchSpaceMirror, UICity, init)
	end
  end

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

	bt.CaptureIceAsteroids.spawn_period = range(5, 6)
	bt.CaptureIceAsteroids.expedition_time = 2160000
	bt.ImportGreenhouseGases.spawn_period = range(5, 6)
	bt.ImportGreenhouseGases.expedition_time = 2160000

	bt.ImportGreenhouseGases.rocket_required_resources = {
    PlaceObj("ResourceAmount", {
      "resource",
      "Metals",
      "amount",
      50000
    }),
    PlaceObj("ResourceAmount", {
      "resource",
      "Fuel",
      "amount",
      100000
    }),
    PlaceObj("ResourceAmount", {
      "resource",
      "MachineParts",
      "amount",
      15000
    })
  	}

	bt.ImportGreenhouseGases.terraforming_changes = {
	PlaceObj("TerraformingParamAmount", {
      "param",
      "Atmosphere",
      "amount",
      5000
	})
	}

	bt.ImportGreenhouseGases.description = T(0, [[Deploy robotic scoops into the atmosphere of Titan, largest moon of Saturn, and bring the collected gases to Mars. 
High concentrations of nitrous oxides may cause toxic rain!]])

	bt.LaunchSpaceSunshade.OnCompletion = function(self, object, city, idx)
	local MScount = GetMagneticShieldsCount()
	if MScount<10 then
	self.rocket = false
	local init = not g_SpecialProjectSpawnNextIdx[bt.LaunchSpaceSunshade]
	SpawnSpecialProject(LaunchSpaceSunshade, UICity, init)
	end
  end

	bt.LaunchSpaceSunshade.rocket_required_resources = {
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

	bt.LaunchSpaceSunshade.consume_rocket = false
	bt.MeltThePolarCaps.spawn_period = range(5, 6)
	bt.MeltThePolarCaps.consume_rocket = false
	bt.MeltThePolarCaps.expedition_time = 720000

	bt.MeltThePolarCaps.CalcOutcome = function(self, object, city, idx)
    local dec_percent = 50
    local min_water = 3 * const.TerraformingScale
    local min_atm = 1 * const.TerraformingScale
    local amount_water = 10 * const.TerraformingScale
    local amount_atm = 5 * const.TerraformingScale
    for i = 1, idx - 1 do
      amount_water = amount_water - MulDivRound(dec_percent, amount_water, 100)
      amount_atm = amount_atm - MulDivRound(dec_percent, amount_atm, 100)
    end
    amount_water = Max(min_water, amount_water)
    amount_atm = Max(min_atm, amount_atm)
    return amount_water, amount_atm
  end
  
	bt.MeltThePolarCaps.rocket_required_resources = {
    PlaceObj("ResourceAmount", {
      "resource",
      "Funding",
      "amount",
      1000000000
    }),
	PlaceObj("ResourceAmount", {
      "resource",
      "Fuel",
      "amount",
      50000
    })
  }

	bt.SeedVegetation.spawn_period = range(1, 3)
	bt.SeedVegetation.rocket_required_resources = {
    PlaceObj("ResourceAmount", {
      "resource",
      "Seeds",
      "amount",
      200000
    }),
    PlaceObj("ResourceAmount", {
      "resource",
      "Fuel",
      "amount",
      35000
    })
  }
end

function SpaceMirrorsCount()
return g_SpecialProjectCompleted and g_SpecialProjectCompleted.LaunchSpaceMirror or 0
end

DefineConst({
  group = "Terraforming",
  id = "Decay_AtmosphereSP_MagneticShield",
  name = T(526462328425, "Magnetic shield Decay Reduct (%)"),
  save_in = "armstrong",
  scale = "Terraforming",
  value = 400
})
