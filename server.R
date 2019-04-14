library(AotClient)
library(DT)
source("viewAotData.R")

server <- shinyServer(function(input, output) {
  output$mytable <- renderDataTable(nodes,
                options = list(
                  pageLength = 5
                )
                )
})

server