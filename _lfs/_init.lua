local a = node.LFS and node.LFS.get or node.flashindex
local t = _ENV or getfenv()
local e
if _VERSION == 'Lua 5.1' then
    e = {
        __index = function(t, e)
            local a, t, o, n, i = a(e)
            if not t then
                return a
            elseif e == '_time' then
                return a
            elseif e == '_config' then
                local e, a = file.fscfg()
                return {
                    lfs_base = t,
                    lfs_mapped = o,
                    lfs_size = n,
                    fs_mapped = e,
                    fs_size = a
                }
            elseif e == '_list' then
                return i
            else
                return nil
            end
        end,
        __newindex = function(t, e, t)
            error("LFS is readonly. Invalid write to LFS." .. e, 2)
        end,
    }
    setmetatable(e, e)
    t.module = nil
    package.seeall = nil
else
    e = node.LFS
end
t.LFS = e
package.loaders[3] = function(t)
    return e[t]
end
local o = loadfile
t.loadfile = function(e)
    if file.exists(e) then return o(e) end
    local o = e:match("(.*)%.l[uc]a?$")
    local a = o and a(o)
    return (a or error(("Cannot find '%s' in FS or LFS"):format(e))) and a
end
t.dofile = function(e) return assert(loadfile(e))() end
