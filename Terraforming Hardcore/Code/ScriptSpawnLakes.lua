function GetMapBaseheight()
--get map name
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
return baseheight
end

function GetMaxWaterlevel()
local baseheight = GetMapBaseheight()
local maxwaterlevel = baseheight - 1500
local altitude = g_CurrentMapParams.Altitude
	if altitude < 1500 then
		maxwaterlevel = baseheight - altitude - 50
	end
return maxwaterlevel
end

function FindLowestPoints(city)
	local baseheight = GetMapBaseheight()

--table for lowest points in sectors
	local sectorlowestpoints = {}

--from Exploration.lua
	local tile = GetMapSectorTile(city.map_id)
	local radius = tile/2
	local sectors = city.MapSectors

--scan through sectors
	for xsec = 1, const.SectorCount do
		local sectors = sectors[xsec]
		for ysec = 1, const.SectorCount do
			local sector = sectors[ysec]
			local center = sector.area:Center()
			local havg = terrain.GetAreaHeight(center, radius)

--skip high sectors, in each low sector scan through "hexes" with step of about 2 hexes
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

--find point with minimal z and put in into sectorlowestpoints
				for j=1,20 do
					for k=1,20 do
						local pos = point(lakepointx[j], lakepointy[k])
						pos = pos:SetTerrainZ()
						if pos:z() < sectorlowestpoints[sector.id]:z() then
						sectorlowestpoints[sector.id] = pos
						end
					end
				end
			end
		end
	end

return sectorlowestpoints
end

GlobalVar("MinWaterLevel", 6000)

function OnMsg.ChangeMapDone()
	local city = UICity
	local baseheight = GetMapBaseheight()
	local sectorlowestpoints = FindLowestPoints(city)
	local minmin = baseheight-3000
	for i in pairs(sectorlowestpoints) do
		if sectorlowestpoints[i]:z() < minmin then
				minmin = sectorlowestpoints[i]:z()-500
		end
	end
	MinWaterLevel = minmin

end

function OnMsg.ChangeMapDone()
	local city = UICity
	CreateGameTimeThread(function()
  -- the first msg box closed is the welcome to mars one
  WaitMsg("MessageBoxClosed")

	if not UICity then return end
	local sectorlowestpoints = FindLowestPoints(city)
	local baseheight = GetMapBaseheight()

--in each sector spawn a lake in the lowest point if it is low enough.
	for i in pairs(sectorlowestpoints) do
		if sectorlowestpoints[i]:z()<(baseheight-2000) then
			SpawnRainLake(sectorlowestpoints[i])
		end
	end

	end)
end