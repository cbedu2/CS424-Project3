library(shinydashboard)

body <- dashboardBody(
  leafletOutput("map")
)


ui <- fluidPage(
  fluidRow(
    body
  )
)

ui