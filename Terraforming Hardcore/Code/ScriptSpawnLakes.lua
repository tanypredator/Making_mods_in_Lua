GlobalVar("SectorLowestZ", max_int)
GlobalVar("one_sector_height_marker_check", false)

function OnMsg.ChangeMapDone()
	if not UICity then return end
	local MyMapName = FillRandomMapProps(nil, g_CurrentMapParams)
	local baseheight = 0
	if MyMapName == "BlankBig_01" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_04" then
 		baseheight = 10000
	end

	local mapx, mapy = terrain.GetMapSize()
	local lakecheckpoints = {}
	local lakepointx = {}
	local lakepointy = {}

	local stepx=0
	for i=1,10 do
	pointx=mapx/20+stepx
	stepx=stepx+mapx/10
	lakepointx[i] = pointx
	end

	local stepy=0
	for i=1,10 do
	pointy=mapy/20+stepy
	stepy=stepy+mapy/10
	lakepointy[i] = pointy
	end	

	for i=1,100 do
		for i,x in ipairs(lakepointx) do
			for i,y in ipairs(lakepointy) do
			lakecheckpoints[i] = point(lakepointx,lakepointy)
			end
		end
	end

	local sectorlowestpoints = {}

	for i,p in ipairs(lakecheckpoints) do
	local xradius=mapx/20
		if SectorLowestZ == max_int and not mapdata.IsPrefabMap then
			local tavg, tmin, tmax = terrain.GetAreaHeight(lakecheckpoints[i],xradius)
			SectorLowestZ = tmin

		end

		DefineClass.MinimumSectorElevationMarker = {
	__parents = { "EditorMarker" },
}

		function MinimumSectorElevationMarker:Init()
			if one_sector_height_marker_check then
			print("warning!, this sector already has an elevation marker!")
			end
			if editor.Active == 1 then
				self:EditorTextUpdate(true)
			end
		end

		function MinimumSectorElevationMarker:Done()
			if one_sector_height_marker_check == self then
				one_sector_height_marker_check = nil
			end
		end

		function MinimumSectorElevationMarker:GameInit()
			if one_sector_height_marker_check then
				print("Killing extra MinimumElevationMarkers!")
				DoneObject(self)
			end
			if SectorLowestZ == max_int then
				SectorLowestZ = self:GetVisualPos()
			end
			one_sector_height_marker_check = self
			return SectorLowestZ
		end

		if SectorLowestZ:z()>baseheight then
			sectorlowestpoints[i]=nil
		else
			sectorlowestpoints[i]=SectorLowestZ
		end
	end

	for i,point in ipairs(sectorlowestpoints) do
		if point then
		SpawnRainLake(point)
		end
	end

--[[		local pos = point(250000, 250000, baseheight)]]
end
