do
    -- SDA = 21
    -- SCL = 22
    SDA = 16
    SCL = 17


    print('SDA = '..SDA..', SCL = '..SCL..'\n----------------')
    print('Be Patient!')
    addr = 2
    -- dev_address = 0x62
    id = i2c.SW -- software interface
    -- id = i2c.HW0
    -- speed = i2c.SLOW

    ans = false
    adrtbl = {}
    i2c.setup(id, SDA, SCL, i2c.SLOW)

    function search(addr)
        i2c.start(id)
        ans = i2c.address(id, addr, i2c.TRANSMITTER)
        i2c.stop(id)
        if ans then
            print('Ask For '..'0x'.. string.format("%0X", addr), '- Got Address!')
            adrtbl[#adrtbl+1] ='0x'.. string.format("%0X", addr)
        end
    end
    print('\n')

    tmr.create():alarm(200, 1, function(t)
        addr = addr + 1
        if addr < 127 then
            search(addr)
        else
            t:stop()
            t:unregister()
            t = nil
            if #adrtbl ~= 0 then
                print('\nGot i2c addresses:')
                for k, v in pairs(adrtbl) do
                    print(k, v)
                end
            else
                print("No Devices Found :-( !")
            end

        end
    end)
end