ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

ESX.RegisterServerCallback('r:info', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local info = {
        money = xPlayer.getMoney(),
        bankmoney = xPlayer.getAccount('bank').money,
        blackmoney = xPlayer.getAccount('black_money').money
    }
    cb(info)
end)

ESX.RegisterServerCallback('r:getCars', function(source, cb)
	local source_ = source
	local xPlayer = ESX.GetPlayerFromId(source_)
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local cars = {}
			for i=1, #result, 1 do
				table.insert(cars, {
					props        = json.decode(result[i].vehicle),
					plate        = result[i].plate,
					stored       = result[i].stored,
					garage       = result[i].garage,
					vehiclemodel = result[i].vehiclemodel
				})
			end

			cb(cars)
		end)
	end
end)

ESX.RegisterServerCallback('r:getBills', function(source, cb)
	local source_ = source
	local xPlayer = ESX.GetPlayerFromId(source_)
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result2)
			local bills = {}
			if result2 ~= nil then
				for i=1, #result2, 1 do
					table.insert(bills, {
						label        = result2[i].label,
						amount        = result2[i].amount,
						id = result2[i].id
					})
				end
			else
				TriggerClientEvent('esx:showNotification', source, '~y~No ~b~tienes multas para pagar~s~!')
			end
			cb(bills)
		end)
	end
end)


ESX.RegisterServerCallback("r:payBills", function(source, cb, id, amount)
	local source_ = source
	local xPlayer = ESX.GetPlayerFromId(source_)
	
	if xPlayer ~= nil then
		if xPlayer.getAccount('bank').money >= amount then
			xPlayer.removeAccountMoney('bank', amount)
			MySQL.Async.execute('DELETE FROM billing WHERE id = @id AND amount = @amount', {['@id'] = id, ['amount'] = amount})
			TriggerClientEvent('esx:showNotification', source, '~y~Se ha pagado correctamente~s~!')
			cb(true)
		else 
			TriggerClientEvent('esx:showNotification', source, '~y~No ~b~tienes el dinero bancario suficiente para pagarla~s~!')
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback("r:getPerms", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'mod' then
        cb(true)
    else
        cb(false)
    end
end)