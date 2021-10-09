fx_version 'adamant'

game 'gta5'

client_script 'client/main.lua'

server_scripts {
    'server/server.lua',
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua'
}