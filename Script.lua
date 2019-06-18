--[[
DefineClass.LandscapeLake = {
  properties = {
    {
      template = true,
      category = "Landscape",
      name = T(11902, "Max Volume"),
      id = "volume_max",
      editor = "number",
      default = 100 * const.ResourceScale,
      scale = const.ResourceScale
    },
    {
      template = true,
      category = "Landscape",
      name = T(11903, "Irrigation Debit"),
      id = "irrigation",
      editor = "number",
      default = const.ResourceScale / 2,
      scale = const.ResourceScale
    },
  },
  water_obj = false,
  use_demolished_state = true,
  demolish_sinking = range00,
  demolish_debris = 0,
  level_min = 0,
  level_max = 0,
  wc_modifier = false,
  volume = 0,
  dl2 = 0,
  objs = false,
  use_shape_selection = false,
  landscape_construction_visuals = true,
  auto_clear = false,
  GetSkins = __empty_function__
}


PlaceObj("TechPreset", {
  
  id = "LakeVaporators",
  
PlaceObj("Effect_ModifyLabel", {
    Label = "LandscapeLake",
    Percent = -100,
    Prop = "water_consumption"
  }),

  PlaceObj("Effect_ModifyLabel", {
    Amount = 1,
    Label = "LandscapeLake",
    Prop = "disable_maintenance"
  })
})
--]]

function LandscapeLake:AdjustConsumption()
  if self.destroyed or self.volume < self.volume_max or self.city:IsTechResearched("LakeVaporators") 

--If the Lake is not destroyed, and its volume is not less than maximum volume, and LakeVaporators are researched, then do this mystical check of wc_modifier which is set to false by default... Is that a water_consumption modifier by Lake Vaporators? O_o

  then
    if self.wc_modifier then
      DoneObject(self.wc_modifier)
      self.wc_modifier = false
    end
    return
  end

  local irrigation = self:GetIrrigationDebit()

--And self:GetIrrigationDebit() is probably = const.ResourceScale/2, and const.ResourceScale = const.Scale.Resources, and what is const.Scale.Resources I've never found.

  if irrigation < self.water_consumption 

--And self.water_consumption is probably got from the characteristics of LifeSupportConsumer class, but I couldn't find any number...

    then
    local wcm = self.wc_modifier

--And wc_modifier was set to false by default, right?

    if wcm then
      wcm:Remove()
    end

    local excess = self.water_consumption - irrigation

    if excess > 0 then

      if wcm then
        wcm.amount = -excess
        wcm:Add()

--which is still false, so

      else
        self.wc_modifier = ObjectModifier:new({
          target = self,
          prop = "water_consumption",
          amount = -excess
        })
      end

    end
  end
end

--[[
--What I'm thinking to add is something like:

      else
	  if GetTerraformParamPct("Water") == 85

	  then

	PlaceObj("Effect_ModifyLabel", {
   	 Label = "LandscapeLake",
   	 Percent = -100,
  	  Prop = "water_consumption"
 	 })

	  else

        self.wc_modifier = ObjectModifier:new({
          target = self,
          prop = "water_consumption",
          amount = -excess
        })
      end

--[[


--[[
function LandscapeLake:BuildingUpdate(delta, day, hour)
  local income = (self.city:IsTechResearched("LakeVaporators") and self.base_water_consumption) or (self.working and self.water and self.water.consumption) or (0)

-- if LakeVaporators researched, income = self.base_water_consumption. If no, then if Lake is working, and if self.water is true (? if it is a number?), then income = self.water.consumption. And if Lake is not working, and self.water is false, then income = 0.

  local water = income * delta / const.HourDuration

--and delta is an argument of AddSoilQualityTick? O_o Or where from does it came?

  if g_RainDisaster then
    local daily_rain = MulDivRound(self.volume_max, self.rain_gain, 100)
    water = water + daily_rain * delta / const.DayDuration
  else
    water = water - self:GetIrrigationDebit() * delta / const.HourDuration
  end
  self:AddVolume(water)
  self:AddSoilQualityTick(delta)
end
--[[


