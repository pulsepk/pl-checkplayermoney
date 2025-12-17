fx_version 'cerulean'
games { 'gta5' }

author 'PulseScripts - pulsescripts.com'
description 'Check Player with most Money'
version '1.1.3'

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


