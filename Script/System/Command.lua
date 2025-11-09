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
local _anon_func_0 = function(LsdOSBack) -- 71
	local _with_0 = LsdOSBack() -- 69
	_with_0.order = -1 -- 70
	_with_0:alignLayout() -- 71
	return _with_0 -- 69
end -- 69
local _anon_func_1 = function(Story, filename, thread) -- 75
	local _with_0 = Story(filename) -- 72
	_with_0.order = 0 -- 73
	_with_0:alignLayout() -- 74
	thread(function() -- 75
		return _with_0:showAsync() -- 75
	end) -- 75
	return _with_0 -- 72
end -- 72
local _anon_func_2 = function(select, tostring, ...) -- 78
	local _accum_0 = { } -- 78
	local _len_0 = 1 -- 78
	for i = 1, select('#', ...) do -- 78
		_accum_0[_len_0] = tostring(select(i, ...)) -- 78
		_len_0 = _len_0 + 1 -- 78
	end -- 78
	return _accum_0 -- 78
end -- 78
local commands = setmetatable({ -- 5
	preload = function(...) -- 5
		return emit("Command.Preload", { -- 5
			... -- 5
		}) -- 5
	end, -- 5
	BGM = function(filename) -- 7
		return Audio:playStream(filename, true, 0.5) -- 7
	end, -- 7
	stopBGM = function() -- 9
		return Audio:stopStream(1.0) -- 9
	end, -- 9
	SE = function(filename) -- 11
		return Audio:play(filename, false) -- 11
	end, -- 11
	background = function(filename, blur) -- 13
		if blur == nil then -- 13
			blur = true -- 13
		end -- 13
		return emit("Command.Background", filename, blur) -- 13
	end, -- 13
	noBackground = function() -- 15
		return emit("Command.Background") -- 15
	end, -- 15
	figure = function(filename, x, y, scale) -- 17
		if x == nil then -- 17
			x = 0 -- 17
		end -- 17
		if y == nil then -- 17
			y = 0 -- 17
		end -- 17
		if scale == nil then -- 17
			scale = 1.0 -- 17
		end -- 17
		return emit("Command.Figure", filename, x, y, scale) -- 17
	end, -- 17
	noFigure = function() -- 19
		return emit("Command.Figure") -- 19
	end, -- 19
	inputName = function() -- 21
		local u8 = require("utf-8") -- 22
		local InputBox = require("UI.InputBox") -- 23
		local Config = require("Data.Config") -- 24
		local _with_0 = InputBox({ -- 25
			hint = "请输入你的姓名" -- 25
		}) -- 25
		_with_0.visible = false -- 26
		_with_0:schedule(once(function() -- 27
			sleep() -- 28
			_with_0.visible = true -- 29
		end)) -- 27
		_with_0:addTo(Director.ui) -- 30
		_with_0:slot("Inputed", function(name) -- 31
			Config.charName = u8.sub(name, 1, 10) -- 32
			_with_0:removeFromParent() -- 33
			return emit("Story.Advance") -- 34
		end) -- 31
		coroutine.yield("Command") -- 35
		return _with_0 -- 25
	end, -- 21
	chapter = function(filename) -- 37
		local LsdOSBack = require("UI.LsdOSBack") -- 38
		local Story = require("UI.Story") -- 39
		local Config = require("Data.Config") -- 40
		if filename then -- 41
			Config.chapter = filename -- 42
		else -- 44
			filename = Config.chapter -- 44
		end -- 41
		Director.entry:removeAllChildren() -- 45
		Director.ui:removeAllChildren() -- 46
		Director.entry:gslot("Command.Background", function(filename, blur) -- 47
			do -- 48
				local child = Director.entry:getChildByTag("background") -- 48
				if child then -- 48
					child:removeFromParent() -- 49
				end -- 48
			end -- 48
			do -- 50
				local child = Director.ui:getChildByTag("background") -- 50
				if child then -- 50
					child:removeFromParent() -- 51
				end -- 50
			end -- 50
			if not filename then -- 52
				return -- 52
			end -- 52
			local bg -- 53
			do -- 53
				local _with_0 = Sprite(filename) -- 53
				if _with_0 ~= nil then -- 53
					local bgW, bgH = _with_0.width, _with_0.height -- 54
					local updateBGSize -- 55
					updateBGSize = function() -- 55
						local width, height -- 56
						do -- 56
							local _obj_0 = blur and View.size or App.bufferSize -- 56
							width, height = _obj_0.width, _obj_0.height -- 56
						end -- 56
						if bgW / bgH > width / height then -- 57
							_with_0.width, _with_0.height = bgW * height / bgH, height -- 58
						else -- 60
							_with_0.width, _with_0.height = width, bgH * width / bgW -- 60
						end -- 57
					end -- 55
					updateBGSize() -- 61
					_with_0:gslot("AppChange", function(settingName) -- 62
						if settingName == "Size" then -- 62
							return updateBGSize() -- 63
						end -- 62
					end) -- 62
				end -- 53
				bg = _with_0 -- 53
			end -- 53
			if not bg then -- 64
				return -- 64
			end -- 64
			if blur then -- 65
				return Director.entry:addChild(bg, -1, "background") -- 66
			else -- 68
				return Director.ui:addChild(bg, -1, "background") -- 68
			end -- 65
		end) -- 47
		Director.entry:addChild(_anon_func_0(LsdOSBack)) -- 69
		return Director.ui:addChild(_anon_func_1(Story, filename, thread)) -- 75
	end, -- 37
}, { -- 77
	__index = function(_self, name) -- 77
		return function(...) -- 77
			return print("[command]: " .. tostring(name) .. "(" .. tostring(table.concat(_anon_func_2(select, tostring, ...), ', ')) .. ")") -- 78
		end -- 78
	end -- 77
}) -- 3
_module_0 = commands -- 80
return _module_0 -- 80
