DefineClass.LandscapeLake = {
  __parents = {
    "Building",
    "LifeSupportConsumer",
    "TerraformingBuildingBase",
    "SoilOverlayInfopanelButtonBuilding"
  },
  flags = {cfBlockPass = true},
  properties = {
    {
      template = true,
      category = "Landscape",
      name = T(11900, "Gradient Dist (hex)"),
      id = "gradient_dist",
      editor = "number",
      default = 5,
      min = 0,
      max = 20,
      slider = true
    },
    {
      template = true,
      category = "Landscape",
      name = T(11901, "Soil Max Value"),
      id = "soil_max_value",
      editor = "number",
      default = 10000,
      min = 0,
      max = 10000,
      slider = true,
      scale = const.SoilGridScale
    },
    {
      template = true,
      category = "Landscape",
      name = T(12195, "Soil Tick Step"),
      id = "soil_boost_sol",
      editor = "number",
      default = 1000,
      min = 0,
      max = 10000,
      slider = true,
      scale = const.SoilGridScale
    },
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
    {
      template = true,
      category = "Landscape",
      name = T(12055, "Rain Gain (pct/sol)"),
      id = "rain_gain",
      editor = "number",
      default = 5,
      min = 0,
      max = 100,
      slider = true
    }
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
function LandscapeLake:GameInit()
  self:PlacePrefab()
end
function LandscapeLake:Done()
  if IsValid(self.water_obj) then
    DoneObject(self.water_obj)
  end
  self:SetVolume(0)
  self:DeletePrefabObjs()
  self:RestoreTerrain(false, true, true)
end
function LandscapeLake:DeletePrefabObjs()
  for _, obj in ipairs(self.objs or empty_table) do
    if IsValid(obj) then
      DoneObject(obj)
    end
  end
end
function LandscapeLake:RebuildStart()
  Building.RebuildStart(self)
  self:DeletePrefabObjs()
end
function LandscapeLake:AddVolume(vol)
  return self:SetVolume(self.volume + vol)
end
function LandscapeLake:AddSoilQualityTick(delta)
  if not self:IsTerraformingActive() then
    return
  end
  local shape = self:GetBuildShape()
  local step = MulDivRound(self.soil_boost_sol, delta, const.DayDuration)
  local max = MulDivRound(self.soil_max_value, self.volume, self.volume_max)
  if step > 0 and max > 0 then
    SoilAdd(self, step, shape, self.gradient_dist, 0, max)
    OnSoilGridChanged()
  end
end
function LandscapeLake:SetVolume(vol)
  local volume_max = self.volume_max
  local new_volume = Clamp(vol, 0, volume_max)
  if self.volume == new_volume then
    return false
  end
  if volume_max > self.volume and new_volume == volume_max then
    Msg("LakeFull", self)
  end
  self.volume = new_volume
  Msg("LakeVolumeChanged", self)
  self:AdjustConsumption()
  self:UpdateVisuals()
  RebuildInfopanel(self)
  return true
end
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
        self.wc_modifier = ObjectModifier:new({
          target = self,
          prop = "water_consumption",
          amount = -excess
        })
      end
    end
  end
end
function LandscapeLake:ShowUISectionConsumption()
  if self.city:IsTechResearched("LakeVaporators") then
    return false
  end
  return Building.ShowUISectionConsumption(self)
end
function LandscapeLake:OnSetWorking(working)
  Building.OnSetWorking(self, working)
  self:UpdateFX()
end
function LandscapeLake:UpdateFX()
  local pump = self:GetAttaches("WaterPump")[1]
  if not pump then
    return
  end
  if self.working then
    PlayFX("Working", "start", pump)
  else
    PlayFX("Working", "end", pump)
  end
end
function LandscapeLake:UpdateVisuals()
  if self.volume_max <= 0 then
    return
  end
  if IsValid(self.water_obj) then
    local x, y, z0 = self.water_obj:GetVisualPosXYZ()
    local dl = self.level_max - self.level_min
    local z = self.level_min + sqrt(MulDivRound(self.dl2, self.volume, self.volume_max))
    self.water_obj:SetPos(x, y, z)
    if z0 <= z then
      terrain.UpdateWaterGridFromObject(self.water_obj)
      return
    end
  end
  ApplyAllWaterObjects()
end
function LandscapeLake:GetWaterLevelPct()
  return 100 * self.volume / self.volume_max
end
function LandscapeLake:CheatFill()
  self:SetVolume(self.volume_max)
end
function LandscapeLake:CheatEmpty()
  self:SetVolume(0)
end
function LandscapeLake:CheatToggleWaterGrid()
  DbgToggleWaterGrid()
end
function LandscapeLake:BuildingUpdate(delta, day, hour)
  local income = self.city:IsTechResearched("LakeVaporators") and self.base_water_consumption or self.working and self.water and self.water.consumption or 0
  local water = income * delta / const.HourDuration
  if g_RainDisaster then
    local daily_rain = MulDivRound(self.volume_max, self.rain_gain, 100)
    water = water + daily_rain * delta / const.DayDuration
  else
    water = water - self:GetIrrigationDebit() * delta / const.HourDuration
  end
  self:AddVolume(water)
  self:AddSoilQualityTick(delta)
end
function LandscapeLake:GetIrrigationDebit()
  return self:IsTerraformingActive() and self.irrigation or 0
end
function LandscapeLake:IsTerraformingActive()
  if self.volume == 0 or self.terraforming_disabled ~= 0 then
    return false
  end
  return not self:IsFrozen()
end
function LandscapeLake:IsFrozen()
  return GetAverageHeatShape(self:GetBuildShape(), self) < 128
end
function LandscapeLake:GetPrefabName()
  return "Any.Gameplay." .. self:GetEntity()
end
function LandscapeLake:PlacePrefab()
  local angle = self:GetAngle()
  local pos = self:GetVisualPos()
  self:SetPos(pos)
  local prefab_name = self:GetPrefabName()
  local prefab = PrefabMarkers[prefab_name]
  if not prefab then
    print("No prefab found:", prefab_name)
    return
  end
  local offset = prefab.dummy_offset or point30
  local prefab_pos = pos - Rotate(offset, angle)
  local err, bbox, objs = PlacePrefab(prefab_name, prefab_pos, angle, "+")
  if err then
    StoreErrorSource(self, err, prefab_name)
    return
  end
  local min_x, min_y, z0 = pos:xyz()
  local level_max = z0 - guim
  local ClearGameFlags = CObject.ClearGameFlags
  local gofPermanent = const.gofPermanent
  local IsKindOf = IsKindOf
  for _, obj in ipairs(objs or empty_table) do
    ClearGameFlags(obj, gofPermanent)
    if IsKindOf(obj, "PrefabDummyObj") then
      local dummy_pos = obj:GetVisualPos()
      level_max = Min(level_max, dummy_pos:z())
      if Platform.developer and not IsCloser2D(self, obj, 1 * guim) then
        local offset = dummy_pos - pos
        print("Lake", self:GetEntity(), "offset:", offset)
      end
      DoneObject(obj)
    end
  end
  local level_min = level_max - 10 * guim
  if prefab.min then
    local x, y, z = prefab.min:xyz()
    local s = Max(prefab.size:xy())
    local offset_x2 = point(2 * x * guim - s, 2 * y * guim - s, 2 * z)
    local pos_min = prefab_pos + Rotate(offset_x2, angle) / 2
    min_x, min_y = pos_min:xy()
    level_min = terrain.GetHeight(min_x, min_y)
  end
  self.level_min, self.level_max = level_min, level_max
  local water_obj = self.water_obj
  if not IsValid(water_obj) then
    water_obj = WaterFill:new()
    self.water_obj = water_obj
  end
  water_obj:SetPos(min_x, min_y, level_min)
  local dl = self.level_max - self.level_min
  self.dl2 = dl * dl
  self.objs = objs
  self:UpdateVisuals()
  terrain.RebuildPassability(bbox)
end
function LandscapeLake:GatherConstructionStatuses(statuses)
  local prefab_name = self:GetPrefabName()
  local prefab = PrefabMarkers[prefab_name] or empty_table
  if prefab.min then
    local x, y, z = prefab.min:xyz()
    local x0, y0, z0 = self:GetVisualPosXYZ()
    if z + z0 <= 0 then
      statuses[#statuses + 1] = ConstructionStatus.LandscapeLowTerrain
    end
  end
  Building.GatherConstructionStatuses(self, statuses)
end
function LandscapeLake:GetUIWarning()
  local warning = Building.GetUIWarning(self)
  if warning then
    return warning
  end
  if WaterFrozen or self:IsFrozen() then
    return T(12136, "Doesn't increase soil quality and global Water while frozen.")
  end
end
function OnMsg.GatherSelectedObjectsOnHexGrid(q, r, objects)
  local lake = HexGridGetObject(ObjectGrid, q, r, "LandscapeLake")
  if lake then
    table.insert_unique(objects, lake)
  end
end
GlobalVar("WaterFrozen", false)
GlobalVar("WaterUnfrozenEvent", false)
GlobalVar("WaterFrozenEvent", false)
local SetWaterFrozen = function(frozen)
  if not UICity then
    return
  end
  hr.ForcedWaterIce = frozen and 1 or 0
  if frozen == WaterFrozen then
    return
  end
  WaterFrozen = frozen
  Msg("WaterPhysicalStateChange", WaterFrozen)
  local modTerraParam
  RemoveOnScreenNotification("WaterFreezes")
  RemoveOnScreenNotification("WaterUnfrozen")
  if frozen then
    modTerraParam = Modifier:new({
      prop = "terraforming_disabled",
      amount = 1,
      id = "Frozen Water"
    })
    if WaterUnfrozenEvent and not WaterFrozenEvent then
      WaterFrozenEvent = true
      AddOnScreenNotification("WaterFreezes")
    end
  elseif not WaterUnfrozenEvent then
    WaterUnfrozenEvent = true
    AddOnScreenNotification("WaterUnfrozen")
  end
  UICity:SetLabelModifier("LandscapeLake", "WaterFreeze.TerraParam", modTerraParam)
end
function OnMsg.NewMapLoaded()
  if not mapdata.GameLogic then
    return
  end
  if not IsTerraformingThresholdReached("LiquidWater") then
    SetWaterFrozen(true)
  end
end
function OnMsg.LoadGame()
  hr.ForcedWaterIce = WaterFrozen and 1 or 0
end
function OnMsg.TerraformThresholdPassed(id, reached)
  if id == "LiquidWater" then
    SetWaterFrozen(not reached)
  end
end
function OnMsg.GatherLabels(labels)
  labels.LandscapeLake = true
end
function SavegameFixups.ResetPipeConnectionCaches()
  PipeShapeConnectionsCache = {}
end
function SavegameFixups.ResetCableConnectionCaches()
  CableConnectionsCache = {}
end
function LandscapeLake:GetShapeConnections(supply_resource)
  local cache = supply_resource == "electricity" and CableConnectionsCache or PipeShapeConnectionsCache
  local connections = cache[self.entity]
  if not connections then
    connections = {}
    cache[self.entity] = connections
    local shape = self:GetSupplyGridConnectionShapePoints(supply_resource)
    local find = table.find
    if supply_resource == "electricity" then
      local first, last = GetSpotRange(self.entity, EntityStates.idle, "Electricitygrid")
      local spots
      if first >= 0 then
        spots = {}
        for i = first, last do
          local pt = GetEntitySpotPos(self.entity, i)
          spots[#spots + 1] = point(WorldToHex(pt))
        end
      end
      for i, hex in ipairs(shape) do
        local v = 0
        for dir, neighbour in ipairs(HexNeighbours) do
          neighbour = hex + neighbour
          if find(shape, neighbour) then
            v = bor(v, shift(1, dir - 1))
          elseif not spots or find(spots, neighbour) then
            v = bor(v, shift(1, dir + 8 - 1))
          end
        end
        connections[i] = v
      end
    else
      local pipes_list = self:GetPipeConnections()
      local hits = 0
      for i, hex in ipairs(shape) do
        local v = 0
        for dir, neighbour in ipairs(HexNeighbours) do
          neighbour = hex + neighbour
          if find(shape, neighbour) then
            v = bor(v, shift(1, dir - 1))
          end
        end
        for _, conn in ipairs(pipes_list) do
          if conn[1] == hex then
            if band(v, shift(1, conn[2])) == 0 then
              v = bor(v, shift(1, conn[2] + 8))
            end
            hits = hits + 1
          end
        end
        connections[i] = v
      end
    end
  end
  return connections
end
function LandscapeLake:GetFlattenShape(obj)
  if obj then
    return GetEntityOutlineShape(obj:GetEntity())
  end
  return Building.GetFlattenShape(self)
end
