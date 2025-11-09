-- [yue]: Script/UI/Story.yue
local type = _G.type -- 1
local Class = Dora.Class -- 1
local property = Dora.property -- 1
local print = _G.print -- 1
local Sprite = Dora.Sprite -- 1
local thread = Dora.thread -- 1
local Cache = Dora.Cache -- 1
local tostring = _G.tostring -- 1
local sleep = Dora.sleep -- 1
local Path = Dora.Path -- 1
local View = Dora.View -- 1
local Pass = Dora.Pass -- 1
local SpriteEffect = Dora.SpriteEffect -- 1
local collectgarbage = _G.collectgarbage -- 1
local _module_0 = nil -- 1
local Story = require("UI.View.Story") -- 2
local StoryFigure = require("UI.StoryFigure") -- 3
local Answer = require("UI.Answer") -- 4
local Struct = require("Utils").Struct -- 5
local YarnRunner = require("YarnRunner") -- 6
local Config = require("Data.Config") -- 7
local Command = require("System.Command") -- 8
local Dialog = Struct.Story.Dialog("character", "name", "text") -- 10
local getCharName -- 12
getCharName = function(current) -- 12
	if current.marks then -- 13
		local _list_0 = current.marks -- 14
		for _index_0 = 1, #_list_0 do -- 14
			local mark = _list_0[_index_0] -- 14
			local _type_0 = type(mark) -- 15
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0 -- 15
			if _tab_0 then -- 15
				local attr = mark.name -- 15
				local name -- 15
				do -- 15
					local _obj_0 = mark.attrs -- 15
					local _type_1 = type(_obj_0) -- 15
					if "table" == _type_1 or "userdata" == _type_1 then -- 15
						name = _obj_0.name -- 15
					end -- 17
				end -- 17
				local id -- 15
				do -- 15
					local _obj_0 = mark.attrs -- 15
					local _type_1 = type(_obj_0) -- 15
					if "table" == _type_1 or "userdata" == _type_1 then -- 15
						id = _obj_0.id -- 15
					end -- 17
				end -- 17
				if name == nil then -- 15
					name = '' -- 15
				end -- 15
				if id == nil then -- 15
					id = '' -- 15
				end -- 15
				if attr ~= nil then -- 15
					if ("char" == attr or "Character" == attr) then -- 16
						return name, id -- 17
					end -- 16
				end -- 15
			end -- 17
		end -- 17
	end -- 13
	return '', '' -- 18
