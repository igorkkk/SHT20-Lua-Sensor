if killtop and #killtop ~= 0 then
	local prt = prt or print
	local com, dt
	com = table.remove(killtop)

	if not com then
		return node.task.post(function() dofile('mqttpub.lua') end)
	end

	-- local ok, com2 = pcall(sjson.decode(com[2]))

	local com2 = sjson.decode(com[2])
	-- if ok then
		for k,v in pairs(com2) do
			print(k,v)
		end 

		--{"offset":10800,"tempnow":3.8,"tempFC":3.5,"weatherFC":3}
		if com2.offset then wth.offset = com2.offset end
		if com2.tempnow then wth.tempOM = com2.tempnow end
		if com2.tempFC then wth.tempFCOM = com2.tempFC end
		if com2.weatherFC then wth.codeFCOM = com2.weatherFC end
	-- end

	if com[1] == 'outtemp' then
		if com[2] then
			dt = tonumber(com[2]) or nil
			if dt then wth.mqttoutt = dt end
		end
	elseif com[1] == 'intemp' then
		if com[2] then
			dt = tonumber(com[2]) or nil
			if dt then wth.mqttint = dt end
		end
	else
		prt('No "cmd" to Work')
	end

	com = nil
	node.task.post(function() dofile('mqttanalize.lua') end)
end
