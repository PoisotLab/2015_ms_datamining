library(dismo)
library(raster)
library(maps)
library(maptools)
library(mapdata)
library(plyr)
library(igraph)

load("ppd.Rdata")
load("g.Rdata")
load("sdm.Rdata")

names(sdm) = sort(unique(V(g)$name))

# Species richness
sp_ric = sdm[[1]]
for(i in c(2:length(sdm))) sp_ric = sp_ric + sdm[[i]]
#plot(sp_ric, col=colors)
#map("world", add=T)

# Number links
el = get.edgelist(g)
n_link = NA
for(i in c(1:nrow(el))){
  cat(paste(i, "\n"))
  from = el[i,1]
  to = el[i,2]
  if(is.logical(n_link)) {
    n_link = sdm[[from]]*sdm[[to]]
  } else {
    n_link = n_link + (sdm[[from]]*sdm[[to]])
  }
}

save(n_link, sp_ric, file="dm.Rdata")
