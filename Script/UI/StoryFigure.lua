-- [xml]: Script/UI/StoryFigure.xml
return function(args) -- 1
local _ENV = Dora(args) -- 1
local node1 = Node() -- 2
local offsets = { -- 4
charF = {x = 330, y = -350, scale = 0.47}, -- 5
charM = {x = 0, y = -460, scale = 0.52}, -- 6
ninilite = {x = -102, y = 40, scale = 0.45}, -- 7
ayan = {x = 187, y = -370, scale = 0.47}, -- 8
villywan = {x = 19, y = 257, scale = 0.33}, -- 9
moling = {x = 0, y = 77, scale = 0.39}, -- 10
moyu = {x = -163, y = -246, scale = 0.44}, -- 11
liyena = {x = 0, y = 405, scale = 0.43}, -- 12
sunborn = {x = 307, y = 244, scale = 0.46}, -- 13
wuyun = {x = 41, y = -346, scale = 0.50}, -- 14
vika = {x = -2733, y = -1553, scale = 1.27}, -- 15
vivi = {x = -2137, y = -2316, scale = 1.3}, -- 16
yuzijiang = {x = 40, y = 261, scale = 0.45}, -- 17
char = {x = -251, y = -89, scale = 0.44}, -- 18
} -- 19
local file, look -- 20
if char == "vivi" then -- 21
file = "spine:vikaFigure" -- 22
look = "vivi" -- 23
elseif char == "vika" then -- 24
file = "spine:vikaFigure" -- 25
look = "vika" -- 26
else -- 27
file = "spine:" .. char .. "Figure" -- 28
look = "" -- 29
end -- 30
local offsetX, offsetY, scale = 0, 0, 1.0 -- 31
if offsets[char] then -- 32
offsetX = offsets[char].x -- 33
offsetY = offsets[char].y -- 34
scale = offsets[char].scale -- 35
end -- 36
local spine = Playable(file) -- 38
spine.x = offsetX -- 38
spine.y = offsetY -- 38
spine.scaleX = scale -- 38
spine.scaleY = scale -- 38
spine.look = look -- 38
spine:play("idle",true) -- 38
node1:addChild(spine) -- 38
do -- 45
	if editing then -- 47
		spine:schedule(function() -- 48
			local width, height -- 49
			do -- 49
				local _obj_0 = App.visualSize -- 49
				width, height = _obj_0.width, _obj_0.height -- 49
			end -- 49
			ImGui.SetNextWindowPos(Vec2(width - 10, 10), "FirstUseEver", Vec2(1, 0)) -- 50
			ImGui.SetNextWindowSize(Vec2(240, 160), "FirstUseEver") -- 51
			return ImGui.Begin(char, { -- 52
				"NoResize", -- 52
				"NoSavedSettings" -- 52
			}, function() -- 52
				local x, y, scale -- 53
				do -- 53
					local _obj_0 = spine -- 53
					x, y, scale = _obj_0.x, _obj_0.y, _obj_0.scaleX -- 53
				end -- 53
				do -- 54
					local changed -- 54
					changed, x = ImGui.DragFloat("X", x, 1, -3000, 3000, "%.2f") -- 54
					if changed then -- 54
						spine.x = x -- 54
					end -- 54
				end -- 54
				do -- 55
					local changed -- 55
					changed, y = ImGui.DragFloat("Y", y, 1, -3000, 3000, "%.2f") -- 55
					if changed then -- 55
						spine.y = y -- 55
					end -- 55
				end -- 55
				local changed -- 56
				changed, scale = ImGui.DragFloat("Scale", scale, 0.01, -2, 2, "%.2f") -- 56
				if changed then -- 56
					spine.scaleX = scale -- 57
					spine.scaleY = scale -- 57
				end -- 56
			end) -- 57
		end) -- 48
	end -- 47
end -- 57
return node1 -- 46
end