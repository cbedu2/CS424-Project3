library(AotClient)
library(lubridate)
library(DT)
library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)

obs <- ls.observations(filters = list(
  node = '004',
  sensor = 'metsense.pr103j2.temperature',
  timestamp = 'ge:2019-04-29T00:00:00',
  size = 1500
))
obs2 <- ls.observations(filters = list(
  node = '01C',
  sensor = 'metsense.pr103j2.temperature',
  timestamp = 'ge:2019-04-22T00:00:00',
  size = 15000
))
metricConverter<- function(df, uom){
  if(uom == 'imperial'){
    df$imperial<-(df$value*(9/5))+32
    return(df)
  }else{
    return(df)
  }
}
  
weeklyLineChart <- function(df, metric){
  df$Date <- as.Date(df$timestamp)
  df <- df %>%
    dplyr::select(Date,value)%>%
    dplyr::group_by(Date)
  df <- aggregate(df[,2],list(df$Date),mean)
  df <- metricConverter(df,metric)
  if(metric == 'imperial'){
    return(ggplot(data=df, aes(x=Group.1 , y=imperial,group=1))+geom_line() )
  }else{
    return(ggplot(data=df, aes(x=Group.1 , y=value,group=1))+geom_line()  )
  }
  
}
dailyLineChart <- function(df, metric){
  df <- metricConverter(df,metric)
  if(metric=='imperial'){
    return(ggplot(data=df,aes(x=timestamp,y=imperial,group=1))+geom_line() )
  }else{
    return(ggplot(data=df,aes(x=timestamp,y=value,group=1))+geom_line() ) 
  }
}

