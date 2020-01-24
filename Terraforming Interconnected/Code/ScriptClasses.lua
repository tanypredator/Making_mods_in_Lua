-- new building class

DefineClass.DeepAquiferExtractor = {
  __parents = { "WaterProducer", "TerraformingBuilding" },
	building_update_time = const.HourDuration,

	}

function DeepAquiferExtractor:SetPostConsumption()
  if self.post_consumption == 100 then
    return
  end
  TerraformingBuilding.SetPostConsumption(self)
  if self.post_consumption == 0 then
    self.disable_el_modifier = ObjectModifier:new({
      target = self,
      prop = "disable_electricity_consumption",
      amount = 1
    })
    return
  end
  self.el_modifier = ObjectModifier:new({
    target = self,
    prop = "electricity_consumption",
    percent = self.post_consumption - 100
  })
end
function DeepAquiferExtractor:ResetPostConsumption()
  if self.post_consumption == 100 then
    return
  end
  TerraformingBuilding.ResetPostConsumption(self)
  if self.disable_el_modifier then
    self.disable_el_modifier:Remove()
    self.disable_el_modifier = false
  elseif self.el_modifier then
    self.el_modifier:Remove()
    self.el_modifier = false
  end
end
function DeepAquiferExtractor:GetHeatRange()
  return
end
function DeepAquiferExtractor:GetHeatBorder()
  return
end



-- [[fix for building icons by ChoGGi
local function FixUpImages()
	local bt = BuildingTemplates
	
	bt.Lake.display_icon = "UI/Icons/Buildings/lake.tga"
	bt.Lake.encyclopedia_image = "UI/Encyclopedia/Lake.tga"
	
	bt.FountainSmall.display_icon = "UI/Icons/Buildings/small_fountain.tga"
	bt.FountainSmall.encyclopedia_image = "UI/Encyclopedia/SmallFountain.tga"
	
	bt.FountainLarge.display_icon = "UI/Icons/Buildings/large_fountain.tga"
	bt.FountainLarge.encyclopedia_image = "UI/Encyclopedia/Fountain.tga"
end

function OnMsg.LoadGame()
	FixUpImages()
end
function OnMsg.CityStart()
	FixUpImages()
end]]
