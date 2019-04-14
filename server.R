library(AotClient)
server <- shinyServer(function(input, output) {
  output$table <- renderDataTable(ls.nodes(),
                options = list(
                  pageLength = 5
                )
                )
})

server