library(AotClient)
library(DT)
library(leaflet)
library(sp)
library(future)
source("barChart.R")
source("viewAotData.R")
source("query.R")
source("lines.R")

pollutantsensors <- c("chemsense.co.concentration",
                     "chemsense.h2s.concentration",
                     "chemsense.no2.concentration",
                     "chemsense.o3.concentration",
                     "chemsense.so2.concentration")
etcsensors <- c("metsense.pr103j2.temperature",
                "metsense.hih4030.humidity",
                "lightsense.tsl260rd.intensity")

v <- reactiveValues()
v$nodes <- nodes
v$tblNodes <- nodes
v$selNodes <- c("", "")  # Current, Previous

v$curPollutantData <- data.frame()
v$prevPollutantData <- data.frame()
v$curEtcData <- data.frame()
v$prevEtcData <- data.frame()

mapIcons <- iconList(
  redStar = makeIcon(iconUrl="./assets/chicagostar25.png", iconWidth=20, iconHeight=25),
  blueStar = makeIcon(iconUrl="./assets/chicagostar25_lightblue.png", iconWidth=20, iconHeight=25),
  greyStar = makeIcon(iconUrl="./assets/chicagostar25_grey.png", iconWidth=20, iconHeight=25)
)

getNow <- function(value, id) {ls.observations(filters=list(node=id, sensor=value, size=1))}

server <- shinyServer(function(input, output, session) {
  
  observe({
    if (nrow(v$curPollutantData) < 1 | !("sensor_path" %in% colnames(v$curPollutantData))) {
      #output$testBarChart1 <- renderPlot()
      output$node1Err1 <- renderText("No data for selected node!")
    } else {
      output$node1Err1 <- renderText("")
      output$testBarChart1 <- renderPlot(pollutantsChart(v$curPollutantData, input$units))
    }
  })
  observe({
    if (nrow(v$curEtcData) < 1 | !("sensor_path" %in% colnames(v$curEtcData))) {
      output$node1Err2 <- renderText("No data for selected node!")
      #output$etcChart1 <- renderPlot()
    } else {
      output$node1Err2 <- renderText("")
      output$etcChart1 <- renderPlot(etcChart(v$curEtcData, input$units))
    }
  })

  observe({
    if (nrow(v$prevPollutantData) < 1 | !("sensor_path" %in% colnames(v$prevPollutantData))) {
      output$node2Err1 <- renderText("No data for selected node!")
    } else {
      output$testBarChart2 <- renderPlot(pollutantsChart(v$prevPollutantData, input$units))
    }
  })
  observe({
    if (nrow(v$prevEtcData) < 1 | !("sensor_path" %in% colnames(v$prevEtcData))) {
      output$node2Err2 <- renderText("No data for selected node!")
    } else {
      output$etcChart2 <- renderPlot(etcChart(v$prevEtcData, input$units))
    }
  })
  
  # Update table rows when filters change
  observe({
    tbl <- isolate(v$nodes)
    tbl$isLive <- rowSums(tbl[input$filters]) >= length(input$filters)
    
    v$tblNodes <- tbl %>%
      dplyr::filter(isLive) %>%
      dplyr::select(vsn, address, CO, H2S, NO2, O3, SO2, Temp, Humidity, Intensity)
  })

   df1 <- ls.observations(filters = list(
       node = '004',
       sensor = 'chemsense.co.concentration',
       timestamp = 'ge:2019-04-29T00:00:00',
       size = 2000
  ))
  lineChart <- weeklyLineChart(df1,"m")
  output$lineCharta1 <- renderPlot(lineChart)
  output$lineCharta2 <- renderPlot(lineChart)
  output$lineCharta3 <- renderPlot(lineChart)
  output$lineCharta4 <- renderPlot(lineChart)
  output$lineCharta5 <- renderPlot(lineChart)
  output$lineCharta6 <- renderPlot(lineChart)
  output$lineCharta7 <- renderPlot(lineChart)
  output$lineCharta8 <- renderPlot(lineChart)
  output$lineCharta9 <- renderPlot(lineChart)
  output$lineCharta10 <- renderPlot(lineChart)
  
  output$lineChartb1 <- renderPlot(lineChart)
  output$lineChartb2 <- renderPlot(lineChart)
  output$lineChartb3 <- renderPlot(lineChart)
  output$lineChartb4 <- renderPlot(lineChart)
  output$lineChartb5 <- renderPlot(lineChart)
  output$lineChartb6 <- renderPlot(lineChart)
  output$lineChartb7 <- renderPlot(lineChart)
  output$lineChartb8 <- renderPlot(lineChart)
  output$lineChartb9 <- renderPlot(lineChart)
  output$lineCharta10 <- renderPlot(lineChart)
  
  output$lineChartac1 <- renderPlot(lineChart)
  output$lineChartac2 <- renderPlot(lineChart)
  output$lineChartac3 <- renderPlot(lineChart)
  output$lineChartac4 <- renderPlot(lineChart)
  output$lineChartac5 <- renderPlot(lineChart)
  output$lineChartac6 <- renderPlot(lineChart)
  output$lineChartac7 <- renderPlot(lineChart)
  output$lineChartac8 <- renderPlot(lineChart)
  output$lineChartac9 <- renderPlot(lineChart)
  output$lineChartac10 <- renderPlot(lineChart)
  
  output$lineChartbc1 <- renderPlot(lineChart)
  output$lineChartbc2 <- renderPlot(lineChart)
  output$lineChartbc3 <- renderPlot(lineChart)
  output$lineChartbc4 <- renderPlot(lineChart)
  output$lineChartbc5 <- renderPlot(lineChart)
  output$lineChartbc6 <- renderPlot(lineChart)
  output$lineChartbc7 <- renderPlot(lineChart)
  output$lineChartbc8 <- renderPlot(lineChart)
  output$lineChartbc9 <- renderPlot(lineChart)
  output$lineChartbc10 <- renderPlot(lineChart)

  # Render table the first time, and if filters changes
  observe({
    output$table <- renderDataTable(v$tblNodes, options = list(pageLength=10))
  })
  # output$table <- renderDataTable(v$nodes, options = list(pageLength=10))
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
              <li>library(future)</li>
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
    n$isLive <- rowSums(n[input$filters]) >= length(input$filters)
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
    n <- isolate(v$tblNodes)                     # No dependency on nodes (should trigger via selection event)
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
    n <- isolate(v$tblNodes)                     # No dependency on nodes
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
  
  # Update titles on node change
  observe({
    output$node1Title <- renderText(ifelse(v$selNodes[1] == "", "...", paste("Node", v$selNodes[1])))
    output$node2Title <- renderText(ifelse(is.na(v$selNodes[2]) | v$selNodes[2] == "",
                                           "...", paste("Node", v$selNodes[2])))
  })
  
  # On node selection, get data from API
  observe({
    id <- v$selNodes[1]
    print(id)
    
    if (id != "") {
      pollutantDF <- simpleGetNow(pollutantsensors, id)
      pollutantDF$value <- abs(pollutantDF$value)
      
      miscDF <- simpleGetNow(etcsensors, id)

      v$prevPollutantData <- isolate(v$curPollutantData)
      v$prevEtcData <- isolate(v$curEtcData)
      v$curPollutantData <- pollutantDF
      v$curEtcData <- miscDF
    }
  })
  
  output$testarea <- renderPrint({
    #v$selNodes
    #v$curPollutantData
    
  })
})

server
