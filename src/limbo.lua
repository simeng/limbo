local http = require "socket.http"
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

function limbo:request(url)
    local r, c, h, s = http.request{
        url = self.servers[0] .. url
    }
    return r
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
    return "NOT IMPLEMENTED"
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
