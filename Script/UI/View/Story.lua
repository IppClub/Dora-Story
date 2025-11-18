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
local frame = AlignNode{vAlign = "Bottom", hAlign = "Center"} -- 15
ui:addChild(frame) -- 15
ui.frame = frame -- 15
local talkArea = AlignNode{vAlign = "Bottom", hAlign = "Left"} -- 16
ui:addChild(talkArea) -- 16
local talkBack = SolidRect{color = 0x66000000, order = -1, height = 370, width = 3258} -- 17
talkArea:addChild(talkBack) -- 17
local sprite1 = Sprite("button.clip|prompt_chat_2") -- 18
sprite1.x = 50 -- 18
sprite1.y = 340 -- 18
talkArea:addChild(sprite1) -- 18
local rightLabel = Sprite("button.clip|prompt_chat_2") -- 19
rightLabel.x = 3208 -- 19
rightLabel.y = 340 -- 19
talkArea:addChild(rightLabel) -- 19
local talkLine = Line() -- 20
talkLine.color3 = Color3(0xffffff) -- 20
talkArea:addChild(talkLine) -- 20
talkLine:set({Vec2(92,340),Vec2(3166,340)},Color(0xffffffff)) -- 20
local name = Label("SourceHanSansCN-Regular",55) -- 24
name.anchor = Vec2(0,name.anchor.y) -- 24
name.x = 97 -- 24
name.y = 185 -- 24
name.color3 = Color3(0xffffff) -- 24
name.alignment = "Center" -- 24
name.textWidth = 280 -- 24
talkArea:addChild(name) -- 24
ui.name = name -- 24
local confirm = Node() -- 29
confirm.touchEnabled = true -- 29
talkArea:addChild(confirm) -- 29
ui.confirm = confirm -- 29
local textArea = ScrollArea{y = 165, x = 1620, scrollBar = false, paddingX = 0} -- 30
talkArea:addChild(textArea) -- 30
ui.textArea = textArea -- 30
local view = textArea.view -- 31
local text = Label("SourceHanSansCN-Regular",50) -- 32
text.color3 = Color3(0xffffff) -- 32
text.alignment = "Left" -- 32
text.textWidth = 2368 -- 32
view:addChild(text) -- 32
ui.text = text -- 32
local rightCenter = AlignNode{vAlign = "Center", hAlign = "Right"} -- 39
ui:addChild(rightCenter) -- 39
ui.rightCenter = rightCenter -- 39
local answerList = Menu() -- 40
answerList.x = -413.5 -- 40
answerList.size = Size(907,114) -- 40
rightCenter:addChild(answerList) -- 40
ui.answerList = answerList -- 40
local rightBottom = AlignNode{vAlign = "Bottom", hAlign = "Right"} -- 43
ui:addChild(rightBottom) -- 43
local reviewButton = ReviewButton{y = 260, x = -163} -- 44
rightBottom:addChild(reviewButton) -- 44
ui.reviewButton = reviewButton -- 44
local move = Action(Sequence(Move(1,Vec2(-163,94),Vec2(-163,114),Ease.InExpo),Move(1,Vec2(-163,114),Vec2(-163,94),Ease.OutExpo))) -- 46
local continueIcon = Sprite("button.clip|prompt_chat_continue") -- 51
continueIcon.x = -163 -- 51
continueIcon.y = 94 -- 51
rightBottom:addChild(continueIcon) -- 51
ui.continueIcon = continueIcon -- 51
continueIcon:slot("Enter",function() -- 52
continueIcon:perform(move) -- 52
continueIcon:slot("ActionEnd",function(_action_) if _action_ == move then continueIcon:perform(move) end end) -- 52
end) -- 52
local rightTop = AlignNode{vAlign = "Top", hAlign = "Right"} -- 55
ui:addChild(rightTop) -- 55
local reviewMask = FullScreenMask{} -- 61
ui:addChild(reviewMask) -- 61
ui.reviewMask = reviewMask -- 61
local topCenter = AlignNode{vAlign = "Top", hAlign = "Center"} -- 62
ui:addChild(topCenter) -- 62
ui.topCenter = topCenter -- 62
local label1 = Label("SourceHanSansCN-Regular",70) -- 63
label1.anchor = Vec2(label1.anchor.x,1) -- 63
label1.y = -83 -- 63
label1.color3 = Color3(0xffffff) -- 63
label1.alignment = "Center" -- 63
label1.text = "对话回顾" -- 63
topCenter:addChild(label1) -- 63
local leftLabel1 = Sprite("button.clip|prompt_chat_2") -- 67
leftLabel1.x = -1579 -- 67
leftLabel1.y = -208 -- 67
topCenter:addChild(leftLabel1) -- 67
local rightLabel1 = Sprite("button.clip|prompt_chat_2") -- 68
rightLabel1.x = 1579 -- 68
rightLabel1.y = -208 -- 68
topCenter:addChild(rightLabel1) -- 68
local talkLine2 = Line() -- 69
talkLine2.y = -208 -- 69
talkLine2.color3 = Color3(0xffffff) -- 69
topCenter:addChild(talkLine2) -- 69
talkLine2:set({Vec2(-1579,0),Vec2(1579,0)},Color(0xffffffff)) -- 69
local reviewBack = Node() -- 73
reviewBack.touchEnabled = true -- 73
topCenter:addChild(reviewBack) -- 73
ui.reviewBack = reviewBack -- 73
local reviewArea = ScrollArea{scrollBar = false, paddingX = 0} -- 74
topCenter:addChild(reviewArea) -- 74
ui.reviewArea = reviewArea -- 74
local view = reviewArea.view -- 75
ui:slot("AlignLayout",function(w, h) -- 79
do -- 79
	local scale = h / H -- 82
	local reviewW = w / scale - 160 * 2 -- 83
	local reviewH = h / scale - 208 - 370 -- 84
	reviewArea.y = -208 - reviewH / 2 -- 85
	reviewArea.view:removeAllChildren() -- 86
	local _list_0 = ui._reviews -- 87
	for _index_0 = 1, #_list_0 do -- 87
		local _des_0 = _list_0[_index_0] -- 87
		local name, text = _des_0.name, _des_0.text -- 87
		reviewArea.view:addChild(ReviewSentence({ -- 88
			width = reviewW, -- 88
			name = name, -- 88
			text = text -- 88
		})) -- 88
	end -- 88
	reviewArea.view:addChild(ReviewSentence({ -- 89
		width = reviewW, -- 89
		name = "", -- 89
		text = "\n" -- 89
	})) -- 89
	reviewArea:adjustSizeWithAlign("Auto", 0, Size(reviewW, reviewH)) -- 90
	local offset = (w / 2) / scale - 150 -- 91
	leftLabel1.x = -offset -- 92
	rightLabel1.x = offset -- 93
	offset = (w / 2) / scale - 192 -- 94
	talkLine2:removeFromParent() -- 95
	do -- 96
		local _with_0 = Line({ -- 96
			Vec2(-offset, -208), -- 96
			Vec2(offset, -208) -- 96
		}, Color(0xffffffff)) -- 96
		_with_0:addTo(topCenter) -- 97
		talkLine2 = _with_0 -- 96
	end -- 96
	local _list_1 = { -- 98
		talkArea, -- 98
		rightBottom, -- 98
		rightTop, -- 98
		rightCenter, -- 98
		figure, -- 98
		frame, -- 98
		topCenter -- 98
	} -- 98
	for _index_0 = 1, #_list_1 do -- 98
		local item = _list_1[_index_0] -- 98
		item.scaleX = scale -- 99
		item.scaleY = scale -- 100
	end -- 100
	talkBack:removeFromParent() -- 101
	local realWidth = w / scale -- 102
	do -- 103
		local _with_0 = SolidRect({ -- 103
			width = realWidth, -- 103
			height = 370, -- 103
			color = 0x66000000 -- 103
		}) -- 103
		_with_0.order = -1 -- 104
		_with_0:addTo(talkArea) -- 105
		talkBack = _with_0 -- 103
	end -- 103
	talkLine:removeFromParent() -- 106
	do -- 107
		local _with_0 = Line({ -- 107
			Vec2(92, 340), -- 107
			Vec2(realWidth - 92, 340) -- 107
		}, Color(0xffffffff)) -- 107
		_with_0:addTo(talkArea) -- 108
		talkLine = _with_0 -- 107
	end -- 107
	rightLabel.x = realWidth - 50 -- 109
	text.textWidth = realWidth - 890 -- 110
	textArea.x = 436 + (realWidth - 890) / 2 -- 111
	textArea:adjustSizeWithAlign("Auto", 0, Size(realWidth - 890, math.min(300, text.height + 20))) -- 112
end -- 112
end) -- 80
return ui -- 80
end