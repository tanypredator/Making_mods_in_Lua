local entity = "Ice_Cliff_06"

local IsMassUIModifierPressed = IsMassUIModifierPressed
local ApplyAllWaterObjects = ApplyAllWaterObjects
local table_remove = table.remove

DefineClass.RainLake = {
	__parents = {
		"Building",
  		"TerraformingBuildingBase",
    "SoilOverlayInfopanelButtonBuilding"
	},
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
      default = 25,
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

function RainLake:GameInit()
	self:SetColorModifier(-12374251)

	-- init water level
	self.water_obj = WaterFill:new()
	local pos = self:GetPos()
	self.level_min = pos:z()-50
	self.level_max = pos:z()+1000
	self.water_obj:SetPos(pos)
	ApplyAllWaterObjects()
end

function RainLake:Done()
	if IsValid(self.water_obj) then
		DoneObject(self.water_obj)
		ApplyAllWaterObjects()
	end
  self:SetVolume(0)
end

function RainLake:AddVolume(vol)
  return self:SetVolume(self.volume + vol)
end

function RainLake:AddSoilQualityTick(delta)
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

function RainLake:SetVolume(vol)
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
	if self.volume < 10000 then
	self.terraforming_boost_sol = 0
	elseif self.volume >= 10000 and self.volume < 30000 then
	self.terraforming_boost_sol = 20
	elseif self.volume >= 30000 and self.volume < 60000 then
	self.terraforming_boost_sol = 40
	elseif self.volume >= 60000 then
	self.terraforming_boost_sol = 60
	end
  return true
end

function RainLake:UpdateVisuals()
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

function RainLake:AdjustLevel(dir, smaller)
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

function RainLake:BuildingUpdate(delta, day, hour)
    local income = 0
  local water = income * delta / const.HourDuration
  if g_RainDisaster then
    local daily_rain = MulDivRound(self.volume_max, self.rain_gain, 100)
    water = water + daily_rain * delta / const.DayDuration
  end
  self:AddVolume(water)
  self:AddSoilQualityTick(delta)
end


function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.RainLake then
		PlaceObj("BuildingTemplate", {
			"Id", "RainLake",
			"template_class", "RainLake",
			"construction_cost_Concrete", 1000,
			"palette_color1", "outside_base",
			"dome_forbidden", true,
			"display_name", [[Rain-lake]],
			"display_name_pl", [[Rain-lakes]],
			"description", [[This is a marker for a future lake. It will be filled with rains when they start. At the beginning water surface will look ugly because of "waves" effect. You can elevate the water level with a button, until it looks OK. The lake will improve the "Water" teraforming parameter and local soil quality, when the rains fill in enough water.]],
			"display_icon", "UI/Icons/Buildings/terraforming_big_lake.tga",
			"entity", entity,
			"build_category", "Lakes",
			"Group", "Lakes",
			"encyclopedia_exclude", true,
			"on_off_button", false,
			"prio_button", false,
			"use_demolished_state", false,
			"force_extend_bb_during_placement_checks", 30000,
			"demolish_sinking", range(0, 0),
			"demolish_debris", 0,
			"auto_clear", true,
			"terraforming_param", "Water",
			"terraforming_boost_sol", 0,
		})
	end
--~ end

--~ function OnMsg.ClassesBuilt()
	local building = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building, "ChoGGi_Template_InstantLake_Adjust", true)

	table.insert(
		building,
		#building+1,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_InstantLake_Adjust", true,
			"comment", "fill/drain toggle",
			"__context_of_kind", "RainLake",
			"__template", "InfopanelButton",
			"Icon", "UI/Icons/IPButtons/drill.tga",
			"RolloverText", T(0, [[Adjust lake level
<left_click> Raise <right_click> Lower]]),
			"RolloverTitle", [[Adjust Level]],
			"RolloverHint", T(0, [[Ctrl + <left_click> Halve level adjust]]),
			"RolloverHintGamepad", T(7518--[[ButtonA]]) .. " " .. T(7618--[[ButtonX]]),
			"OnPress", function (self, gamepad)
				self.context:AdjustLevel("up", not gamepad and IsMassUIModifierPressed())
				ObjModified(self.context)
			end,
			"AltPress", true,
			"OnAltPress", function (self, gamepad)
				if gamepad then
					self.context:AdjustLevel("down", true)
				else
					self.context:AdjustLevel("down", IsMassUIModifierPressed())
				end
				ObjModified(self.context)
			end,
		})
	)

end

-- remove UnevenTerrain error
local cs_UnevenTerrain = ConstructionStatus.UnevenTerrain
local orig_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
function ConstructionController:UpdateConstructionStatuses(...)
	local ret = orig_UpdateConstructionStatuses(self, ...)
	if self.template_obj:IsKindOf("RainLake") then
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