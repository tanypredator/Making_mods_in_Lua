function OnMsg.ChangeMapDone()
	if not UICity then return end
	local MyMapName = FillRandomMapProps(nil, g_CurrentMapParams)
	local baseheight = 0
	if MyMapName == "BlankBig_01" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_04" then
 		baseheight = 10000
	end
	
	local sectorlowestpoints = {}
	local n=1

	local tile = GetMapSectorTile()
	local radius = tile/2
	local sectors = g_MapSectors
	for xsec = 1, const.SectorCount do
		local sectors = sectors[xsec]
		for ysec = 1, const.SectorCount do
			local sector = sectors[ysec]
			local center = sector.area:Center()
			local havg = terrain.GetAreaHeight(center, radius)
			local pointlist={}

			if havg<(baseheight+4000) then
			local n=1
			local stepx = 0
			local stepy = 0
			local initx=center:x()-radius+500
			local inity=center:y()-radius+500
				for x=1,40 do
					for y=1,40 do
						pointlist[n] = point((initx+stepx),(inity+stepy))
						pointlist[n] = pointlist[n]:SetTerrainZ()
						stepy=stepy+1000
						n=n+1
						end
					stepx=stepx+1000
					n=n+1
					end
				end
 		   	local key, value = 1, pointlist[1]:z()
 		   	for i = 2, #pointlist do
				if value<pointlist[i]:z() then
  					key, value = i, pointlist[i]:z()
				end
 		   	end
			sectorlowestpoints[n] = pointlist[key]
			n=n+1
		end
	end


--[[			local sectorlowestpoints = {point(250000,250000,baseheight), point(350000,350000,baseheight)}
local pos = point(250000, 250000, baseheight)]]

	for i,point in ipairs(sectorlowestpoints) do
		SpawnRainLake(point)
	end

end
