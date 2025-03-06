local dev = {
    ids     = 'esp8266_2B3C5E',
    mdl     = 'ESP8266 + SCD4x',
    dname   = 'SCD4x 2B3C5E',
    mf      = 'igorkkk',
    stat_t  = 'SHT20/data',
    avty_t  = 'SHT20/state',
    exp_aft = 600,
}

local at = {
    nameT           = 'Temperature',
    obj_idT         = 'esp8266_2B3C5E_temperature',
    obj_idH         = 'esp8266_2B3C5E_temperature',
    -- uniq_id        = 'esp8266_2B3C5E_temperature',
    dev_cls        = 'temperature', -- ????????????????????
    unit_of_meas_g = '°c',
    val_tpl        = '{{value_json.temperature}}'

}


devT = {
    device       =
    {
        ids = { dev.ids },
        mdl = dev.mdl,
        name = dev.dname,
        mf = dev.mf
    },
    stat_t       = dev.stat_t,
    avty_t       = dev.avty_t,
    exp_aft      = dev.exp_aft,
    name         = at.name,
    obj_id       = at.obj_id,
    uniq_id      = at.obj_id,
    dev_cls      = at.dev_cla,
    unit_of_meas = at.unit_of_meas_g,
    val_tpl      = at.val_tpl
}

local ok, json = pcall(sjson.encode, devT)
if ok then print(json) else print('! Lost JSON') end
