assert(_VERSION == "Lua 5.3")

BinaryReader = {
    f_handle = nil,
    f_size = 0
}

function BinaryReader:open(fullpath)
    self.f_handle = assert(io.open(fullpath, "rb"))
    self.f_size = self.f_handle:seek("end")
    self.f_handle:seek("set")
end

function BinaryReader:close()
    self.f_handle:close()
    self.f_handle = nil
    self.f_size = 0

end

function BinaryReader:pos()
   return self.f_handle:seek()
end

function BinaryReader:size()
    return self.f_size
end

function BinaryReader:seek(pos)
    return self.f_handle:seek("set", pos)
end

function BinaryReader:read(size)
    return self.f_handle:read(size)
end


--[[ integer ]]----------------------------------------------------------------

function BinaryReader:uint8()  -- unsigned byte
    local i8 = string.undumpint(self.f_handle:read(1), 1, 1)
    return i8
end

function BinaryReader:sint8()  -- signed byte
    local i8 = self:uint8()
    if i8 > 127 then
        i8 = i8 - 256
    end
    return i8
end

function BinaryReader:uint16(endianness)  -- unsigned short
    local i16 = string.undumpint(self.f_handle:read(2), 1, 2, endianness or "n")
    return i16
end

function BinaryReader:sint16(endianness)  -- signed short
    local i16 = 0
    i16 = self:uint16(endianness)
    if i16 > 32767 then
        i16 = i16 - 65536
    end
    return i16
end

function BinaryReader:uint32(endianness)  -- unsigned integer
    local i32 = string.undumpint(self.f_handle:read(4), 1, 4, endianness or "n")
    return i32
end

function BinaryReader:sint32(endianness)  -- signed integer
    local i32 = 0
    i32 = self:uint32(endianness)
    if i32 > 2147483647 then
        i32 = i32 - 4294967296
    end
    return i32
end

function BinaryReader:uint64(endianness)  -- unsigned integer
    local i64 = string.undumpint(self.f_handle:read(8), 1, 8, endianness or "n")
    return i64
end

--[[ float ]]------------------------------------------------------------------

function BinaryReader:float(endianness)  -- float
    local f = string.undumpfloat(self.f_handle:read(4), 1, "f", endianness or "n")
    return f
end

function BinaryReader:double(endianness)  -- float
    local d = string.undumpfloat(self.f_handle:read(8), 1, "d", endianness or "n")
    return d
end


--[[ string ]]------------------------------------------------------------------

function BinaryReader:hex32()  -- hex
    local h32 = string.format("%08X", self:uint32())
    return h32
end

function BinaryReader:str(len) -- string
    local str = nil
    if len ~= nil then
        str = self.f_handle:read(len)
    else
        local chars = {}
        local char = ""
        local zero = string.char(0x00)
        while char ~= zero do
            char = self.f_handle:read(1)
            table.insert(chars, char)
        end
        table.remove(chars)
        str = table.concat(chars)
    end
    return str
end

function BinaryReader:idstring(str)
    local len = string.len(str)
    local tmp = self:str(len)
    assert(str == tmp, "ERROR: " .. tmp .. " != " .. str)
end
