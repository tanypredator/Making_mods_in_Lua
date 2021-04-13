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

			if havg<(baseheight+3000) then
				local step = 1000
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
				local pointlist={}
				for n=1,400 do
					for j=1,20 do
						for k=1,20 do
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


	for i,point in ipairs(sectorlowestpoints) do
			SpawnRainLake(point)
	end
	Sleep(25) end, self)
end