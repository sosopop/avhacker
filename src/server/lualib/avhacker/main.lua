local _M = {}
_M._VERSION = "1.0"

local function _find_provider( self, url)
    for i, v in pairs( self._provider_list) do
        local m = ngx.re.match( url, v)
        if m then
            return i
        end
    end
    return nil
end

local function _go( self )
    local args = ngx.req.get_uri_args()
    --  通过url的方式解析
    local url = args.url
    if url then
        local prov = _find_provider( self, url)
        if not prov then
            return output_json_result( EC.PROV_NOT_EXIST)
        end
        local provider = require( "avhacker/providers/"..prov)
        if not provider then
            return output_json_result( EC.PROV_LOAD_FAILED)
        end
        return provider.parse( url );
    end

    -- 通过站名和id方式解析
    local prov = args.prov
    if self._provider_list[prov] then
        local id = args.id
        if id then
            local provider = require( "avhacker/providers/"..prov)
            if not provider then
                return output_json_result( EC.PROV_LOAD_FAILED)
            end
            return provider.parse_id( id );
        end
    end
    return output_json_result( EC.INVALID_PARAM)
end

local function _init( self )
    --  获取解析模块列表，并进行注册
    local res = ngx.location.capture( "/modules/")
    local file_list = cjson.decode( res.body)
    self._provider_list = { }
    for i, v in ipairs( file_list) do
        local m = ngx.re.match( v.name, [[(.*?)\.lua]])
        if #(m) == 1 then
            local module_name = m[1]
            local provider = require( "avhacker/providers/"..module_name)
            self._provider_list[module_name] = provider._PATTERN
        end
    end
end

function _M:go( )
    ngx.log( ngx.INFO, "avhacker init")
    _init( self)
    _M.go = _go
    _M.go( self);
end

return _M