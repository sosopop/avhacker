local _M = { }

_M.EC={}
_M.EM={}

_M.EC.OK = 0
_M.EM[_M.EC.OK] = [[Success]]

_M.EC.UNKNOWN = -1
_M.EM[_M.EC.UNKNOWN] = [[Unknown error]]

_M.EC.INVALID_PARAM = -2
_M.EM[_M.EC.INVALID_PARAM] = [[Parameter invalid]]

_M.EC.PROV_NOT_EXIST = -3
_M.EM[_M.EC.PROV_NOT_EXIST] = [[Provider not exist]]

_M.EC.PROV_LOAD_FAILED = -4
_M.EM[_M.EC.PROV_LOAD_FAILED] = [[Provider load failed]]

_M.EC.PARSE_FAILED = -5
_M.EM[_M.EC.PARSE_FAILED] = [[Parse failed]]

return _M