-- Fix Entity & Attaches in Savegame for v1.0 to v1.2 to v1.3
function SavegameFixups.RDM_GeoPowerPlant_Fix1()
	MapForEach("map", "sBuilding_GeoPowerPlant", function(obj)
		if  obj:GetEntity() == "sBuilding_GeoPowerPlant" then
			SuspendPassEdits("Building.ChangeSkin")
			if obj.working then
				obj:ChangeWorkingStateAnim(false)
			end
			obj:DestroyAttaches()
			obj:ChangeEntity("RDM_GeoPowerPlant")
			--AutoAttachObjectsToShapeshifter(obj)
			obj:Settemplate_name("RDM_GeoPowerPlant",nil)

			obj:Init()
			obj:GameInit()
			obj:DeduceAndReapplyDustVisualsFromState()
			
			if obj.working then
				obj:ChangeWorkingStateAnim(true)
			end
			ResumePassEdits("Building.ChangeSkin")
			

		end
	end)
end