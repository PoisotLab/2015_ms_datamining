library(dismo)
library(raster)
library(maps)
library(maptools)
library(igraph)
library(mapdata)
library(plyr)
library(doMC)

load("ppd.Rdata")
load("g.Rdata")

ppd = unique(ppd)
cutoff = 100
nrecords = ddply(ppd, "genus", nrow)
ok_gen = nrecords$genus[nrecords$`V1` >= cutoff]
not_ok_bool = !(V(g)$name %in% ok_gen)
g = delete.vertices(g, not_ok_bool)
g = delete.vertices(g, V(g)[ degree(g)==0 ])
ppd = subset(ppd, genus %in% V(g)$name)

save(ppd, file="ppd.Rdata")
save(g, file="g.Rdata")

xl = range(ppd$longitude) + c(-3.0, 3.0)
yl = range(ppd$latitude) + c(-3.0, 3.0)

# Load (or download and crop) bioclim data
cat("Getting clim data\n")
bioclim = crop(getData("worldclim", var="bio", res=5), c(min(xl), max(xl), min(yl), max(yl)))
writeRaster(bioclim, filename="bioclim.grd", overwrite=T)
bclim = brick("bioclim.grd")
cat("Got it!\n\n")

make_pred = function(sites, pred){
  bc_sites = extract(pred, sites[,c('longitude', 'latitude')])
  bs = data.frame(sites, bc_sites)
  bc = bioclim(bs[,colnames(bc_sites)])
  p = predict(pred, bc)
  return(p)
}

usgen = sort(unique(ppd$genus))
cat("Preparing to run SDMs\n")
registerDoMC(9)
sdm = alply(usgen, 1, function(x) make_pred(subset(ppd, genus == x), bclim), .parallel=T)
names(sdm) = usgen
save(sdm, file="sdm.Rdata")
