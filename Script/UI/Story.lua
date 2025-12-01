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
				local children -- 58
				do -- 58
					local _accum_0 = { } -- 58
					local _len_0 = 1 -- 58
					local _list_0 = self.frame.children -- 58
					for _index_0 = 1, #_list_0 do -- 58
						local child = _list_0[_index_0] -- 58
						if child.tag == "" then -- 58
							_accum_0[_len_0] = child -- 58
							_len_0 = _len_0 + 1 -- 58
						end -- 58
					end -- 58
					children = _accum_0 -- 58
				end -- 58
				for _index_0 = 1, #children do -- 59
					local child = children[_index_0] -- 59
					child.tag = "deleted" -- 60
					child:once(function() -- 61
						sleep(child:perform(Opacity(0.2, 1, 0))) -- 62
						return child:removeFromParent() -- 63
					end) -- 61
				end -- 63
			end -- 57
			if not folder or not Content:exist(folder) or not Content:isdir(folder) then -- 64
				return -- 64
			end -- 64
			local _with_0 = playFrame(folder, duration, loop, x, y, scale) -- 65
			if _with_0 ~= nil then -- 65
				_with_0:addTo(self.frame) -- 66
			end -- 65
			return _with_0 -- 65
		end) -- 56
		self:gslot("Command.Figure", function(filename, x, y, scale) -- 67
			self.figure:removeAllChildren() -- 68
			if not filename then -- 69
				self._dialog.character = "" -- 70
				return -- 71
			end -- 69
			local _with_0 = Sprite(filename) -- 72
			if _with_0 ~= nil then -- 72
				_with_0.x, _with_0.y = x, y -- 73
				_with_0.scaleX = scale -- 74
				_with_0.scaleY = scale -- 74
				_with_0:addTo(self.figure) -- 75
			end -- 72
			return _with_0 -- 72
		end) -- 67
		self._runner = YarnRunner(dialogFile, "Start", Config, Command) -- 76
		self:advance() -- 77
		self.reviewVisible = false -- 78
		self._advancing = false -- 79
		local nextSentence -- 80
		nextSentence = function() -- 80
			if self._advancing then -- 81
				return -- 81
			end -- 81
			if self._options then -- 82
				return -- 82
			end -- 82
			if self:advance() then -- 83
				return thread(function() -- 84
					return self:updateDialogAsync() -- 84
				end) -- 84
			else -- 86
				return self:hide() -- 86
			end -- 83
		end -- 80
		self:gslot("Story.Advance", function() -- 87
			self._advancing = false -- 88
			return nextSentence() -- 89
		end) -- 87
		self.confirm:onKeyDown(function(keyName) -- 90
			if keyName == "Return" then -- 90
				return nextSentence() -- 90
			end -- 90
		end) -- 90
		self.confirm:slot("Tapped", nextSentence) -- 91
		self.textArea:slot("NoneScrollTapped", nextSentence) -- 92
		self.reviewButton:slot("Tapped", function() -- 93
			if self._advancing then -- 94
				return -- 94
			end -- 94
			self.reviewVisible = true -- 95
			return self:alignLayout() -- 96
		end) -- 93
		self.reviewBack:slot("Tapped", function() -- 97
			self.reviewVisible = false -- 97
		end) -- 97
		self.reviewArea:slot("NoneScrollTapped", function() -- 98
			self.reviewVisible = false -- 98
		end) -- 98
		do -- 99
			local _with_0 = Dialog() -- 99
			_with_0.__modified = function(key, value) -- 100
				if "character" == key then -- 101
					if (value ~= nil) and value ~= "" then -- 102
						self.figure:removeAllChildren() -- 103
						return self.figure:addChild(StoryFigure({ -- 104
							char = value -- 104
						})) -- 104
					end -- 102
				elseif "name" == key then -- 105
					if (value ~= nil) then -- 106
						self.name.text = value -- 106
					end -- 106
				elseif "text" == key then -- 107
					if (value ~= nil) then -- 108
						self.text.text = value -- 108
					end -- 108
				end -- 108
			end -- 100
			_with_0.__updated = function() -- 109
				return self:alignLayout() -- 109
			end -- 109
			self._dialog = _with_0 -- 99
		end -- 99
		self._reviews = { } -- 110
		self.visible = false -- 111
	end, -- 54
	updateDialogAsync = function(self) -- 113
		if not self._current then -- 114
			return -- 114
		end -- 114
		if self._advancing then -- 115
			return -- 115
		end -- 115
		self._advancing = true -- 116
		local name, characterId = getCharName(self._current) -- 117
		if characterId == 'vivi' then -- 118
			Cache:loadAsync("spine:vikaFigure") -- 119
			self._dialog.character = characterId -- 120
		elseif characterId ~= '' then -- 121
			Cache:loadAsync("spine:" .. tostring(characterId) .. "Figure") -- 122
			self._dialog.character = characterId -- 123
		end -- 118
		local text = self._current.text -- 124
		do -- 125
			local _obj_0 = self._reviews -- 125
			_obj_0[#_obj_0 + 1] = { -- 125
				name = name, -- 125
				text = text -- 125
			} -- 125
		end -- 125
		self._dialog.name = name -- 126
		self._dialog.text = text -- 127
		self.answerList:removeAllChildren() -- 128
		if self._options then -- 129
			self.continueIcon.visible = false -- 130
			local count = #self._options -- 131
			for i = 1, count do -- 132
				local option = self._options[i] -- 133
				name = getCharName(option) -- 134
				local optionText = option.text -- 135
				self.answerList:addChild((function() -- 136
					local _with_0 = Answer({ -- 136
						text = optionText -- 136
					}) -- 136
					_with_0:slot("Tapped", function() -- 137
						_with_0.touchEnabled = false -- 138
						return thread(function() -- 139
							sleep(0.3) -- 140
							do -- 141
								local _obj_0 = self._reviews -- 141
								_obj_0[#_obj_0 + 1] = { -- 141
									name = name, -- 141
									text = optionText -- 141
								} -- 141
							end -- 141
							if self:advance(i) then -- 142
								return thread(function() -- 143
									return self:updateDialogAsync() -- 143
								end) -- 143
							else -- 145
								return self:hide() -- 145
							end -- 142
						end) -- 145
					end) -- 137
					return _with_0 -- 136
				end)()) -- 136
			end -- 145
			local size = self.answerList:alignItems(40) -- 146
			self.answerList.size = size -- 147
			self.answerList:alignItems(40) -- 148
		else -- 150
			self.continueIcon.visible = true -- 150
		end -- 129
		self._advancing = false -- 151
		if self._preloads then -- 152
			local _list_0 = self._preloads -- 153
			for _index_0 = 1, #_list_0 do -- 153
				local item = _list_0[_index_0] -- 153
				if Content:isdir(item) then -- 154
					preloadFrame(item) -- 155
				else -- 157
					if "" == Path:getExt(item) then -- 157
						local figureFile -- 158
						if 'vivi' == item then -- 159
							figureFile = "spine:vikaFigure" -- 159
						else -- 160
							figureFile = "spine:" .. tostring(item) .. "Figure" -- 160
						end -- 160
						thread(function() -- 161
							return Cache:loadAsync(figureFile) -- 161
						end) -- 161
					else -- 163
						thread(function() -- 163
							return Cache:loadAsync(item) -- 163
						end) -- 163
					end -- 157
				end -- 154
			end -- 163
			self._preloads = nil -- 164
		end -- 152
	end, -- 113
	showAsync = function(self) -- 166
		self:updateDialogAsync() -- 167
		self.visible = true -- 168
		self._viewScale = View.scale -- 169
		self._viewEffect = View.postEffect -- 170
		View.scale = 4 * self._viewScale -- 171
		local size = View.size -- 172
		local blurH -- 173
		do -- 173
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurh") -- 173
			_with_0.grabPass = true -- 174
			_with_0:set("u_radius", size.width) -- 175
			blurH = _with_0 -- 173
		end -- 173
		local blurV -- 176
		do -- 176
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurv") -- 176
			_with_0.grabPass = true -- 177
			_with_0:set("u_radius", size.height) -- 178
			blurV = _with_0 -- 176
		end -- 176
		do -- 179
			local _with_0 = SpriteEffect() -- 179
			for _ = 1, 3 do -- 180
				_with_0:add(blurH) -- 181
				_with_0:add(blurV) -- 182
			end -- 182
			View.postEffect = _with_0 -- 179
		end -- 179
		return self:gslot("AppChange", function(settingName) -- 183
			if settingName == "Size" then -- 183
				local width, height -- 184
				do -- 184
					local _obj_0 = View.size -- 184
					width, height = _obj_0.width, _obj_0.height -- 184
				end -- 184
				blurH:set("u_radius", width) -- 185
				return blurV:set("u_radius", height) -- 186
			end -- 183
		end) -- 186
	end, -- 166
	hide = function(self) -- 188
		self:gslot("AppChange", nil) -- 189
		self:emit("Ended") -- 190
		self:removeFromParent() -- 191
		local viewScale = self._viewScale -- 192
		local viewEffect = self._viewEffect -- 193
		return thread(function() -- 194
			collectgarbage() -- 195
			Cache:removeUnused() -- 196
			View.scale = viewScale -- 197
			sleep() -- 198
			View.postEffect = viewEffect -- 199
		end) -- 199
	end -- 188
}) -- 21
return _module_0 -- 199
