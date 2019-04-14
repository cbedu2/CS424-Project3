library(AotClient)
library(DT)
library(leaflet)

source("viewAotData.R")

sensors <- reactive({
  getSensors()
})

nodes <- reactive({
  getNodes()
})

shapeNodes <- function(nodedf) {
  nodelist <- nodedf$location.geometry$coordinates
  matrix(unlist(nodelist), ncol = 2, byrow = TRUE)
}

server <- shinyServer(function(input, output) {
  output$table <- renderDataTable(nodes(),
                                  options = list(pageLength = 5))
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(data=shapeNodes(nodes()))
  })
})

server