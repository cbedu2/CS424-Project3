library(AotClient)
library(DT)
library(dplyr)
sensors <- ls.sensors()
nodes <- ls.nodes()
nodes <- nodes[!(nodes$address=="TBD" | nodes$address=="Georgia Tech"),]
nodes2<-nodes %>%
  select(vsn, address)
sensors[is.na(sensors)] <- 0
observations <- ls.observations()
colnames(observations)[colnames(ob)]
stat.node()