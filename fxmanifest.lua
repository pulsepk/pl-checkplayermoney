fx_version 'cerulean'
games { 'gta5' }

author 'PulsePK https://discord.gg/P7NFTeqwQb'
description 'PL-CheckPlayerMoney'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
   
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

dependencies {
    'ox_lib'
}

