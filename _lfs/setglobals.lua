prt = function(...) if DEBUG then print(...) end end
askfl = function(t, e)
    if e then
        node.task.post(function() dofile(t)(e) end)
    else
        node.task.post(function() dofile(t) end)
    end
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
    dofile('wifi32.lua')
    askfl('mqttset.lua') 
    askfl('main.lua')
end
-----------------------------------------------------
