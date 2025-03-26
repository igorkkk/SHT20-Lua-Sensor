prt = function(...) if DEBUG then print(...) end end

askfl = function(t, e)
    if type(t) == 'function' then
        local ok, r = pcall(t, e)
        return r
    elseif type(t) == 'string' then
        -- if t:sub(-4) == '.lua' then t = t:sub(1, -5) end
        -- if not file.exists(t) then
        --     if t:sub(-4) == '.lua' then
        --         t = t:sub(1, -4); t = t .. 'lc'
        --     end
        -- end
        -- if file.exists(t) then
        if e then
            node.task.post(function() dofile(t)(e) end)
        else
            node.task.post(function() dofile(t) end)
        end
    end
    -- end
end

do
    ---- For SHT20:
    if SDA and SCL then
        dat.id = ID
        prt('i2c set at pins SDA: ' .. SDA .. ', SCL: ' .. SCL .. ', Speed:', i2c.setup(ID, SDA, SCL, i2c.SLOW))
        dat.i2c = true
        SDA, SCL, ID = nil, nil, nil
    else
        prt '! Setglob: I2c Lost'
    end
    -- dofile('wifi32.lua')
    -- askfl('mqttset.lua')

    askfl('main.lua')
    ---------------------- WiFi --------------------------
    local passerr = rtcmem.read32(0)
    if passerr < 0 or passerr > 10 then
        rtcmem.write32(0, 0)
    end
    if SSID and PASSWD and passerr < 4 then
        dat.ssid = SSID
        dat.pass = PASSWD
    end
    SSID, PASSWD = nil, nil
    if file.exists('setwifidata.lua') then
        if passerr > 3 then
            file.remove('setwifidata.lua')
            rtcmem.write32(0, 0)
        else
            dofile 'setwifidata.lua'
        end
    end
    local ok, err = pcall(dofile, "encript.lua")
    dofile('encript.lua')
    dofile('__networksAsk.lua')
    askfl('mqttset.lua')
    -----------------------------------------------------
end
-----------------------------------------------------
