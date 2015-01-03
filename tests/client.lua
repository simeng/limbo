package.path = "../src/?.lua;" .. package.path

local limbo = require 'limbo'

local client = limbo:new { servers = {[0] = "http://localhost"}, privKey = "private", pubKey = "public"}

client:request("/test")

print(client:statusUrl())
