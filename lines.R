library(AotClient)
library(lubridate)
library(DT)
library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)

obs <- ls.observations(filters = list(
  node = '004',
  sensor = 'chemsense.co.concentration',
  timestamp = 'ge:2019-04-29T00:00:00',
  size = 2000
))
obs2 <- ls.observations(filters = list(
  node = '01C',
  sensor = 'chemsense.co.concentration',
  timestamp = 'ge:2019-04-22T00:00:00',
  size = 15000
))
  
  
weeklyLineChart <- function(df, metric){
  df$Date <- as.Date(df$timestamp)
  df <- df %>%
    dplyr::select(Date,value)%>%
    dplyr::group_by(Date)
  df <- aggregate(df[,2],list(df$Date),mean)
  return(ggplot(data=df, aes(x=Group.1 , y=value,group=1))+geom_line()  )
}
dailyLineChart <- function(df, metric){
  return(ggplot(data=df,aes(x=timestamp,y=value,group=1))+geom_line() )
}

