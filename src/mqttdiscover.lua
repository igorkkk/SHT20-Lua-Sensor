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
                device_class = "temperature",
                unit_of_measurement = "°C",
                value_template = "{{ value_json.sht20temp | round(1)}}",
                unique_id = dat.device_id .. "_t"
            },
            sht20testhumi = {
                p = "sensor",
                device_class = "humidity",
                unit_of_measurement = "%",
                value_template = "{{ value_json.sht20hum | round(1)}}",
                unique_id = dat.device_id .. "_h"
            },
            sht20testheap = {
                p = "sensor",
                name = 'Куча-Мала',
                device_class = "data_size",
                unit_of_measurement = "B",
                value_template = "{{ value_json.heap }}",
                unique_id = dat.device_id .. "_hp"
            },
            sht20testswitch = {
                p = "switch",
                name = 'Еще Нажми Меня',
                device_class = "outlet",
                topic = "SHT20/421C699E/state",
                command_topic = "SHT20/421C699E/com/sw01",
                value_template = "{{ value_json.switch }}",
                payload_on = "On",
                payload_off = "Off",
                state_on = 'On',
                state_off = 'Off',
                unique_id = dat.device_id .. "_sw"
            }
        },
        state_topic = 'SHT20/421C699E/state',
        -- availability_topic = 'SHT20/421C699E/available',
        qos = 2
    }

    local ok, json_str = pcall(sjson.encode, disc)
    if ok then prt(json_str, '\n', json_str2) else prt('! Lost JSON') end

    if ok and dat.broker then
        m:publish(top, json_str, 2, 0,
            function(con)
                prt('mqttdiscover: MQTT Published Discover Data')
                dat.diskover = true
            end)
    end
end
