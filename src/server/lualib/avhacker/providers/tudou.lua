local _M = {}
_M._VERSION = "1.0"
_M._PATTERN = [[^https?://[a-zA-Z\.\-_0-9]{0,10}\.tudou\.com]]

_M.parse = function( url, opt )
    ngx.log( ngx.INFO, "do parse : "..url)
    output_json_result( EC.OK, url)
end

_M.parse_id = function( id, opt )
    ngx.log( ngx.INFO, "do parse : "..id)
    output_json_result( EC.OK, id)
end


return _M