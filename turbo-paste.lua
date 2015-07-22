#!/usr/bin/env luajit

-- configuration
-- salt: used to create a hash based on current counter
-- url: the url to access the appliation
-- port: the port number use by turbo http server
-- address: ip or hostname to listen on
-- kwargs: arguments passed on to HTTPServer
local conf = {
    salt = "CHANGE ME!",
    url = "http://172.16.3.80:8888/",
    port = 8888,
    address = "0.0.0.0",
    kwargs = {
        max_body_size=1024*1024*1
    }
}

-- no changes after here if you dont know what you are doing

local turbo = require("turbo")
local turboredis = require("turboredis")
local hashids = require("hashids")

local yield = coroutine.yield

-- setup redis connection
local redis = turboredis.Connection:new()

-- create mustage template helper
local tpl = turbo.web.Mustache.TemplateHelper("./tpl")

-- General handler
local PasteHandler = class("PasteHandler", turbo.web.RequestHandler)

-- get post and store in redis
function PasteHandler:post()
    -- This handler takes one POST argument.
    local paste = self:get_argument("tpaste", "")
    if paste == "" then
        error(turbo.web.HTTPError(400, "400 No data received."))
    end
    -- counter is used for statistical usage
    -- and to generate an unique redis key(hash)
    local counter = yield(redis:incr("counter"))
    -- create a hash from the counter
    local h = hashids.new(conf.salt, 4)
    local hash = h:encode(counter)
    -- write the paste to redis
    yield(redis:set(hash, paste))
    self:write(conf.url .. hash .. "\n")
end

-- display index page
function PasteHandler:get()
    self:write(tpl:render("index.tpl", {url = conf.url}))
end

-- handler to display paste
local GetPasteHandler = class("GetPasteHandler", turbo.web.RequestHandler)

function GetPasteHandler:get(hash)
    local paste = yield(redis:get(hash, paste))
    if not paste then
	error(turbo.web.HTTPError(404, "404 Not found."))
    end
    local hl = self:get_argument("hl", false)
    if hl == "true" then
        self:write(tpl:render("highlight.tpl", {paste = paste}))
    else
        self:add_header("Content-Type", "text/plain; charset=UTF-8")
        self:write(paste)
    end
end

-- new redis connection
turbo.ioloop.instance():add_callback(function()
    local ok = yield(redis:connect())
    if not ok then
        error(turbo.web.HTTPError(501, "501 Could not connect to backend."))
    end
end)

-- turbo http
turbo.web.Application({
    {"^/$", PasteHandler},
    {"^/(%w*)$", GetPasteHandler},
    {"/favicon.ico$", turbo.web.StaticFileHandler, "favicon.ico"}
}):listen(conf.port, conf.ip, conf.kwargs)
turbo.ioloop.instance():start()
