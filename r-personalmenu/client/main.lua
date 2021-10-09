ESX = nil 
Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(0) 
    end 
end)

RegisterKeyMapping('rmenu', 'Root Personal Menu', 'keyboard', 'F10')

RegisterCommand('rmenu', function()
    PrincipalMenuR()
end)





-- funciones

function AFKCamera()
	_afkactivedesactive = not _afkactivedesactive
	if _afkactivedesactive then
	ESX.ShowNotification("Has desactivado el movimiento de la cámara")
	elseif not _afkactivedesactive then
	ESX.ShowNotification("Has activado el movimiento de la cámara")
	end
	while (_afkactivedesactive) do
		N_0xf4f2c0d4ee209e20()
		Citizen.Wait(10000)
   end
end

function PrincipalMenuR()
	ESX.UI.Menu.CloseAll()	
	ESX.UI.Menu.Open('default',GetCurrentResourceName(),"PrincipalMenuR",
	{ 
		title    = 'Personal Menú <span>[' .. GetPlayerServerId(PlayerId()) .. "]</span>",
		subtitle = GetPlayerName(PlayerId()),
		align    = 'bottom-right',
		elements = {
            -- {label = "Menu De Administracion", value = 'adm'},
			{label = "Información Personal", value = 'infopersonal'},
            {label = "Ver tus coches", value = 'coches'},
            {label = "Ver tus multas", value = 'multas'},
			{label = "Apartado Estético", value = 'hud'},
            {label = "Activar/Desactivar cámara AFK", value = 'afkactivedesactive'},
            {label = "Rockstar Editor", value = 'editor'},
            {label = "Menu de entornos", value = 'entornos'},
            {label = "Utilidades", value = 'utilidades'}
        }
	}, function(data, menu)
		if data.current.value == 'infopersonal' then
			PrincipalMenu()
        -- elseif data.current.value == 'adm' then
        --     AdmMenu()
        elseif data.current.value == 'coches' then
            ViewVehicles()
        elseif data.current.value == 'multas' then
            ViewMultas()
        elseif data.current.value == 'documentation' then
            SecondaryMenu()
		elseif data.current.value == 'hud' then
			OpenHudMenu()
		elseif data.current.value == 'editor' then
			RockstarEditor()
		elseif data.current.value == "afkactivedesactive" then
			AFKCamera()
		elseif data.current.value == "utilidades" then
			OpenUtilidades()
		elseif data.current.value == "entornos" then
            MenuEntornos()
			menu.close()
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function PrincipalMenu()
        ESX.TriggerServerCallback('r:info', function(info)
            local name = GetPlayerName(PlayerId())
            local Data = ESX.GetPlayerData()
            local job = Data.job.label
            local jobgrade = Data.job.grade_label
            local money = info.money
            local bank = info.bankmoney
            local blackmoney = info.blackmoney
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'information', {
                title = 'Informacion de '..name.. '',
                align = 'bottom-right',
                elements = {
                    {label = 'Trabajo: '..job.. ' - ' ..jobgrade..'</span>', value = nil},
                    {label = 'Dinero: <span>'..money..'$</span>', value = nil},
                    {label = 'Banco: <span>'..bank..'$</span>', value = nil},
                    {label = 'Dinero negro: <span>'..blackmoney..'$</span>', value = nil},
                    {label = '<span style = color:red; span>Cerrar</span>', value = 'cerrar'}
                }}, function(data, menu) 
                    if data.current.value == 'cerrar' then
                        PrincipalMenuR()
                    end
                end, function(data, menu)
                    PrincipalMenuR()
            end)
        end)
    end

function SecondaryMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'id_card_menu', {
       title = 'Documentación', 
        align = 'bottom-right',
        elements = {
           {label = 'Ver ID', value = 'seeID'},
            {label = 'Mostrar ID', value = 'showID'},
            {label = 'Ver Licencia de conducir', value = 'seeDriver'},
            {label = 'Mostrar Licencia de conducir', value = 'showDriver'},
            {label = '<span style = color:red; span>Cerrar</span>', value = 'cancel'},
        }
    
    }, function(data, menu)
        local docum = data.current.value
        if docum == 'seeID' then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId())) 
        elseif docum == 'showID' then
            local player, distance = ESX.Game.GetClosestPlayer()
  
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
            else
                ESX.ShowNotification('No hay nadie cerca')
            end
  
        elseif docum == 'seeDriver' then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        elseif docum == 'showDriver' then
            local player, distance = ESX.Game.GetClosestPlayer()
  
            if distance ~= -1 and distance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
            else
                ESX.ShowNotification('No hay nadie cerca')
            end
        end
        menu.close()
    end, function(data, menu)
        PrincipalMenuR()
    end)
