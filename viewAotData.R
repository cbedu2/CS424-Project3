library(AotClient)
library(DT)
library(dplyr)
library(stringr)

# if (!exists("sensors")) 
  sensors <- ls.sensors()
# if (!exists("nodes")) 
  nodes <- ls.nodes()

# Convert factors to strings so comparisons work
nodes$vsn <- sapply(nodes$vsn, as.character)

# if (!exists("observations")) 
  observations <-ls.observations(filters=list(size=1000))

latlng <- nodes$location.geometry$coordinates %>%
          unlist() %>%
          matrix(ncol=2, byrow=TRUE)

nodes$lat <- latlng[,2]
nodes$lng <- latlng[,1]

nodes <- nodes %>%
  dplyr::select(vsn,address,lat,lng) %>%
  dplyr::filter(address!="TBD" & address!="Georgia Tech")

testSensor <- function(nodeId, sensorName) {
  x <- observations %>%
    dplyr::filter(node_vsn == nodeId & sensor_path == sensorName) %>%
    nrow()
  x > 0
}
testOtherSensors <- function(nodeId, sensorType){
  x <- observations %>%
    dplyr::filter(node_vsn == nodeId & str_detect(sensor_path,sensorType))%>%
    nrow()
  x > 0
}

nodes$CO <- sapply(nodes$vsn, testSensor, "chemsense.co.concentration")
nodes$H2S <- sapply(nodes$vsn, testSensor, "chemsense.h2s.concentration")
nodes$NO2 <- sapply(nodes$vsn, testSensor, "chemsense.no2.concentration")
nodes$O3 <- sapply(nodes$vsn, testSensor, "chemsense.o3.concentration")
nodes$SO2 <- sapply(nodes$vsn, testSensor, "chemsense.so2.concentration")
nodes$PM2.5 <- sapply(nodes$vsn, testSensor, "alphasense.opc_n2.pm2_5")
nodes$PM10 <- sapply(nodes$vsn, testSensor, "alphasense.opc_n2.pm10")
nodes$Temp <- sapply(nodes$vsn, testOtherSensors,"temperature")
nodes$Humidity <- sapply(nodes$vsn, testOtherSensors,"humidity")
nodes$Intensity <- sapply(nodes$vsn, testOtherSensors,"intensity")

# TODO: Temperature, Humidity, Light Intensity


