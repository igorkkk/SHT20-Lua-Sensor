if not dat.broker then return end
do
    dat = dat or {}
    dat.device_id = 'sht20test' .. dat.chip_id

    local top = 'homeassistant/device/' .. dat.device_id .. '/SHT20-Test/config'

    local disc = {
        dev = {
            ids = { dat.device_id },
            name = "SHT20 Test Sensor",
            mf = "igorkkk",
            mdl = "SHT20 Sensor",
            mdl_id = 'Testing Work',
            sw = dofile('_aaversion.lua'),
            sn = dat.chip_id,
            hw = "0.0",
            cu = 'http://' .. dat.ip
        },
        o = {
            name = "SHT20-Test",
            sw = "0.1",
        },
        cmps = {
            sht20testtemp = {
                p = "sensor",
                dev_cla = "temperature",
                ic = "mdi:home-thermometer-outline",
                unit_of_meas = "°C",
                val_tpl = "{{ value_json.sht20temp | round(1)}}",
                uniq_id = dat.device_id .. "_t"
            },
            sht20testhumi = {
                p = "sensor",
                dev_cla = "humidity",
                unit_of_meas = "%",
                val_tpl = "{{ value_json.sht20hum | round(1)}}",
                uniq_id = dat.device_id .. "_h"
            },
            sht20testheap = {
                p = "sensor",
                name = 'Куча-Мала',
                ic = "mdi:wheel-barrow",
                dev_cla = "data_size",
                unit_of_meas = "B",
                val_tpl = "{{ value_json.heap }}",
                uniq_id = dat.device_id .. "_hp"
            },
            sht20testreg = {
                p = "sensor",
                name = 'Регистр',
                ic = "mdi:tape-measure",
                dev_cla = "data_size",
                unit_of_meas = "B",
                val_tpl = "{{ value_json._Reg }}",
                uniq_id = dat.device_id .. "_reg"
            },
            sht20testswitch = {
                p = "switch",
                name = 'Еще Нажми Меня',
                -- ic = "mdi:wheel-barrow",
                dev_cla = "outlet",
                t = "SHT20/421C699E/state",
                cmd_t = "SHT20/421C699E/com/sw01",
                val_tpl = "{{ value_json.switch }}",
                pl_on = "On",
                pl_off = "Off",
                stat_on = 'On',
                stat_off = 'Off',
                uniq_id = dat.device_id .. "_sw"
            },
            sht20testbinary = {
                p = "binary_sensor",
                name = 'Смотри Меня',
                ic = "mdi:emoticon-happy-outline",    
                dev_cla = "light",
                t = "SHT20/421C699E/state",
                val_tpl = "{{ value_json.binary }}",
                pl_on = 'On',
                pl_off = 'Off',
                uniq_id = dat.device_id .. "_bs"
            },
            sht20testtext = {
                p = "text",
                name = 'Читай Меня',
                ic = "mdi:book-heart-outline",
                -- dev_cla = "light",
                command_topic = "SHT20/421C699E/state",
                val_tpl = "{{ value_json.txt }}",
                -- pl_on = 'On',
                -- pl_off = 'Off',
                uniq_id = dat.device_id .. "_txt"
            }
        },
        state_topic = 'SHT20/421C699E/state',
        -- availability_topic = 'SHT20/421C699E/available',
        qos = 2
    }

    local ok, json_str = pcall(sjson.encode, disc)
    if ok then 
        -- prt(json_str, '\n') 
    else 
        prt('! Lost JSON') 
    end

    if ok and dat.broker then
        m:publish(top, json_str, 2, 0,
            function(con)
                prt('mqttdiscover: MQTT Published Discover Data')
                dat.diskover = true
            end)
    end
end
