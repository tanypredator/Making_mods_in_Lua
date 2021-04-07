--[[local BaseHeight = 0
local MyMapName = FillRandomMapProps(nil, g_CurrentMapParams)

function EstablishBaseHeights()
	if MyMapName = BlankBig_01 then
	BaseHeight = 10000
	end
end]]

function OnMsg.ChangeMapDone()
	if not UICity then return end
 	 local pos = point(250000, 250000, 10000)
 	 SpawnRainLake(pos)
end