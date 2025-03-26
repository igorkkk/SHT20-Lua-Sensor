--------- wifi -------------
SSID = "SSID"
PASSWD = "PASS"

------- SHT20 -------
SDA = 21
SCL = 22
ID = i2c.SW

DEBUG = true

wth.city = 'Moscow'
time.settimezone('EST-3')

-- Настройки MQTT:
dat.brk = '192.168.57.190' -- Брокер
dat.port = 1883           -- Порт

dat.chip_id = string.format("%X", node.chipid())

dat.clnt = 'SHT20/'..dat.chip_id
dat.mqlgin = dat.chip_id
dat.mqpass = 'MQTT_Passwd'
---------------------- Дальше не менять ------------------------
node.task.post(function() dofile('setglobals.lua') end)
