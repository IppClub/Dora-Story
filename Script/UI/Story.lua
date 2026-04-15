-- [yue]: Script/UI/Story.yue
local _module_0 = nil -- 1
local _ENV = Dora -- 1
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
local type <const> = type -- 10
local Class <const> = Class -- 10
local property <const> = property -- 10
local print <const> = print -- 10
local sleep <const> = sleep -- 10
local Opacity <const> = Opacity -- 10
local Content <const> = Content -- 10
local Sprite <const> = Sprite -- 10
local thread <const> = thread -- 10
local Cache <const> = Cache -- 10
local tostring <const> = tostring -- 10
local Path <const> = Path -- 10
local View <const> = View -- 10
local Pass <const> = Pass -- 10
local SpriteEffect <const> = SpriteEffect -- 10
local collectgarbage <const> = collectgarbage -- 10
local Dialog = Struct.Story.Dialog("character", "name", "text") -- 12
local getCharName -- 14
getCharName = function(current) -- 14
	if current.marks then -- 15
		local _list_0 = current.marks -- 16
		for _index_0 = 1, #_list_0 do -- 16
			local mark = _list_0[_index_0] -- 16
			local _type_0 = type(mark) -- 17
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0 -- 17
			if _tab_0 then -- 17
				local attr = mark.name -- 17
				local name -- 17
				do -- 17
					local _obj_0 = mark.attrs -- 17
					local _type_1 = type(_obj_0) -- 17
					if "table" == _type_1 or "userdata" == _type_1 then -- 17
						name = _obj_0.name -- 17
					end -- 17
				end -- 17
				local id -- 17
				do -- 17
					local _obj_0 = mark.attrs -- 17
					local _type_1 = type(_obj_0) -- 17
					if "table" == _type_1 or "userdata" == _type_1 then -- 17
						id = _obj_0.id -- 17
					end -- 17
				end -- 17
				if name == nil then -- 17
					name = '' -- 17
				end -- 17
				if id == nil then -- 17
					id = '' -- 17
				end -- 17
				if attr ~= nil then -- 17
					if ("char" == attr or "Character" == attr) then -- 18
						return name, id -- 19
					end -- 18
				end -- 17
			end -- 17
		end -- 16
	end -- 15
	return '', '' -- 20
