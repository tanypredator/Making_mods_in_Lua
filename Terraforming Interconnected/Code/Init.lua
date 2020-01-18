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