resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

fx_version "cerulean"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'DArkSouL'
description 'Dev-Tool which shows targeted entity informations'
version '1.0.0'
lua54 'yes'

client_scripts {
	'config.lua',
	'client/models.lua',
	'client/client.lua',
	'client/client.js'
}

-- html
ui_page 'html/ui.html'
files {
    'html/ui.html',
    'html/style.css',
    'html/img/eye.png',
    'html/client.js',
}