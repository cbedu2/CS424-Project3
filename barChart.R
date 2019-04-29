library(AotClient)
library(DT)
library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)

pollutantsChart <- function(nodeID,metric){
  df <- data.frame(value = numeric(),
                   sensor_path = character())
  sensorTypes <- c('chemsense.o3.concentration','chemsense.co.concentration','chemsense.h2s.concentration','chemsense.no2.concentration','chemsense.so2.concentration')
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
