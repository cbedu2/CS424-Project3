library(shinydashboard)

body <- fluidPage(
  fluidRow(
    column(
      4,
      h3("Select County"),
      leafletOutput("map")
    ),
    column(
      4,
      h3("Test Table"),
      DT::dataTableOutput("mytable")
    ),
    column(
      4,
      h3("Charts")
    )
  ),
  fluidRow(
    h3("controls")
  )
)


ui <- fluidPage(
  body
)

ui