end

function RockstarEditor()
   ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'client',
        {
            title    = 'Rockstar Editor',
            align    = 'bottom-right',
            elements = {
            {label = 'Iniciar Grabación', value = 'empezar_grabacion'},
            {label = 'Guardar grabación', value = 'guardar_grabacion'},
            {label = 'Descartar grabación', value = 'descartar_grabacion'},
            {label = '<span style = color:red; span>Cerrar</span>', value = 'atras'}
        }
    }, function(data, menu)

            if data.current.value == 'empezar_grabacion' then
              StartRecording(1)
            elseif data.current.value == 'guardar_grabacion' then
              if(IsRecording()) then
                  StopRecordingAndSaveClip()
              end
            elseif data.current.value == 'descartar_grabacion' then
              StopRecordingAndDiscardClip()
          elseif data.current.value == 'atras' then
              PrincipalMenuR()
            end
      end, function(data, menu)
       PrincipalMenuR()
      end)
  end

function OpenHudMenu(source)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
	{
		title    = 'Apartado Estetico',
		align    = 'bottom-right',
		elements = {
            -- {label = "Estadísticas", value = 'stats'},
            {label = "Activar/Desactivar ID", value = 'id'},
            {label = "Activar/Desactivar Hud",	value = 'nohud'},
            {label = "Activar/Desactivar Voz",	value = 'novoz'},
            {label = "Activar/Desactivar Brujula",	value = 'nohudc2'},
			{label = "Activar/Desactivar Hud Coche", value = 'nohudc'},
		    {label = "<span style = color:red; span>Cerrar</span>",	value = 'offmenu'},
		}
	}, function(data, menu)
		if data.current.value == 'nohudc' then
			ExecuteCommand('togglecontadorcoche')
        elseif data.current.value == 'nohudc2' then
            ExecuteCommand('togglecompass')
        elseif data.current.value == 'nohud' then
            ExecuteCommand('togglehud')
        elseif data.current.value == 'novoz' then
            ExecuteCommand('togglevoz')
        elseif data.current.value == 'colorhud' then
            ExecuteCommand('customstatus')
		elseif data.current.value == 'id' then
			ExecuteCommand("id")
        -- elseif data.current.value == 'stats' then
		-- 	ExecuteCommand("habilidades")
		elseif data.current.value == 'offmenu' then
			PrincipalMenuR()
		end
	end,
	function(data, menu)
        PrincipalMenuR()
	end)
end

function OpenUtilidades()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'client',
         {
             title    = 'Utilidades',
             align    = 'bottom-right',
             elements = {
             {label = 'Resetear Voz', value = 'rvoz'},
             {label = 'Resetear Personaje', value = 'rskin'},
             {label = 'Poner / Quitar MiniMapa', value = 'map'},
             {label = 'Poner / Quitar Barras', value = 'movieon'},
             {label = 'Poner Ubicacion rapida', value = 'gps'},
             {label = '<span style = color:red; span>Cerrar</span>', value = 'atras'}
         }
     }, function(data, menu)
 
             if data.current.value == 'rvoz' then
                ExecuteCommand('rvoz')              
             elseif data.current.value == 'rskin' then
                ExecuteCommand('fixpj')
             elseif data.current.value == 'gps' then
                MenuGps()
             elseif data.current.value == 'map' then 
                ExecuteCommand('minimapa')
            elseif data.current.value == 'movieon' then 
                ExecuteCommand('movieon')
           elseif data.current.value == 'atras' then
               PrincipalMenuR()
             end
       end, function(data, menu)
        PrincipalMenuR()
       end)
   end


