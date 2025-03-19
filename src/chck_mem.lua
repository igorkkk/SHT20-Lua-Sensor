do
    wth = wth or {}
    -- print("\n\n\n\n\n\n\n\n\n\n\n\n\n=========== _G table: ===========")
    local c1, c2, c3 = 0, 0, 0
    for k, v in pairs(_G) do --[[print(k, ':', v);]] c1 = c1 + 1  end
    -- print("\n===== package.loaded table: =====")
    for k, v in pairs(_G.package.loaded) do --[[print(k, ':', v);]] c2 = c2 + 1 end
    -- print("\n===== Registry table: =====")
    for _ in ipairs(debug.getregistry()) do c3 = c3 + 1 end
    -- for k, v in pairs(debug.getregistry()) do print(k, ':', v)  end
    -- print("=================================")
    print('_G = ' .. c1.. ', Loaded = ' .. c2..', Reg: ' .. c3, 'Heap: ' .. node.heap())
    -- print("=================================")
    wth._G = c1; wth.Loaded = c2; wth.Reg = c3; wth.Heap = node.heap()
end
