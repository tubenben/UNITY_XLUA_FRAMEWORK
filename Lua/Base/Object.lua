
local Object = {}
Object._NAME = "Object"
Object._C = Object

function Object:ctor()
	
end


function Object:on_delete()
	
end

function Object:isTypeof(_class)
	assert(_class)
	if self._C == _class then
		return true
	end
	local super = _class.super
	while super do
		if super == _class then
			return true
		end
		super = super.super
	end
	return false
end


function Object:_forwardInvoke(func_name, ...)
	local _class = self._C
	local function recursionInvoke(class,...)
		if class.super then
			recursionInvoke(class.super,...)
		end
		local func = rawget(class, func_name)
		if func then
			func(self, ...)
		end
	end
	recursionInvoke(_class, ...)
end


function Object:_backInvoke(func_name, ...)
	local _class = self._C
	local function recursionInvoke(class,...)
		local func = rawget(class, func_name)
		if func then
			func(self, ...)
		end
		if class.super then
			recursionInvoke(class.super,...)
		end
	end
	recursionInvoke(_class, ...)
end



function Object.new(...)
	local o = {}
	setmetatable(o,{__index = Object})
	o:_forwardInvoke("ctor",...)
	return o
end

return Object