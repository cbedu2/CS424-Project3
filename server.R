library(AotClient)
library(DT)
library(leaflet)
library(sp)

source("viewAotData.R")

sensors <- reactive({
  getSensors()
})

nodes <- reactive({
  n <- getNodes()

  latlng <-
    n$location.geometry$coordinates %>%
    unlist() %>%
    matrix(ncol=2, byrow=TRUE)

  n$lat <- latlng[,2]
  n$lng <- latlng[,1]
  n
})

starIcon <- makeIcon(
  iconUrl = './assets/chicagostar25.png',
  iconWidth = 20,
  iconHeight = 25
)

server <- shinyServer(function(input, output) {
  output$table <- renderDataTable(nodes(),
                                  options = list(pageLength = 5))
  observe({
    clickedMarker <- input$map_marker_click
    coords <- c(clickedMarker$lng, clickedMarker$lat)
    #dataTableProxy("table") %>% selectColumns()
  })
  output$testarea <- renderPrint({
    clickedMarker <- input$map_marker_click
    clickedMarker
  })
  
  # Render the map the first time
  output$map <- renderLeaflet({
    leaflet(nodes()) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(icon=starIcon, layerId=~vsn)
  })
  # Update the map on changes to inputs
  observe({
    tileset <- switch(input$mapTiles,
                      "r" = providers$CartoDB.Positron,
                      "s" = providers$Esri.WorldImagery,
                      "t" = providers$Stamen.TopOSMRelief)
    leafletProxy("map") %>%
      addProviderTiles(tileset)
  })
})

server