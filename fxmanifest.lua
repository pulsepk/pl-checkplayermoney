fx_version 'cerulean'
games { 'gta5' }

author 'PulsePK https://discord.gg/P7NFTeqwQb'
description 'Check Player with most Money'
version '1.1.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/bridge/*',
    'client/main.lua'
   
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/bridge/*',
    'server/main.lua'
}

dependencies {
    'ox_lib'
}

files {
    'locales/en.json'
}


