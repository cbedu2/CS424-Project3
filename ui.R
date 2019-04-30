library(shinydashboard)
library(leaflet)
library(DT)
library(future)

filterList <- c("SO2", "H2S", "O3", "NO2", "CO",
                "Temp", "Intensity", "Humidity")

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
       alt = "placeholder Image")
}, deleteFile = TRUE)


css = tags$style(
  ".body{
  background-color: aliceblue;
  }"
)

ui <- bootstrapPage(
  tags$body(
    css,
    h1("The Air I Breathe"),
    tags$div(id="mainpage", class="col-12",
             tags$div(
               tags$div(class="col-xs-6 col-md-3 col-lg-3", style="height:75%; top: 400px",
                      h3("Interactive Map"),
                      leafletOutput("map",height=600),
                      radioButtons("mapTiles", "Map Background",
                                   choiceValues = c("r", "s", "t"),
                                   choiceNames = c("Road Map", "Satellite", "Terrain"),
                                   inline = TRUE)
             ),
             tags$div(class="col-xs-6 col-md-3 col-lg-3", style="height:75%; top: 400px ",
                      h3("Data Table"),
                      DT::dataTableOutput("table")
             )),
             tags$div(id="compareNodes",class="col-xs-12 col-md-6 col-lg-6",
                      tags$div(class="col-xs-6 col-md-3 col-lg-3", style="height:100%; width:50%; padding: 0",
                               h3(textOutput("node1Title")),
                               h4("Now"),
                               h5(textOutput("node1Err1")),
                               plotOutput("testBarChart1"),
                               h5(textOutput("node1Err2")),
                               plotOutput("etcChart1"),
                               h4("last 24 Hours"),
                               tabsetPanel(type = "tabs",
                                           tabPanel("SO2", plotOutput("lineCharta1")),
                                           tabPanel("H2S",plotOutput("lineCharta2")),
                                           tabPanel("O3", plotOutput("lineCharta3")),
                                           tabPanel("NO2", plotOutput("lineCharta4")),
                                           tabPanel("CO", plotOutput("lineCharta5")),
                                           tabPanel("PM2.5", plotOutput("lineCharta6")),
                                           tabPanel("PM10", plotOutput("lineCharta7")),
                                           tabPanel("Temp", plotOutput("lineCharta8")),
                                           tabPanel("Light ", plotOutput("lineCharta9")),
                                           tabPanel("humidity ",plotOutput("lineCharta10"))
                               ),
                               h4("last 7 Days"),
                               tabsetPanel(type = "tabs",
                                           tabPanel("SO2", plotOutput("lineChartab1")),
                                           tabPanel("H2S",plotOutput("lineChartab2")),
                                           tabPanel("O3", plotOutput("lineChartab3")),
                                           tabPanel("NO2", plotOutput("lineChartab4")),
                                           tabPanel("CO", plotOutput("lineChartab5")),
                                           tabPanel("PM2.5", plotOutput("lineChartab6")),
                                           tabPanel("PM10", plotOutput("lineChartab7")),
                                           tabPanel("Temp", plotOutput("lineChartab8")),
                                           tabPanel("Light ", plotOutput("lineChartab9")),
                                           tabPanel("humidity ",plotOutput("lineChartab10"))
                               )
                      ),
                      tags$div(class="col-xs-6 col-md-3  col-lg-3", style="height:100%; width:50%; padding: 0",
                               h3(textOutput("node2Title")),
                               h4("Now"),
                               h5(textOutput("node2Err1")),
                               plotOutput("testBarChart2"),
                               h5(textOutput("node2Err2")),
                               plotOutput("etcChart2"),
                               h4("last 24 Hours"),
                               tabsetPanel(type = "tabs",
                                           tabPanel("SO2", plotOutput("node2DaySO2")),
                                           tabPanel("H2S",plotOutput("node2DayH2S")),
                                           tabPanel("O3", plotOutput("node2DayO3")),
                                           tabPanel("NO2", plotOutput("node2DayNO2")),
                                           tabPanel("CO", plotOutput("node2DayCO")),
                                           tabPanel("Temp", plotOutput("node2DayTemp")),
                                           tabPanel("Light ", plotOutput("node2DayLight")),
                                           tabPanel("humidity ",plotOutput("node2DayHum"))
                               ),
                               h4("last 7 Days"),
                               tabsetPanel(type = "tabs",
                                           tabPanel("SO2", plotOutput("node2WeekSO2")),
                                           tabPanel("H2S",plotOutput("node2WeekH2S")),
                                           tabPanel("O3", plotOutput("node2WeekO3")),
                                           tabPanel("NO2", plotOutput("node2WeekNO2")),
                                           tabPanel("CO", plotOutput("node2WeekCO")),
                                           tabPanel("Temp", plotOutput("node2WeekTemp")),
                                           tabPanel("Light ", plotOutput("node2WeekLight")),
                                           tabPanel("humidity ",plotOutput("node2WeekHum"))
                               )
                      )
             ),
             tags$div(class="col-md-12 col-lg-12 col-xs-4",
                      tags$div(
                        tags$h3("Filter Options"),
                        checkboxGroupInput("filters",label="",inline = TRUE,
                                           choices = filterList, selected=filterList),
                        tags$h3("Units"),
                        radioButtons("units",label="",inline = TRUE,
                                     choiceValues = c("i", "m"), choiceNames = c("Imperial", "Metric"))
                      ),
                      tags$p(
                        "This dashboard was created by Dylan Vo, Wilfried Bedu, William Toher. It uses data from",
                        tags$a(href="https://darksky.net/dev","Darksky"),
                        "and",
                        tags$a(href="https://arrayofthings.github.io","Array of Things"),
                        "more information available at our",
                        tags$a(href="https://cbedu2.github.io/CS424/Projects/Project3/index.html","Project Description page")
                      ),
                      actionButton("moreInfoModalButton", "More Info")
             )
    ),
    verbatimTextOutput("testarea")
  )
)
ui
