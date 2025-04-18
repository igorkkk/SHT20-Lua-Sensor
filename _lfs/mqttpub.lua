do
	if not dat.broker or not m then return end
	if not dat.diskover then
		dofile("mqttdiscover.lua")
		return
	else
		wth.heap = node.heap()
		wth.binary = math.random(1, 10) > 5 and 'On' or 'Off'
		wth.txt = math.random(1, 10) > 5 and 'Good!' or 'Bad!'
		local prt = prt or print
		local ok, json = pcall(sjson.encode, wth)
		wth.heap = nil
		if ok then
			m:publish(dat.clnt .. '/' .. 'state', json, 2, 0, function(con)
				dat.killm = 0
				prt("mqttpub: MQTT Publish Data")
			end)
		else
			prt("!mqttpub: failed to encode or send json!")
		end
		collectgarbage()
	end
end
