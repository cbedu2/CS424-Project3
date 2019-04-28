library(AotClient)
library(DT)
library(leaflet)
library(sp)

source("viewAotData.R")

v <- reactiveValues()
v$nodes <- nodes
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
  
  observeEvent(input$moreInfoModalButton, {
    showModal(modalDialog(
      HTML("<p>
            This dashboard uses data from <a href=\"https://arrayofthings.github.io\">ArrayOfThings</a> and <a href=\"https://darksky.net/dev\"
            to display information about pollutants and weather data from the city of chicago.<br/>
           </p>
           <h3>Authors</h3>
           <ul>
                <li>Dylan Vo - <a href=\"https://dylanvo21.github.io/CS424/\">dvo7</a></li>
                <li>Will Toher - <a href=\"https://willtoher.com/424/index.html\">wtoher2</a></li>
                <li>Will Bedu - <a href=\"https://cbedu2.github.io/CS424/index.html\">cbedu2</a></li>
           </ul>
           <h3>Libraries used</h3>
           <ul>
              <li>library(sp)</li>
              <li>library(leaflet)</li>
              <li>library(DT)</li>
              <li>library(AotClient)</li>
              <li>library(shiny)</li>
              <li>library(shinydashboard)</li>
           </ul>
           <p>you can read more about how this project was created using R and Shiny at our <a href=\"https://cbedu2.github.io/CS424/Projects/Project3/index.html\">webpage</a></p>
           "),
      easyClose = TRUE
    ))
  })
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