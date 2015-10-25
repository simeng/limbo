package.path = "../src/?.lua;" .. package.path
require "io"

function dump(tbl, indent) 
    if (not indent) then
        indent = 0
    end
    for k, v in pairs(tbl) do
        io.write(string.rep("  ", indent) .. k .. ": ")
        if (type(v) == 'table') then
            io.write("\n")
            dump(v, indent + 1)
        else
            io.write(tostring(v) .. "\n")
        end
    end
end

local limbo = require 'limbo'

local client = limbo:new { servers = {[0] = "http://localhost"}, privKey = "privkey", pubKey = "testuser"}

dump(client:request("/status"))
dump(client:imagesUrl())
print(client:statusUrl())
