-- lock building until relevant tech is researched
function BT_DoBuildingUnlock(buildingID, techID)
    if UICity:IsTechResearched(techID) then
        UnlockBuilding(buildingID);
    elseif UICity:IsTechDiscovered(techID) then
        local name = TechDef[techID].display_name;
        LockBuilding(buildingID, 'disable', T{3956, "Research <em><tech_name></em> to unlock this building.", tech_name = name});    
    else
        LockBuilding(buildingID);
    end
end

function OnMsg.CityStart()
    BT_DoBuildingUnlock('RDM_GeoPowerPlant', 'MagneticFieldGenerator')
end
function OnMsg.TechResearched(tech_id, city, first_time)
	BT_DoBuildingUnlock('RDM_GeoPowerPlant', 'MagneticFieldGenerator')
end
function OnMsg.LoadGame()
    BT_DoBuildingUnlock('RDM_GeoPowerPlant', 'MagneticFieldGenerator')
end


function OnMsg.ClassesBuilt() RDM_ModGeoThermalPower:Init() end

--[[function RDM_ModBase:Init()
	self:SetMod()
	self:SetModDir()
	self:SetModTitle()
	self:SetModVersion()
	
	if RDM_ModRegister then 
		RDM_ModRegister[self.class] = self
	end
	
	if not RDM_ModRegister then
		ModLog("[SILVA][Error] Global var RDM_ModRegister is nil or doesn't exist.")
	end
	
	Msg("RDM_ModLoaded", self.class, self.ModID)
end

-- SET Mod informations
function RDM_ModBase:SetMod() 			self.Mod 		= Mods[self.ModID] end
function RDM_ModBase:SetModDir() 		self.ModDir		= self.Mod.env.CurrentModPath or "" end
function RDM_ModBase:SetModTitle() 		self.ModTitle 	= self.Mod.title or "" end]]

-- fix for icons
function OnMsg.RDM_FixerThrowFixes(Fixer) 
	Fixer:FixIconUpgradePath("RDM_GeoPowerPlant", 1)
end

-- @Class sMod_GeoThermalPower
-- ===================================================================================
DefineClass.RDM_ModGeoThermalPower = {
	__parents = { "RDM_ModBase" },
	ModID = "KFWTQp4", -- SET

	techs = {"MagneticFieldGenerator"},
	buildings = {"RDM_GeoPowerPlant"},
	upgrades = {"RDM_GeoPowerPlant_AdvancedTurbine"},
	
}
-- Set Locks/Unlocks rules
function RDM_ModGeoThermalPower:Init()
	RDM_ModBase.Init(self)
	
	self.rules_buildings = { 
		{self.buildings[1], self.techs[1]},
	}
	RDM_AddBuildingRules(self.rules_buildings)
	--[[function RDM_Controller:AddBuildingRules(rules)
	for _, rule in ipairs(rules) do
		table.insert(self.rules_building, rule)
	end
	end]]
	self.rules_upgrades = { 
		{self.upgrades[1], self.techs[1]},
	}
	RDM_AddUpgradeRules(self.rules_upgrades)
	--[[function RDM_Controller:AddUpgradeRules(rules)
	for _, rule in ipairs(rules) do
		table.insert(self.rules_upgrade, rule)
	end
	end]]
	-- rules are in Lua_RDM_Core.lua and there I'm lost O_O
	
end


function OnMsg.TechResearched(tech_id, city, first_time)
	RDM_LockUnlock("RDM_ModGeoThermalPower", tech_id)
end


--[[function RDM_Controller:LockUnlock(mod_classname, tech_id)
	local mod = self:GetMod(mod_classname)

	if mod then
		if #mod.rules_buildings > 0 then
			for _, rule in ipairs(mod.rules_buildings) do
				local tech, bld_id = rule[2], rule[1]
				if tech_id == tech then
					UnlockBuilding(bld_id)
				end
			end
		end
		
		if #mod.rules_upgrades > 0 then
			for _, rule in ipairs(mod.rules_upgrades) do
				local tech, upgrade_id = rule[2], rule[1]
				if tech_id == tech then
					UnlockUpgrade(upgrade_id)
				end
			end
		end
		
		-- modifiers = { {id, label, prop[], tech }, {...} }
		if #mod.rules_modifiers > 0 then
			for _, rule in ipairs(mod.rules_modifiers) do
				local tech, modifier_id, modifier_label, modifier_props = rule[4], rule[1], rule[2], rule[3]
				if tech_id == tech then
					CreateLabelModifier(modifier_id, modifier_label, modifier_props[1], modifier_props[2], modifier_props[3])
				end
			end
		end
		
		-- crops
		if #mod.rules_crops > 0 then
			for _, rule in ipairs(mod.rules_crops) do
				local tech, crop_id = rule[2], rule[1]
				if tech_id == tech then
					UnlockCrop(crop_id, tech)
				end
			end
		end
		
	else
		ModLog("[SILVA][Error] Mod classname: ".. mod_classname .. " doesn't exist.")
	end
end]]
