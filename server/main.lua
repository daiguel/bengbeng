local ox_inventory = exports.ox_inventory

local function getSlots(itemsList)
    local fullSlots = {}
    for k, v in pairs(itemsList) do
        table.insert(fullSlots, k)
    end
    return fullSlots
end
-- drop all in one place random items and random amounts of each item :)
local function selectRandomItemsToRemove(weightToRemove, inventory) 
    local itemsToRmove = {}
    local weightremoved = weightToRemove
    while ( weightToRemove > 0 ) do
        local slots = getSlots(inventory.items)
        local randomSlot = slots[math.random(1, #slots)]
        local itemInfos = inventory.items[randomSlot]
        if itemInfos~=nil then
            if itemInfos.weight > 0 then --slot not empty and sum of items has weight 
                local itemWeight = itemInfos.weight / itemInfos.count
                
                weightToRemove = weightToRemove -  itemWeight
                inventory.items[randomSlot].count = inventory.items[randomSlot].count - 1 --update number amount of items in inventory
                inventory.items[randomSlot].weight = inventory.items[randomSlot].weight - itemWeight --update weight of items inventory
                
                local found = false
                for _, v in pairs(itemsToRmove) do
                    if (itemInfos.name == v[1]) and (itemInfos.metadata == v[3]) then 
                        v[2] = v[2] + 1
                        found = true
                        break
                    end
                end

                if not found then
                    table.insert(itemsToRmove, {itemInfos.name, 1, itemInfos.metadata})
                end
            end
        end
    end
    -- print(json.encode(itemsToRmove, {indent = true}))
    weightremoved = (math.abs(weightToRemove) + weightremoved)
    return itemsToRmove ,weightremoved
end

RegisterNetEvent("bengbeng:extendsCarryCapacity")
AddEventHandler("bengbeng:extendsCarryCapacity", function(weightToAdd)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local newWeight = ESX.GetConfig().MaxWeight + weightToAdd
    xPlayer.setMaxWeight(newWeight)

    local inventory = ox_inventory:Inventory(_source, true)
    local weightToRemove = inventory.weight - inventory.maxWeight
    if weightToRemove > 0 then
        local itemsToRmove, droppedWeight = selectRandomItemsToRemove(weightToRemove, inventory)
        local countSlot = 0
        for _, v in pairs(itemsToRmove) do 
            ox_inventory:RemoveItem(_source, v[1], v[2])
            countSlot = countSlot + 1
        end 
        ox_inventory:CustomDrop('dropped_items', itemsToRmove, xPlayer.getCoords(true), countSlot+2, droppedWeight+5000)-- +5KG and 2 free slots to give possibility to switch items    
    
    end
end)

lib.versionCheck('daiguel/bengbeng')
--drop one by one Wait is fucking server perfs 
-- RegisterNetEvent("bengbeng:extendsCarryCapacity")
-- AddEventHandler("bengbeng:extendsCarryCapacity", function (weightToAdd)
--     local _source = source
--     local xPlayer = ESX.GetPlayerFromId(_source)
--     xPlayer.setMaxWeight(ESX.GetConfig().MaxWeight + weightToAdd)

--     local inventory = ox_inventory:Inventory(_source, true)

--     while inventory.weight > inventory.maxWeight do -- simulate items dropping one by one 
--         local ped = GetPlayerPed(_source)
--         local playerCoords = GetEntityCoords(ped)
--         local slots = getSlots(inventory.items)
--         local randomSlot = slots[math.random(1, #slots)]
--         local itemInfos = inventory.items[randomSlot]
--         if itemInfos~=nil then
--             if itemInfos.weight > 0 then --slot not empty and sum of items has weight 
--                 local amountToDrop =  math.random(itemInfos.count) --drop random amount of selected item
--                 --print(amountToDrop)
--                 ox_inventory:RemoveItem(_source, itemInfos.name, amountToDrop)
--                 ox_inventory:CustomDrop('dropped_items', {
--                     {itemInfos.name, amountToDrop, itemInfos.metadata},
--                 }, playerCoords)  --xPlayer.getCoords(true) not updating 
     
--                 Wait(4000) --wait 4 sec after next drop
--             end
--         end
--         inventory = ox_inventory:Inventory(_source, true)
--     end

    
-- end)