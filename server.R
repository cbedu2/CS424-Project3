library(AotClient)
library(DT)
library(leaflet)
library(sp)

source("viewAotData.R")

sensors <- reactive({
  getSensors()
})

nodes <- reactive({
  getNodes()
})

starIcon <- makeIcon(
  iconUrl = './assets/chicagostar25.png',
  iconWidth = 20,
  iconHeight = 25
)

shapeNodes <- function(nodedf) {
  # Get node coordinates - this is a list of 1x2 vectors
  nodelist <- nodedf$location.geometry$coordinates
  
  # Unwrap list into a 2-column matrix
  coords <- matrix(unlist(nodelist), ncol = 2, byrow = TRUE)
  
  SpatialPoints(coords)
}

server <- shinyServer(function(input, output) {
  output$table <- renderDataTable(nodes(),
                                  options = list(pageLength = 5))
  output$map <- renderLeaflet({
    leaflet(shapeNodes(nodes())) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(icon=starIcon)
  })
})

server