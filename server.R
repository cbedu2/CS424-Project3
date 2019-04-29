library(AotClient)
library(DT)
library(leaflet)
library(sp)
library(future)
source("barChart.R")
source("viewAotData.R")

v <- reactiveValues()
v$nodes <- nodes
v$selNodes <- c("", "")  # Current, Previous

mapIcons <- iconList(
  redStar = makeIcon(iconUrl="./assets/chicagostar25.png", iconWidth=20, iconHeight=25),
  blueStar = makeIcon(iconUrl="./assets/chicagostar25_lightblue.png", iconWidth=20, iconHeight=25),
  greyStar = makeIcon(iconUrl="./assets/chicagostar25_grey.png", iconWidth=20, iconHeight=25)
)

server <- shinyServer(function(input, output, session) {
  #comparingNodes
  
  output$testBarChart1 <- renderPlot(pollutantsChart("004","m"))
  output$testBarChart2 <- renderPlot(pollutantsChart("004","m"))
  output$etcChart1 <- renderPlot(etcChart("004","m"))
  output$etcChart2 <- renderPlot(etcChart("004","m"))
  
  observe({
    if (!is.na(v$selNodes[1]) & v$selNodes[1] != "") {
      output$testBarChart1 <- renderPlot(pollutantsChart(v$selNodes[1], input$units))
      output$etcChart1 <- renderPlot(etcChart(v$selNodes[1], input$units))
    }
    if (!is.na(v$selNodes[2]) & v$selNodes[2] != "") {
      output$testBarChart2 <- renderPlot(pollutantsChart(v$selNodes[2], input$units))
      output$etcChart2 <- renderPlot(etcChart(v$selNodes[2], input$units))
    }
  })
  
  # Render table the first time, and if nodes changes
  output$table <- renderDataTable(v$nodes, options = list(pageLength=10))
  tableProxy <- dataTableProxy("table")

  # Pop up window with credit information
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
    print("Drawing map...")
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addMarkers(data=isolate(v$nodes), icon=mapIcons["blueStar"],
                 layerId=~vsn, lat=~lat, lng=~lng)
  })
  mapProxy <- leafletProxy("map")

  # Update the map on tileset toggle
  observe({
    tileset <- switch(input$mapTiles,
                      "r" = providers$CartoDB.Positron,
                      "s" = providers$Esri.WorldImagery,
                      "t" = providers$Stamen.TopOSMRelief)
    mapProxy %>%
      clearTiles() %>%
      addProviderTiles(tileset)
  })

  # Update map icons on node selection OR sensor filter change
  observe({
    n <- isolate(v$nodes)
    n$isLive <- rowSums(n[input$filters]) > 0
    n$icon <- with(n, ifelse(vsn %in% v$selNodes, "redStar",
                             ifelse(isLive, "blueStar", "greyStar")))
    n$z <- with(n, ifelse(vsn %in% v$selNodes, 1000, 
                          ifelse(isLive, 500, 0))) # Draw selected nodes on top
    mapProxy %>%
      clearMarkers() %>%
      addMarkers(data=n, icon=~mapIcons[icon], layerId=~vsn, lat=~lat, lng=~lng,
                 options=markerOptions(zIndexOffset=~z))
  })

  # Update selected nodes on map click
  observe({
    clickedMarker <- input$map_marker_click   # Dependency on map markers
    curNodes <- isolate(v$selNodes)           # No dependency on selNodes
    curVal <- ifelse(length(curNodes) >= 1, curNodes[1], "")
    v$selNodes <- c(clickedMarker$id, curVal) # Trigger updates on selNodes
  })

  # Update selected nodes on table click
  observe({
    n <- isolate(v$nodes)                     # No dependency on nodes (should trigger via selection event)
    clickedRows <- input$table_rows_selected  # Dependency on table row selection
    newRowId <- tail(clickedRows, n=1)
    newNodeId <- n[newRowId, 1]
    
    if (length(clickedRows) > 1) {
      prevRowId <- tail(clickedRows, n=2)[1]
      prevNodeId <- n[prevRowId, 1]
    } else {
      prevNodeId <- ""
    }
    v$selNodes <- c(newNodeId, prevNodeId)    # Trigger updates on selNodes
  })

  # Update table selected rows on node change
  observe({
    n <- isolate(v$nodes)                     # No dependency on nodes
    curNode <- v$selNodes[1]                  # Dependency on selNodes

    if (is.null(curNode) | curNode == "") {
      # print("Selected node is null or blank")
      newRowId <- NULL
    } else {
      # print(paste("Looking up recent id:", curNode))
      foundRows <- which(n == curNode, arr.ind = TRUE)
      if (length(foundRows) < 1) {
        print(paste("ID:", curNode, "not found in table!"))
        newRowId <- NULL
      } else {
        newRowId <- foundRows[1,1]
      }
    }

    if (length(v$selNodes) > 1) {
      prevNode <- v$selNodes[2]
      # print(paste("Looking up previous id:", prevNode))
      foundRowsPrev <- which(n == prevNode, arr.ind = TRUE)
      if (length(foundRowsPrev) < 1) {
        if (prevNode != "") print(paste("ID:", prevNode, "not found in table!"))
        prevRowId <- NULL
      } else {
        prevRowId <- foundRowsPrev[1,1]
      }
    } else {
      prevRowId <- NULL
    }

    tableProxy %>% selectRows(c(prevRowId, newRowId))
  })
  
  # On node selection, get data from API
  
  # Draw graphs and table

  output$testarea <- renderPrint({
    #v$selNodes
    input$filters
  })
})

server
