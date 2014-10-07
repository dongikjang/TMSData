## @knitr ui
require(shiny)
require(rCharts)
#networks <- getNetworks()
networks <- c("All", "Express Highways", "National Highway", "Provincial Road", 
              "Gov-Aided Provincial Road")
shinyUI(bootstrapPage( 
  tags$link(href='style.css', rel='stylesheet'),
  tags$script(src='app.js'),
  includeHTML('www/credits.html'),
  selectInput('network', '', networks, "All"),
  mapOutput('map_container')
))