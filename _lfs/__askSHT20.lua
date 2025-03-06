do
    sht20 = require("sht20")
    local call = function()
        package.loaded["sht20"] = nil
        sht20 = nil
        print('\nSHT20 Done All Works Now!\nHeap: ', node.heap(),'\n')
        collectgarbage("collect")
    end
    sht20.read(call)
end
