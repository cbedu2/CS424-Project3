library(AotClient)
library(DT)
df<-ls.nodes()
server <- shinyServer(function(input, output) {
  output$table <- renderDataTable(df,
                options = list(
                  pageLength = 5
                )
                )
})

server