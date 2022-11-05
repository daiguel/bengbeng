fx_version 'cerulean'
game 'gta5'

name "bengbeng"
lua54 'yes'

description "gives a bag to player to extend his carry capacity "
author "daiguel"
version "1.0.0"

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'	
}

files {
    'locales/*.json'
}

dependencies {
	'ox_lib',
	'es_extended'
}
