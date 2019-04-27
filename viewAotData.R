library(AotClient)
library(DT)
library(dplyr)
sensors <- ls.sensors()
nodes <- ls.nodes()
observations <-ls.observations(filters=list(size=1000))
observations2 <- merge(observations, nodes, by.x='node_vsn',by.y="vsn")

nodes <- nodes %>%
  dplyr::select(vsn,address) %>%
  dplyr::filter(address!="TBD" & address!="Georgia Tech")
sapply(nodes,class)
co <- observations2 %>% 
  dplyr::select(sensor_path,node_vsn,value)%>%
  dplyr::filter(sensor_path=="chemsense.co.concentration")
coDf <- data.frame(CO = character(),
                   vsn = factor())
for(i in 1:nrow(co)){
  if(co[i,3]!="TBD" || co[i,3]!="Georgia Tech" ){
    newRow <- data.frame(CO=TRUE,
                         vsn = co[i,2])
    coDf <-rbind(coDf,newRow)
  }
}
nodes2 <- left_join(nodes,coDf, by='vsn')
h2s <- observations2 %>% 
  dplyr::select(sensor_path,node_vsn,value)%>%
  dplyr::filter(sensor_path=="chemsense.h2s.concentration")
h2sDf <- data.frame(H2S = character(),
                   vsn = factor())
if(nrow(h2s)==0){
  nodes2<-left_join(nodes2,h2sDf,by = "vsn")
} else{
  for(i in 1:nrow(h2s)){
    if(h2s[i,3]!="TBD")
      newRow <- data.frame(H2S=TRUE,
                           vsn = h2s[i,2])
    h2sDf <-rbind(h2sDf,newRow)
  }
}

nodes2 <- full_join(nodes2,h2sDf,by = "vsn")
no2 <- observations2 %>% 
  dplyr::select(sensor_path,node_vsn,value)%>%
  dplyr::filter(sensor_path=="chemsense.no2.concentration")
no2Df <- data.frame(NO2 = character(),
                   vsn = factor())
for(i in 1:nrow(no2)){
    newRow <- data.frame(NO2=TRUE,
                         vsn = no2[i,2])
    no2Df <-rbind(no2Df,newRow)
}
nodes2 <- full_join(nodes2,no2Df,by = "vsn")
o3 <- observations2 %>% 
  dplyr::select(sensor_path,node_vsn,value)%>%
  dplyr::filter(sensor_path=="chemsense.o3.concentration")
o3Df <- data.frame(O3 = character(),
                   vsn = factor())
for(i in 1:nrow(o3)){
    newRow <- data.frame(O3=TRUE,
                         vsn = o3[i,2])
    o3Df <-rbind(o3Df,newRow)
}
nodes2 <- full_join(nodes2,o3Df,by = "vsn")
so2 <- observations2 %>% 
  dplyr::select(sensor_path,node_vsn,value)%>%
  dplyr::filter(sensor_path=="chemsense.so2.concentration")
so2Df <- data.frame(SO2 = character(),
                   vsn = factor())
for(i in 1:nrow(so2)){
    newRow <- data.frame(SO2=TRUE,
                         vsn = so2[i,2])
    so2Df <-rbind(so2Df,newRow)
}
nodes2 <- full_join(nodes2,so2Df,by = "vsn")