function LandscapeLake:GetIrrigationDebit()
a=15000
b=1
c=0.25
local irrigation_factor = 2/(Terraforming.Water/a+b)-c
local new_irrigation = self.irrigation*irrigation_factor
	if Terraforming.Water < 80000 
	then
	return self:IsTerraformingActive()and new_irrigation or 0
	else return self:IsTerraformingActive()and 0
	end
end