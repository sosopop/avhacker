local _M = {}
_M._VERSION = "1.0"
_M._PATTERN = [[^https?://[a-zA-Z\.\-_0-9]{0,10}\.163\.com]]

_M.parse = function( url, opt )
    ngx.log( ngx.INFO, "do parse : "..url)
end

return _M