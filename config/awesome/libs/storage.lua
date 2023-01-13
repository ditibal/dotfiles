local tableIO = require 'libs.tableIO'

local Storage = {}
setmetatable(Storage, Storage)
Storage.__index = Storage

function Storage:__call(path)
    local obj = {}
    obj.path = path
    setmetatable(obj, Storage)

    local file = io.open(path, 'r')

    if (file == nil) then
        tableIO.save({}, path)
    end

    return obj
end

function Storage:get(key, default)
    local data = require('storage_data')
    return data[key:gsub("%s+", "_")] or default or nil
end

function Storage:set(key, value)
    local data = require('storage_data')
    data[key:gsub("%s+", "_")] = value
    tableIO.save(data, self.path)
end

return Storage