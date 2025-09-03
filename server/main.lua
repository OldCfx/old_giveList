local ox_inventory = exports.ox_inventory
local ActiveStashes = {}

RegisterCommand('givelist', function(source, args)
    local staff = source


    if not IsPlayerAceAllowed(staff, "givelist.use") then
        return lib.notify(staff,
            { description = 'Tu n’as pas la permission d’utiliser cette commande', type = 'error' })
    end

    if not args[1] then
        return lib.notify(staff, { description = 'Usage: /givelist [weapon|motclé]', type = 'error' })
    end

    local filter = string.lower(args[1])
    local allItems = ox_inventory:Items()
    local stashItems = {}


    if filter == 'weapon' then
        for name, data in pairs(allItems) do
            if name:lower():find('weapon_', 1, true) then
                table.insert(stashItems, { name, Config.ItemCount })
            end
        end
    else
        for name, data in pairs(allItems) do
            if string.find(name:lower(), filter, 1, true)
                or (data.label and string.find(data.label:lower(), filter, 1, true)) then
                table.insert(stashItems, { name, Config.ItemCount })
            end
        end
    end

    if #stashItems == 0 then
        return lib.notify(staff, { description = 'Aucun item trouvé pour ce filtre', type = 'error' })
    end


    local mystash = ox_inventory:CreateTemporaryStash({
        label = Config.StashLabel,
        slots = #stashItems,
        maxWeight = 5000000,
        items = stashItems
    })

    if Config.AutoFill then
        ActiveStashes[mystash] = {}
        for _, v in ipairs(stashItems) do
            ActiveStashes[mystash][v[1]] = Config.ItemCount
        end
    end

    TriggerClientEvent('ox_inventory:openInventory', staff, 'stash', mystash)
end, false)

exports.ox_inventory:registerHook('swapItems', function(payload)
    local inv = payload.fromInventory
    local slot = payload.fromSlot
    if not inv or not slot or not slot.name then return end
    if ActiveStashes[inv] then
        local itemName = slot.name
        local desiredCount = ActiveStashes[inv][itemName]
        if desiredCount then
            SetTimeout(50, function()
                local currentCount = payload.count - desiredCount
                if currentCount < desiredCount then
                    local toAdd = desiredCount - currentCount
                    exports.ox_inventory:AddItem(inv, itemName, toAdd, nil, slot.slot)
                    logs('LE STAFF ' .. GetPlayerName(payload.source) .. ' s\'est give x' .. payload.count ..
                        ' ' .. itemName)
                end
            end)
        end
    end
    return true
end)


function logs(message)
    if Config.printLog then
        local time = os.date('%d-%m %H:%M:%S')
        print(('[%s] %s'):format(time, message))
    end
end
