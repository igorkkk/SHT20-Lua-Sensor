
function hass_register()
	local hass_device = string.format('{"connections":[["mac","%s"]],"identifiers":["%s"],"model":"ESP8266 + VEML6075","name":"VEML6075 %s","manufacturer":"derf"}', wifi.sta.getmac(), device_id, chip_id)
	local hass_entity_base = string.format('"device":%s,"state_topic":"%s/data","expire_after":600', hass_device, mqtt_prefix)
	local hass_uva = string.format('{%s,"name":"UVA","object_id":"%s_uva","unique_id":"%s_uva","device_class":"irradiance","unit_of_measurement":"µW/cm²","value_template":"{{value_json.uva_uwcm2}}"}', hass_entity_base, device_id, device_id)
	local hass_uvb = string.format('{%s,"name":"UVB","object_id":"%s_uvb","unique_id":"%s_uvb","device_class":"irradiance","unit_of_measurement":"µW/cm²","value_template":"{{value_json.uvb_uwcm2}}"}', hass_entity_base, device_id, device_id)
	local hass_uvi = string.format('{%s,"name":"UV Index","object_id":"%s_uvi","unique_id":"%s_uvi","device_class":"irradiance","unit_of_measurement":"counts","value_template":"{{value_json.uv_index}}"}', hass_entity_base, device_id, device_id)
	local hass_rssi = string.format('{%s,"name":"RSSI","object_id":"%s_rssi","unique_id":"%s_rssi","device_class":"signal_strength","unit_of_measurement":"dBm","value_template":"{{value_json.rssi_dbm}}","entity_category":"diagnostic"}', hass_entity_base, device_id, device_id)

	mqttclient:publish("homeassistant/sensor/" .. device_id .. "/uva/config", hass_uva, 0, 1, function(client)
		mqttclient:publish("homeassistant/sensor/" .. device_id .. "/uvb/config", hass_uvb, 0, 1, function(client)
			mqttclient:publish("homeassistant/sensor/" .. device_id .. "/uvi/config", hass_uvi, 0, 1, function(client)
				mqttclient:publish("homeassistant/sensor/" .. device_id .. "/rssi/config", hass_rssi, 0, 1, function(client)
					collectgarbage()
					setup_client()
				end)
			end)
		end)
	end)
end



-- local hass_device = string.format('{"connections":[["mac","%s"]],"identifiers":["%s"],"model":"ESP8266 + VEML6075","name":"VEML6075 %s","manufacturer":"derf"}', wifi.sta.getmac(), device_id, chip_id)

-- --[[
-- The discovery topic needs to follow a specific format:
-- <discovery_prefix>/<component>/[<node_id>/]<object_id>/config

-- <discovery_prefix>: The Discovery Prefix defaults to homeassistant

-- <component>: One of the supported MQTT integrations, e.g., binary_sensor, or device in case of a device discovery.

-- <node_id>: (Optional): ID of the node providing the topic, this is not used by Home Assistant but may be used 
-- to structure the MQTT topic. 
-- The ID of the node must only consist of characters from the character class [a-zA-Z0-9_-] (alphanumerics, underscore and hyphen).
-- Best practice for entities with a unique_id is to set <object_id> to unique_id and omit the <node_id>.

-- <object_id>: The ID of the device. This is only to allow for separate topics for each device 
-- and is not used for the entity_id. 
-- The ID of the device must only consist of characters from the character class [a-zA-Z0-9_-] (alphanumerics, underscore and hyphen).
-- ]]

-- chip_id = string.format("%06X", node.chipid())
-- device_id = "esp8266_" .. chip_id


-- local hass_uva = string.format(
-- '{%s, -- hass_entity_base
-- "name":"UVA",
-- "object_id":"%s_uva", -- device_id
-- "unique_id":"%s_uva", -- device_id
-- "device_class":"irradiance",
-- "unit_of_measurement":"µW/cm²",
-- "value_template":"{{value_json.uva_uwcm2}}"}', 

-- hass_entity_base, device_id, device_id)

-- local hass_device = string.format('
-- {"connections":[["mac","%s"]], 	-- wifi.sta.getmac()
-- "identifiers":["%s"],			-- device_id
-- "model":"ESP8266 + VEML6075",
-- "name":"VEML6075 %s", 			-- chip_id
-- "manufacturer":"derf"}', wifi.sta.getmac(), device_id, chip_id)

-- local hass_entity_base = string.format('"device":%s,"state_topic":"%s/data","expire_after":600', hass_device, mqtt_prefix)