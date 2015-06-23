library(dismo)
library(raster)
library(maps)
library(maptools)
library(mapdata)
library(plyr)
library(igraph)
library(RColorBrewer)

load("dm.Rdata")
load("g.Rdata")
load("ppd.Rdata")

#source("layout.foodweb.r")
wg = walktrap.community(g)$membership
sp_colors = brewer.pal(length(unique(wg)), 'Set1')[wg]
names(sp_colors) = V(g)$name

small_ppd = ppd
small_ppd$latitude = round(small_ppd$latitude, 0)
small_ppd$longitude = round(small_ppd$longitude, 0)
P = unique(small_ppd)

# Figure 1 -- network and ppd
pdf(file="figure1.pdf", width=18, height=7)

layout(matrix(rep(c(1,1,1,2,2,2,2,2,2), 6), ncol=9, byrow=T))

# Draw the network
plot(g, layout=layout.fruchterman.reingold,
  vertex.size=3, vertex.color=sp_colors,
  vertex.label=NA, vertex.frame.color = NA,
  edge.arrow.size=0, edge.color=rgb(0.4, 0.4, 0.4, 0.2))

# Draw the world map
map("world", col=rep(rgb(0.9, 0.9, 0.9), 2), fill=T)
points(P[,c(3,2)], pch=19, cex=0.1, col=sp_colors[P$genus])

dev.off()

colors = colorRampPalette(brewer.pal(9, "YlGnBu"))(256)


space_grid = expand.grid(x=seq(from=-180, to=180), y=seq(from=-90, to=90))
space_grid$S = extract(sp_ric, space_grid[,c('x', 'y')])
space_grid$L = extract(n_link, space_grid[,c('x', 'y')])
space_grid$Co = space_grid$L/(space_grid$S^2)
space_grid = subset(space_grid, !is.na(Co))

sg = ddply(space_grid, .(y), summarize, Co = mean(Co), S = mean(S), L = mean(L))


zsc = function(x) (x-mean(x))/sd(x)

# Figure 2 -- trends
pdf(file="figure2.pdf", height=8, width=9)
par(mfcol=c(3,2))

plot(sp_ric, col=colors, axes=F, bty='n')
map("world", add=T, col=rgb(0.3, 0.3, 0.3, 0.2), interior=F)
box()
title("Number of genera")

plot(zsc(S)~y, sg, xlab="Latitude", ylab="Z-score of (predicted) genera richness", pch=NA, xlim=c(-80, 80))
rect(-23.26,par("usr")[3],23.26,par("usr")[4], col=colors()[4], border=NA)
points(zsc(S)~y, sg, col=brewer.pal(3, 'Set1')[2], pch=19)
abline(v=0, lty=2, col="darkgrey")
abline(v=23.26*c(-1,1), lty=3, col='grey')
box()

plot(n_link, col=colors, axes=F, bty='n')
map("world", add=T, col=rgb(0.3, 0.3, 0.3, 0.2), interior=F)
box()
title("Number of interactions")

plot(zsc(L)~y, sg, xlab="Latitude", ylab="Z-score of (predicted) link numbers", pch=NA, xlim=c(-80, 80))
rect(-23.26,par("usr")[3],23.26,par("usr")[4], col=colors()[4], border=NA)
points(zsc(L)~y, sg, col=brewer.pal(3, 'Set1')[2], pch=19)
abline(v=0, lty=2, col="darkgrey")
abline(v=23.26*c(-1,1), lty=3, col='grey')
box()

Co = n_link/(sp_ric^2)

plot(sqrt(Co), col=colors, zlim=c(0,1))
map("world", add=T, col=rgb(0.3, 0.3, 0.3, 0.2), interior=F)
#box()
title("Connectance")

plot(zsc(Co)~y, sg, xlab="Latitude", ylab="Z-score of (predicted) connectance", pch=NA, xlim=c(-80, 80))
rect(-23.26,par("usr")[3],23.26,par("usr")[4], col=colors()[4], border=NA)
points(zsc(Co)~y, sg, col=brewer.pal(3, 'Set1')[2], pch=19)
abline(v=0, lty=2, col="darkgrey")
abline(v=23.26*c(-1,1), lty=3, col='grey')
box()


dev.off()
