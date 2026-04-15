-- [yue]: Script/System/Command.yue
local _module_0 = nil -- 1
local _ENV = Dora -- 1
local emit <const> = emit -- 2
local Audio <const> = Audio -- 2
local require <const> = require -- 2
local once <const> = once -- 2
local sleep <const> = sleep -- 2
local Director <const> = Director -- 2
local coroutine <const> = coroutine -- 2
local Sprite <const> = Sprite -- 2
local View <const> = View -- 2
local App <const> = App -- 2
local thread <const> = thread -- 2
local setmetatable <const> = setmetatable -- 2
local print <const> = print -- 2
local tostring <const> = tostring -- 2
local table <const> = table -- 2
local select <const> = select -- 2
local _anon_func_0 = function(LsdOSBack) -- 83
	local _with_0 = LsdOSBack() -- 83
	_with_0.order = -1 -- 84
	_with_0:alignLayout() -- 85
	return _with_0 -- 83
end -- 83
local _anon_func_1 = function(Story, filename) -- 86
	local _with_0 = Story(filename) -- 86
	_with_0.order = 0 -- 87
	_with_0:alignLayout() -- 88
	thread(function() -- 89
		return _with_0:showAsync() -- 89
	end) -- 89
	return _with_0 -- 86
end -- 86
local _anon_func_2 = function(...) -- 92
	local _accum_0 = { } -- 92
	local _len_0 = 1 -- 92
	for i = 1, select('#', ...) do -- 92
		_accum_0[_len_0] = tostring(select(i, ...)) -- 92
		_len_0 = _len_0 + 1 -- 92
	end -- 92
	return _accum_0 -- 92
end -- 92
local commands = setmetatable({ -- 6
	preload = function(...) -- 6
		return emit("Command.Preload", { -- 7
			... -- 7
		}) -- 7
	end, -- 6
	BGM = function(filename) -- 9
		return Audio:playStream(filename, true, 0.5) -- 10
	end, -- 9
	stopBGM = function() -- 12
		return Audio:stopStream(1.0) -- 13
	end, -- 12
	SE = function(filename) -- 15
		return Audio:play(filename, false) -- 16
	end, -- 15
	background = function(filename, blur) -- 18
		if blur == nil then -- 18
			blur = true -- 18
		end -- 18
		return emit("Command.Background", filename, blur) -- 19
	end, -- 18
	noBackground = function() -- 21
		return emit("Command.Background") -- 22
	end, -- 21
	figure = function(filename, x, y, scale) -- 24
		if x == nil then -- 24
			x = 0 -- 24
		end -- 24
		if y == nil then -- 24
			y = 0 -- 24
		end -- 24
		if scale == nil then -- 24
			scale = 1.0 -- 24
		end -- 24
		return emit("Command.Figure", filename, x, y, scale) -- 25
	end, -- 24
	noFigure = function() -- 27
		return emit("Command.Figure") -- 27
	end, -- 27
	frame = function(folder, duration, x, y, scale, loop) -- 29
		if x == nil then -- 29
			x = 0 -- 29
		end -- 29
		if y == nil then -- 29
			y = 0 -- 29
		end -- 29
		if scale == nil then -- 29
			scale = 1.0 -- 29
		end -- 29
		if loop == nil then -- 29
			loop = true -- 29
		end -- 29
		emit("Command.Frame") -- 30
		return emit("Command.Frame", folder, duration, loop, x, y, scale) -- 31
	end, -- 29
	noFrame = function() -- 33
		return emit("Command.Frame") -- 33
	end, -- 33
	inputName = function() -- 35
		local u8 = require("utf-8") -- 36
		local InputBox = require("UI.InputBox") -- 37
		local Config = require("Data.Config") -- 38
		local _with_0 = InputBox({ -- 39
			hint = "请输入你的姓名" -- 39
		}) -- 39
		_with_0.visible = false -- 40
		_with_0:schedule(once(function() -- 41
			sleep() -- 42
			_with_0.visible = true -- 43
		end)) -- 41
		_with_0:addTo(Director.ui) -- 44
		_with_0:slot("Inputed", function(name) -- 45
			Config.charName = u8.sub(name, 1, 10) -- 46
			_with_0:removeFromParent() -- 47
			return emit("Story.Advance") -- 48
		end) -- 45
		coroutine.yield("Command") -- 49
		return _with_0 -- 39
	end, -- 35
	chapter = function(filename) -- 51
		local LsdOSBack = require("UI.LsdOSBack") -- 52
		local Story = require("UI.Story") -- 53
		local Config = require("Data.Config") -- 54
		if filename then -- 55
			Config.chapter = filename -- 56
		else -- 58
			filename = Config.chapter -- 58
		end -- 55
		Director.entry:removeAllChildren() -- 59
		Director.ui:removeAllChildren() -- 60
		Director.entry:gslot("Command.Background", function(filename, blur) -- 61
			do -- 62
				local child = Director.entry:getChildByTag("background") -- 62
				if child then -- 62
					child:removeFromParent() -- 63
				end -- 62
			end -- 62
			do -- 64
				local child = Director.ui:getChildByTag("background") -- 64
				if child then -- 64
					child:removeFromParent() -- 65
				end -- 64
			end -- 64
			if not filename then -- 66
				return -- 66
			end -- 66
			local bg -- 67
			do -- 67
				local _with_0 = Sprite(filename) -- 67
				if _with_0 ~= nil then -- 67
					local bgW, bgH = _with_0.width, _with_0.height -- 68
					local updateBGSize -- 69
					updateBGSize = function() -- 69
						local width, height -- 70
						do -- 70
							local _obj_0 = blur and View.size or App.bufferSize -- 70
							width, height = _obj_0.width, _obj_0.height -- 70
						end -- 70
						if bgW / bgH > width / height then -- 71
							_with_0.width, _with_0.height = bgW * height / bgH, height -- 72
						else -- 74
							_with_0.width, _with_0.height = width, bgH * width / bgW -- 74
						end -- 71
					end -- 69
					updateBGSize() -- 75
					_with_0:gslot("AppChange", function(settingName) -- 76
						if settingName == "Size" then -- 76
							return updateBGSize() -- 77
						end -- 76
					end) -- 76
				end -- 67
				bg = _with_0 -- 67
			end -- 67
			if not bg then -- 78
				return -- 78
			end -- 78
			if blur then -- 79
				return Director.entry:addChild(bg, -1, "background") -- 80
			else -- 82
				return Director.ui:addChild(bg, -1, "background") -- 82
			end -- 79
		end) -- 61
		Director.entry:addChild(_anon_func_0(LsdOSBack)) -- 83
		return Director.ui:addChild(_anon_func_1(Story, filename)) -- 86
	end -- 51
}, { -- 91
	__index = function(_self, name) -- 91
		return function(...) -- 91
			return print("[command]: " .. tostring(name) .. "(" .. tostring(table.concat(_anon_func_2(...), ', ')) .. ")") -- 92
		end -- 91
	end -- 91
}) -- 4
_module_0 = commands -- 94
return _module_0 -- 1
