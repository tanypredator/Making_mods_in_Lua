GlobalVar("DustDevilsDisabled", false)

-- from the DustStorm.lua
function StopDustDevils()
	for i = #g_DustDevils, 1, -1 do
		g_DustDevils[i]:delete()
	end
end

-- from the armstrong - Disasters.lua
function OnMsg.TerraformThresholdPassed(id, reached)
  if id == "DustDevilStop" then
    DustDevilsDisabled = reached
    if reached then
      StopDustDevil()
      --to do: should add "OnScreenNotification"
    end
  end
end

local disaster_terraforming_params = {
  MapSettings_DustDevils = {
    param = "Vegetation",
    threshold = "DustDevilsStop"
  },
}

-- from armstrong\Presets - TerraformingParam.lua
PlaceObj("TerraformingParam", {
Threshold = {
    PlaceObj("ThresholdItem", {
      "Id",
      "DustDevilsStop",
      "Threshold",
      50
      })}
alias = "VegetationTP",
id = "Vegetation"
})
