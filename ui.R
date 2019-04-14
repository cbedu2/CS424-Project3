library(shinydashboard)

body <- dashboardBody(
)


ui <- basicPage(
  h2("Test table"),
  DT::dataTableOutput("mytable")
)
ui