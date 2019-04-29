library(AotClient)


query <- function(filters){
  return(ls.observations(filters = filters))
}

sensorTypes <- c("metsense.bmp180.temperature")


get7DaysAgoISO8601 <-function(){
  epoch = as.integer(Sys.time())
  DaysAgoEpoch = epoch - 84400
  as.POSIXct(DaysAgoEpoch, origin="1970-01-01")
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