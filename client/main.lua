local ped = cache.ped
local currentBag = 0

local bagsInfo = Config.bagsInfo
local refreshRate = Config.refreshRate

local function getBagCapacity(bag)
    for _, v in pairs(bagsInfo) do 
        if v.bagNum==bag and v.model == GetEntityModel(PlayerPedId()) then return v.capacity end
    end 
    return 0
    
end

lib.onCache("ped", function (value)
    ped = value
end)

CreateThread(function ()
    while true do 
        Wait(refreshRate)
        local bag = GetPedDrawableVariation(ped, 5)
        if (currentBag ~= bag) and ESX.IsPlayerLoaded() then
            --print(currentBag, bag, "=========== here")
            currentBag = bag
            local bagCapacity = getBagCapacity(currentBag)
            TriggerServerEvent('bengbeng:extendsCarryCapacity', bagCapacity)
        end
    end
end)