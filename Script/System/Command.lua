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
local _anon_func_0 = function(LsdOSBack) -- 66
	local _with_0 = LsdOSBack() -- 64
	_with_0.order = -1 -- 65
	_with_0:alignLayout() -- 66
	return _with_0 -- 64
end -- 64
local _anon_func_1 = function(Story, filename, thread) -- 70
	local _with_0 = Story(filename) -- 67
	_with_0.order = 0 -- 68
	_with_0:alignLayout() -- 69
	thread(function() -- 70
		return _with_0:showAsync() -- 70
	end) -- 70
	return _with_0 -- 67
end -- 67
local _anon_func_2 = function(select, tostring, ...) -- 73
	local _accum_0 = { } -- 73
	local _len_0 = 1 -- 73
	for i = 1, select('#', ...) do -- 73
		_accum_0[_len_0] = tostring(select(i, ...)) -- 73
		_len_0 = _len_0 + 1 -- 73
	end -- 73
	return _accum_0 -- 73
end -- 73
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
	figure = function(filename, x, y, scale) -- 15
		if x == nil then -- 15
			x = 0 -- 15
		end -- 15
		if y == nil then -- 15
			y = 0 -- 15
		end -- 15
		if scale == nil then -- 15
			scale = 1.0 -- 15
		end -- 15
		return emit("Command.Figure", filename, x, y, scale) -- 15
	end, -- 15
	inputName = function() -- 17
		local u8 = require("utf-8") -- 18
		local InputBox = require("UI.InputBox") -- 19
		local Config = require("Data.Config") -- 20
		local _with_0 = InputBox({ -- 21
			hint = "请输入你的姓名" -- 21
		}) -- 21
		_with_0.visible = false -- 22
		_with_0:schedule(once(function() -- 23
			sleep() -- 24
			_with_0.visible = true -- 25
		end)) -- 23
		_with_0:addTo(Director.ui) -- 26
		_with_0:slot("Inputed", function(name) -- 27
			Config.charName = u8.sub(name, 1, 10) -- 28
			_with_0:removeFromParent() -- 29
			return emit("Story.Advance") -- 30
		end) -- 27
		coroutine.yield("Command") -- 31
		return _with_0 -- 21
	end, -- 17
	chapter = function(filename) -- 33
		local LsdOSBack = require("UI.LsdOSBack") -- 34
		local Story = require("UI.Story") -- 35
		local Config = require("Data.Config") -- 36
		if filename then -- 37
			Config.chapter = filename -- 38
		else -- 40
			filename = Config.chapter -- 40
		end -- 37
		Director.entry:removeAllChildren() -- 41
		Director.ui:removeAllChildren() -- 42
		Director.entry:gslot("Command.Background", function(filename, blur) -- 43
			local bg -- 44
			do -- 44
				local _with_0 = Sprite(filename) -- 44
				if _with_0 ~= nil then -- 44
					local bgW, bgH = _with_0.width, _with_0.height -- 45
					local updateBGSize -- 46
					updateBGSize = function() -- 46
						local width, height -- 47
						do -- 47
							local _obj_0 = blur and View.size or App.bufferSize -- 47
							width, height = _obj_0.width, _obj_0.height -- 47
						end -- 47
						if bgW / bgH > width / height then -- 48
							_with_0.width, _with_0.height = bgW * height / bgH, height -- 49
						else -- 51
							_with_0.width, _with_0.height = width, bgH * width / bgW -- 51
						end -- 48
					end -- 46
					updateBGSize() -- 52
					_with_0:gslot("AppChange", function(settingName) -- 53
						if settingName == "Size" then -- 53
							return updateBGSize() -- 54
						end -- 53
					end) -- 53
				end -- 44
				bg = _with_0 -- 44
			end -- 44
			if not bg then -- 55
				return -- 55
			end -- 55
			do -- 56
				local child = Director.entry:getChildByTag("background") -- 56
				if child then -- 56
					child:removeFromParent() -- 57
				end -- 56
			end -- 56
			do -- 58
				local child = Director.ui:getChildByTag("background") -- 58
				if child then -- 58
					child:removeFromParent() -- 59
				end -- 58
			end -- 58
			if blur then -- 60
				return Director.entry:addChild(bg, -1, "background") -- 61
			else -- 63
				return Director.ui:addChild(bg, -1, "background") -- 63
			end -- 60
		end) -- 43
		Director.entry:addChild(_anon_func_0(LsdOSBack)) -- 64
		return Director.ui:addChild(_anon_func_1(Story, filename, thread)) -- 70
	end, -- 33
}, { -- 72
	__index = function(_self, name) -- 72
		return function(...) -- 72
			return print("[command]: " .. tostring(name) .. "(" .. tostring(table.concat(_anon_func_2(select, tostring, ...), ', ')) .. ")") -- 73
		end -- 73
	end -- 72
}) -- 3
_module_0 = commands -- 75
return _module_0 -- 75
