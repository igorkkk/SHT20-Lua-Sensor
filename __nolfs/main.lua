
WorkTmr = tmr.create()

local point = 1
local wt = {}
wt[1] = {'__askSHT20.lua', 0, 30}
wt[2] = {'chck_mem.lua', 0, 30}
wt[3] = {'mqttpub.lua', 0, 30}


local dispatch = function()
    local tm = time.get()
    if wt[point][3] < tm - wt[point][2] then
        wt[point][2] = tm
        askfl(wt[point][1])
        point = point + 1
    end
    point = point > #wt and 1 or point
end

WorkTmr:alarm(3000, tmr.ALARM_AUTO, dispatch)
