#!/usr/bin/env luajit

local turbo = require("turbo")
local turboredis = require("turboredis")
local yield = coroutine.yield
local hashids = require("hashids")

-- some variables
local salt = "CHANGE ME!"
local url = "http://172.16.3.80:8888/"

-- setup redis connection
local redis = turboredis.Connection:new()

-- create tempplate helper
local tpl = turbo.web.Mustache.TemplateHelper("./tpl")


local PasteHandler = class("PasteHandler", turbo.web.RequestHandler)

-- get post and store in redis
function PasteHandler:post()
    -- This handler takes one POST argument.
    local paste = self:get_argument("tpaste", "")
    if paste == "" then
        self:write("No data received!")
    else
	-- counter is used for statistical usage
	-- and to generate an unique redis key(hash)
	local counter = yield(redis:incr("counter"))
	-- create a hash from the counter
	local h = hashids.new(salt, 4)
	local hash = h:encode(counter)
	-- write the paste to redis
	yield(redis:set(hash, paste))
	self:write(url .. hash)
    end
end

-- display index page
function PasteHandler:get()
    self:write(tpl:render("index.tpl", {url = url}))
end

-- handler to display paste
local GetPasteHandler = class("GetPasteHandler", turbo.web.RequestHandler)

function GetPasteHandler:get(hash)
    local paste = yield(redis:get(hash, paste))
    self:add_header("Content-Type", "text/plain; charset=UTF-8")
    self:write(paste)
end

-- new redis connection
turbo.ioloop.instance():add_callback(function()
    local ok = yield(redis:connect())
    if not ok then
        error("Could not connect to Redis")
    end
end)

-- turbo http
turbo.web.Application({
    {"^/$", PasteHandler},
    {"^/(%w*)$", GetPasteHandler}
}):listen(8888)
turbo.ioloop.instance():start()

