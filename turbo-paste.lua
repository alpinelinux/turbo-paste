#!/usr/bin/env luajit

local turbo = require("turbo")
local hashids = require("hashids")
local redis = require("redis")
local conf = require("config")

-- setup redis connection
local client = redis.connect(conf.redis)

-- create mustage template helper
local tpl = turbo.web.Mustache.TemplateHelper(conf.templates)

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
    local counter = client:incr("counter")
    -- create a hash from the counter
    local h = hashids.new(conf.salt, 4)
    local hash = h:encode(counter)
    -- write the paste to redis
    client:set(hash, paste)
    self:write(conf.url .. hash .. "\n")
end

-- display index page
function PasteHandler:get()
    self:write(tpl:render("index.tpl", {url = conf.url}))
end

-- handler to display paste
local GetPasteHandler = class("GetPasteHandler", turbo.web.RequestHandler)

function GetPasteHandler:get(hash)
    local paste = client:get(hash, paste)
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

-- handler to display paste form
local PasteFormHandler = class("PasteHandler", turbo.web.RequestHandler)

function PasteFormHandler:get()
    self:write(tpl:render("form.tpl", {url = conf.url}))
end


-- turbo http
turbo.web.Application({
    {"^/$", PasteHandler},
    {"^/form$", PasteFormHandler},
    {"^/(%w*)$", GetPasteHandler},
    {"/favicon.ico$", turbo.web.StaticFileHandler, "favicon.ico"}
}):listen(conf.port, conf.address, conf.kwargs)
turbo.ioloop.instance():start()
