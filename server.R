library(AotClient)
library(DT)
library(leaflet)
library(sp)

source("viewAotData.R")

v <- reactiveValues()
v$nodes <- nodes
v$nodes2 <- nodes2
v$viewNode <- NULL
v$cmpNodes <- NULL

starIcon <- makeIcon(
  iconUrl = './assets/chicagostar25.png',
  iconWidth = 20,
  iconHeight = 25
)

server <- shinyServer(function(input, output, session) {
  output$table <- renderDataTable(v$nodes,
                                  options = list(pageLength = 5))
  observe({
    clickedMarker <- input$map_marker_click
    v$cmpNodes <- c(clickedMarker$id, v$viewNode)
    v$viewNode <- clickedMarker$id
    #dataTableProxy("table") %>% selectColumns()
  })
  output$testarea <- renderPrint({
    clickedMarker <- input$map_marker_click
    clickedMarker
    # v$nodes
  })
  
  # Render the map the first time
  output$map <- renderLeaflet({
    # leaflet() %>% addProviderTiles(providers$CartoDB.Positron)
    leaflet(v$nodes) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(icon=starIcon, layerId=~vsn)
  })
  # Update the map on changes to inputs
  observe({
    tileset <- switch(input$mapTiles,
                      "r" = providers$CartoDB.Positron,
                      "s" = providers$Esri.WorldImagery,
                      "t" = providers$Stamen.TopOSMRelief)
    leafletProxy("map") %>% addProviderTiles(tileset)
  })
})

server