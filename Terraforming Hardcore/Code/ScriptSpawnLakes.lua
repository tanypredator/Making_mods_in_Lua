function OnMsg.ChangeMapDone()
	CreateGameTimeThread(function(self)
	if not UICity then return end
	local MyMapName = FillRandomMapProps(nil, g_CurrentMapParams)
	local baseheight = 10000
	if MyMapName == "BlankBigCanyonCMix_01" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_02" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_03" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_04" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_05" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_06" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_07" then
 		baseheight = 5040
	elseif MyMapName == "BlankBigCanyonCMix_08" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_09" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCanyonCMix_10" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigCliffsCMix_01" then
 		baseheight = 9545
	elseif MyMapName == "BlankBigCliffsCMix_02" then
 		baseheight = 9545
	elseif MyMapName == "BlankBigCrater_01" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigCratersCMix_01" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigCratersCMix_02" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigHeartCMix_03" then
 		baseheight = 5710
	elseif MyMapName == "BlankBigTerraceCMix_01" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_02" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_03" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_04" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_05" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_06" then
 		baseheight = 8250
	elseif MyMapName == "BlankBigTerraceCMix_07" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_08" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_09" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_10" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_11" then
 		baseheight = 7545
	elseif MyMapName == "BlankBigTerraceCMix_12" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_13" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_14" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_15" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_16" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_17" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_18" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_19" then
 		baseheight = 7830
	elseif MyMapName == "BlankBigTerraceCMix_20" then
 		baseheight = 7830
	end
--[[	
	local type = type
	local GetMapSectorXY = GetMapSectorXY
	local IsInMapPlayableArea = IsInMapPlayableArea
	local point = point
	local lowest_points

local function GetLowestPointEachSector()
	-- max the z of the default points
	local max_point = point(0, 0, terrain.GetMapHeight())
	-- and build a list of sectors with it
	lowest_points = {}
	local g_MapSectors = g_MapSectors

	for sector in pairs(g_MapSectors) do
 		if type(sector) ~= "number" then
		lowest_points[sector.id] = max_point
 		end
	end

	local width, height = terrain.GetMapSize()
	local border = mapdata.PassBorder or 0

	local width, height = ConstructableArea:sizexyz()
	width = width / 1000
	height = height / 1000

	for x = 100, width do
 		for y = 10, height do
 			local x1000, y1000 = x * 1000, y * 1000
            -- the area outside grids is counted as the nearest grid.
			if IsInMapPlayableArea(x1000, y1000) then
				local sector_id = GetMapSectorXY(x1000, y1000).id
				local stored = lowest_points[sector_id]:z()
				if stored then
					local pos = point(x1000, y1000):SetTerrainZ()
					if pos:z() < stored then
						lowest_points[sector_id] = pos
					end
				end
			end
		end
	end
	return lowest_points
end

local sectorlowestpoints = GetLowestPointEachSector()
]]

	local sectorlowestpoints = {}

	local tile = GetMapSectorTile()
	local radius = tile/2
	local sectors = g_MapSectors

	for xsec = 1, const.SectorCount do
		local sectors = sectors[xsec]
		for ysec = 1, const.SectorCount do
			local sector = sectors[ysec]
			local center = sector.area:Center()
			local havg = terrain.GetAreaHeight(center, radius)

			if havg<(baseheight+3000) then
				local step = 2000
				local initx=center:x()-radius+500
				local inity=center:y()-radius+500
				local lakepointx = {}
				local lakepointy = {}
				lakepointx[1] = initx
				lakepointy[1] = inity

				for i=1,19 do
 				 	lakepointx[i+1]=lakepointx[i]+step
  			 	 	lakepointy[i+1]=lakepointy[i]+step
				end

				sectorlowestpoints[sector.id] = point(lakepointx[1], lakepointy[1])
				sectorlowestpoints[sector.id] = sectorlowestpoints[sector.id]:SetTerrainZ()

				for j=1,20 do
					for k=1,20 do
						local pos = point(lakepointx[j], lakepointy[k])
						pos = pos:SetTerrainZ()
						if pos:z()<(baseheight-1000) then
							if pos:z() < sectorlowestpoints[sector_id]:z() then
						sectorlowestpoints[sector_id] = pos
							end
						end
					end
				end
			end
		end
	end


	for i,point in ipairs(sectorlowestpoints) do
			SpawnRainLake(point)
	end
	Sleep(25) end, self)
end