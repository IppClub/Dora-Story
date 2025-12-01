-- [ts]: FrameAnimation.ts
local ____lualib = require("lualib_bundle") -- 1
local Map = ____lualib.Map -- 1
local __TS__New = ____lualib.__TS__New -- 1
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter -- 1
local __TS__ArraySort = ____lualib.__TS__ArraySort -- 1
local __TS__ArrayMap = ____lualib.__TS__ArrayMap -- 1
local ____exports = {} -- 1
local ____Dora = require("Dora") -- 2
local Content = ____Dora.Content -- 2
local Path = ____Dora.Path -- 2
local Sprite = ____Dora.Sprite -- 2
local sleep = ____Dora.sleep -- 2
local Node = ____Dora.Node -- 2
local App = ____Dora.App -- 2
local Cache = ____Dora.Cache -- 2
local wait = ____Dora.wait -- 2
local thread = ____Dora.thread -- 2
local Opacity = ____Dora.Opacity -- 2
local frameLoading = __TS__New(Map) -- 4
function ____exports.preloadFrame(folder) -- 6
	frameLoading:set(folder, true) -- 7
	thread(function() -- 8
		local files = __TS__ArraySort(__TS__ArrayFilter( -- 9
			Content:getAllFiles(folder), -- 9
			function(____, f) -- 9
				local ext = Path:getExt(f) -- 10
				return ext == "png" or ext == "jpg" -- 11
			end -- 9
		)) -- 9
		Cache:loadAsync(__TS__ArrayMap( -- 13
			files, -- 13
			function(____, f) return Path(folder, f) end -- 13
		)) -- 13
		frameLoading:delete(folder) -- 14
	end) -- 8
end -- 6
function ____exports.playFrame(folder, duration, loop, x, y, scale) -- 18
	local node = Node() -- 19
	node.x = x -- 20
	node.y = y -- 21
	local ____scale_0 = scale -- 22
	node.scaleY = ____scale_0 -- 22
	node.scaleX = ____scale_0 -- 22
	node:onCleanup(function() -- 23
		thread(function() -- 24
			sleep(0.5) -- 25
			collectgarbage() -- 26
			Cache:removeUnused() -- 27
		end) -- 24
	end) -- 23
	node:perform(Opacity(0.3, 0, 1)) -- 30
	local files = __TS__ArraySort(__TS__ArrayFilter( -- 31
		Content:getAllFiles(folder), -- 31
		function(____, f) -- 31
			local ext = Path:getExt(f) -- 32
			return ext == "png" or ext == "jpg" -- 33
		end -- 31
	)) -- 31
	local interval = math.max(1 / App.targetFPS, duration / #files) -- 35
	local lastSprite = nil -- 36
	local function animation() -- 37
		if frameLoading:get(folder) then -- 37
			wait(function() return not frameLoading:get(folder) end) -- 39
		elseif not frameLoading:has(folder) then -- 39
			frameLoading:set(folder, true) -- 41
			Cache:loadAsync(__TS__ArrayMap( -- 42
				files, -- 42
				function(____, f) return Path(folder, f) end -- 42
			)) -- 42
			frameLoading:delete(folder) -- 43
		end -- 43
		for ____, f in ipairs(files) do -- 45
			if lastSprite then -- 45
				lastSprite:removeFromParent() -- 47
			end -- 47
			lastSprite = Sprite(Path(folder, f)) -- 49
			if lastSprite ~= nil then -- 49
				lastSprite:addTo(node) -- 50
			end -- 50
			sleep(interval) -- 51
		end -- 51
		return false -- 53
	end -- 37
	if loop then -- 37
		node:loop(animation) -- 56
	else -- 56
		node:once(animation) -- 58
	end -- 58
	return node -- 60
end -- 18
return ____exports -- 18