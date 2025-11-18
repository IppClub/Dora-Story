-- [yue]: Script/System/Command.yue
local setmetatable = _G.setmetatable -- 1
local emit = Dora.emit -- 1
local Audio = Dora.Audio -- 1
local once = Dora.once -- 1
local sleep = Dora.sleep -- 1
local Director = Dora.Director -- 1
local coroutine = _G.coroutine -- 1
local Sprite = Dora.Sprite -- 1
local View = Dora.View -- 1
local App = Dora.App -- 1
local thread = Dora.thread -- 1
local print = _G.print -- 1
local tostring = _G.tostring -- 1
local table = _G.table -- 1
local select = _G.select -- 1
local _module_0 = nil -- 1
local _anon_func_0 = function(LsdOSBack) -- 83
	local _with_0 = LsdOSBack() -- 81
	_with_0.order = -1 -- 82
	_with_0:alignLayout() -- 83
	return _with_0 -- 81
end -- 81
local _anon_func_1 = function(Story, filename, thread) -- 87
	local _with_0 = Story(filename) -- 84
	_with_0.order = 0 -- 85
	_with_0:alignLayout() -- 86
	thread(function() -- 87
		return _with_0:showAsync() -- 87
	end) -- 87
	return _with_0 -- 84
end -- 84
local _anon_func_2 = function(select, tostring, ...) -- 90
	local _accum_0 = { } -- 90
	local _len_0 = 1 -- 90
	for i = 1, select('#', ...) do -- 90
		_accum_0[_len_0] = tostring(select(i, ...)) -- 90
		_len_0 = _len_0 + 1 -- 90
	end -- 90
	return _accum_0 -- 90
end -- 90
local commands = setmetatable({ -- 5
	preload = function(...) -- 5
		return emit("Command.Preload", { -- 6
			... -- 6
		}) -- 6
	end, -- 5
	BGM = function(filename) -- 8
		return Audio:playStream(filename, true, 0.5) -- 9
	end, -- 8
	stopBGM = function() -- 11
		return Audio:stopStream(1.0) -- 12
	end, -- 11
	SE = function(filename) -- 14
		return Audio:play(filename, false) -- 15
	end, -- 14
	background = function(filename, blur) -- 17
		if blur == nil then -- 17
			blur = true -- 17
		end -- 17
		return emit("Command.Background", filename, blur) -- 18
	end, -- 17
	noBackground = function() -- 20
		return emit("Command.Background") -- 21
	end, -- 20
	figure = function(filename, x, y, scale) -- 23
		if x == nil then -- 23
			x = 0 -- 23
		end -- 23
		if y == nil then -- 23
			y = 0 -- 23
		end -- 23
		if scale == nil then -- 23
			scale = 1.0 -- 23
		end -- 23
		return emit("Command.Figure", filename, x, y, scale) -- 24
	end, -- 23
	noFigure = function() -- 26
		return emit("Command.Figure") -- 26
	end, -- 26
	frame = function(folder, duration, x, y, scale, loop) -- 28
		if x == nil then -- 28
			x = 0 -- 28
		end -- 28
		if y == nil then -- 28
			y = 0 -- 28
		end -- 28
		if scale == nil then -- 28
			scale = 1.0 -- 28
		end -- 28
		if loop == nil then -- 28
			loop = true -- 28
		end -- 28
		return emit("Command.Frame", folder, duration, loop, x, y, scale) -- 29
	end, -- 28
	noFrame = function() -- 31
		return emit("Command.Frame") -- 31
	end, -- 31
	inputName = function() -- 33
		local u8 = require("utf-8") -- 34
		local InputBox = require("UI.InputBox") -- 35
		local Config = require("Data.Config") -- 36
		local _with_0 = InputBox({ -- 37
			hint = "请输入你的姓名" -- 37
		}) -- 37
		_with_0.visible = false -- 38
		_with_0:schedule(once(function() -- 39
			sleep() -- 40
			_with_0.visible = true -- 41
		end)) -- 39
		_with_0:addTo(Director.ui) -- 42
		_with_0:slot("Inputed", function(name) -- 43
			Config.charName = u8.sub(name, 1, 10) -- 44
			_with_0:removeFromParent() -- 45
			return emit("Story.Advance") -- 46
		end) -- 43
		coroutine.yield("Command") -- 47
		return _with_0 -- 37
	end, -- 33
	chapter = function(filename) -- 49
		local LsdOSBack = require("UI.LsdOSBack") -- 50
		local Story = require("UI.Story") -- 51
		local Config = require("Data.Config") -- 52
		if filename then -- 53
			Config.chapter = filename -- 54
		else -- 56
			filename = Config.chapter -- 56
		end -- 53
		Director.entry:removeAllChildren() -- 57
		Director.ui:removeAllChildren() -- 58
		Director.entry:gslot("Command.Background", function(filename, blur) -- 59
			do -- 60
				local child = Director.entry:getChildByTag("background") -- 60
				if child then -- 60
					child:removeFromParent() -- 61
				end -- 60
			end -- 60
			do -- 62
				local child = Director.ui:getChildByTag("background") -- 62
				if child then -- 62
					child:removeFromParent() -- 63
				end -- 62
			end -- 62
			if not filename then -- 64
				return -- 64
			end -- 64
			local bg -- 65
			do -- 65
				local _with_0 = Sprite(filename) -- 65
				if _with_0 ~= nil then -- 65
					local bgW, bgH = _with_0.width, _with_0.height -- 66
					local updateBGSize -- 67
					updateBGSize = function() -- 67
						local width, height -- 68
						do -- 68
							local _obj_0 = blur and View.size or App.bufferSize -- 68
							width, height = _obj_0.width, _obj_0.height -- 68
						end -- 68
						if bgW / bgH > width / height then -- 69
							_with_0.width, _with_0.height = bgW * height / bgH, height -- 70
						else -- 72
							_with_0.width, _with_0.height = width, bgH * width / bgW -- 72
						end -- 69
					end -- 67
					updateBGSize() -- 73
					_with_0:gslot("AppChange", function(settingName) -- 74
						if settingName == "Size" then -- 74
							return updateBGSize() -- 75
						end -- 74
					end) -- 74
				end -- 65
				bg = _with_0 -- 65
			end -- 65
			if not bg then -- 76
				return -- 76
			end -- 76
			if blur then -- 77
				return Director.entry:addChild(bg, -1, "background") -- 78
			else -- 80
				return Director.ui:addChild(bg, -1, "background") -- 80
			end -- 77
		end) -- 59
		Director.entry:addChild(_anon_func_0(LsdOSBack)) -- 81
		return Director.ui:addChild(_anon_func_1(Story, filename, thread)) -- 87
	end, -- 49
}, { -- 89
	__index = function(_self, name) -- 89
		return function(...) -- 89
			return print("[command]: " .. tostring(name) .. "(" .. tostring(table.concat(_anon_func_2(select, tostring, ...), ', ')) .. ")") -- 90
		end -- 90
	end -- 89
}) -- 3
_module_0 = commands -- 92
return _module_0 -- 92