function MenuGps()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gps',{
        title = 'GPS Rápido',
		    align = 'bottom-right',
		    elements = {
			  {label = 'Garage Cental', value = 'garaje'},
			  {label = 'Comisaria', value = 'comisaria'}, 
			  {label = 'Hospital', value = 'hospital'}, 
			  {label = 'Concesionario', value = 'conce'},
			  {label = 'Mecánico', value = 'mecanico'},
			  {label = 'Paleto Bay', value = 'paleto'},	
              {label = 'Sandy Shores', value = 'sandy'},	
              {label = 'Badulake Central', value = 'badu'},	
		 }
  },
	function(data, menu)
		if data.current.value == 'garaje' then
			SetNewWaypoint(215.12, -815.74)
            PrincipalMenuR()
		elseif data.current.value == 'comisaria' then 
			SetNewWaypoint(411.28, -978.73)
            PrincipalMenuR()
		elseif data.current.value == 'hospital' then 
			SetNewWaypoint(291.37, -581.63)
            PrincipalMenuR()
        elseif data.current.value == 'conce' then
			SetNewWaypoint(-33.78, -1102.12)
            PrincipalMenuR()
		elseif data.current.value == 'mecanico' then
			SetNewWaypoint(-359.59, -133.44)
            PrincipalMenuR()
        elseif data.current.value == 'paleto' then
			SetNewWaypoint(-173.84, 6358.29)
            PrincipalMenuR()
        elseif data.current.value == 'sandy' then
			SetNewWaypoint(2035.46, 5056.26)
            PrincipalMenuR()
		elseif data.current.value == 'badu' then
			SetNewWaypoint(-708.01, -913.8)
            PrincipalMenuR()
		end
	end,
	function(data, menu)
		PrincipalMenuR()
	end)
end

-- function AdmMenu()
--     local elements = {}

--     ESX.TriggerServerCallback('r:getPerms', function(cb)
--         if cb then
--             table.insert(elements, {label = 'Administracion', value = 'adm'})
--         end

--         ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admmenu', {
--             title = 'Menú de administracion', 
--             align = 'bottom-right',
--             elements = elements

--         }, function(data, menu)
--             if data.current.value == 'adm' then
--                 AdministracionMenu()
--             end
--         end, function(data, menu)
--             PrincipalMenuR()
--         end)
--     end)
-- end

-- function AdministracionMenu()
--     local godmode = true
--     local invisible = true

--     local elements = {
--         {label = 'Noclip', value = 'noclip'},
--         {label = 'GodMode', value = 'godmode'},
--         {label = 'Invisible', value = 'invisible'},
--         {label = 'Abrir vehículo', value = 'abrirveh'},
--         {label = 'Cerrar vehículo', value = 'cerrarveh'},
--         {label = 'Reparar vehiculo', value = 'fix'},
--         {label = 'Poner Ped', value = 'ped'},
--         {label = 'Mostrar cordenadas', value = 'coordss'},
--         {label = '<span style = color:red; span>Cerrar</span>', value = 'cerrar'}
--     }

--     ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'apx_admin', {
--         title = 'Menu de administración', 
--         align = Config.Align,
--         elements = elements
--     }, function(data, menu)
--         local adm = data.current.value
--             if adm  == 'noclip' then
--                 TriggerEvent('rnoclip')
--             elseif adm  == 'godmode' then
--                 if godmode then
--                     SetEntityInvincible(PlayerPedId(), true)
--                     ESX.ShowNotification('Has activado el ~g~Godmode.')
--                     godmode = false
--                 else
--                     SetEntityInvincible(PlayerPedId(), false)
--                     ESX.ShowNotification('Has desactivado el ~r~Godmode.')
--                     godmode = true
--                 end
--             elseif adm == 'invisible' then
--                 if invisible then
--                     SetEntityVisible(PlayerPedId(), false)
--                     ESX.ShowNotification('Has activado el ~g~Invisible.')
--                     invisible = false
--                 else
--                     SetEntityVisible(PlayerPedId(), true)
--                     ESX.ShowNotification('Has desactivado el ~r~Invisible.')
--                     invisible = true
--                 end
--             elseif adm == 'abrirveh' then
--                 local coords = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 8.0, 0, 71)
--                 if coords < 1 then
--                     ESX.ShowNotification('No estas cerca de un vehiculo.')
--                 else
--                     SetVehicleDoorsLocked(coords, 1)
--                     ESX.ShowNotification('Vehiculo ~g~desbloqueado.')
--                 end
--             elseif adm == 'cerrarveh' then
--                 local coords = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 8.0, 0, 71)
--                 if coords < 1 then
--                     ESX.ShowNotification('No estas cerca de un vehiculo.')
--                 else
--                     SetVehicleDoorsLocked(coords, 2)
--                     ESX.ShowNotification('Vehiculo ~r~bloqueado.')
--                 end
--             elseif adm == 'fix' then
--                 TriggerEvent('rfix')
--             elseif adm == 'ped' then
--                 ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), 'rpedmenu', {
--                     title = 'Menú de Peds',
--                 }, function(menuData, menuHandle)
--                     local pedModel = menuData.value
                                
