math = {}

local function CheckNum(x, name, arg)
    x = tonumber(x)
    if x then
        return x
    else
        print(str.error:format(arg or 1, name, str.nan))
        return 0/0
    end
end

math.floor = rawget(_G, "floatfloor") or function(x)
    x = CheckNum(x, str.floor)

    return x - (x % 1)
end

math.min = Min

function OnMsg.NewHour(hour)
    --Get current terraforming values
    local currentAir = GetTerraformParam("Atmosphere")
    local currentHeat = GetTerraformParam("Temperature")
    local currentWater = GetTerraformParam("Water")
    local currentPlants = GetTerraformParam("Vegetation")

    local airChange = floatfloor((currentPlants/24000)(150000/(currentPlants+50000)))10
    local heatChange = floatfloor((currentAir0.7-currentHeat)/4800)10
    local waterChange = floatfloor((currentHeat0.8-currentWater)/4800)10
    local minEnv = math.min(currentAir,currentHeat,currentWater)
    if minEnv < currentPlants then
    local plantsChange = floatfloor(minEnv-Current)/48
    ChangeTerraformParam("Atmosphere",airChange)
    ChangeTerraformParam("Temperature",heatChange)
    ChangeTerraformParam("Water",waterChange)
    ChangeTerraformParam("Vegetation",plantsChange)
end
