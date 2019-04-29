library(AotClient)
library(lubridate)

query <- function(filters){
  return(ls.observations(filters = filters))
}

sensorTypes <- c("metsense.bmp180.temperature")

formatDate <- function(daysAgoEpoch){
  datetime <- as_datetime(daysAgoEpoch)
  return(
    paste("ge:",format.Date(datetime, "%Y"),"-",format.Date(datetime, "%m"),"-",format.Date(datetime, "%d"),"T",format.Date(datetime, "%H"),":",format.Date(datetime, "%m"),":",second(datetime),sep="")
  )
}
getXDaysAgoISO8601 <-function(days){
  epoch = as.integer(Sys.time())
  daysAgoEpoch = epoch - 84400*days
  return(formatDate(daysAgoEpoch))
}


queryBuilder <- function(sensorType="", timestamp="",nodeId=""){
  filters <- list(
    node =nodeId,
    sensor= sensorType,
    timestamp = timestamp,
    size=20000,
    page=1 
  )
  data1 = query(filters)[,-(5:9),drop=FALSE]
  len <- nrow(data1)
  #will fail if entire dataset has exactly 20000 rows this is bad code but the fix needs to happen at at API level
  if( len == 20000){
    filters$page <- 2
    data2 <- query(filters)[,-(5:9),drop=FALSE]
    return(rbind(data1,data2))
  }else{
    return(data1)
  }
}

for(sensorType in sensorTypes){
  results <- queryBuilder(sensorType,nodeId="004", timestamp="ge:2019-04-18T00:00:00")
}