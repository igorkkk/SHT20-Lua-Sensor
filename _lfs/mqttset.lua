do
    local prt = prt or print
    local brk = dat.brk; dat.brk = nil
    local port = dat.port; dat.port = nil
    local subscribe, merror, newm, mconnect, getmqtt
    dat.killm = 0

    getmqtt = tmr.create()
    getmqtt:alarm(35000, tmr.ALARM_AUTO, function(t)
        if dat.killm ~= 0 then prt('!mqttset: dat.killm:', dat.killm) end
        dat.killm = dat.killm + 1
        if dat.killm > 5 then
            if m then m:close() ; m = nil end
            dat.broker = false
        end
        if dat.killm > 6 then
            if not m then mconnect(newm())
            else m:connect(brk, port, 0, 0, subscribe, merror)
            end
        end
    end)

    function subscribe(con)
        prt("mqttset: Connected MQTT Broker as '"..dat.clnt.."'")
        dat.killm = 0
        dat.broker = true
        con:subscribe(dat.clnt.."/com/#", 0)
        con:publish(dat.clnt..'/available', "On", 0, 0)
        askfl('mqttpub.lua')
        prt("mqttset: Subscribed at '"..dat.clnt.."/com/#'")
    end

    function merror(con, errmsg)
        prt('!mqttset: MQTT Error:', errmsg)
        dat.killm = 6
        getmqtt:start(true)
        errmsg = nil
        collectgarbage()
    end

    function newm()
        m = mqtt.Client(dat.clnt, 25, dat.mqlgin, dat.mqpass)
        m:lwt(dat.clnt..'/available', "Off", 0, 1)
        m:on("offline", function(con, msg)
            con:close()
            dat.broker = false
            merror(con, msg)
        end)
        m:on("message", function(con, top, dt)
            if not killtop then killtop = {} end
            top = string.match(top, "/(%w+)$")
            prt('mqttset: Got', top, dt)
            if dt then
                table.insert(killtop, {top, dt})
                if not dat.analiz then
                    dofile("mqttanalize.lua")
                end
            end
        end)
        return m
    end

    function mconnect(con)
        if dat.ip then
            prt('mqttset: Now connect to ', brk, port)
            con:connect(brk, port, 0, 0, subscribe, merror)
        else dat.killm = 7 end
    end
    mconnect(newm())
end