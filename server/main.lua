local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('mgnMushroom:server:pickMushroom', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, 1)
end)

CreateThread(function()
    for k,v in pairs(Config.MushroomTypes) do
        QBCore.Functions.CreateUseableItem(k, function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
            local mushroom = Config.MushroomTypes[item.name]
            if mushroom.effect == 'health' then
               -- effect
            elseif mushroom.effect == 'stamina' then
                -- effect
            end
            TriggerClientEvent('QBCore:Notify', source, 'You ate a ' .. mushroom.label .. ' and feel better', 'success')
        end)
    end
end)

