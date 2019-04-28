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
  # Render table the first time
  output$table <- renderDataTable(v$nodes,
                                  options = list(pageLength = 5))
  
  observeEvent(input$moreInfoModalButton, {
    showModal(modalDialog(
      HTML("<p>
            This dashboard uses data from <a href=\"https://arrayofthings.github.io\">ArrayOfThings</a> and <a href=\"https://darksky.net/dev\">Dark Sky</a>
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
  
  # Render map the first time
  output$map <- renderLeaflet({
    # leaflet() %>% addProviderTiles(providers$CartoDB.Positron)
    leaflet(v$nodes) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(icon=starIcon, layerId=~vsn)
  })
  
  # Update the map on tileset toggle
  observe({
    tileset <- switch(input$mapTiles,
                      "r" = providers$CartoDB.Positron,
                      "s" = providers$Esri.WorldImagery,
                      "t" = providers$Stamen.TopOSMRelief)
    leafletProxy("map") %>% addProviderTiles(tileset)
  })
  
  # Update selected nodes on map click
  observe({
    clickedMarker <- input$map_marker_click
    curVal <- isolate(v$viewNode)
    v$cmpNodes <- c(clickedMarker$id, curVal)
    v$viewNode <- clickedMarker$id
  })
  
  # Update selected nodes on table click
  observe({
    clickedRows <- input$table_rows_selected
    newRowId <- tail(clickedRows, n=1)
    newNodeId <- v$nodes[newRowId, 1]
    
    if (length(clickedRows) > 1) {
      prevRowId <- tail(clickedRows, n=2)[1]
      prevNodeId <- v$nodes[prevRowId, 1]
    } else {
      prevNodeId <- NULL
    }
    v$cmpNodes <- c(newNodeId, prevNodeId)
    v$viewNode <- newNodeId
  })
  
  # Update table selected rows on node change
  observe({
    n <- isolate(v$nodes)
    if (length(v$cmpNodes) > 0) {
      newNodeId <- which(nodes == v$viewNode, arr.ind = TRUE)[1,1]
    } else {
      newNodeId <- NULL
    }
    if (length(v$cmpNodes) > 1) {
      oldNodeId <- which(nodes == v$cmpNodes[2], arr.ind = TRUE)[1,1]
    } else {
      oldNodeId <- NULL
    }
    
    dataTableProxy("table") %>% selectRows(c(oldNodeId, newNodeId))
  })
  
  
  output$testarea <- renderPrint({
    v$cmpNodes
    #input$table_rows_selected
  })
  
  
})

server