local _M = {}
_M._VERSION = "1.0"

function _M:new ( )
    local context = {
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
    local content = web_fetch( url )
    if #content == 0 then
        return build_result( EC.PARSE_FAILED)
    end
    --bilibili不管3721都给你压缩的数据，这里需要用gz解压
    content = gz_decompress(content);

    local m = ngx.re.match( content, [[h1 title="(.+?)"]], "o")
    if not m then
        return build_result( EC.PARSE_FAILED)
    end

    m = ngx.re.match( content, [[cid=(\d+)]], "o")
    if not m then
        return build_result( EC.PARSE_FAILED)
    end

    return self:parse_id( m[1], opt);
end

function _M:parse_id ( id, opt )
    --匹配Json数据
    local jsonUrl = "http://interface.bilibili.com/playurl?platform=bilihelper&appkey=95acd7f6cc3392f3&cid=" .. id .. "&otype=json&type=mp4";
    content = web_fetch( jsonUrl )
    if #content == 0 then
        return build_result( EC.PARSE_FAILED)
    end
    local json_root = cjson.decode(content);
    if not json_root then
        return build_result( EC.PARSE_FAILED)
    end
    self.result.timelength = json_root.timelength
    self.result.streams = {{
        quality = "HD",
        type = "MP4",
        segs = {{
            url = json_root.durl[1].url,
            timeLength = json_root.durl[1].length,
            fileSize = 0
        }}
    }}

    return build_result( EC.OK, self.result )
end

return _M