-- [yue]: init.yue
local Path = Dora.Path -- 1
local Content = Dora.Content -- 1
do -- 2
	local scriptPath = Path:getScriptPath(...) -- 2
	if scriptPath then -- 2
		local _list_0 = { -- 4
			scriptPath, -- 4
			Path(scriptPath, "Script"), -- 5
			Path(scriptPath, "Spine"), -- 6
			Path(scriptPath, "Image"), -- 7
			Path(scriptPath, "Font") -- 8
		} -- 3
		for _index_0 = 1, #_list_0 do -- 9
			local path = _list_0[_index_0] -- 3
			Content:insertSearchPath(1, path) -- 10
		end -- 10
	else -- 11
		return -- 11
	end -- 2
end -- 2
local Command = require("System.Command") -- 13
local Config = require("Data.Config") -- 14
Config.chapter = "start.yarn" -- 16
return Command.chapter() -- 18
