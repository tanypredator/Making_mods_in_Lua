-- new building class

DefineClass.DeepAquiferExtractor = {
  __parents = { "ResourceProducer", "ElectricityConsumer", "WaterProducer", "DustGenerator", "BuildingDepositExploiterComponent", "OutsideBuildingWithShifts", "SubsurfaceDepositConstructionRevealer", "TerraformingBuilding" },

	subsurface_deposit_class = "SubsurfaceDepositWater",

	building_update_time = const.HourDuration,
	stockpile_spots1 = { "Resourcepile" },
	additional_stockpile_params1 = {
		apply_to_grids = false,
		has_platform = true,
		snap_to_grid = false,
		priority = 2,
		additional_supply_flags = const.rfSpecialDemandPairing
	},
	}

function 	DeepAquiferExtractor:DroneLoadResource(drone, request, resource, amount)
	TaskRequester.DroneLoadResource(self, drone, request, resource, amount)
	
	if not self.working then
		self:UpdateWorking()
	end
end

function DeepAquiferExtractor:GameInit()
	self:DepositChanged()
end

function DeepAquiferExtractor:OnDepositsLoaded()
	self:DepositChanged()
	self:UpdateConsumption()
	self:UpdateWorking()
end

-- extract used resource after it is used
function DeepAquiferExtractor:ProduceSupply(resource, amount)
	if resource == "water" and self.nearby_deposits[1] then
		local deposit_grade = self.nearby_deposits[1].grade --ExtractResource may kill this
		
		if self:DoesHaveUpgradeConsumption() then
			amount = self:Consume_Upgrades_Production(amount, 100)
		end
		
		amount = self:ExtractResource(amount)
		if self:ProduceWasteRock(amount, deposit_grade) then
			self:UpdateWorking(false)
		end
	end
end

function DeepAquiferExtractor:DepositChanged()
	local deposit_multipler = self:GetCurrentDepositQualityMultiplier()
	local amount = MulDivRound(self:GetClassValue("water_production"), deposit_multipler, 100)
	self:SetBase("water_production", amount)
	self:UpdateWorking()
end

function DeepAquiferExtractor:OnChangeActiveDeposit()
	BuildingDepositExploiterComponent.OnChangeActiveDeposit(self)
	self:DepositChanged()
end

function DeepAquiferExtractor:OnDepositDepleted(deposit)
	BuildingDepositExploiterComponent.OnDepositDepleted(self, deposit)
	self:DepositChanged()
end

function DeepAquiferExtractor:OnSetWorking(working)
	Building.OnSetWorking(self, working)
	local production = working and self.water_production or 0
	if self.water then
		self.water:SetProduction(production, production)
	end
	
end

function DeepAquiferExtractor:OnModifiableValueChanged(prop)
	if prop == "water_production" and self.water then
		local production = self.working and self.water_production or 0
		self.water:SetProduction(production, production)
	end
end

function DeepAquiferExtractor:IsIdle()
	return self.ui_working and not self:CanExploit() and not self.city:IsTechResearched("NanoRefinement")
end

function DeepAquiferExtractor:SetUIWorking(working)
	Building.SetUIWorking(self, working)
	BuildingDepositExploiterComponent.UpdateIdleExtractorNotification(self)
end


function DeepAquiferExtractor:BuildingUpdate()
	RebuildInfopanel(self)
end


--fix for building icons by ChoGGi
local function FixUpImages()
	
	local bt = BuildingTemplates
	bt.DeepAquiferExtractor.display_icon = "UI/Icons/Buildings/core_heat_convector.tga"

	local tech = TechDef["CoreHeatConvertor"]
	tech.icon = "UI/Icons/Research/core_heat_convertor.tga"

	local ct = ClassTemplates.Building["DeepAquiferExtractor"]
	ct.upgrade1_icon = "UI/Icons/Upgrades/amplify_01.tga"
	local ct1 = ClassTemplates.Building["RDM_GeoPowerPlant"]
	ct1.upgrade1_icon = "UI/Icons/Upgrades/automation_01.tga"

	
end

function OnMsg.LoadGame()
	FixUpImages()
end
function OnMsg.CityStart()
	FixUpImages()
end
