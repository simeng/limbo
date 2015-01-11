local http = require "socket.http"
local ltn12 = require "ltn12"
local json = require "cjson"
require "hmac.sha2"

local function bintohex(s)
    return (s:gsub('(.)', function(c)
        return string.format('%02x', string.byte(c))
    end))
end 

if not http then
    print "Requires socket.http"
end
local limbo = {}

function limbo:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    if not o.servers then
        print "Missing servers"
        return nil
    end
    if not o.pubKey then
        print "Missing pubKey"
        return nil
    end
    if not o.privKey then
        print "Missing privkey"
        return nil
    end

    return o
end

function limbo:request(url, params, method)
    local resp = {}
    if (not method) then
        method = 'GET'
    end

    url = self.servers[0] .. url

    local timestamp = os.date("%Y-%m-%dT%H:%M:%SZ")
    local sigdata = method .. "|" .. url .. "|" .. self.pubKey .. "|" .. timestamp
    local signature = bintohex(hmac.sha256(sigdata, self.privKey))
    local accessToken = bintohex(hmac.sha256(url, self.privKey))
    url = url .. "?accessToken=" .. accessToken

    local r, code, headers = http.request{
        url = url,
        sink = ltn12.sink.table(resp),
        headers = {
            ['accept'] = 'application/json',
            ['x-imbo-authenticate-signature'] = signature,
            ['x-imbo-authenticate-timestamp'] = timestamp
        }
    }

    if (code ~= 200 or headers['x-imbo-error-message']) then
        return { error = { code = code, message = headers['x-imbo-error-message'] } }
    end

    return json.decode(resp[1])
end

function limbo:metadataUrl(identifier)
    return "NOT IMPLEMENTED"
end

function limbo:statusUrl()
    return "NOT IMPLEMENTED"
end

function limbo:userUrl()
    return "NOT IMPLEMENTED"
end

function limbo:imagesUrl()
    return self:request("/users/" .. self.pubKey .. "/images.json")
end

function limbo:imageUrl()
    return "NOT IMPLEMENTED"
end

function limbo:addImage()
    return "NOT IMPLEMENTED"
end

function limbo:addImageFromString()
    return "NOT IMPLEMENTED"
end

function limbo:addImageFromUrl()
    return "NOT IMPLEMENTED"
end

function limbo:imageExists()
    return "NOT IMPLEMENTED"
end

function limbo:imageIdentifierExists()
    return "NOT IMPLEMENTED"
end

function limbo:headImage()
    return "NOT IMPLEMENTED"
end

function limbo:deleteImage()
    return "NOT IMPLEMENTED"
end

function limbo:editMetadata()
    return "NOT IMPLEMENTED"
end

function limbo:replaceMetadata()
    return "NOT IMPLEMENTED"
end

function limbo:deleteMetadata()
    return "NOT IMPLEMENTED"
end

function limbo:numImages()
    return "NOT IMPLEMENTED"
end

function limbo:images()
    return "NOT IMPLEMENTED"
end

function limbo:imageData()
    return "NOT IMPLEMENTED"
end

function limbo:imageDataFromUrl()
    return "NOT IMPLEMENTED"
end

function limbo:imageProperties()
    return "NOT IMPLEMENTED"
end

function limbo:imageIdentifier()
    return "NOT IMPLEMENTED"
end

function limbo:imageIdentifierFromString()
    return "NOT IMPLEMENTED"
end

function limbo:serverStatus()
    return "NOT IMPLEMENTED"
end

function limbo:userInfo()
    return "NOT IMPLEMENTED"
end

return limbo
