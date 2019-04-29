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
    h2("The Air I Breathe"),
    tags$div(id="mainpage", class="col-12",
             tags$div(class="col-xs-6 col-md-3 col-lg-3", style="height:100%; padding: 0",
                      h3("Interactive Map"),
                      leafletOutput("map",height=600),
                      radioButtons("mapTiles", "Map Background",
                                   choiceValues = c("r", "s", "t"),
                                   choiceNames = c("Road Map", "Satellite", "Terrain"),
                                   inline = TRUE)
             ),
             tags$div(class="col-xs-6 col-md-3 col-lg-3", style="height:100%; padding: 0",
                      h3("Data Table"),
                      DT::dataTableOutput("table")
             ),
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
                                           tabPanel("SO2", "pending"),
                                           tabPanel("H2S","pending"),
                                           tabPanel("O3", "pending"),
                                           tabPanel("NO2", "pending"),
                                           tabPanel("CO", "pending"),
                                           tabPanel("Temp", "pending"),
                                           tabPanel("Light ", "pending"),
                                           tabPanel("humidity ","pending")
                               ),
                               h4("last 7 Days"),
                               tabsetPanel(type = "tabs",
                                           tabPanel("SO2", "pending"),
                                           tabPanel("H2S", "pending"),
                                           tabPanel("O3", "pending"),
                                           tabPanel("NO2", "pending"),
                                           tabPanel("CO", "pending"),
                                           tabPanel("Temp", "pending"),
                                           tabPanel("Light ", "pending"),
                                           tabPanel("humidity ","pending")
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
                                           tabPanel("SO2", "pending"),
                                           tabPanel("H2S","pending"),
                                           tabPanel("O3", "pending"),
                                           tabPanel("NO2", "pending"),
                                           tabPanel("CO", "pending"),
                                           tabPanel("Temp", "pending"),
                                           tabPanel("Light ", "pending"),
                                           tabPanel("humidity ","pending")
                               ),
                               h4("last 7 Days"),
                               tabsetPanel(type = "tabs",
                                           tabPanel("SO2", "pending"),
                                           tabPanel("H2S", "pending"),
                                           tabPanel("O3", "pending"),
                                           tabPanel("NO2", "pending"),
                                           tabPanel("CO", "pending"),
                                           tabPanel("Temp", "pending"),
                                           tabPanel("Light ", "pending"),
                                           tabPanel("humidity ","pending")
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
