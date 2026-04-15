-- [yue]: init.yue
local _ENV = Dora -- 1
local Path <const> = Path -- 2
local Content <const> = Content -- 2
local require <const> = require -- 2
do -- 4
	local scriptPath = Path:getScriptPath(...) -- 4
	if scriptPath then -- 4
		local _list_0 = { -- 6
			scriptPath, -- 6
			Path(scriptPath, "Script"), -- 7
			Path(scriptPath, "Spine"), -- 8
			Path(scriptPath, "Image"), -- 9
			Path(scriptPath, "Font") -- 10
		} -- 5
		for _index_0 = 1, #_list_0 do -- 5
			local path = _list_0[_index_0] -- 5
			Content:insertSearchPath(1, path) -- 12
		end -- 5
	else -- 13
		return -- 13
	end -- 4
end -- 4
local Command = require("System.Command") -- 15
local Config = require("Data.Config") -- 16
Config.chapter = "start.yarn" -- 18
return Command.chapter() -- 20
