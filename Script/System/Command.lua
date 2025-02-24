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
local _anon_func_0 = function(LsdOSBack) -- 64
	local _with_0 = LsdOSBack() -- 62
	_with_0.order = -1 -- 63
	_with_0:alignLayout() -- 64
	return _with_0 -- 62
end -- 62
local _anon_func_1 = function(Story, filename, thread) -- 68
	local _with_0 = Story(filename) -- 65
	_with_0.order = 0 -- 66
	_with_0:alignLayout() -- 67
	thread(function() -- 68
		return _with_0:showAsync() -- 68
	end) -- 68
	return _with_0 -- 65
end -- 65
local _anon_func_2 = function(select, tostring, ...) -- 71
	local _accum_0 = { } -- 71
	local _len_0 = 1 -- 71
	for i = 1, select('#', ...) do -- 71
		_accum_0[_len_0] = tostring(select(i, ...)) -- 71
		_len_0 = _len_0 + 1 -- 71
	end -- 71
	return _accum_0 -- 71
end -- 71
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
	background = function(filename, blur) -- 11
		if blur == nil then -- 11
			blur = true -- 11
		end -- 11
		return emit("Command.Background", filename, blur) -- 11
	end, -- 11
	figure = function(filename, x, y, scale) -- 13
		if x == nil then -- 13
			x = 0 -- 13
		end -- 13
		if y == nil then -- 13
			y = 0 -- 13
		end -- 13
		if scale == nil then -- 13
			scale = 1.0 -- 13
		end -- 13
		return emit("Command.Figure", filename, x, y, scale) -- 13
	end, -- 13
	inputName = function() -- 15
		local u8 = require("utf-8") -- 16
		local InputBox = require("UI.InputBox") -- 17
		local Config = require("Data.Config") -- 18
		local _with_0 = InputBox({ -- 19
			hint = "请输入你的姓名" -- 19
		}) -- 19
		_with_0.visible = false -- 20
		_with_0:schedule(once(function() -- 21
			sleep() -- 22
			_with_0.visible = true -- 23
		end)) -- 21
		_with_0:addTo(Director.ui) -- 24
		_with_0:slot("Inputed", function(name) -- 25
			Config.charName = u8.sub(name, 1, 10) -- 26
			_with_0:removeFromParent() -- 27
			return emit("Story.Advance") -- 28
		end) -- 25
		coroutine.yield("Command") -- 29
		return _with_0 -- 19
	end, -- 15
	chapter = function(filename) -- 31
		local LsdOSBack = require("UI.LsdOSBack") -- 32
		local Story = require("UI.Story") -- 33
		local Config = require("Data.Config") -- 34
		if filename then -- 35
			Config.chapter = filename -- 36
		else -- 38
			filename = Config.chapter -- 38
		end -- 35
		Director.entry:removeAllChildren() -- 39
		Director.ui:removeAllChildren() -- 40
		Director.entry:gslot("Command.Background", function(filename, blur) -- 41
			local bg -- 42
			do -- 42
				local _with_0 = Sprite(filename) -- 42
				if _with_0 ~= nil then -- 42
					local bgW, bgH = _with_0.width, _with_0.height -- 43
					local updateBGSize -- 44
					updateBGSize = function() -- 44
						local width, height -- 45
						do -- 45
							local _obj_0 = blur and View.size or App.bufferSize -- 45
							width, height = _obj_0.width, _obj_0.height -- 45
						end -- 45
						if bgW / bgH > width / height then -- 46
							_with_0.width, _with_0.height = bgW * height / bgH, height -- 47
						else -- 49
							_with_0.width, _with_0.height = width, bgH * width / bgW -- 49
						end -- 46
					end -- 44
					updateBGSize() -- 50
					_with_0:gslot("AppChange", function(settingName) -- 51
						if settingName == "Size" then -- 51
							return updateBGSize() -- 52
						end -- 51
					end) -- 51
				end -- 42
				bg = _with_0 -- 42
			end -- 42
			if not bg then -- 53
				return -- 53
			end -- 53
			if blur then -- 54
				do -- 55
					local child = Director.entry:getChildByTag("background") -- 55
					if child then -- 55
						child:removeFromParent() -- 56
					end -- 55
				end -- 55
				return Director.entry:addChild(bg, 0, "background") -- 57
			else -- 59
				do -- 59
					local child = Director.ui:getChildByTag("background") -- 59
					if child then -- 59
						child:removeFromParent() -- 60
					end -- 59
				end -- 59
				return Director.ui:addChild(bg, 0, "background") -- 61
			end -- 54
		end) -- 41
		Director.entry:addChild(_anon_func_0(LsdOSBack)) -- 62
		return Director.ui:addChild(_anon_func_1(Story, filename, thread)) -- 68
	end, -- 31
}, { -- 70
	__index = function(_self, name) -- 70
		return function(...) -- 70
			return print("[command]: " .. tostring(name) .. "(" .. tostring(table.concat(_anon_func_2(select, tostring, ...), ', ')) .. ")") -- 71
		end -- 71
	end -- 70
}) -- 3
_module_0 = commands -- 73
return _module_0 -- 73
