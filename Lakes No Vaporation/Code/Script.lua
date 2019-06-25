function LandscapeLake:GetIrrigationDebit()
	if Terraforming.Water < 10000 then
	return self:IsTerraformingActive()and 2*self.irrigation or 0
	elseif Terraforming.Water >= 10000 and Terraforming.Water < 25000 then
	return self:IsTerraformingActive()and self.irrigation or 0
	elseif Terraforming.Water >= 25000 and Terraforming.Water < 40000 then
	return self:IsTerraformingActive()and 0.75*self.irrigation or 0
	elseif Terraforming.Water >= 40000 and Terraforming.Water < 65000 then
	return self:IsTerraformingActive()and 0.5*self.irrigation or 0
	elseif Terraforming.Water >= 65000 and Terraforming.Water < 80000 then
	return self:IsTerraformingActive()and 0.25*self.irrigation or 0
	else return self:IsTerraformingActive()and 0
	end
end