
function LandscapeLake:AdjustConsumption()
  if self.destroyed or self.volume < self.volume_max or self.city:IsTechResearched("LakeVaporators") then
    if self.wc_modifier then
      DoneObject(self.wc_modifier)
      self.wc_modifier = false
    end
    return
  end
  local irrigation = self:GetIrrigationDebit()
  if irrigation < self.water_consumption then
    local wcm = self.wc_modifier
    if wcm then
      wcm:Remove()
    end
    local excess = self.water_consumption - irrigation
    if excess > 0 then
      if wcm then
        wcm.amount = -excess
        wcm:Add()
      else
	  if Terraforming and Terraforming.Water >= 85000
	  then
        self.wc_modifier = ObjectModifier:new({
          target = self,
          prop = "water_consumption",
          Percent = -100
        })
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
end
