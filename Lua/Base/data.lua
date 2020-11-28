
Setting = Setting or {}

local mt = 
{
	__index = function(self, key)
	 	local data = rawget(self, key)
	 	if not data then
	 		data = require ("Setting/" .. key)
	 		self[key] = data
	 	end
	 	return data
	end
}

setmetatable(Setting, mt)