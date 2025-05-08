fx_version 'adamant'
games { 'gta5' }

author 'tgb'
description 'Vehicle Spawn'
version '1.0'

ui_page "html/mainpage.html"

files {
  "html/**.html",
  "html/**.css",
  "html/img/**.png"
}

client_script {
  'client/**.lua'
}


server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/**.lua'

}
export {
  'openExternal'
}
