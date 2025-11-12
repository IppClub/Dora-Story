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
				self._dialog.character = "" -- 58
				return -- 59
			end -- 57
			local _with_0 = Sprite(filename) -- 60
			if _with_0 ~= nil then -- 60
				_with_0.x, _with_0.y = x, y -- 61
				_with_0.scaleX = scale -- 62
				_with_0.scaleY = scale -- 62
				_with_0:addTo(self.figure) -- 63
			end -- 60
			return _with_0 -- 60
		end) -- 55
		self._runner = YarnRunner(dialogFile, "Start", Config, Command) -- 64
		self:advance() -- 65
		self.reviewVisible = false -- 66
		self._advancing = false -- 67
		local nextSentence -- 68
		nextSentence = function() -- 68
			if self._advancing then -- 69
				return -- 69
			end -- 69
			if self._options then -- 70
				return -- 70
			end -- 70
			if self:advance() then -- 71
				return thread(function() -- 72
					return self:updateDialogAsync() -- 72
				end) -- 72
			else -- 74
				return self:hide() -- 74
			end -- 71
		end -- 68
		self:gslot("Story.Advance", function() -- 75
			self._advancing = false -- 76
			return nextSentence() -- 77
		end) -- 75
		self.confirm:onKeyDown(function(keyName) -- 78
			if keyName == "Return" then -- 78
				return nextSentence() -- 78
			end -- 78
		end) -- 78
		self.confirm:slot("Tapped", nextSentence) -- 79
		self.textArea:slot("NoneScrollTapped", nextSentence) -- 80
		self.reviewButton:slot("Tapped", function() -- 81
			if self._advancing then -- 82
				return -- 82
			end -- 82
			self.reviewVisible = true -- 83
			return self:alignLayout() -- 84
		end) -- 81
		self.reviewBack:slot("Tapped", function() -- 85
			self.reviewVisible = false -- 85
		end) -- 85
		self.reviewArea:slot("NoneScrollTapped", function() -- 86
			self.reviewVisible = false -- 86
		end) -- 86
		do -- 87
			local _with_0 = Dialog() -- 87
			_with_0.__modified = function(key, value) -- 88
				if "character" == key then -- 89
					if (value ~= nil) and value ~= "" then -- 90
						self.figure:removeAllChildren() -- 91
						return self.figure:addChild(StoryFigure({ -- 92
							char = value -- 92
						})) -- 92
					end -- 90
				elseif "name" == key then -- 93
					if (value ~= nil) then -- 94
						self.name.text = value -- 94
					end -- 94
				elseif "text" == key then -- 95
					if (value ~= nil) then -- 96
						self.text.text = value -- 96
					end -- 96
				end -- 96
			end -- 88
			_with_0.__updated = function() -- 97
				return self:alignLayout() -- 97
			end -- 97
			self._dialog = _with_0 -- 87
		end -- 87
		self._reviews = { } -- 98
		self.visible = false -- 99
	end, -- 53
	updateDialogAsync = function(self) -- 101
		if not self._current then -- 102
			return -- 102
		end -- 102
		if self._advancing then -- 103
			return -- 103
		end -- 103
		self._advancing = true -- 104
		local name, characterId = getCharName(self._current) -- 105
		if characterId == 'vivi' then -- 106
			Cache:loadAsync("spine:vikaFigure") -- 107
			self._dialog.character = characterId -- 108
		elseif characterId ~= '' then -- 109
			Cache:loadAsync("spine:" .. tostring(characterId) .. "Figure") -- 110
			self._dialog.character = characterId -- 111
		end -- 106
		local text = self._current.text -- 112
		do -- 113
			local _obj_0 = self._reviews -- 113
			_obj_0[#_obj_0 + 1] = { -- 113
				name = name, -- 113
				text = text -- 113
			} -- 113
		end -- 113
		self._dialog.name = name -- 114
		self._dialog.text = text -- 115
		self.answerList:removeAllChildren() -- 116
		if self._options then -- 117
			self.continueIcon.visible = false -- 118
			local count = #self._options -- 119
			for i = 1, count do -- 120
				local option = self._options[i] -- 121
				name = getCharName(option) -- 122
				local optionText = option.text -- 123
				self.answerList:addChild((function() -- 124
					local _with_0 = Answer({ -- 124
						text = optionText -- 124
					}) -- 124
					_with_0:slot("Tapped", function() -- 125
						_with_0.touchEnabled = false -- 126
						return thread(function() -- 127
							sleep(0.3) -- 128
							do -- 129
								local _obj_0 = self._reviews -- 129
								_obj_0[#_obj_0 + 1] = { -- 129
									name = name, -- 129
									text = optionText -- 129
								} -- 129
							end -- 129
							if self:advance(i) then -- 130
								return thread(function() -- 131
									return self:updateDialogAsync() -- 131
								end) -- 131
							else -- 133
								return self:hide() -- 133
							end -- 130
						end) -- 133
					end) -- 125
					return _with_0 -- 124
				end)()) -- 124
			end -- 133
			local size = self.answerList:alignItems(40) -- 134
			self.answerList.size = size -- 135
			self.answerList:alignItems(40) -- 136
		else -- 138
			self.continueIcon.visible = true -- 138
		end -- 117
		self._advancing = false -- 139
		if self._preloads then -- 140
			local _list_0 = self._preloads -- 141
			for _index_0 = 1, #_list_0 do -- 141
				local item = _list_0[_index_0] -- 141
				if "" == Path:getExt(item) then -- 142
					local figureFile -- 143
					if 'vivi' == item then -- 144
						figureFile = "spine:vikaFigure" -- 144
					else -- 145
						figureFile = "spine:" .. tostring(item) .. "Figure" -- 145
					end -- 145
					Cache:loadAsync(figureFile) -- 146
				else -- 148
					Cache:loadAsync(item) -- 148
				end -- 142
			end -- 148
			self._preloads = nil -- 149
		end -- 140
	end, -- 101
	showAsync = function(self) -- 151
		self:updateDialogAsync() -- 152
		self.visible = true -- 153
		self._viewScale = View.scale -- 154
		self._viewEffect = View.postEffect -- 155
		View.scale = 4 * self._viewScale -- 156
		local size = View.size -- 157
		local blurH -- 158
		do -- 158
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurh") -- 158
			_with_0.grabPass = true -- 159
			_with_0:set("u_radius", size.width) -- 160
			blurH = _with_0 -- 158
		end -- 158
		local blurV -- 161
		do -- 161
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurv") -- 161
			_with_0.grabPass = true -- 162
			_with_0:set("u_radius", size.height) -- 163
			blurV = _with_0 -- 161
		end -- 161
		do -- 164
			local _with_0 = SpriteEffect() -- 164
			for _ = 1, 3 do -- 165
				_with_0:add(blurH) -- 166
				_with_0:add(blurV) -- 167
			end -- 167
			View.postEffect = _with_0 -- 164
		end -- 164
		return self:gslot("AppChange", function(settingName) -- 168
			if settingName == "Size" then -- 168
				local width, height -- 169
				do -- 169
					local _obj_0 = View.size -- 169
					width, height = _obj_0.width, _obj_0.height -- 169
				end -- 169
				blurH:set("u_radius", width) -- 170
				return blurV:set("u_radius", height) -- 171
			end -- 168
		end) -- 171
	end, -- 151
	hide = function(self) -- 173
		self:gslot("AppChange", nil) -- 174
		self:emit("Ended") -- 175
		self:removeFromParent() -- 176
		local viewScale = self._viewScale -- 177
		local viewEffect = self._viewEffect -- 178
		return thread(function() -- 179
			collectgarbage() -- 180
			Cache:removeUnused() -- 181
			View.scale = viewScale -- 182
			sleep() -- 183
			View.postEffect = viewEffect -- 184
		end) -- 184
	end -- 173
}) -- 20
return _module_0 -- 184
