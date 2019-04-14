library(AotClient)
library(DT)
library(dplyr)
sensors <- ls.sensors()
nodes <- ls.nodes()
nodes <- nodes[!(nodes$address=="TBD" | nodes$address=="Georgia Tech"),]
