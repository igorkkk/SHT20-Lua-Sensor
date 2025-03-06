do
    local ssid, pwd = SSID, PASSWD
    dat = dat or {}
    wifi.start()
    wifi.mode(wifi.STATION)

    wifi.sta.on("got_ip", function(_, info)
        dat.ip = info.ip
        print("NodeMCU Got IP:", dat.ip)
    end)

    wifi.sta.on("disconnected", function()
        print("NodeMCU Disconnected")
        dat.ip = nil
    end)

    time.settimezone('EST-3')
    time.initntp()

    local cfg = {
        auto = true,
        save = true,
        ssid = ssid,
        pwd = pwd
    }
    wifi.sta.config(cfg, true)
    SSID, PASSWD = nil, nil
    wifi.sta.connect()
end
