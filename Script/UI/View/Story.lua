-- [xml]: Script/UI/View/Story.xml
local SolidRect = require("UI.View.Shape.SolidRect") -- 2
local AlignNode = require("UI.Control.Basic.AlignNode") -- 3
local ScrollArea = require("UI.Control.Basic.ScrollArea") -- 4
local FullScreenMask = require("UI.FullScreenMask") -- 6
local ReviewSentence = require("UI.ReviewSentence") -- 7
local ReviewButton = require("UI.ReviewButton") -- 9
local H <const> = 1563 -- 11
return function(args) -- 1
local _ENV = Dora(args) -- 1
local ui = AlignNode{isRoot = true, inUI = true} -- 12
local item1 = FullScreenMask{} -- 13
ui:addChild(item1) -- 13
local figure = AlignNode{vAlign = "Bottom", hAlign = "Center"} -- 14
ui:addChild(figure) -- 14
ui.figure = figure -- 14
local talkArea = AlignNode{vAlign = "Bottom", hAlign = "Left"} -- 15
ui:addChild(talkArea) -- 15
local talkBack = SolidRect{color = 0x66000000, order = -1, height = 370, width = 3258} -- 16
talkArea:addChild(talkBack) -- 16
local sprite1 = Sprite("button.clip|prompt_chat_2") -- 17
sprite1.x = 50 -- 17
sprite1.y = 340 -- 17
talkArea:addChild(sprite1) -- 17
local rightLabel = Sprite("button.clip|prompt_chat_2") -- 18
rightLabel.x = 3208 -- 18
rightLabel.y = 340 -- 18
talkArea:addChild(rightLabel) -- 18
local talkLine = Line() -- 19
talkLine.color3 = Color3(0xffffff) -- 19
talkArea:addChild(talkLine) -- 19
talkLine:set({Vec2(92,340),Vec2(3166,340)},Color(0xffffffff)) -- 19
local name = Label("SourceHanSansCN-Regular",55) -- 23
name.anchor = Vec2(0,name.anchor.y) -- 23
name.x = 97 -- 23
name.y = 185 -- 23
name.color3 = Color3(0xffffff) -- 23
name.alignment = "Center" -- 23
name.textWidth = 280 -- 23
talkArea:addChild(name) -- 23
ui.name = name -- 23
local confirm = Node() -- 28
confirm.touchEnabled = true -- 28
talkArea:addChild(confirm) -- 28
ui.confirm = confirm -- 28
local textArea = ScrollArea{y = 165, x = 1620, scrollBar = false, paddingX = 0} -- 29
talkArea:addChild(textArea) -- 29
ui.textArea = textArea -- 29
local view = textArea.view -- 30
local text = Label("SourceHanSansCN-Regular",50) -- 31
text.color3 = Color3(0xffffff) -- 31
text.alignment = "Left" -- 31
text.textWidth = 2368 -- 31
view:addChild(text) -- 31
ui.text = text -- 31
local rightCenter = AlignNode{vAlign = "Center", hAlign = "Right"} -- 38
ui:addChild(rightCenter) -- 38
ui.rightCenter = rightCenter -- 38
local answerList = Menu() -- 39
answerList.x = -413.5 -- 39
answerList.size = Size(907,114) -- 39
rightCenter:addChild(answerList) -- 39
ui.answerList = answerList -- 39
local rightBottom = AlignNode{vAlign = "Bottom", hAlign = "Right"} -- 42
ui:addChild(rightBottom) -- 42
local reviewButton = ReviewButton{y = 260, x = -163} -- 43
rightBottom:addChild(reviewButton) -- 43
ui.reviewButton = reviewButton -- 43
local move = Action(Sequence(Move(1,Vec2(-163,94),Vec2(-163,114),Ease.InExpo),Move(1,Vec2(-163,114),Vec2(-163,94),Ease.OutExpo))) -- 45
local continueIcon = Sprite("button.clip|prompt_chat_continue") -- 50
continueIcon.x = -163 -- 50
continueIcon.y = 94 -- 50
rightBottom:addChild(continueIcon) -- 50
ui.continueIcon = continueIcon -- 50
continueIcon:slot("Enter",function() -- 51
continueIcon:perform(move) -- 51
continueIcon:slot("ActionEnd",function(_action_) if _action_ == move then continueIcon:perform(move) end end) -- 51
end) -- 51
local rightTop = AlignNode{vAlign = "Top", hAlign = "Right"} -- 54
ui:addChild(rightTop) -- 54
local reviewMask = FullScreenMask{} -- 60
ui:addChild(reviewMask) -- 60
ui.reviewMask = reviewMask -- 60
local topCenter = AlignNode{vAlign = "Top", hAlign = "Center"} -- 61
ui:addChild(topCenter) -- 61
ui.topCenter = topCenter -- 61
local label1 = Label("SourceHanSansCN-Regular",70) -- 62
label1.anchor = Vec2(label1.anchor.x,1) -- 62
label1.y = -83 -- 62
label1.color3 = Color3(0xffffff) -- 62
label1.alignment = "Center" -- 62
label1.text = "对话回顾" -- 62
topCenter:addChild(label1) -- 62
local leftLabel1 = Sprite("button.clip|prompt_chat_2") -- 66
leftLabel1.x = -1579 -- 66
leftLabel1.y = -208 -- 66
topCenter:addChild(leftLabel1) -- 66
local rightLabel1 = Sprite("button.clip|prompt_chat_2") -- 67
rightLabel1.x = 1579 -- 67
rightLabel1.y = -208 -- 67
topCenter:addChild(rightLabel1) -- 67
local talkLine2 = Line() -- 68
talkLine2.y = -208 -- 68
talkLine2.color3 = Color3(0xffffff) -- 68
topCenter:addChild(talkLine2) -- 68
talkLine2:set({Vec2(-1579,0),Vec2(1579,0)},Color(0xffffffff)) -- 68
local reviewBack = Node() -- 72
reviewBack.touchEnabled = true -- 72
topCenter:addChild(reviewBack) -- 72
ui.reviewBack = reviewBack -- 72
local reviewArea = ScrollArea{scrollBar = false, paddingX = 0} -- 73
topCenter:addChild(reviewArea) -- 73
ui.reviewArea = reviewArea -- 73
local view = reviewArea.view -- 74
ui:slot("AlignLayout",function(w, h) -- 78
do -- 78
	local scale = h / H -- 81
	local reviewW = w / scale - 160 * 2 -- 82
	local reviewH = h / scale - 208 - 370 -- 83
	reviewArea.y = -208 - reviewH / 2 -- 84
	reviewArea.view:removeAllChildren() -- 85
	local _list_0 = ui._reviews -- 86
	for _index_0 = 1, #_list_0 do -- 86
		local _des_0 = _list_0[_index_0] -- 86
		local name, text = _des_0.name, _des_0.text -- 86
		reviewArea.view:addChild(ReviewSentence({ -- 87
			width = reviewW, -- 87
			name = name, -- 87
			text = text -- 87
		})) -- 87
	end -- 87
	reviewArea.view:addChild(ReviewSentence({ -- 88
		width = reviewW, -- 88
		name = "", -- 88
		text = "\n" -- 88
	})) -- 88
	reviewArea:adjustSizeWithAlign("Auto", 0, Size(reviewW, reviewH)) -- 89
	local offset = (w / 2) / scale - 150 -- 90
	leftLabel1.x = -offset -- 91
	rightLabel1.x = offset -- 92
	offset = (w / 2) / scale - 192 -- 93
	talkLine2:removeFromParent() -- 94
	do -- 95
		local _with_0 = Line({ -- 95
			Vec2(-offset, -208), -- 95
			Vec2(offset, -208) -- 95
		}, Color(0xffffffff)) -- 95
		_with_0:addTo(topCenter) -- 96
		talkLine2 = _with_0 -- 95
	end -- 95
	local _list_1 = { -- 97
		talkArea, -- 97
		rightBottom, -- 97
		rightTop, -- 97
		rightCenter, -- 97
		figure, -- 97
		topCenter -- 97
	} -- 97
	for _index_0 = 1, #_list_1 do -- 97
		local item = _list_1[_index_0] -- 97
		item.scaleX = scale -- 98
		item.scaleY = scale -- 99
	end -- 99
	talkBack:removeFromParent() -- 100
	local realWidth = w / scale -- 101
	do -- 102
		local _with_0 = SolidRect({ -- 102
			width = realWidth, -- 102
			height = 370, -- 102
			color = 0x66000000 -- 102
		}) -- 102
		_with_0.order = -1 -- 103
		_with_0:addTo(talkArea) -- 104
		talkBack = _with_0 -- 102
	end -- 102
	talkLine:removeFromParent() -- 105
	do -- 106
		local _with_0 = Line({ -- 106
			Vec2(92, 340), -- 106
			Vec2(realWidth - 92, 340) -- 106
		}, Color(0xffffffff)) -- 106
		_with_0:addTo(talkArea) -- 107
		talkLine = _with_0 -- 106
	end -- 106
	rightLabel.x = realWidth - 50 -- 108
	text.textWidth = realWidth - 890 -- 109
	textArea.x = 436 + (realWidth - 890) / 2 -- 110
	textArea:adjustSizeWithAlign("Auto", 0, Size(realWidth - 890, math.min(300, text.height + 20))) -- 111
end -- 111
end) -- 79
return ui -- 79
end