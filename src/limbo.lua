local urllib = require "socket.url"
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
    if not method then
        method = 'GET'
    end
    if not params then
        params = {}
    end

    url = self.servers[0] .. url

    local parsed_url = urllib.parse(url)

    local source = nil
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    local headers = {}


    -- GET requests need access token
    if method == 'GET' then
        for k, v in pairs(params) do
            if parsed_url['query'] then
                parsed_url['query'] = parsed_url['query'] .. "&"
            else
                parsed_url['query'] = ""
            end
            parsed_url['query'] = parsed_url['query'] .. urllib.escape(k) .. "=" .. urllib.escape(v)
        end

        url = urllib.build(parsed_url)
        local accessToken = bintohex(hmac.sha256(url, self.privKey))
        if parsed_url['query'] then
            parsed_url['query'] = parsed_url['query'] .. "&"
        else
            parsed_url['query'] = ""
        end
        parsed_url['query'] = parsed_url['query'] .. "accessToken=" .. accessToken
        url = urllib.build(parsed_url)
    elseif method == 'PUT' or method == 'POST' then
        local body = json.encode(params)
        source = ltn12.source.string(body)
        headers['content-type'] = 'application/json'
        headers['content-length'] = #body
    elseif method == 'FILE' then
        method = 'POST'
        local file = io.open(params, "r")
        local size = file:seek('end')
        file:seek('set')
        source = ltn12.source.file(file)
        headers['content-type'] = 'multipart/form-data'
        headers['content-length'] = size
    end

    if not method == 'GET' then
        local sigdata = method .. "|" .. url .. "|" .. self.pubKey .. "|" .. timestamp
        local signature = bintohex(hmac.sha256(sigdata, self.privKey))

        headers['accept'] = 'application/json'
        headers['x-imbo-authenticate-signature'] = signature
        headers['x-imbo-authenticate-timestamp'] = timestamp
    end

    local r, code, headers = http.request{
        url = url,
        method = method,
        source = source,
        sink = ltn12.sink.table(resp),
        headers = headers
    }

    if (code < 200 or code >= 300 or headers['x-imbo-error-message']) then
        return { request = { url = url, method = method }, error = { code = code, message = headers['x-imbo-error-message'] } }
    end

    return json.decode(resp[1])
end

function limbo:metadataUrl(identifier)
    return "NOT IMPLEMENTED"
end

function limbo:stats()
    return self:request("/stats")
end

function limbo:status()
    return self:request("/status")
end

function limbo:user()
    return self:request("/users/" .. self.pubKey .. ".json")
end

function limbo:images(params)
    
    return self:request("/users/" .. self.pubKey .. "/images.json", params)
end

function limbo:imageUrl()
    return "NOT IMPLEMENTED"
end

function limbo:addImage(file)
    return self:request("/users/" .. self.pubKey .. "/images", file, "FILE")
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

function limbo:deleteImage(image)
    return self:request("/users/" .. self.pubKey .. "/images/" .. image, {}, "DELETE")
end

function limbo:editMetadata(image, metadata)
    return self:request("/users/" .. self.pubKey .. "/images/" .. image .. "/metadata.json", metadata, "POST")
end

function limbo:replaceMetadata(image, metadata)
    return self:request("/users/" .. self.pubKey .. "/images/" .. image .. "/metadata.json", metadata, "PUT")
end

function limbo:deleteMetadata(image)
    return self:request("/users/" .. self.pubKey .. "/images/" .. image .. "/metadata.json", {}, "DELETE")
end

function limbo:fetchMetadata(image)
    return self:request("/users/" .. self.pubKey .. "/images/" .. image .. "/metadata.json", {})
end

function limbo:numImages()
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
