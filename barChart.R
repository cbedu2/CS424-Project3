library(AotClient)
library(DT)
library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)

simpleGetNow <- function(sensorTypes, nodeID) {
  df <- data.frame(
    value = numeric(),
    uom = character(),
    timestamp = character(),
    sensor_path = character(),
    node_vsn = character()
  )
  for (value in sensorTypes) {
    tryCatch({
      newRow <- ls.observations(filters = list(
        node = nodeID,
        sensor = value,
        size = 1
      )) %>%
        dplyr::select(value, uom, timestamp, sensor_path, node_vsn)
      df <- rbind(df, newRow)
    }, warning=function(w) {
      print(paste("[Warn] Fetch failed for id:", nodeID, "and sensor:", value))
    }, error=function(e) {
      print(paste("[Warn] Fetch failed for id:", nodeID, "and sensor:", value))
    })
  }
  df
}

pollutantsChart <- function(df,metric){
  ggplot(df,aes(x=sensor_path,y=value)) +
    geom_bar(stat='identity',width=.5) +
    theme(axis.text.x=element_text(angle=60,hjust=1,vjust=0.5))
}

etcChart <- function(df, metric){
  # df <- data.frame(value = numeric(),
  #                  sensor_path = character())
  # sensorTypes <- c('metsense.pr103j2.temperature','metsense.hih4030.humidity','lightsense.tsl260rd.intensity')
  # for (value in sensorTypes){
  #   if(value == 'metsense.pr103j2.temperature' && metric == 'i'){
  #     newRow <- ls.observations(filters=list(
  #       node = nodeID,
  #       sensor = value,
  #       size = 1
  #     ))
  #     newRow$value <- (newRow$value*(9/5))+32
  #   }
  #   else{
  #     newRow <- ls.observations(filters=list(
  #       node = nodeID,
  #       sensor = value,
  #       size = 1
  #     ))
  #   }
  #   
  #   newRow <- newRow %>%
  #     dplyr::select(value,sensor_path)
  #   df <- rbind(df,newRow)
  # }
  return(ggplot(df,aes(x=sensor_path,y=value)) +
           geom_bar(stat='identity',width=.5) +
           theme(axis.text.x=element_text(angle=60,hjust=1,vjust=0.5)))
}
