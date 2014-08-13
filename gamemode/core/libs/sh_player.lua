local playerMeta = FindMetaTable("Player")

-- nutData information for the player.
do
	if (SERVER) then
		function playerMeta:getNutData(key, default)
			local data = self.nutData and self.nutData[key]

			if (data == nil) then
				return default
			else
				return data
			end
		end
	else
		function playerMeta:getNutData(key, default)
			local data = nut.localData and nut.localData[key]

			if (data == nil) then
				return default
			else
				return data
			end
		end

		netstream.Hook("nutData", function(key, value)
			nut.localData = nut.loadData or {}
			nut.localData[key] = value
		end)
	end
end

-- Whitelist networking information here.
do
	if (CLIENT) then
		netstream.Hook("charWhitelist", function(faction, whitelisted)
			local data = nut.faction.indices[faction]

			if (data) then
				nut.localData = nut.localData or {}
				nut.localData.whitelists = nut.localData.whitelists or {}
				nut.localData.whitelists[data.uniqueID] = whitelisted
			end
		end)
	end
	
	function playerMeta:hasWhitelist(faction)
		local data = nut.faction.indices[faction]

		if (data and data.isDefault) then
			return true
		end

		return self:getNutData("whitelists", {})[faction] == true
	end
end