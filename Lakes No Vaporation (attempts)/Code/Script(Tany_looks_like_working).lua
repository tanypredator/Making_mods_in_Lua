function LandscapeLake:GetIrrigationDebit()

	if g_NoTerraforming or Terraforming.Water and Terraforming.Water < 80000 then
  return self:IsTerraformingActive()and self.irrigation or 0
	else
	return 0
	end
end
