do
    wth = wth or {}
    local c1, c2, c3 = 0, 0, 0
    for k, v in pairs(_G) do c1 = c1 + 1  end
    for k, v in pairs(_G.package.loaded) do c2 = c2 + 1 end
    for _ in ipairs(debug.getregistry()) do c3 = c3 + 1 end
    print('_G = ' .. c1.. ', Loaded = ' .. c2..', Reg: ' .. c3, 'Heap: ' .. node.heap())
    wth._G = c1; wth._Loaded = c2; wth._Reg = c3; wth._Heap = node.heap()
end
