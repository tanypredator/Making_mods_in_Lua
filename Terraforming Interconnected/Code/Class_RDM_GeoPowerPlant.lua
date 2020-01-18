DefineClass.RDM_GeoPowerPlantTurbine = { 
	__parents = { "BuildingEntityClass" },
	entity = "RDM_GeoPowerPlantTurbine",
}
DefineClass.RDM_GeoPowerPlantGenerator = { 
	__parents = { "BuildingEntityClass" },
	entity = "RDM_GeoPowerPlantGenerator",
}

-- @DefineClass RDM_GeoPowerPlant 
DefineClass.RDM_GeoPowerPlant = {
	__parents = { "Building", "ElectricityProducer", "BaseHeater", "Workplace", "LifeSupportConsumer", "TerraformingBuildingBase" },
	
	properties = {
		{ template = true, id = "effect_range", name = T{31, "Effect Range"}, editor = "number", category = "Geothermal", default = 10, min = 1, max = 20 },		
		{ id = "work_state", name = T{34, "Work State"}, editor = "text", default = "", no_edit = false },
	},
	
	-- animation
	wait_working_anims_to_finish = false,
	anim_control_thread = false,
	current_state = "idle",
	
	building_update_time = const.HourDuration / 4,
	heat = 4*const.MaxHeat, -- compensate cold wave + cold area + 2 spheres
	
	fx_actor_class = "RDM_GeoPowerPlant",
	use_shape_selection = true,
}
function RDM_GeoPowerPlant:GameInit()
	self.fx_actor_class = "RDM_GeoPowerPlant"
end

function RDM_GeoPowerPlant:GetHeatRange()
	return self.effect_range * 10 * guim
end

function RDM_GeoPowerPlant:GetHeatBorder()
	return const.SubsurfaceHeaterFrameRange
end

function RDM_GeoPowerPlant:GetSelectionRadiusScale()
	return self.effect_range
end

function RDM_GeoPowerPlant:SetWorkState(state)
	if self.work_state == state then
		return
	end

	self.work_state = state
		
	self:ApplyHeat(self.work_state == "produce")
end

function RDM_GeoPowerPlant:OnSetWorking(working)
	ElectricityProducer.OnSetWorking(self, working)
	Workplace.OnSetWorking(self, working)
	if working then
		self:SetWorkState("produce")	
	else 
		self:SetWorkState("disabled")
	end
end

function RDM_GeoPowerPlant:WorkLightsOn()
	self:SetSIModulation(100)
	
	local attaches = self:GetAttaches({"RDM_GeoPowerPlantTurbine","RDM_GeoPowerPlantGenerator"})

	for k, att in ipairs(attaches) do
		att:SetSIModulation(100)
	end
end