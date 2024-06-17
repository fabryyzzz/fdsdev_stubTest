
-- https://discord.gg/amEJNfn9HX FOR SUPPORT

fx_version 'adamant'
games { 'gta5' }
lua54 'yes'
author 'FDS DEVELOPMENT - FiveM Resources'
description 'Paraffin Glove'
version '1.0.0'

-- What to run
ui_page {
	'html/index.html', 
}
   
client_scripts {
	"client/*.lua",
	"client/client/*.lua"
}

files {
	'html/fonts/*.otf',
	'html/index.html',
	'html/index.js', 
	'html/locale.js', 
	'html/suoni/*.*', 
	'html/style.css'
   } 
   

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	
	"server/*.lua",
	"server/server/*.lua"
}

shared_scripts {
	"shared/*.lua",
	'@ox_lib/init.lua',
}

escrow_ignore {
	'client/edit.lua', 
	'server/edit.lua', 
	'shared/config.lua',
	'shared/locale.lua',
}

-- https://discord.gg/amEJNfn9HX
-- https://discord.gg/amEJNfn9HX
-- https://discord.gg/amEJNfn9HX
-- https://discord.gg/amEJNfn9HX
-- https://discord.gg/amEJNfn9HX
-- https://discord.gg/amEJNfn9HX
-- DISCORD FOR SUPPORT
