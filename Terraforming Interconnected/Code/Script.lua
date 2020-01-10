function GreenHauseHeating ()
local param = GetTerraformParam("Atmosphere")
	if param >= 10000 then
	local heating = param*0.01
      ChangeTerraformParam("Temperature", heating)
	end
end

function OnMsg.NewHour(hour)
 if hour == 8 then
GreenHauseHeating ()
 end -- once a day at 8AM
end 

function FormatTerraformingValue(value)
  local v = value * 100
  local mul = MaxTerraformingValue
  local d1 = MulDivTrunc(v, 10, mul) % 10
  local d2 = MulDivTrunc(v, 100, mul) % 10
  if d1 == 0 and d2 == 0 then
    return T({
      11723,
      "<n>%",
      n = v / mul
    })
  elseif d2 == 0 then
    return T({
      12199,
      "<n>.<d1>%",
      n = v / mul,
      d1 = d1
    })
  else
    return T({
      11724,
      "<n>.<d1><d2>%",
      n = v / mul,
      d1 = d1,
      d2 = d2
    })
  end
end