end -- 14
_module_0 = Class(Story, { -- 23
	reviewVisible = property(function(self) -- 23
		return self._reviewVisible -- 23
	end, function(self, value) -- 24
		self._reviewVisible = value -- 25
		self.reviewMask.visible = value -- 26
		self.topCenter.visible = value -- 27
		self.reviewBack.visible = value -- 28
		self.reviewArea.visible = value -- 29
	end), -- 23
	advance = function(self, option) -- 31
		local action, result = self._runner:advance(option) -- 32
		if "Text" == action then -- 33
			if result.optionsFollowed then -- 34
				local _ -- 35
				_, self._options = self._runner:advance() -- 35
			else -- 37
				self._options = nil -- 37
			end -- 34
			self._current = result -- 38
			return true -- 39
		elseif "Command" == action then -- 40
			self._current = nil -- 41
			self._options = nil -- 42
			self.answerList:removeAllChildren() -- 43
			self.continueIcon.visible = true -- 44
			self._advancing = true -- 45
			return true -- 46
		elseif "Option" == action then -- 47
			self._options = result -- 48
			return true -- 49
		elseif "Error" == action then -- 50
			return print(result) -- 51
		else -- 53
			return false -- 53
		end -- 33
	end, -- 31
	__init = function(self, dialogFile) -- 55
		self:gslot("Command.Preload", function(items) -- 56
			self._preloads = items -- 56
		end) -- 56
		self:gslot("Command.Frame", function(folder, duration, loop, x, y, scale) -- 57
			if loop == nil then -- 57
				loop = true -- 57
			end -- 57
			if x == nil then -- 57
				x = 0 -- 57
			end -- 57
			if y == nil then -- 57
				y = 0 -- 57
			end -- 57
			if scale == nil then -- 57
				scale = 1.0 -- 57
			end -- 57
			if self.frame.children then -- 58
				local children -- 59
				do -- 59
					local _accum_0 = { } -- 59
					local _len_0 = 1 -- 59
					local _list_0 = self.frame.children -- 59
					for _index_0 = 1, #_list_0 do -- 59
						local child = _list_0[_index_0] -- 59
						if child.tag == "" then -- 59
							_accum_0[_len_0] = child -- 59
							_len_0 = _len_0 + 1 -- 59
						end -- 59
					end -- 59
					children = _accum_0 -- 59
				end -- 59
				for _index_0 = 1, #children do -- 60
					local child = children[_index_0] -- 60
					child.tag = "deleted" -- 61
					child:once(function() -- 62
						sleep(child:perform(Opacity(0.2, 1, 0))) -- 63
						return child:removeFromParent() -- 64
					end) -- 62
				end -- 60
			end -- 58
			if not folder or not Content:exist(folder) or not Content:isdir(folder) then -- 65
				return -- 65
			end -- 65
			local _with_0 = playFrame(folder, duration, loop, x, y, scale) -- 66
			if _with_0 ~= nil then -- 66
				_with_0:addTo(self.frame) -- 67
			end -- 66
			return _with_0 -- 66
		end) -- 57
		self:gslot("Command.Figure", function(filename, x, y, scale) -- 68
			self.figure:removeAllChildren() -- 69
			if not filename then -- 70
				self._dialog.character = "" -- 71
				return -- 72
			end -- 70
			local _with_0 = Sprite(filename) -- 73
			if _with_0 ~= nil then -- 73
				_with_0.x, _with_0.y = x, y -- 74
				_with_0.scaleX = scale -- 75
				_with_0.scaleY = scale -- 75
				_with_0:addTo(self.figure) -- 76
			end -- 73
			return _with_0 -- 73
		end) -- 68
		self._runner = YarnRunner(dialogFile, "Start", Config, Command) -- 77
		self:advance() -- 78
		self.reviewVisible = false -- 79
		self._advancing = false -- 80
		local nextSentence -- 81
		nextSentence = function() -- 81
			if self._advancing then -- 82
				return -- 82
			end -- 82
			if self._options then -- 83
				return -- 83
			end -- 83
			if self:advance() then -- 84
				return thread(function() -- 85
					return self:updateDialogAsync() -- 85
				end) -- 85
			else -- 87
				return self:hide() -- 87
			end -- 84
		end -- 81
		self:gslot("Story.Advance", function() -- 88
			self._advancing = false -- 89
			return nextSentence() -- 90
		end) -- 88
		self.confirm:onKeyDown(function(keyName) -- 91
			if keyName == "Return" then -- 91
				return nextSentence() -- 91
			end -- 91
		end) -- 91
		self.confirm:slot("Tapped", nextSentence) -- 92
		self.textArea:slot("NoneScrollTapped", nextSentence) -- 93
		self.reviewButton:slot("Tapped", function() -- 94
			if self._advancing then -- 95
				return -- 95
			end -- 95
			self.reviewVisible = true -- 96
			return self:alignLayout() -- 97
		end) -- 94
		self.reviewBack:slot("Tapped", function() -- 98
			self.reviewVisible = false -- 98
		end) -- 98
		self.reviewArea:slot("NoneScrollTapped", function() -- 99
			self.reviewVisible = false -- 99
		end) -- 99
		do -- 100
			local _with_0 = Dialog() -- 100
			_with_0.__modified = function(key, value) -- 101
				if "character" == key then -- 102
					if (value ~= nil) and value ~= "" then -- 103
						self.figure:removeAllChildren() -- 104
						return self.figure:addChild(StoryFigure({ -- 105
							char = value -- 105
						})) -- 105
					end -- 103
				elseif "name" == key then -- 106
					if (value ~= nil) then -- 107
						self.name.text = value -- 107
					end -- 107
				elseif "text" == key then -- 108
					if (value ~= nil) then -- 109
						self.text.text = value -- 109
					end -- 109
				end -- 101
			end -- 101
			_with_0.__updated = function() -- 110
				return self:alignLayout() -- 110
			end -- 110
			self._dialog = _with_0 -- 100
		end -- 100
		self._reviews = { } -- 111
		self.visible = false -- 112
	end, -- 55
	updateDialogAsync = function(self) -- 114
		if not self._current then -- 115
			return -- 115
		end -- 115
		if self._advancing then -- 116
			return -- 116
		end -- 116
		self._advancing = true -- 117
		local name, characterId = getCharName(self._current) -- 118
		if characterId == 'vivi' then -- 119
			Cache:loadAsync("spine:vikaFigure") -- 120
			self._dialog.character = characterId -- 121
		elseif characterId ~= '' then -- 122
			Cache:loadAsync("spine:" .. tostring(characterId) .. "Figure") -- 123
			self._dialog.character = characterId -- 124
		end -- 119
		local text = self._current.text -- 125
		do -- 126
			local _obj_0 = self._reviews -- 126
			_obj_0[#_obj_0 + 1] = { -- 126
				name = name, -- 126
				text = text -- 126
			} -- 126
		end -- 126
		self._dialog.name = name -- 127
		self._dialog.text = text -- 128
		self.answerList:removeAllChildren() -- 129
		if self._options then -- 130
			self.continueIcon.visible = false -- 131
			local count = #self._options -- 132
			for i = 1, count do -- 133
				local option = self._options[i] -- 134
				name = getCharName(option) -- 135
				local optionText = option.text -- 136
				self.answerList:addChild((function() -- 137
					local _with_0 = Answer({ -- 137
						text = optionText -- 137
					}) -- 137
					_with_0:slot("Tapped", function() -- 138
						_with_0.touchEnabled = false -- 139
						return thread(function() -- 140
							sleep(0.3) -- 141
							do -- 142
								local _obj_0 = self._reviews -- 142
								_obj_0[#_obj_0 + 1] = { -- 142
									name = name, -- 142
									text = optionText -- 142
								} -- 142
							end -- 142
							if self:advance(i) then -- 143
								return thread(function() -- 144
									return self:updateDialogAsync() -- 144
								end) -- 144
							else -- 146
								return self:hide() -- 146
							end -- 143
						end) -- 140
					end) -- 138
					return _with_0 -- 137
				end)()) -- 137
			end -- 133
			local size = self.answerList:alignItems(40) -- 147
			self.answerList.size = size -- 148
			self.answerList:alignItems(40) -- 149
		else -- 151
			self.continueIcon.visible = true -- 151
		end -- 130
		self._advancing = false -- 152
		if self._preloads then -- 153
			local _list_0 = self._preloads -- 154
			for _index_0 = 1, #_list_0 do -- 154
				local item = _list_0[_index_0] -- 154
				if Content:isdir(item) then -- 155
					preloadFrame(item) -- 156
				else -- 158
					if "" == Path:getExt(item) then -- 158
						local figureFile -- 159
						if 'vivi' == item then -- 160
							figureFile = "spine:vikaFigure" -- 160
						else -- 161
							figureFile = "spine:" .. tostring(item) .. "Figure" -- 161
						end -- 159
						thread(function() -- 162
							return Cache:loadAsync(figureFile) -- 162
						end) -- 162
					else -- 164
						thread(function() -- 164
							return Cache:loadAsync(item) -- 164
						end) -- 164
					end -- 158
				end -- 155
			end -- 154
			self._preloads = nil -- 165
		end -- 153
	end, -- 114
	showAsync = function(self) -- 167
		self:updateDialogAsync() -- 168
		self.visible = true -- 169
		self._viewScale = View.scale -- 170
		self._viewEffect = View.postEffect -- 171
		View.scale = 4 * self._viewScale -- 172
		local size = View.size -- 173
		local blurH -- 174
		do -- 174
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurh") -- 174
			_with_0.grabPass = true -- 175
			_with_0:set("u_radius", size.width) -- 176
			blurH = _with_0 -- 174
		end -- 174
		local blurV -- 177
		do -- 177
			local _with_0 = Pass("builtin:vs_sprite", "builtin:fs_spriteblurv") -- 177
			_with_0.grabPass = true -- 178
			_with_0:set("u_radius", size.height) -- 179
			blurV = _with_0 -- 177
		end -- 177
		do -- 180
			local _with_0 = SpriteEffect() -- 180
			for _ = 1, 3 do -- 181
				_with_0:add(blurH) -- 182
				_with_0:add(blurV) -- 183
			end -- 181
			View.postEffect = _with_0 -- 180
		end -- 180
		return self:gslot("AppChange", function(settingName) -- 184
			if settingName == "Size" then -- 184
				local width, height -- 185
				do -- 185
					local _obj_0 = View.size -- 185
					width, height = _obj_0.width, _obj_0.height -- 185
				end -- 185
				blurH:set("u_radius", width) -- 186
				return blurV:set("u_radius", height) -- 187
			end -- 184
		end) -- 184
	end, -- 167
	hide = function(self) -- 189
		self:gslot("AppChange", nil) -- 190
		self:emit("Ended") -- 191
		self:removeFromParent() -- 192
		local viewScale = self._viewScale -- 193
		local viewEffect = self._viewEffect -- 194
		return thread(function() -- 195
			collectgarbage() -- 196
			Cache:removeUnused() -- 197
			View.scale = viewScale -- 198
			sleep() -- 199
			View.postEffect = viewEffect -- 200
		end) -- 195
	end -- 189
}) -- 22
return _module_0 -- 1