end -- 12
_module_0 = Class(Story, { -- 21
	reviewVisible = property(function(self) -- 21
		return self._reviewVisible -- 21
	end, function(self, value) -- 22
		self._reviewVisible = value -- 23
		self.reviewMask.visible = value -- 24
		self.topCenter.visible = value -- 25
		self.reviewBack.visible = value -- 26
		self.reviewArea.visible = value -- 27
	end), -- 21
	advance = function(self, option) -- 29
		local action, result = self._runner:advance(option) -- 30
		if "Text" == action then -- 31
			if result.optionsFollowed then -- 32
				local _ -- 33
				_, self._options = self._runner:advance() -- 33
			else -- 35
				self._options = nil -- 35
			end -- 32
			self._current = result -- 36
			return true -- 37
		elseif "Command" == action then -- 38
			self._current = nil -- 39
			self._options = nil -- 40
			self.answerList:removeAllChildren() -- 41
			self.continueIcon.visible = true -- 42
			self._advancing = true -- 43
			return true -- 44
		elseif "Option" == action then -- 45
			self._options = result -- 46
			return true -- 47
		elseif "Error" == action then -- 48
			return print(result) -- 49
		else -- 51
			return false -- 51
		end -- 51
	end, -- 29
	__init = function(self, dialogFile) -- 53
		self:gslot("Command.Preload", function(items) -- 54
			self._preloads = items -- 54
		end) -- 54
		self:gslot("Command.Figure", function(filename, x, y, scale) -- 55
			self.figure:removeAllChildren() -- 56
			if not filename then -- 57
				return -- 57
			end -- 57
			local _with_0 = Sprite(filename) -- 58
			if _with_0 ~= nil then -- 58
				_with_0.x, _with_0.y = x, y -- 59
				_with_0.scaleX = scale -- 60
				_with_0.scaleY = scale -- 60
				_with_0:addTo(self.figure) -- 61
			end -- 58
			return _with_0 -- 58
		end) -- 55
		self._runner = YarnRunner(dialogFile, "Start", Config, Command) -- 62
		self:advance() -- 63
		self.reviewVisible = false -- 64
		self._advancing = false -- 65
		local nextSentence -- 66
		nextSentence = function() -- 66
			if self._advancing then -- 67
				return -- 67
			end -- 67
			if self._options then -- 68
				return -- 68
			end -- 68
			if self:advance() then -- 69
				return thread(function() -- 70
					return self:updateDialogAsync() -- 70
				end) -- 70
			else -- 72
				return self:hide() -- 72
			end -- 69
		end -- 66
		self:gslot("Story.Advance", function() -- 73
			self._advancing = false -- 74
			return nextSentence() -- 75
		end) -- 73
		self.confirm:onKeyDown(function(keyName) -- 76
			if keyName == "Return" then -- 76
				return nextSentence() -- 76
			end -- 76
		end) -- 76
		self.confirm:slot("Tapped", nextSentence) -- 77
		self.textArea:slot("NoneScrollTapped", nextSentence) -- 78
		self.reviewButton:slot("Tapped", function() -- 79
			if self._advancing then -- 80
				return -- 80
			end -- 80
			self.reviewVisible = true -- 81
			return self:alignLayout() -- 82
		end) -- 79
		self.reviewBack:slot("Tapped", function() -- 83
			self.reviewVisible = false -- 83
		end) -- 83
		self.reviewArea:slot("NoneScrollTapped", function() -- 84
			self.reviewVisible = false -- 84
		end) -- 84
		do -- 85
			local _with_0 = Dialog() -- 85
			_with_0.__modified = function(key, value) -- 86
				if "character" == key then -- 87
					if (value ~= nil) and value ~= "" then -- 88
						self.figure:removeAllChildren() -- 89
						return self.figure:addChild(StoryFigure({ -- 90
							char = value -- 90
						})) -- 90
					end -- 88
				elseif "name" == key then -- 91
					if (value ~= nil) then -- 92
						self.name.text = value -- 92
					end -- 92
				elseif "text" == key then -- 93
					if (value ~= nil) then -- 94
						self.text.text = value -- 94
					end -- 94
				end -- 94
			end -- 86
			_with_0.__updated = function() -- 95
				return self:alignLayout() -- 95
			end -- 95
			self._dialog = _with_0 -- 85
		end -- 85
		self._reviews = { } -- 96
		self.visible = false -- 97
	end, -- 53
	updateDialogAsync = function(self) -- 99
		if not self._current then -- 100
			return -- 100
		end -- 100
		if self._advancing then -- 101
			return -- 101
		end -- 101
		self._advancing = true -- 102
		local name, characterId = getCharName(self._current) -- 103
		if characterId == 'vivi' then -- 104
			Cache:loadAsync("spine:vikaFigure") -- 105
		elseif characterId ~= '' then -- 106
			Cache:loadAsync("spine:" .. tostring(characterId) .. "Figure") -- 107
		end -- 104
		local text = self._current.text -- 108
		do -- 109
			local _obj_0 = self._reviews -- 109
			_obj_0[#_obj_0 + 1] = { -- 109
				name = name, -- 109
				text = text -- 109
			} -- 109
		end -- 109
		self._dialog.character = characterId -- 110
		self._dialog.name = name -- 111
		self._dialog.text = text -- 112
		self.answerList:removeAllChildren() -- 113
		if self._options then -- 114
			self.continueIcon.visible = false -- 115
			local count = #self._options -- 116
			for i = 1, count do -- 117
				local option = self._options[i] -- 118
				name = getCharName(option) -- 119
				local optionText = option.text -- 120
				self.answerList:addChild((function() -- 121
					local _with_0 = Answer({ -- 121
						text = optionText -- 121
					}) -- 121
					_with_0:slot("Tapped", function() -- 122
						_with_0.touchEnabled = false -- 123
						return thread(function() -- 124
							sleep(0.3) -- 125
							do -- 126
								local _obj_0 = self._reviews -- 126
								_obj_0[#_obj_0 + 1] = { -- 126
									name = name, -- 126
									text = optionText -- 126
								} -- 126
							end -- 126
							if self:advance(i) then -- 127
								return thread(function() -- 128
									return self:updateDialogAsync() -- 128
								end) -- 128
							else -- 130
								return self:hide() -- 130
							end -- 127
						end) -- 130
					end) -- 122
					return _with_0 -- 121
				end)()) -- 121
			end -- 130
			local size = self.answerList:alignItems(40) -- 131
			self.answerList.size = size -- 132
			self.answerList:alignItems(40) -- 133
		else -- 135
			self.continueIcon.visible = true -- 135
		end -- 114
		self._advancing = false -- 136
		if self._preloads then -- 137
			local _list_0 = self._preloads -- 138
			for _index_0 = 1, #_list_0 do -- 138
				local item = _list_0[_index_0] -- 138
				if "" == Path:getExt(item) then -- 139
					local figureFile -- 140
					if 'vivi' == item then -- 141
						figureFile = "spine:vikaFigure" -- 141
					else -- 142
						figureFile = "spine:" .. tostring(item) .. "Figure" -- 142
					end -- 142
					Cache:loadAsync(figureFile) -- 143
				else -- 145
					Cache:loadAsync(item) -- 145
				end -- 139
			end -- 145
			self._preloads = nil -- 146
		end -- 137
	end, -- 99
	showAsync = function(self) -- 148
		self:updateDialogAsync() -- 149
		self.visible = true -- 150
		self._viewScale = View.scale -- 151
		self._viewEffect = View.postEffect -- 152
		View.scale = 4 * self._viewScale -- 153
		local size = View.size -- 154
		local blurH -- 155
		do -- 155
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurh") -- 155
			_with_0.grabPass = true -- 156
			_with_0:set("u_radius", size.width) -- 157
			blurH = _with_0 -- 155
		end -- 155
		local blurV -- 158
		do -- 158
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurv") -- 158
			_with_0.grabPass = true -- 159
			_with_0:set("u_radius", size.height) -- 160
			blurV = _with_0 -- 158
		end -- 158
		do -- 161
			local _with_0 = SpriteEffect() -- 161
			for _ = 1, 3 do -- 162
				_with_0:add(blurH) -- 163
				_with_0:add(blurV) -- 164
			end -- 164
			View.postEffect = _with_0 -- 161
		end -- 161
		return self:gslot("AppChange", function(settingName) -- 165
			if settingName == "Size" then -- 165
				local width, height -- 166
				do -- 166
					local _obj_0 = View.size -- 166
					width, height = _obj_0.width, _obj_0.height -- 166
				end -- 166
				blurH:set("u_radius", width) -- 167
				return blurV:set("u_radius", height) -- 168
			end -- 165
		end) -- 168
	end, -- 148
	hide = function(self) -- 170
		self:gslot("AppChange", nil) -- 171
		self:emit("Ended") -- 172
		self:removeFromParent() -- 173
		local viewScale = self._viewScale -- 174
		local viewEffect = self._viewEffect -- 175
		return thread(function() -- 176
			collectgarbage() -- 177
			Cache:removeUnused() -- 178
			View.scale = viewScale -- 179
			sleep() -- 180
			View.postEffect = viewEffect -- 181
		end) -- 181
	end -- 170
}) -- 20
return _module_0 -- 181
