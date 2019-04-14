library(AotClient)
library(DT)
library(dplyr)

getSensors = function() {
  ls.sensors()
}

getNodes = function() {
  nodes <- ls.nodes()
  nodes[!(nodes$address=="TBD" | nodes$address=="Georgia Tech"),]
}