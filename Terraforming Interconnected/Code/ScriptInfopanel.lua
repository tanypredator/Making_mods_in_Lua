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
