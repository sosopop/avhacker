local _M = {}
_M._VERSION = "1.0"

function _M:new ( )
    local context = {
        id = "",
        result = {}
    }
    return setmetatable( context, { __index = _M } )
end

function _M:handle ( url)
    local m = ngx.re.match( url, [[^https?://[a-zA-Z\.\-_0-9]{0,10}\.bilibili\.com]], "o")
    if m then
        return true
    end
    return false
end

function _M:parse ( url, opt )
    local content = web_fetch( url, { 
        headers = {
            ["Accept-Encoding"] = "gzip"
        }
    })
    if #content == 0 then
        return build_result( EC.PARSE_FAILED)
    end
    --self.result
    --local m = ngx.re.match( content, [[h1\s+?title="(.+?)"]], "o")
    local ffi = require("ffi")
ffi.cdef[[
unsigned long compressBound(unsigned long sourceLen);
int compress2(uint8_t *dest, unsigned long *destLen,
	      const uint8_t *source, unsigned long sourceLen, int level);
int uncompress(uint8_t *dest, unsigned long *destLen,
	       const uint8_t *source, unsigned long sourceLen);
]]
local zlib = ffi.load(ffi.os == "Windows" and "zlib1" or "z")

local function reader(s)
    local done
    return function()
        if done then return end
        done = true
        return s
    end
end

local function writer()
    local t = {}
    return function(data, sz)
        if not data then return table.concat(t) end
        t[#t + 1] = ffi.string(data, sz)
    end
end

if content then
    local write = writer()
    zlib.inflate(reader(body), write, nil, "gzip")
    content = write()
end

-- Simple test code.
        ngx.say(content)
    local m = ngx.re.match( content, [[\d+]], "o")
    if not m then
        return build_result( EC.PARSE_FAILED)
    end
    self.result.title = m[1]
    return build_result( EC.OK, self.result )
end

function _M:parse_id ( id, opt )
    output_json_result( EC.OK)
end

return _M