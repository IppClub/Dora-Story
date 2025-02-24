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
	"story", -- 数据库名
	"charName", -- 玩家名字
	"chapter", -- 当前章节
	-- 以上为保留字段，在下面补充新的变量
	"gold", -- 教学对话测试用临时变量
	"name" -- 教学对话测试用临时变量
)

conf:load()

if not conf.chapter then
	conf.chapter = "start"
end

return conf
