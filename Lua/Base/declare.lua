local G = _G

function declareObject(...)
	local _classname = select(1, ...)
	local _base = select(2,...)
	local _namespace = select(3,...) or G
 	
 	assert(type(_classname) == "string")
 	assert(_base ~= nil)
 	local declare = G[_classname] or {}
 	G[_classname] = declare
 	declare.super = _base
	declare._NAME = _classname
	declare._C = declare
 	setmetatable(declare, {__index = _base})

 	declare.new = function(...)
 		local o = {}
 		setmetatable(o, {__index = declare})
 		o:_forwardInvoke("ctor",...)
 		return o
 	end

 	return declare, base

end 


function declareSystem(...)
	local _classname = select(1, ...)
	local _base = select(2,...)
 	local _declare = declareObject(_classname, _base, Systems)

	assert(_declare:isTypeof(SystemBase), "[declareWindow] base not is SystemBase")
 	Systems[_classname] = _declare
 	return _declare , _base
 	
end 

function declareWindow(...)
	local _classname = select(1, ...)
	local _base = select(2,...)
 	local _declare = declareObject(_classname, _base, Windows)
 	
	assert(_declare:isTypeof(WindowBase), "[declareWindow] base not is WindowBase")
 	Systems[_classname] = _declare
 	return _declare , _base
 	
end 