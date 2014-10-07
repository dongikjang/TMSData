## @knitr loadLibraries
require(RJSONIO); require(rCharts); require(RColorBrewer)#; require(httr)
options(stringsAsFactors = F)


val2col <- function(z, zlim, col = heat.colors(12), breaks){
  if(!missing(breaks)){
    if(length(breaks) != (length(col)+1)){stop("must have one more break than colour")}
  }
  if(missing(breaks) & !missing(zlim)){
    #breaks <- seq(zlim[1], zlim[2], length.out=(length(col)+1)) 
    breaks <- seq(zlim[1], zlim[2], length.out=(length(col))) 
  }
  if(missing(breaks) & missing(zlim)){
    zlim <- range(z, na.rm=TRUE)
    breaks <- seq(zlim[1], zlim[2], length.out=(length(col))) 
    #breaks <- seq(zlim[1], zlim[2], length.out=(length(col)+1)) 
  }
  colorlevels <- col[((as.vector(z)-breaks[1])/(range(breaks)[2]-range(breaks)[1]))*(length(breaks)-1)+1] # assign colors to heights for each point
  colorlevels
}
  
## @knitr plotMap
plotMap <- function(network = 'All', width = 1200, height = 1000){
  library(leaflet)
  center_ <- list(lat=37.4, lng=127.4)
  if(network=="All"){
    load("TMSList.RData")
  } else{
    load("TMSList.RData")
    levcode <- unlist(lapply(data_, function(x) x$lev))
    data_ <- switch(network,
                   "Express Highways" = subset(data_, levcode=="1"),
                   "National Highway" = subset(data_, levcode=="2"),
                   "Provincial Road" = subset(data_, levcode=="3"),
                   "Gov-Aided Provincial Road" = subset(data_, levcode=="5"))
  }

  require(shiny)
  require(rCharts)
  library(leaflet)
  L1 <- Leaflet$new()
  L1$tileLayer(provider = 'Stamen.TonerLite')
  L1$set(width = width, height = height)
  L1$setView(c(center_$lat, center_$lng), 10)
  L1$geoJson(toGeoJSON(data_), 
      onEachFeature = '#! function(feature, layer){
        layer.bindPopup(feature.properties.popup)
      } !#',
      pointToLayer =  "#! function(feature, latlng){
        return L.circleMarker(latlng, {
          radius: 4,
          fillColor: feature.properties.fillColor || 'red',    
          color: '#000',
          weight: 1,
          fillOpacity: 0.8
        })
    } !#")
  L1$enablePopover(TRUE)
  L1$fullScreen(TRUE)
  return(L1)
}
