local ApplyAllWaterObjects = ApplyAllWaterObjects
local table_remove = table.remove

DefineClass.RainLakeSpawned = {
	__parents = {"Building",   "SoilOverlayInfopanelButtonBuilding", "EditorObject"},

	display_name = T("Sea marker"),
	description = T("This is a marker for a future lake or sea. It will be filled with underground water when it melts and with rains when they start. At the beginning water surface may look ugly because of waves effect."),
	display_icon = "UI/Icons/Buildings/terraforming_big_lake.tga",
	entity = "Ice_Cliff_06",

properties = {
    {
      template = true,
      category = "Landscape",
      name = T(11900, "Gradient Dist (hex)"),
      id = "gradient_dist",
      editor = "number",
      default = 35,
      min = 0,
      max = 50,
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
      name = T(12055, "Rain Gain (pct/sol)"),
      id = "rain_gain",
      editor = "number",
      default = 10,
      min = 0,
      max = 100,
      slider = true
    }
  },
	water_obj = false,
  level_min = 0,
  level_max = 0,
  volume = 0,
  dl2 = 0
}

function RainLakeSpawned:Init()
end

function SpawnRainLake(pos)
  local lake = PlaceObject("RainLakeSpawned")
  lake:SetPos(pos)
  return lake
end

function RainLakeSpawned:GameInit()
	self:SetColorModifier(-12374251)
--[[	local maxwaterlevel = GetMaxWaterlevel()]]
	-- init water level
	self.water_obj = WaterFill:new()
	local pos = self:GetPos()
	self.level_min = MinWaterLevel
	self.level_max = GetMaxWaterlevel()
	self.water_obj:SetPos(pos:x(), pos:y(), self.level_min)
	ApplyAllWaterObjects()
	self:UpdateVisuals()
end

function RainLakeSpawned:Done()
	if IsValid(self.water_obj) then
		DoneObject(self.water_obj)
		ApplyAllWaterObjects()
	end
  self:SetVolume(0)
end

function RainLakeSpawned:AddVolume(vol)
  return self:SetVolume(self.volume + vol)
end

function RainLakeSpawned:AddSoilQualityTick(delta)
  if Terraforming.Temperature < 25000 then
    return
  end
  local shape = self:GetBuildShape()
  local step = MulDivRound(self.soil_boost_sol, delta, const.DayDuration)
  local max = MulDivRound(self.soil_max_value, self.volume, self.volume_max)
  if Terraforming.Temperature >= 25000 and step > 0 and max > 0 then
    SoilAdd(self, step, shape, self.gradient_dist, 0, max)
    OnSoilGridChanged()
  end
end

function RainLakeSpawned:SetVolume(vol)
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
  self:UpdateVisuals()
  RebuildInfopanel(self)
  return true
end

function RainLakeSpawned:UpdateVisuals()
  if self.volume_max <= 0 then
    return
  end
  if IsValid(self.water_obj) then
    local x, y, z0 = self.water_obj:GetVisualPosXYZ()
    local dl = self.level_max - self.level_min
 	self.dl2 = dl * dl
    local z = self.level_min + sqrt(MulDivRound(self.dl2, self.volume, self.volume_max))
    self.water_obj:SetPos(x, y, z)
    if z0 <= z then
      terrain.UpdateWaterGridFromObject(self.water_obj)
      return
    end
  end
  ApplyAllWaterObjects()
end

function RainLakeSpawned:GetWaterLevelPct()
  return 100 * self.volume / self.volume_max
end

function RainLakeSpawned:AdjustLevel(dir, smaller)
	local step = 100
	if smaller then
		step = step / 2
	end
	if dir == "down" then
		step = step * -1
	end
	local level_new = self.level_max + step
if level_new >= self.level_min then
	self.level_max = level_new
elseif level_new < self.level_min then
	self.level_max = self.level_min
end
	self:UpdateVisuals()
end

function RainLakeSpawned:BuildingUpdate(delta, day, hour)
    local income = 0
  local water = income * delta / const.HourDuration
  if g_RainDisaster then
    local daily_rain = MulDivRound(self.volume_max, self.rain_gain, 100)
    water = water + daily_rain * delta / const.DayDuration
  end
  self:AddVolume(water)
  self:AddSoilQualityTick(delta)
end

function OnMsg.TerraformThresholdPassed(id, reached)
  if id == "LiquidWater" then
    local objs = MapGet("map", "RainLakeSpawned")
    for i = 1, #objs do
    objs[i]:AddVolume(10)
    end
  end
end


-- remove UnevenTerrain error
local cs_UnevenTerrain = ConstructionStatus.UnevenTerrain
local orig_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
function ConstructionController:UpdateConstructionStatuses(...)
	local ret = orig_UpdateConstructionStatuses(self, ...)
	if self.template_obj:IsKindOf("RainLakeSpawned") then
		local statuses = self.construction_statuses or ""
		for i = 1, #statuses do
			local status = statuses[i]
			if status == cs_UnevenTerrain then
				table_remove(statuses, i)
				self.cursor_obj:SetColorModifier(-256)
				break
			end
		end
	end
	return ret
end

