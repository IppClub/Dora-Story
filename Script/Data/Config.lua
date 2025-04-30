local Director <const> = require("Director")
local Content <const> = require("Content")
local Path <const> = require("Path")
local DB <const> = require("DB")
local Config <const> = require("Config")

local dbPath = Path(Content.writablePath, "story.db")
DB:exec("ATTACH DATABASE '" .. dbPath .. "' AS story;")
Director.entry:onCleanup(function()
	DB:exec("DETACH DATABASE story")
end)

local conf = Config(
"story",
"charName",
"chapter",

"gold",
"name")


conf:load()

if not conf.chapter then
	conf.chapter = "start"
end

return conf