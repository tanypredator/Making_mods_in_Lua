function OnMsg.ChangeMapDone()
	if not UICity then return end
	local MyMapName = FillRandomMapProps(nil, g_CurrentMapParams)
	local baseheight = 10000
	if MyMapName == "BlankBig_01" then
 		baseheight = 10000
	elseif MyMapName == "BlankBigTerraceCMix_04" then
 		baseheight = 10000
	end
	
	local sectorlowestpoints = {}
	local number=1

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
				local lakepointx = {}
				local lakepointy = {}
				for x=1,20 do
					lakepointx[x]=initx+stepx
					stepx=stepx+2000
				end
				for y=1,20 do
					lakepointy[y]=inity+stepy
					stepy=stepy+2000
				end

				for n=1,400 do
					for j,x in ipairs(lakepointx) do
						for k,y in ipairs(lakepointy) do
						pointlist[n] = point(lakepointx[j], lakepointy[k])
						pointlist[n] = pointlist[n]:SetTerrainZ()
						end
					end
				end
 		   		local min, height = 1, pointlist[1]:z()
 		   		for i = 1, #pointlist do
					if height>pointlist[i]:z() then
  						min, height = i, pointlist[i]:z()
					end
 		   		end
				if pointlist[min]:z()<(baseheight-1000) then
					sectorlowestpoints[number] = pointlist[min]
					number=number+1
				end
			end
		end
	end


--[[			local sectorlowestpoints = {point(250000,250000,baseheight), point(350000,350000,baseheight)}
local pos = point(250000, 250000, baseheight)]]

	for i,point in ipairs(sectorlowestpoints) do
			SpawnRainLake(point)
	end

end