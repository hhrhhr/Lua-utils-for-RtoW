assert(_VERSION == "Lua 5.3")
require("mod_binary_reader")

if not arg[1] or not arg[2] then
    print("\nusage:\n")
    print("\tlua 2-unpack.lua input_file output_dir\n")
    print("\tinput_file: ungzipped file from 1-ungzip.lua")
    print("\toutput_dir: existing directory for output files\n")
    os.exit(1)
end

local r = BinaryReader
r:open(arg[1])


local entries_num = r:uint32()
print(entries_num)

local pos = r:pos() + 64 + 192  -- 64 bytes header, 192 zero bytes
r:seek(pos)

-- ids
local entries = {}
for i = 1, entries_num do
    local t = {}
    t[1] = r:uint32()
    t[2] = r:uint32()
    t[3] = r:uint32()
    t[4] = r:uint32()
    table.insert(entries, t)
end


-- files
for i = 1, entries_num do
    io.write(string.format("%d/%d ", i, entries_num))
    local unit = r:uint64()
    local name = r:uint64()
    local lang_num = r:uint32()
    local zero = r:uint32() -- 64 bit ??

    local lang = {}
    for i = 1, lang_num do
        local t = {}
        t.lang = r:uint32()
        t.size = r:uint32()
        t.zero = r:uint32() -- 64 bit ??
        table.insert(lang, t)
    end

    for i = 1, lang_num do
        local path = string.format("(%016x)", unit)
        local path_ext = ""
        local name = string.format("(%016x)", name)
        local ext = ""

        if unit == 0x0D972BAB10B40FD3 then
            path_ext = "_localization_"
            ext = ".lang"
        elseif unit == 0x2A690FD348FE9AC5 then
            path_ext = "level"
            ext = ".lvl"
        elseif unit == 0x931E336D7646CC26 then
            path_ext = "animation"
            ext = ".anim"
        elseif unit == 0x99736BE1FFF739A4 then
            path_ext = "_packedOgg_"
            ext = ".oggpak"
        elseif unit == 0x9EFE0A916AAE7880 then
            path_ext = "font"
            ext = ".font"
        elseif unit == 0xA14E8DFA2CD117E2 then
            path_ext = "_script_"
            ext = ".luac"
            -- cut header
            r:read(8)
            lang[i].size = lang[i].size - 8
            -- take filename
            local pos = r:pos()
            r:read(5)
            local len = r:uint8() - 1
            r:read(1)
            name = string.gsub(r:str(len), "/", "\\")
            r:seek(pos)
        elseif unit == 0xAD9C6D9ED1E5E77A then
            path_ext = "package"
            ext = ".pack"
        elseif unit == 0xB277B11FE4A61D37 then
            path_ext = "_cursors_"
            ext = ".cur"
        elseif unit == 0xCD4238C6A0C69E32 then
            path_ext = "texture"
            ext = ".dds"
        elseif unit == 0xE0A48D0BE9A7453F then
            path_ext = "unit"
            ext = ".unit"
        elseif unit == 0xEAC0B497876ADEDF then
            path_ext = "material"
            ext = ".mat"
        else
            ext = ".unk"
        end

        local lng = ""
        if lang[i].lang > 0 then
            lng = string.format("(%d)", lang[i].lang)
        end

        path = string.format("%s\\%s%s\\", arg[2], path, path_ext)
        name = string.format("%s%s%s%s", path, name, lng, ext)

        local mkdir, _ = string.match(name, "(.+)\\(.+)")
        local cmd = string.format("mkdir %s > nul 2>&1", mkdir)
        os.execute(cmd)

        io.write(name)

        local w = assert(io.open(name, "w+b"))
        local data = r:str(lang[i].size)
        w:write(data)
        w:close()

--        io.write(name)
--        r:seek(r:pos() + lang[i].size)

        io.write("\n")
    end
end
io.write("\n")


r:close()
