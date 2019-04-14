library(AotClient)

sensors <- ls.sensors()
nodes <- ls.nodes()
nodes <- nodes[!(nodes$address=="TBD" | nodes$address=="Georgia Tech"),]
sensors[is.na(sensors)] <- 0
observations <- ls.observations()
df <- ls.observations(filters=list(
  sensor="metsense.bmp180.temperature"
))