--                     if not type(pedModel) == "number" then pedModel = 'pedModel' end
--                     if IsModelInCdimage(pedModel) then
--                         while not HasModelLoaded(pedModel) do
--                             Citizen.Wait(15)
--                             RequestModel(pedModel)
--                         end
--                         SetPlayerModel(PlayerId(), pedModel)
--                         menuHandle.close()
--                     else
--                         ESX.ShowNotification('~r~Ped no encontrado')
--                     end
--                 end, function(menuData, menuHandle)
--                     menuHandle.close()
--                 end)
--             elseif adm == 'coordss' then
--                 TriggerEvent('rcoords')
--             elseif adm == 'cerrar' then
--                 ESX.UI.Menu.CloseAll()
--             end
--         end, function(data, menu)
--             menu.close()
--     end)
-- end


function ViewVehicles()
    local elements = {}
    ESX.TriggerServerCallback('r:getCars', function(vehicles)
        for i = 1, #vehicles, 1 do
            local hashVehicule = vehicles[i].props["model"]
            local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)

            table.insert(elements, {
                label = vehicleName .. " - " .. vehicles[i].plate,
                plate = vehicles[i].plate,
                value = i
            })
        end

        table.insert(elements, {label = "<span style = color:red; span>Cerrar</span>", value = 'atras'})
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'openvehiclesmenu',
        {
            title    = "Tus vehículos",
            align    = 'bottom-right',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'atras' then
                PrincipalMenuR()
            end
                PersonalMenuR()
            end)
        end)
    end

    function ViewMultas()
        local elements = {}
        ESX.TriggerServerCallback('r:getBills', function(bills)
            for i = 1, #bills, 1 do
    
                table.insert(elements, {
                    label = bills[i].label .. " - " .. '$' .. bills[i].amount,
                    value = bills[i].id,
                    amount = bills[i].amount
                })
            end
    
            table.insert(elements, {label = "<span style = color:red; span>Cerrar</span>", value = 'atras'})
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'openbillsmenu',
            {
                title    = "Tus multas",
                align    = 'bottom-right',
                elements = elements
            }, function(data, menu)
            if data.current.value == 'atras' then
                PrincipalMenuR()
            else
                ESX.TriggerServerCallback('r:payBills',function(cb)
                    
                end, data.current.value, data.current.amount)
            end
            PrincipalMenuR()
            end)
        end)
    end

function MenuEntornos()
	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'entornos',
        {
            title    = 'Menu de entornos',
            align    = 'bottom-right',
            elements = {
			{label = 'Entorno Tiroteo', value = 'tiroteo'},
			{label = 'Entorno Pelea', value = 'pelea'},
            {label = 'Entorno Droga', value = 'droga'},
			{label = 'Entorno Velocidad', value = 'velocidad'},
            {label = '<span style = color:red; span>Cerrar</span>', value = 'atras'},
			}
        },
        function(data, menu)
        if data.current.value == 'tiroteo' then
            AcDe()
        elseif data.current.value == 'pelea' then
            AcDe2()
        elseif data.current.value == 'droga' then
            AcDe3()
        elseif data.current.value == 'velocidad' then
            AcDe4()
        elseif data.current.value == 'atras' then
            PrincipalMenuR()
        end
      end, function(data, menu)
          PrincipalMenuR()
    end)
end

function AcDe()

	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'entornos',
        {
            title    = 'Menu de entornos',
            align    = 'bottom-right',
            elements = {
			{label = '<span style = color:green; span>Aceptar</span>', value = 'aceptar'},
			{label = '<span style = color:red; span>Cancelar</span>', value = 'denegar'},
			}
        },
        function(data, menu)
        if data.current.value == 'aceptar' then
            ExecuteCommand('entorno ¿Policía? Acabo de ver a varios individuos tirotearse. Necesito que vengais!')
            PrincipalMenuR()
        elseif data.current.value == 'denegar' then
            PrincipalMenuR()
        end
      end, function(data, menu)
        PrincipalMenuR()
    end)
end

