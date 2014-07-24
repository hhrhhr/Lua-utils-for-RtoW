assert(_VERSION == "Lua 5.3")
local zlib = require("zlib")

if not arg[1] or not arg[2] then
    print("\nusage:\n")
    print("\tlua 1-ungzip.lua input_file output_dir\n")
    print("\tinput_file: gzipped file from 'bundle' directory")
    print("\toutput_file: name for output file\n")
    os.exit(1)
end


local r = assert(io.open(arg[1], "rb"))
local filesize = r:seek("end")
r:seek("set")

assert("\x04\x00\x00\xf0" == r:read(4))

local size = string.undumpint(r:read(4), 1, 4)
local tmp = string.undumpint(r:read(4), 1, 4)   -- \x00\x00\x00\x00

local w = assert(io.open(arg[2], "w+b"))

local wsize = 0
while r:seek() < filesize do
    local zsize = string.undumpint(r:read(4), 1, 4)
    local data = r:read(zsize)
    local buf = ""
    if zsize < 0x10000 then
        local stream = zlib.inflate()
        local eof, bin, bout
        buf, eof, bin, bout = stream(data)
        wsize = wsize + bout
    else
        buf = data
        wsize = wsize + zsize
    end
    if wsize > size then
        buf = string.sub(buf, 1, 0x10000 - wsize + size)
    end
    w:write(buf)
end

w:close()

r:close()
