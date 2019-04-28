library(shinydashboard)
library(leaflet)
library(DT)

filterList <- c("SO2", "H2S", "O3", "NO2", "CO", "PM2.5", "PM10",
                "Temperature", "Light Intensity", "Humidity")

placeholderImg <- renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = './WWW/img/placeholder.jpg')
  
  # Generate the PNG
  png(outfile, width = 400, height = 300)
  hist(rnorm(input$obs), main = "Generated in renderImage()")
  dev.off()
  
  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 400,
       height = 300,
       alt = "This is alternate text")
}, deleteFile = TRUE)


css = tags$style(
  ".body{
    background-color: aliceblue;
  }"
)

ui <- bootstrapPage(
  tags$body(
  css,
  h2("The Air I Breathe"),
  tags$div(id="mainpage",class="col-12",
    fluidRow(
      tags$div(
        height="75%",
        style="height:100%",
        class="col-xs-6 col-md-3 col-lg-3",
        h3("Interactive Map"),
        leafletOutput("map",height=600),
        radioButtons("mapTiles", "Map Background",
                     choiceValues = c("r", "s", "t"),
                     choiceNames = c("Road Map", "Satellite", "Terrain"),
                     inline = TRUE)
      ),
      tags$div(
        height="75%",
        style="height:100%",
        class="col-xs-6 col-md-3 col-lg-3",
        h3("Data Table"),
        DT::dataTableOutput("table")
      ),
      tags$div(
        id="compareNodes",
        class="col-xs-6 col-md-6 col-lg-6",
        tags$div(
                 class="col-xs-6 col-md-3 col-lg-3",
                 style="height:100%; border: 5px solid red; height: 100%; width:50%",
                 h3("Node1"),
                 placeholderImg
        ),
        tags$div(height="75%",
                 class="col-xs-6 col-md-3 col-lg-3",
                 style="height:100%; border: 5px solid red; height: 100%; width:50%",
                 h3("Node1"),
                 placeholderImg
        ),
        tags$div(
          tags$p("select timeframe to view"),
          actionButton("nowTimeView", "Now "),
          actionButton("hoursTimeView", " Last 24 Hours"),
          actionButton("daysTimeView", "Last 7 Days")
        )
      )
    ),
    fluidRow(
      tags$div(
        class="col-md-12 col-lg-12 col-xs-4",
        tags$div(
          tags$p("Filter Options"),
          checkboxGroupInput("filters", "Filter Options", inline = TRUE,
                             choices = filterList, selected=filterList)
        ),
        tags$p(
          "this dashboard was created by Dylan Vo, Wilfried Bedu, William Toher. It uses data from",
          tags$a(href="https://darksky.net/dev","Darksky"),
          "and",
          tags$a(href="#","things")
        )
      )
    ),
    verbatimTextOutput("testarea")
  )
))
ui
