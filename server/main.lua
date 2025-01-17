local discordwebhook = 'INSERT_WEBHOOK_HERE'

if Config.UseOldESX then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

RegisterServerEvent('mb_begging:begsomemoney')
AddEventHandler('mb_begging:begsomemoney', function(targetPed)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local pPed = GetPlayerPed(source)
    local money = math.random(Config.MinMoney, Config.MaxMoney)
    local playerPos = GetEntityCoords(pPed, true)
    local targetPedPos = GetEntityCoords(targetPed, true)
    local distance = #(playerPos - targetPedPos)

    if distance >= Config.MaxDistance + 4 then
        xPlayer.addMoney(money)
        TriggerClientEvent('esx:showNotification', source, 'The person was nice and gave you '..money..'$')
        if Config.DiscordLog then
            sendToDiscordLogsEmbed(3158326, '`🙏` | Beg',' Player: `' ..GetPlayerName(source).. '` - `'..GetPlayerIdentifier(source, 0)..'` asked for some money and got `'..money..'$`')
        end
    else
        print('Player: '..GetPlayerName(source)..' (ID: '..source..') - '..GetPlayerIdentifier(source, 0)..' tried to beg for money from too far distance. Distance: '..math.floor(distance))
    end
end)

function sendToDiscordLogsEmbed(color, name, message, footer)
    local footer = 'Made By c0deina and MasiBall - '..os.date("%d/%m/%Y - %X")
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**"..name.."**",
              ["description"] = message,
              ["footer"] = {
              ["text"] = footer,
              },
          }
      }
  
    PerformHttpRequest(discordwebhook, function(err, text, headers) end, 'POST', json.encode({username = 'Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })
end
