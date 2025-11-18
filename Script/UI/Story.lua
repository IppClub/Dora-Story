-- [yue]: Script/UI/Story.yue
local type = _G.type -- 1
local Class = Dora.Class -- 1
local property = Dora.property -- 1
local print = _G.print -- 1
local sleep = Dora.sleep -- 1
local Opacity = Dora.Opacity -- 1
local Content = Dora.Content -- 1
local Sprite = Dora.Sprite -- 1
local thread = Dora.thread -- 1
local Cache = Dora.Cache -- 1
local tostring = _G.tostring -- 1
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
local preloadFrame, playFrame -- 9
do -- 9
	local _obj_0 = require("System.FrameAnimation") -- 9
	preloadFrame, playFrame = _obj_0.preloadFrame, _obj_0.playFrame -- 9
end -- 9
local Dialog = Struct.Story.Dialog("character", "name", "text") -- 11
local getCharName -- 13
getCharName = function(current) -- 13
	if current.marks then -- 14
		local _list_0 = current.marks -- 15
		for _index_0 = 1, #_list_0 do -- 15
			local mark = _list_0[_index_0] -- 15
			local _type_0 = type(mark) -- 16
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0 -- 16
			if _tab_0 then -- 16
				local attr = mark.name -- 16
				local name -- 16
				do -- 16
					local _obj_0 = mark.attrs -- 16
					local _type_1 = type(_obj_0) -- 16
					if "table" == _type_1 or "userdata" == _type_1 then -- 16
						name = _obj_0.name -- 16
					end -- 18
				end -- 18
				local id -- 16
				do -- 16
					local _obj_0 = mark.attrs -- 16
					local _type_1 = type(_obj_0) -- 16
					if "table" == _type_1 or "userdata" == _type_1 then -- 16
						id = _obj_0.id -- 16
					end -- 18
				end -- 18
				if name == nil then -- 16
					name = '' -- 16
				end -- 16
				if id == nil then -- 16
					id = '' -- 16
				end -- 16
				if attr ~= nil then -- 16
					if ("char" == attr or "Character" == attr) then -- 17
						return name, id -- 18
					end -- 17
				end -- 16
			end -- 18
		end -- 18
	end -- 14
	return '', '' -- 19
