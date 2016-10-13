avhacker = require("avhacker/avhacker")
cjson = require("cjson")

function json_decode( str )
    local json_value = nil
    pcall(function (str) json_value = cjson.decode(str) end, str)
    return json_value
end