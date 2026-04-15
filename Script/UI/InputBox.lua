-- [yue]: Script/UI/InputBox.yue
local _module_0 = nil -- 1
local _ENV = Dora -- 1
local u8 = require("utf-8") -- 2
local InputBox = require("UI.View.InputBox") -- 3
local Class <const> = Class -- 4
local Vec2 <const> = Vec2 -- 4
local Line <const> = Line -- 4
local Color <const> = Color -- 4
local loop <const> = loop -- 4
local sleep <const> = sleep -- 4
local math <const> = math -- 4
local Size <const> = Size -- 4
local Keyboard <const> = Keyboard -- 4
local App <const> = App -- 4
local property <const> = property -- 4
local TextInput = Class((function(args) -- 6
	local hint, text = args.hint, args.text -- 7
	if hint == nil then -- 8
		hint = "" -- 8
	end -- 8
	if text == nil then -- 9
		text = "" -- 9
	end -- 9
	local inputBox = InputBox() -- 12
	local width, height -- 13
	do -- 13
		local _obj_0 = inputBox.label.parent -- 13
		width, height = _obj_0.width, _obj_0.height -- 13
	end -- 13
	local label -- 15
	do -- 15
		local _with_0 = inputBox.label -- 15
		if text == "" and hint ~= "" then -- 16
			_with_0.text = hint -- 17
			_with_0.opacity = 0.6 -- 18
		else -- 20
			_with_0.text = text -- 20
		end -- 16
		_with_0.y = height / 2 - 35 / 2 -- 21
		_with_0.anchor = Vec2.zero -- 22
		_with_0.alignment = "Left" -- 23
		label = _with_0 -- 15
	end -- 15
	local cursor = Line({ -- 25
		Vec2.zero, -- 25
		Vec2(0, 35 + 2) -- 25
	}, Color(0xffffffff)) -- 25
	local blink -- 26
	blink = function() -- 26
		return loop(function() -- 26
			cursor.visible = true -- 27
			sleep(0.5) -- 28
			cursor.visible = false -- 29
			return sleep(0.5) -- 30
		end) -- 26
	end -- 26
	cursor.y = label.y -- 32
	cursor.visible = false -- 33
	local updateText -- 35
	updateText = function(txt) -- 35
		label.text = txt -- 36
		local offsetX = math.max(label.width + 3 - width, 0) -- 37
		label.x = -offsetX -- 38
		cursor.x = label.width - offsetX - 30 -- 39
		return cursor:schedule(blink()) -- 40
	end -- 35
	do -- 42
		local _with_0 = inputBox.box -- 42
		local textEditing = "" -- 43
		local textDisplay = "" -- 44
		_with_0.size = Size(width, height) -- 46
		_with_0.hint = hint -- 47
		_with_0:addChild(cursor) -- 48
		local updateIMEPos -- 50
		updateIMEPos = function(next) -- 50
			return _with_0:convertToWindowSpace(Vec2(-label.x + label.width, 0), function(pos) -- 51
				Keyboard:updateIMEPosHint(pos) -- 52
				if next then -- 53
					return next() -- 53
				end -- 53
			end) -- 51
		end -- 50
		local startEditing -- 54
		startEditing = function() -- 54
			return updateIMEPos(function() -- 55
				_with_0:detachIME() -- 56
				_with_0:attachIME() -- 57
				return updateIMEPos() -- 58
			end) -- 55
		end -- 54
		_with_0.updateDisplayText = function(_, txt) -- 59
			textDisplay = txt -- 60
			label.text = txt -- 61
		end -- 59
		_with_0:slot("AttachIME", function() -- 63
			label.opacity = 1.0 -- 64
			_with_0.keyboardEnabled = true -- 65
			return updateText(textDisplay) -- 66
		end) -- 63
		_with_0:slot("DetachIME", function() -- 68
			_with_0.keyboardEnabled = false -- 69
			cursor.visible = false -- 70
			cursor:unschedule() -- 71
			textEditing = "" -- 72
			label.x = 0 -- 73
			if textDisplay == "" then -- 74
				label.opacity = 0.6 -- 75
				label.text = _with_0.hint -- 76
			end -- 74
		end) -- 68
		_with_0.touchEnabled = true -- 78
		_with_0:slot("Tapped", function(touch) -- 79
			if touch.first then -- 79
				return startEditing() -- 79
			end -- 79
		end) -- 79
		_with_0:slot("KeyPressed", function(key) -- 81
			if App.platform == "Android" and u8.len(textEditing) == 1 then -- 82
				if key == "BackSpace" then -- 83
					textEditing = "" -- 83
				end -- 83
			else -- 85
				if textEditing ~= "" then -- 85
					return -- 85
				end -- 85
			end -- 82
			if "BackSpace" == key then -- 87
				if #textDisplay > 0 then -- 88
					textDisplay = u8.sub(textDisplay, 1, -2) -- 89
					return updateText(textDisplay) -- 90
				end -- 88
			elseif "Return" == key or "Escape" == key then -- 91
				_with_0:detachIME() -- 92
				return inputBox:emit("Inputed", textDisplay) -- 93
			end -- 86
		end) -- 81
		_with_0:slot("TextInput", function(txt) -- 95
			textDisplay = u8.sub(textDisplay, 1, -1 - u8.len(textEditing)) .. txt -- 96
			textEditing = "" -- 97
			updateText(textDisplay) -- 98
			return updateIMEPos() -- 99
		end) -- 95
		_with_0:slot("TextEditing", function(txt, _start) -- 101
			textDisplay = u8.sub(textDisplay, 1, -1 - u8.len(textEditing)) .. txt -- 102
			textEditing = txt -- 103
			label.text = textDisplay -- 104
			local offsetX = math.max(label.width + 3 - width, 0) -- 105
			label.x = -offsetX -- 106
			updateText(textDisplay) -- 107
			return updateIMEPos() -- 108
		end) -- 101
	end -- 42
	inputBox:alignLayout() -- 110
	return inputBox -- 111
end), { -- 113
	text = property((function(self) -- 113
		return self.label.text -- 113
	end), function(self, value) -- 114
		if self.imeAttached then -- 115
			self:detachIME() -- 115
		end -- 115
		return self:updateDisplayText(value) -- 116
	end) -- 113
}) -- 6
_module_0 = TextInput -- 119
return _module_0 -- 1
