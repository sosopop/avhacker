local _M = {}
_M._VERSION = "1.0"

local function _find_parser( self, url)

    for i, v in pairs( self._parser_list) do
        local m = ngx.re.match( url, v)
        if m then
            return i
        end
    end

    return nil
end

local function _error( code )

end

local function _go( self )

    local args = ngx.req.get_uri_args()
    local url = args.url

    if not url then
        ngx.log( ngx.INFO, "url not exist")
        return _error( -1)
    end
    
    local parser_name = _find_parser( self, url)
    if not parser_name then
        ngx.log( ngx.INFO, "paser not exist")
        return _error( -1)
    end

    local parser = require( "avhacker/parsers/"..parser_name)
    if not parser then
        ngx.log( ngx.INFO, "can't load parser")
        return _error( -1)
    end

    return parser.parse( args.url );
end

local function _init( self )

    self._parser_list = { }
    --  获取解析模块列表，并进行注册
    local res = ngx.location.capture( "/modules/")
    local file_list = json_decode( res.body)
    for i, v in ipairs( file_list) do
        local m = ngx.re.match( v.name, [[(.*?)\.lua]])
        local parser = require( "avhacker/parsers/"..m[1])
        self._parser_list[m[1]] = parser._PATTERN
    end
end

function _M:go( )
    _init( self)
    _M.go = _go
    _M.go( self);
end

return _M