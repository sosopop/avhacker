--  加载第三方库
cjson = require("cjson.safe")
http = require("resty.http")
--  加载主程序
avhacker = require("avhacker.main")
ffi = require("ffi")

--  加载错误码
local errors = require("avhacker.errors")
--  错误码
EC = errors.EC
--  错误消息
EM = errors.EM

function build_result( error_code, data)
    local json_obj = {
        message = [[]],
        data = {},
        code = 0
    }
    json_obj.code = error_code
    json_obj.message = EM[error_code]
    if data then
        json_obj.data = data
    end
    return json_obj
end

function build_json_result( error_code, data)
    local json_obj = build_result( error_code, data)
    return cjson.encode( json_obj)
end

function output_json_result( error_code, data)
    ngx.say(build_json_result( error_code, data))
end

function output_result( result )
    ngx.say( cjson.encode( result))
end

function web_fetch( url, params)
    local request = http.new()
    if not request then
        return ""
    end
    local res, err = request:request_uri(
        url, params
    )
    if err then
        return ""
    end
    if not res then
        return ""
    end
    if not res.body then
        return ""
    end
    return res.body
end

local function gz_reader(s)
    local done
    return function()
        if done then return end
        done = true
        return s
    end
end

local function gz_writer()
    local t = {}
    return function(data, sz)
        if not data then return table.concat(t) end
        t[#t+1] = ffi.string(data, sz)
    end
end

function gz_decompress( content)
    local zlib = require "zlib"
	local write = gz_writer()
	zlib.inflate(gz_reader(content), write, nil, "gzip")
    return write()
end