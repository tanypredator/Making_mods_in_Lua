local orig_LandscapeLake_SetVolume = LandscapeLake.SetVolume
function LandscapeLake:SetVolume(vol, ...)
local water = Terraforming and Terraforming.Water
-- no terraforming for some reason (or water is too low), so just return orig func
if g_NoTerraforming or water and water < 80000 then
return orig_LandscapeLake_SetVolume(self, vol, ...)
end

-- if the new volume is under the current then abort
if vol < self.volume then
return false
end

return orig_LandscapeLake_SetVolume(self, vol, ...)
end