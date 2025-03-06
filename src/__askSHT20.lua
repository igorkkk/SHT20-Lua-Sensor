do
    SDA = 21
    SCL = 22
    dat = dat or {}
    wth = wth or {}

    dat.sda = dat.sda or SDA
    dat.scl = dat.scl or SCL
    dat.id = dat.id or i2c.SW
    SDA, SCL = nil, nil


    if dat.sda and dat.scl and not dat.i2c then
        sht20 = require("sht20")
        print('i2c set at pins SDA: ' .. dat.sda .. ', SCL: ' .. dat.scl .. ', Speed:',
            i2c.setup(dat.id, dat.sda, dat.scl, i2c.SLOW))
        dat.i2c = true
    end
    dat.sda = nil
    dat.scl = nil
    local call = function()
        package.loaded["sht20"] = nil
        sht20 = nil
        print('\nSHT20 Done All Works Now!\nHeap: ', node.heap(),'\n')
        collectgarbage("collect")
    end
    local readSHT20 = function()
        sht20 = require("sht20")
        sht20.read(call)
    end
    sht20.read(call)
    tmr.create():alarm(30000, 1, readSHT20)
end
