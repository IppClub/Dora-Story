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
			local _with_0 = Sprite(filename) -- 57
			if _with_0 ~= nil then -- 57
				_with_0.x, _with_0.y = x, y -- 58
				_with_0.scaleX = scale -- 59
				_with_0.scaleY = scale -- 59
				_with_0:addTo(self.figure) -- 60
			end -- 57
			return _with_0 -- 57
		end) -- 55
		self._runner = YarnRunner(dialogFile, "Start", Config, Command) -- 61
		self:advance() -- 62
		self.reviewVisible = false -- 63
		self._advancing = false -- 64
		local nextSentence -- 65
		nextSentence = function() -- 65
			if self._advancing then -- 66
				return -- 66
			end -- 66
			if self._options then -- 67
				return -- 67
			end -- 67
			if self:advance() then -- 68
				return thread(function() -- 69
					return self:updateDialogAsync() -- 69
				end) -- 69
			else -- 71
				return self:hide() -- 71
			end -- 68
		end -- 65
		self:gslot("Story.Advance", function() -- 72
			self._advancing = false -- 73
			return nextSentence() -- 74
		end) -- 72
		self.confirm:onKeyDown(function(keyName) -- 75
			if keyName == "Return" then -- 75
				return nextSentence() -- 75
			end -- 75
		end) -- 75
		self.confirm:slot("Tapped", nextSentence) -- 76
		self.textArea:slot("NoneScrollTapped", nextSentence) -- 77
		self.reviewButton:slot("Tapped", function() -- 78
			if self._advancing then -- 79
				return -- 79
			end -- 79
			self.reviewVisible = true -- 80
			return self:alignLayout() -- 81
		end) -- 78
		self.reviewBack:slot("Tapped", function() -- 82
			self.reviewVisible = false -- 82
		end) -- 82
		self.reviewArea:slot("NoneScrollTapped", function() -- 83
			self.reviewVisible = false -- 83
		end) -- 83
		do -- 84
			local _with_0 = Dialog() -- 84
			_with_0.__modified = function(key, value) -- 85
				if "character" == key then -- 86
					if (value ~= nil) and value ~= "" then -- 87
						self.figure:removeAllChildren() -- 88
						return self.figure:addChild(StoryFigure({ -- 89
							char = value -- 89
						})) -- 89
					end -- 87
				elseif "name" == key then -- 90
					if (value ~= nil) then -- 91
						self.name.text = value -- 91
					end -- 91
				elseif "text" == key then -- 92
					if (value ~= nil) then -- 93
						self.text.text = value -- 93
					end -- 93
				end -- 93
			end -- 85
			_with_0.__updated = function() -- 94
				return self:alignLayout() -- 94
			end -- 94
			self._dialog = _with_0 -- 84
		end -- 84
		self._reviews = { } -- 95
		self.visible = false -- 96
	end, -- 53
	updateDialogAsync = function(self) -- 98
		if not self._current then -- 99
			return -- 99
		end -- 99
		if self._advancing then -- 100
			return -- 100
		end -- 100
		self._advancing = true -- 101
		local name, characterId = getCharName(self._current) -- 102
		if characterId == 'vivi' then -- 103
			Cache:loadAsync("spine:vikaFigure") -- 104
		elseif characterId ~= '' then -- 105
			Cache:loadAsync("spine:" .. tostring(characterId) .. "Figure") -- 106
		end -- 103
		local text = self._current.text -- 107
		do -- 108
			local _obj_0 = self._reviews -- 108
			_obj_0[#_obj_0 + 1] = { -- 108
				name = name, -- 108
				text = text -- 108
			} -- 108
		end -- 108
		self._dialog.character = characterId -- 109
		self._dialog.name = name -- 110
		self._dialog.text = text -- 111
		self.answerList:removeAllChildren() -- 112
		if self._options then -- 113
			self.continueIcon.visible = false -- 114
			local count = #self._options -- 115
			for i = 1, count do -- 116
				local option = self._options[i] -- 117
				name = getCharName(option) -- 118
				local optionText = option.text -- 119
				self.answerList:addChild((function() -- 120
					local _with_0 = Answer({ -- 120
						text = optionText -- 120
					}) -- 120
					_with_0:slot("Tapped", function() -- 121
						_with_0.touchEnabled = false -- 122
						return thread(function() -- 123
							sleep(0.3) -- 124
							do -- 125
								local _obj_0 = self._reviews -- 125
								_obj_0[#_obj_0 + 1] = { -- 125
									name = name, -- 125
									text = optionText -- 125
								} -- 125
							end -- 125
							if self:advance(i) then -- 126
								return thread(function() -- 127
									return self:updateDialogAsync() -- 127
								end) -- 127
							else -- 129
								return self:hide() -- 129
							end -- 126
						end) -- 129
					end) -- 121
					return _with_0 -- 120
				end)()) -- 120
			end -- 129
			local size = self.answerList:alignItems(40) -- 130
			self.answerList.size = size -- 131
			self.answerList:alignItems(40) -- 132
		else -- 134
			self.continueIcon.visible = true -- 134
		end -- 113
		self._advancing = false -- 135
		if self._preloads then -- 136
			local _list_0 = self._preloads -- 137
			for _index_0 = 1, #_list_0 do -- 137
				local item = _list_0[_index_0] -- 137
				if "" == Path:getExt(item) then -- 138
					local figureFile -- 139
					if 'vivi' == item then -- 140
						figureFile = "spine:vikaFigure" -- 140
					else -- 141
						figureFile = "spine:" .. tostring(item) .. "Figure" -- 141
					end -- 141
					Cache:loadAsync(figureFile) -- 142
				else -- 144
					Cache:loadAsync(item) -- 144
				end -- 138
			end -- 144
			self._preloads = nil -- 145
		end -- 136
	end, -- 98
	showAsync = function(self) -- 147
		self:updateDialogAsync() -- 148
		self.visible = true -- 149
		self._viewScale = View.scale -- 150
		self._viewEffect = View.postEffect -- 151
		View.scale = 4 * self._viewScale -- 152
		local size = View.size -- 153
		local blurH -- 154
		do -- 154
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurh") -- 154
			_with_0.grabPass = true -- 155
			_with_0:set("u_radius", size.width) -- 156
			blurH = _with_0 -- 154
		end -- 154
		local blurV -- 157
		do -- 157
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurv") -- 157
			_with_0.grabPass = true -- 158
			_with_0:set("u_radius", size.height) -- 159
			blurV = _with_0 -- 157
		end -- 157
		do -- 160
			local _with_0 = SpriteEffect() -- 160
			for _ = 1, 3 do -- 161
				_with_0:add(blurH) -- 162
				_with_0:add(blurV) -- 163
			end -- 163
			View.postEffect = _with_0 -- 160
		end -- 160
		return self:gslot("AppChange", function(settingName) -- 164
			if settingName == "Size" then -- 164
				local width, height -- 165
				do -- 165
					local _obj_0 = View.size -- 165
					width, height = _obj_0.width, _obj_0.height -- 165
				end -- 165
				blurH:set("u_radius", width) -- 166
				return blurV:set("u_radius", height) -- 167
			end -- 164
		end) -- 167
	end, -- 147
	hide = function(self) -- 169
		self:gslot("AppChange", nil) -- 170
		self:emit("Ended") -- 171
		self:removeFromParent() -- 172
		local viewScale = self._viewScale -- 173
		local viewEffect = self._viewEffect -- 174
		return thread(function() -- 175
			collectgarbage() -- 176
			Cache:removeUnused() -- 177
			View.scale = viewScale -- 178
			sleep() -- 179
			View.postEffect = viewEffect -- 180
		end) -- 180
	end -- 169
}) -- 20
return _module_0 -- 180
