payload = create_gist(
  filenames = c('ui.R', 'global.R', 'server.R', 'networks.json'), 
  description = 'TMS Shiny App'
)

post_gist(payload, viewer = 'https://github.com/dongikjang/TMSData')