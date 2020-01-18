-- new building class

DefineClass.CoreHeatConvector = {
  __parents = { "LifeSupportProducer", "TerraformingBuilding" },
	properties = {
		{ template = true, id = "effect_range", name = T{31, "Effect Range"}, editor = "number", category = "Geothermal", default = 10, min = 1, max = 20 },		
		{ id = "work_state", name = T{34, "Work State"}, editor = "text", default = "", no_edit = false },
	},
	building_update_time = const.HourDuration / 4,
	heat = 4*const.MaxHeat, -- compensate cold wave + cold area + 2 spheres

--  research_points_lifetime = 0
}

function CoreHeatConvector:BuildingUpdate(delta)
  if not self.working then
    return
  end
  local terraforming_sum, count = self:GetTerraformingSum()
  local research_pts = MulDivRound(self.ResearchPointsPerDay, terraforming_sum * delta, count * MaxTerraformingValue * const.DayDuration)
  self.research_points_lifetime = self.research_points_lifetime + research_pts
  self.city:AddResearchPoints(research_pts)
end

function MagneticFieldGenerator:GetEstimatedDailyProduction()
  if not self.working and (self.city:GetResearchInfo() or ElectricityConsumer.GetWorkNotPossibleReason(self)) then
    return 0
  end
  local working_shifts = 0
  for idx = 1, self.max_shifts do
    if not self.closed_shifts[idx] then
      working_shifts = working_shifts + 1
    end
  end
  local terraforming_sum, count = self:GetTerraformingSum()
  return MulDivRound(self.ResearchPointsPerDay, terraforming_sum * working_shifts, count * MaxTerraformingValue * self.max_shifts)
end

function MagneticFieldGenerator:GetTerraformingSum()
  local sum, count = 0, 0
  for key in pairs(TerraformingParamDefs) do
    sum = sum + (Terraforming[key] or 0)
    count = count + 1
  end
  return sum, count
end

function MagneticFieldGenerator:GetUIResearchProject()
  return self.city:GetUIResearchProject()
end

function MagneticFieldGenerator:GetResearchProgress()
  return self.city:GetResearchProgress()
end

function MagneticFieldGenerator:UIResearchTech()
  OpenResearchDialog()
end

function MagneticFieldGenerator:GetSolAtmosphereDecay()
  return GetSolAtmosphereDecay()
end

function MagneticFieldGenerator:GetAtmosphereLossReductionSum()
  return GetAtmosphereDecayReduct()
end

function GetAtmosphereDecayReduct()
  local reduct = 0
  for _, generator in ipairs(UICity.labels.MagneticFieldGenerator or empty_table) do
    if generator.working then
      reduct = reduct + generator.decay_atmosphere_reduct
    end
  end
  return reduct
end


-- fix for building icons by ChoGGi
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
end
