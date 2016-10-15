--  加载第三方库
cjson = require("cjson.safe")
--  加载主程序
avhacker = require("avhacker/main")
--  加载错误码
local errors = require("avhacker/errors")
--  错误码
EC = errors.EC
--  错误消息
EM = errors.EM

function build_json_result( error_code, data)
    local json_obj = {
        code = 0,
        message = [[]],
        data = {}
    }
    json_obj.code = error_code
    json_obj.message = EM[error_code]
    if data then
        json_obj.data = data
    end
    return cjson.encode( json_obj)
end

function output_json_result( error_code, data)
    ngx.say(build_json_result( error_code, data))
end