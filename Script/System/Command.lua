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
local _anon_func_0 = function(LsdOSBack) -- 84
	local _with_0 = LsdOSBack() -- 82
	_with_0.order = -1 -- 83
	_with_0:alignLayout() -- 84
	return _with_0 -- 82
end -- 82
local _anon_func_1 = function(Story, filename, thread) -- 88
	local _with_0 = Story(filename) -- 85
	_with_0.order = 0 -- 86
	_with_0:alignLayout() -- 87
	thread(function() -- 88
		return _with_0:showAsync() -- 88
	end) -- 88
	return _with_0 -- 85
end -- 85
local _anon_func_2 = function(select, tostring, ...) -- 91
	local _accum_0 = { } -- 91
	local _len_0 = 1 -- 91
	for i = 1, select('#', ...) do -- 91
		_accum_0[_len_0] = tostring(select(i, ...)) -- 91
		_len_0 = _len_0 + 1 -- 91
	end -- 91
	return _accum_0 -- 91
end -- 91
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
		emit("Command.Frame") -- 29
		return emit("Command.Frame", folder, duration, loop, x, y, scale) -- 30
	end, -- 28
	noFrame = function() -- 32
		return emit("Command.Frame") -- 32
	end, -- 32
	inputName = function() -- 34
		local u8 = require("utf-8") -- 35
		local InputBox = require("UI.InputBox") -- 36
		local Config = require("Data.Config") -- 37
		local _with_0 = InputBox({ -- 38
			hint = "请输入你的姓名" -- 38
		}) -- 38
		_with_0.visible = false -- 39
		_with_0:schedule(once(function() -- 40
			sleep() -- 41
			_with_0.visible = true -- 42
		end)) -- 40
		_with_0:addTo(Director.ui) -- 43
		_with_0:slot("Inputed", function(name) -- 44
			Config.charName = u8.sub(name, 1, 10) -- 45
			_with_0:removeFromParent() -- 46
			return emit("Story.Advance") -- 47
		end) -- 44
		coroutine.yield("Command") -- 48
		return _with_0 -- 38
	end, -- 34
	chapter = function(filename) -- 50
		local LsdOSBack = require("UI.LsdOSBack") -- 51
		local Story = require("UI.Story") -- 52
		local Config = require("Data.Config") -- 53
		if filename then -- 54
			Config.chapter = filename -- 55
		else -- 57
			filename = Config.chapter -- 57
		end -- 54
		Director.entry:removeAllChildren() -- 58
		Director.ui:removeAllChildren() -- 59
		Director.entry:gslot("Command.Background", function(filename, blur) -- 60
			do -- 61
				local child = Director.entry:getChildByTag("background") -- 61
				if child then -- 61
					child:removeFromParent() -- 62
				end -- 61
			end -- 61
			do -- 63
				local child = Director.ui:getChildByTag("background") -- 63
				if child then -- 63
					child:removeFromParent() -- 64
				end -- 63
			end -- 63
			if not filename then -- 65
				return -- 65
			end -- 65
			local bg -- 66
			do -- 66
				local _with_0 = Sprite(filename) -- 66
				if _with_0 ~= nil then -- 66
					local bgW, bgH = _with_0.width, _with_0.height -- 67
					local updateBGSize -- 68
					updateBGSize = function() -- 68
						local width, height -- 69
						do -- 69
							local _obj_0 = blur and View.size or App.bufferSize -- 69
							width, height = _obj_0.width, _obj_0.height -- 69
						end -- 69
						if bgW / bgH > width / height then -- 70
							_with_0.width, _with_0.height = bgW * height / bgH, height -- 71
						else -- 73
							_with_0.width, _with_0.height = width, bgH * width / bgW -- 73
						end -- 70
					end -- 68
					updateBGSize() -- 74
					_with_0:gslot("AppChange", function(settingName) -- 75
						if settingName == "Size" then -- 75
							return updateBGSize() -- 76
						end -- 75
					end) -- 75
				end -- 66
				bg = _with_0 -- 66
			end -- 66
			if not bg then -- 77
				return -- 77
			end -- 77
			if blur then -- 78
				return Director.entry:addChild(bg, -1, "background") -- 79
			else -- 81
				return Director.ui:addChild(bg, -1, "background") -- 81
			end -- 78
		end) -- 60
		Director.entry:addChild(_anon_func_0(LsdOSBack)) -- 82
		return Director.ui:addChild(_anon_func_1(Story, filename, thread)) -- 88
	end, -- 50
}, { -- 90
	__index = function(_self, name) -- 90
		return function(...) -- 90
			return print("[command]: " .. tostring(name) .. "(" .. tostring(table.concat(_anon_func_2(select, tostring, ...), ', ')) .. ")") -- 91
		end -- 91
	end -- 90
}) -- 3
_module_0 = commands -- 93
return _module_0 -- 93
