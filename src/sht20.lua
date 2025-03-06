-- Datasheet Table 7 (Defaults):
-- 85 ms for measure temp
-- 29 ms for measure humidity
do
	local prt = prt or print
	if not dat then
		prt 'No dat Table'; return
	end
	wth            = wth or {}
	local sht20    = {}
	local addr     = 0x40

	local wt       = {}
	wt.T_MEAS_HOLD = 0xE3
	wt.H_MEAS_HOLD = 0xE5
	wt.SOFT_RESET  = 0xFE -- 15 ms

	local call     = function() prt('SHT20 Mod done!') end

	function sht20.srest()
		i2c.start(dat.id)
		if not i2c.address(dat.id, addr, i2c.TRANSMITTER) then
			prt("! sht20.start 1: i2c.address failed")
			return nil
		end
		i2c.write(dat.id, wt.SOFT_RESET)
		i2c.stop(dat.id)
		prt('!SHT20 Restarted!')
	end

	function sht20.crc8(data) -- 0x31 - Polinom, Datasheet
		local crc = 0x00   -- Datasheet!!!!
		for i = 1, 2 do
			crc = bit.bxor(crc, string.byte(data, i))
			for _ = 1, 8 do
				crc = bit.isset(crc, 7) and (bit.bxor(bit.lshift(crc, 1), 0x31)) or (bit.lshift(crc, 1))
				crc = bit.band(crc, 0xff)
			end
		end
		return (crc == string.byte(data, 3))
	end

	local makeT = function(raw)
		local temp = (raw / 65536 * 175.72) - 46.85
		wth.sht20temp = tonumber(string.format("%0.1f ", temp))
		prt("SHT20 temp:", wth.sht20temp)
		sht20.readRaw(wt.H_MEAS_HOLD, 29) -- next step
	end

	local makeH = function(raw)
		local humi = (raw / 65536 * 125) - 6
		wth.sht20hum = tonumber(string.format("%0.1f ", humi))
		prt("SHT20 humi:", wth.sht20hum)
		if call then call() end
	end

	function sht20.readRaw(com, tm)
		i2c.start(dat.id)
		if not i2c.address(dat.id, addr, i2c.TRANSMITTER) then
			prt("! sht20.start 1: failed")
			return
		end
		i2c.write(dat.id, com)
		i2c.stop(dat.id)
		if not tm then return end
		tmr.create():alarm(tm, tmr.ALARM_SINGLE, function(t)
			t = nil
			i2c.start(dat.id)
			if not i2c.address(0, addr, i2c.RECEIVER) then
				prt("! sht20.start 2: failed")
				return
			end
			local data = i2c.read(0, 3)
			i2c.stop(dat.id)
			if data and sht20.crc8(data) then
				local raw = (string.byte(data, 1) * 256 + string.byte(data, 2))
				if tm == 85 then
					makeT(raw)
				else
					makeH(raw)
				end
			else
				prt '! Lost SHT20 Data'
			end
		end)
	end

	function sht20.read(cl)
		call = cl or call
		wth.sht20hum = nil
		wth.sht20temp = nil
		sht20.readRaw(wt.T_MEAS_HOLD, 85)
	end
	function sht20.reset()
		sht20.readRaw(wt.SOFT_RESET)
	end

	return sht20
end
