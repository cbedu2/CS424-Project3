library(AotClient)


query <- function(filters){
  return(ls.observations(filters = filters))
}

sensorTypes <- c("metsense.bmp180.temperature")

queryBuilder <- function(sensorType="", timestamp="",nodeId=""){
  filters <- list(
    node =nodeId,
    sensor= sensor,
    timestamp = timestamp,
    size=20000,
    page=1 
  )
  data1 = query(filters)[,-(5:9),drop=FALSE]
  len <- nrow(data1)
  print(len)
  if( len == 20000){
    filters$page <- 2
    data2 <- query(filters)[,-(5:9),drop=FALSE]
    print(nrow(data2))
    return(rbind(data1,data2))
  }else{
    return(data1)
  }
}

for(sensorType in sensorTypes){
  results <- queryBySensorType(sensorType,timestamp="ge:2019-04-18T00:00:00","004")
}