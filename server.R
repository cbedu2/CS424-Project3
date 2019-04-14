library(AotClient)
library(DT)
library(leaflet)

df <- reactive({
  ls.nodes()
})

shapeNodes <- function(nodedf) {
  nodelist <- nodedf$location.geometry$coordinates
  matrix(unlist(nodelist), ncol = 2, byrow = TRUE)
}

server <- shinyServer(function(input, output) {
  output$table <- renderDataTable(df(),
                                  options = list(pageLength = 5))
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(data=shapeNodes(df()))
  })
})

server