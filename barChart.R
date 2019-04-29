library(AotClient)
library(DT)
library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)
library(future)
source("query.R")
df <- data.frame(value = numeric(),
                 sensor_path = character())
sensorTypes <- c('chemsense.o3.concentration','chemsense.co.concentration','chemsense.h2s.concentration','chemsense.no2.concentration','chemsense.so2.concentration')
for (value in sensorTypes){
  newRow <- ls.observations(filters=list(
    node = '004',
    sensor = value,
    size = 1
  ))
  newRow <- newRow %>%
    dplyr::select(value,sensor_path)
  df <- rbind(df,newRow)
}
ggplot(df,aes(x=sensor_path,y=value)) + geom_bar(stat='identity',width=.5)+ theme(axis.text.x=element_text(angle=60,hjust=1,vjust=0.5))
pollutantsChart <- function(nodeID,metric){
  df <- data.frame(value = numeric(),
                   sensor_path = character())
  sensorTypes <- c('chemsense.o3.concentration','chemsense.co.concentration','chemsense.h2s.concentration','chemsense.no2.concentration','chemsense.so2.concentration')
  for (value in sensorTypes){
    newRow <- future({ls.observations(filters=list(
      node = nodeID,
      sensor = value,
      size = 1
    ))});
    newRow <- newRow %>%
      dplyr::select(value,sensor_path)
    df <- rbind(df,newRow)
  }
  return(ggplot(df,aes(x=sensor_path,y=value)) + geom_bar(stat='identity',width=.5)+ theme(axis.text.x=element_text(angle=60,hjust=1,vjust=0.5)))
  
}
etcChart <- function(nodeID, metric){
  df <- data.frame(value = numeric(),
                   sensor_path = character())
  sensorTypes <- c('metsense.pr103j2.temperature','metsense.hih4030.humidity','lightsense.tsl260rd.intensity')
  for (value in sensorTypes){
    newRow <- ls.observations(filters=list(
      node = nodeID,
      sensor = value,
      size = 1
    ))
    newRow <- newRow %>%
      dplyr::select(value,sensor_path)
    df <- rbind(df,newRow)
  }
  return(ggplot(df,aes(x=sensor_path,y=value)) + geom_bar(stat='identity',width=.5)+ theme(axis.text.x=element_text(angle=60,hjust=1,vjust=0.5)))
  
}



testBarChart <- function(){
  
  cols <- c("col1","col2","col3","col4","col5")
  dat <- data.frame(
    time = (factor(cols, levels=cols)),
    total_bill = c(14.89, 17.23,12.32,23.3,23.5)
  )
  
  return(ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) +
           geom_bar(colour="black", stat="identity") +
           guides(fill=FALSE))
}
