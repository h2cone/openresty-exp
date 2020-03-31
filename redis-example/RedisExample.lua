# https://github.com/openresty/lua-resty-redis

local json = require "cjson"
local redis = require "resty.redis"
local red = redis.new()

red:set_timeouts(1000, 1000, 1000) -- 1 sec

-- or connect to a unix domain socket file listened
-- by a redis server:
-- local ok, err = red:connect("unix:/path/to/redis.sock")

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

local key = ngx.var[1]
local val = ngx.var[2]

local ok, err = red:set(key, val)
if not ok then
    ngx.say("failed to set: ", err)
    return
end

local val, err = red:get(key)
if not val then
    ngx.say("failed to get: ", err)
    return
end

if val == ngx.null then
    ngx.say("key no found")
    return
end

local ok, err = red:close()
if not ok then
    ngx.say("failed to close: ", err)
    return
end

ngx.say(json.encode({[key]=val}))
