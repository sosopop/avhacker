local _M = {}
_M._VERSION = "1.0"

local function avhacker_go()
    ngx.log(ngx.NOTICE, "avhacker_go called")
    ngx.say("ok")
end

local function avhacker_init()
    ngx.log(ngx.NOTICE, "avhacker_init called")
    local res = ngx.location.capture("/modules/")
    ngx.log(ngx.INFO, "body:", res.body)
    local file_list = json_decode(res.body)
    ngx.log(ngx.INFO, "file_list_count:", #(file_list))
    for i, v in ipairs(file_list) do
        ngx.log(ngx.INFO, "index:", i, " value:", v.name)
        local m = ngx.re.match(v.name, [[(.*?)\.lua]])
        local parser = require("avhacker/parsers/"..m[1])
        ngx.log(ngx.INFO, "parser pattern:", parser._PATTERN)
    end
end

_M.go = function()
    avhacker_init()
    _M.go = avhacker_go
    _M.go();
end

return _M