function AcDe2()

	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'entornos',
        {
            title    = 'Menu de entornos',
            align    = 'bottom-right',
            elements = {
			{label = '<span style = color:green; span>Aceptar</span>', value = 'aceptar'},
			{label = '<span style = color:red; span>Cancelar</span>', value = 'denegar'},
			}
        },
        function(data, menu)
        if data.current.value == 'aceptar' then
            ExecuteCommand('entorno ¿Policía? Estoy viendo a gente pelearse. Ayuda porfavor necesito que vengais!')
            PrincipalMenuR()
        elseif data.current.value == 'denegar' then
            PrincipalMenuR()
        end
      end, function(data, menu)
        PrincipalMenuR()
    end)
end

function AcDe3()

	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'entornos',
        {
            title    = 'Menu de entornos',
            align    = 'bottom-right',
            elements = {
			{label = '<span style = color:green; span>Aceptar</span>', value = 'aceptar'},
			{label = '<span style = color:red; span>Cancelar</span>', value = 'denegar'},
			}
        },
        function(data, menu)
        if data.current.value == 'aceptar' then
            ExecuteCommand('entorno ¿Policía? Me acaban de intentar vender droga por esta zona. Necesito que vengais!')
            PrincipalMenuR()
        elseif data.current.value == 'denegar' then
            PrincipalMenuR()
        end
      end, function(data, menu)
        PrincipalMenuR()
    end)
end

function AcDe4()

	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'entornos',
        {
            title    = 'Menu de entornos',
            align    = 'bottom-right',
            elements = {
			{label = '<span style = color:green; span>Aceptar</span>', value = 'aceptar'},
			{label = '<span style = color:red; span>Cancelar</span>', value = 'denegar'},
			}
        },
        function(data, menu)
        if data.current.value == 'aceptar' then
            ExecuteCommand('entorno ¿Policía? Acabo de ver a un vehiculo a altas velocidades. Necesito ue vengais!')
            PrincipalMenuR()
        elseif data.current.value == 'denegar' then
            PrincipalMenuR()
        end
      end, function(data, menu)
        PrincipalMenuR()
    end)
end

-- Comandos

RegisterCommand('rvoz', function()
    NetworkClearVoiceChannel()
    NetworkSessionVoiceLeave()
    Wait(50)
    NetworkSetVoiceActive(false)
    MumbleClearVoiceTarget(2)
    Wait(1000)
    MumbleSetVoiceTarget(2)
    NetworkSetVoiceActive(true)
    ESX.ShowNotification('Chat de voz reiniciado.')
  end)

RegisterCommand('fixpj', function()
    local hp = GetEntityHealth(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
                TriggerEvent('dpc:ApplyClothing')
                SetEntityHealth(PlayerPedId(), hp)
                ESX.ShowNotification('El ped se a fixeado correctamente.')
            end)
        end)
    end)
end, false)


CinematicCamCommand = "movieon" 

CinematicCamMaxHeight = 0.3

CinematicCamBool = false

w = 0

RegisterCommand(CinematicCamCommand, function()
    CinematicCamBool = not CinematicCamBool
    CinematicCamDisplay(CinematicCamBool)
end)


Citizen.CreateThread(function()

    minimap = RequestScaleformMovie("minimap")

    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do 
            Wait(1)
        end
    end

    while true do
        Citizen.Wait(1)
        if w > 0 then
            DrawRects()
        end
        if CinematicCamBool then
            DESTROYHudComponents()
        end
    end
end)

-- funciones lineas negras

function DESTROYHudComponents() 
    for i = 0, 22, 1 do
        if IsHudComponentActive(i) then
            HideHudComponentThisFrame(i)
        end
    end
end

function DrawRects() 
    DrawRect(0.0, 0.0, 2.0, w, 0, 0, 0, 255)
    DrawRect(0.0, 1.0, 2.0, w, 0, 0, 0, 255)
end

function DisplayHealthArmour(int) 
    BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
    ScaleformMovieMethodAddParamInt(int)
    EndScaleformMovieMethod()
end

function CinematicCamDisplay(bool) 
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    if bool then
        DisplayRadar(false)
        DisplayHealthArmour(3)
        for i = 0, CinematicCamMaxHeight, 0.01 do 
            Wait(10)
            w = i
        end
    else
        DisplayRadar(true)
        DisplayHealthArmour(0)
        for i = CinematicCamMaxHeight, 0, -0.01 do
            Wait(10)
            w = i
        end 
    end
end  





-- Creditos

local autor = '.root#2746'
local resources = GetNumResources()

print('Resource echo por : ^5'..autor..'')
print(' En tu servidor con este script hay : ' ..resources.. ' resources')