end -- 13
_module_0 = Class(Story, { -- 22
	reviewVisible = property(function(self) -- 22
		return self._reviewVisible -- 22
	end, function(self, value) -- 23
		self._reviewVisible = value -- 24
		self.reviewMask.visible = value -- 25
		self.topCenter.visible = value -- 26
		self.reviewBack.visible = value -- 27
		self.reviewArea.visible = value -- 28
	end), -- 22
	advance = function(self, option) -- 30
		local action, result = self._runner:advance(option) -- 31
		if "Text" == action then -- 32
			if result.optionsFollowed then -- 33
				local _ -- 34
				_, self._options = self._runner:advance() -- 34
			else -- 36
				self._options = nil -- 36
			end -- 33
			self._current = result -- 37
			return true -- 38
		elseif "Command" == action then -- 39
			self._current = nil -- 40
			self._options = nil -- 41
			self.answerList:removeAllChildren() -- 42
			self.continueIcon.visible = true -- 43
			self._advancing = true -- 44
			return true -- 45
		elseif "Option" == action then -- 46
			self._options = result -- 47
			return true -- 48
		elseif "Error" == action then -- 49
			return print(result) -- 50
		else -- 52
			return false -- 52
		end -- 52
	end, -- 30
	__init = function(self, dialogFile) -- 54
		self:gslot("Command.Preload", function(items) -- 55
			self._preloads = items -- 55
		end) -- 55
		self:gslot("Command.Frame", function(folder, duration, loop, x, y, scale) -- 56
			if loop == nil then -- 56
				loop = true -- 56
			end -- 56
			if x == nil then -- 56
				x = 0 -- 56
			end -- 56
			if y == nil then -- 56
				y = 0 -- 56
			end -- 56
			if scale == nil then -- 56
				scale = 1.0 -- 56
			end -- 56
			if self.frame.children then -- 57
				local _list_0 = self.frame.children -- 58
				for _index_0 = 1, #_list_0 do -- 58
					local child = _list_0[_index_0] -- 58
					child:once(function() -- 59
						sleep(child:perform(Opacity(0.2, 1, 0))) -- 60
						return child:removeFromParent() -- 61
					end) -- 59
				end -- 61
			end -- 57
			if not folder or not Content:exist(folder) or not Content:isdir(folder) then -- 62
				return -- 62
			end -- 62
			local _with_0 = playFrame(folder, duration, loop, x, y, scale) -- 63
			if _with_0 ~= nil then -- 63
				_with_0:addTo(self.frame) -- 64
			end -- 63
			return _with_0 -- 63
		end) -- 56
		self:gslot("Command.Figure", function(filename, x, y, scale) -- 65
			self.figure:removeAllChildren() -- 66
			if not filename then -- 67
				self._dialog.character = "" -- 68
				return -- 69
			end -- 67
			local _with_0 = Sprite(filename) -- 70
			if _with_0 ~= nil then -- 70
				_with_0.x, _with_0.y = x, y -- 71
				_with_0.scaleX = scale -- 72
				_with_0.scaleY = scale -- 72
				_with_0:addTo(self.figure) -- 73
			end -- 70
			return _with_0 -- 70
		end) -- 65
		self._runner = YarnRunner(dialogFile, "Start", Config, Command) -- 74
		self:advance() -- 75
		self.reviewVisible = false -- 76
		self._advancing = false -- 77
		local nextSentence -- 78
		nextSentence = function() -- 78
			if self._advancing then -- 79
				return -- 79
			end -- 79
			if self._options then -- 80
				return -- 80
			end -- 80
			if self:advance() then -- 81
				return thread(function() -- 82
					return self:updateDialogAsync() -- 82
				end) -- 82
			else -- 84
				return self:hide() -- 84
			end -- 81
		end -- 78
		self:gslot("Story.Advance", function() -- 85
			self._advancing = false -- 86
			return nextSentence() -- 87
		end) -- 85
		self.confirm:onKeyDown(function(keyName) -- 88
			if keyName == "Return" then -- 88
				return nextSentence() -- 88
			end -- 88
		end) -- 88
		self.confirm:slot("Tapped", nextSentence) -- 89
		self.textArea:slot("NoneScrollTapped", nextSentence) -- 90
		self.reviewButton:slot("Tapped", function() -- 91
			if self._advancing then -- 92
				return -- 92
			end -- 92
			self.reviewVisible = true -- 93
			return self:alignLayout() -- 94
		end) -- 91
		self.reviewBack:slot("Tapped", function() -- 95
			self.reviewVisible = false -- 95
		end) -- 95
		self.reviewArea:slot("NoneScrollTapped", function() -- 96
			self.reviewVisible = false -- 96
		end) -- 96
		do -- 97
			local _with_0 = Dialog() -- 97
			_with_0.__modified = function(key, value) -- 98
				if "character" == key then -- 99
					if (value ~= nil) and value ~= "" then -- 100
						self.figure:removeAllChildren() -- 101
						return self.figure:addChild(StoryFigure({ -- 102
							char = value -- 102
						})) -- 102
					end -- 100
				elseif "name" == key then -- 103
					if (value ~= nil) then -- 104
						self.name.text = value -- 104
					end -- 104
				elseif "text" == key then -- 105
					if (value ~= nil) then -- 106
						self.text.text = value -- 106
					end -- 106
				end -- 106
			end -- 98
			_with_0.__updated = function() -- 107
				return self:alignLayout() -- 107
			end -- 107
			self._dialog = _with_0 -- 97
		end -- 97
		self._reviews = { } -- 108
		self.visible = false -- 109
	end, -- 54
	updateDialogAsync = function(self) -- 111
		if not self._current then -- 112
			return -- 112
		end -- 112
		if self._advancing then -- 113
			return -- 113
		end -- 113
		self._advancing = true -- 114
		local name, characterId = getCharName(self._current) -- 115
		if characterId == 'vivi' then -- 116
			Cache:loadAsync("spine:vikaFigure") -- 117
			self._dialog.character = characterId -- 118
		elseif characterId ~= '' then -- 119
			Cache:loadAsync("spine:" .. tostring(characterId) .. "Figure") -- 120
			self._dialog.character = characterId -- 121
		end -- 116
		local text = self._current.text -- 122
		do -- 123
			local _obj_0 = self._reviews -- 123
			_obj_0[#_obj_0 + 1] = { -- 123
				name = name, -- 123
				text = text -- 123
			} -- 123
		end -- 123
		self._dialog.name = name -- 124
		self._dialog.text = text -- 125
		self.answerList:removeAllChildren() -- 126
		if self._options then -- 127
			self.continueIcon.visible = false -- 128
			local count = #self._options -- 129
			for i = 1, count do -- 130
				local option = self._options[i] -- 131
				name = getCharName(option) -- 132
				local optionText = option.text -- 133
				self.answerList:addChild((function() -- 134
					local _with_0 = Answer({ -- 134
						text = optionText -- 134
					}) -- 134
					_with_0:slot("Tapped", function() -- 135
						_with_0.touchEnabled = false -- 136
						return thread(function() -- 137
							sleep(0.3) -- 138
							do -- 139
								local _obj_0 = self._reviews -- 139
								_obj_0[#_obj_0 + 1] = { -- 139
									name = name, -- 139
									text = optionText -- 139
								} -- 139
							end -- 139
							if self:advance(i) then -- 140
								return thread(function() -- 141
									return self:updateDialogAsync() -- 141
								end) -- 141
							else -- 143
								return self:hide() -- 143
							end -- 140
						end) -- 143
					end) -- 135
					return _with_0 -- 134
				end)()) -- 134
			end -- 143
			local size = self.answerList:alignItems(40) -- 144
			self.answerList.size = size -- 145
			self.answerList:alignItems(40) -- 146
		else -- 148
			self.continueIcon.visible = true -- 148
		end -- 127
		self._advancing = false -- 149
		if self._preloads then -- 150
			local _list_0 = self._preloads -- 151
			for _index_0 = 1, #_list_0 do -- 151
				local item = _list_0[_index_0] -- 151
				if Content:isdir(item) then -- 152
					preloadFrame(item) -- 153
				else -- 155
					if "" == Path:getExt(item) then -- 155
						local figureFile -- 156
						if 'vivi' == item then -- 157
							figureFile = "spine:vikaFigure" -- 157
						else -- 158
							figureFile = "spine:" .. tostring(item) .. "Figure" -- 158
						end -- 158
						thread(function() -- 159
							return Cache:loadAsync(figureFile) -- 159
						end) -- 159
					else -- 161
						thread(function() -- 161
							return Cache:loadAsync(item) -- 161
						end) -- 161
					end -- 155
				end -- 152
			end -- 161
			self._preloads = nil -- 162
		end -- 150
	end, -- 111
	showAsync = function(self) -- 164
		self:updateDialogAsync() -- 165
		self.visible = true -- 166
		self._viewScale = View.scale -- 167
		self._viewEffect = View.postEffect -- 168
		View.scale = 4 * self._viewScale -- 169
		local size = View.size -- 170
		local blurH -- 171
		do -- 171
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurh") -- 171
			_with_0.grabPass = true -- 172
			_with_0:set("u_radius", size.width) -- 173
			blurH = _with_0 -- 171
		end -- 171
		local blurV -- 174
		do -- 174
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurv") -- 174
			_with_0.grabPass = true -- 175
			_with_0:set("u_radius", size.height) -- 176
			blurV = _with_0 -- 174
		end -- 174
		do -- 177
			local _with_0 = SpriteEffect() -- 177
			for _ = 1, 3 do -- 178
				_with_0:add(blurH) -- 179
				_with_0:add(blurV) -- 180
			end -- 180
			View.postEffect = _with_0 -- 177
		end -- 177
		return self:gslot("AppChange", function(settingName) -- 181
			if settingName == "Size" then -- 181
				local width, height -- 182
				do -- 182
					local _obj_0 = View.size -- 182
					width, height = _obj_0.width, _obj_0.height -- 182
				end -- 182
				blurH:set("u_radius", width) -- 183
				return blurV:set("u_radius", height) -- 184
			end -- 181
		end) -- 184
	end, -- 164
	hide = function(self) -- 186
		self:gslot("AppChange", nil) -- 187
		self:emit("Ended") -- 188
		self:removeFromParent() -- 189
		local viewScale = self._viewScale -- 190
		local viewEffect = self._viewEffect -- 191
		return thread(function() -- 192
			collectgarbage() -- 193
			Cache:removeUnused() -- 194
			View.scale = viewScale -- 195
			sleep() -- 196
			View.postEffect = viewEffect -- 197
		end) -- 197
	end -- 186
}) -- 21
return _module_0 -- 197
