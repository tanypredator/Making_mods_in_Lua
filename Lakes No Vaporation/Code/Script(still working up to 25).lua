function LandscapeLake:GetIrrigationDebit(...)
    local a=15000
    local b=1
    local c=0.25
    local d = GetTerraformParam("Water")
    local irrigation_factor = 2/(d/a+b)-c
    local new_irrigation = self.irrigation*irrigation_factor
	if Terraforming.Water < 80000 then
    return self:IsTerraformingActive() and new_irrigation or 0
	else return 0
	end
end