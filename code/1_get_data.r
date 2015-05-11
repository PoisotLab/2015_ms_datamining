#! /usr/bin/env Rscript

library(rglobi)
library(taxize)
library(spocc)
library(plyr)
library(igraph)
library(RColorBrewer)

genus_name = function(n) {
  n = strsplit(n, " ")
  n = laply(n, function(x) x[1])
  return(n)
}

interactions_from_globi = function(n) {
  globi_prey = c()
  globi_pred = c()
  cat(paste("Getting interactions for", n,"\n"))
  gl_int = get_interactions_by_taxa(sourcetaxon=n)
  gl_int = subset(gl_int, interaction_type %in% c("preysOn", "preyedUponBy"))
  if(NROW(gl_int) > 0){
    for(i in c(1:nrow(gl_int))){
      r = gl_int[i,]
      if(r$interaction_type == "preysOn"){
        globi_pred = c(globi_pred, r$source_taxon_name)
        globi_prey = c(globi_prey, r$target_taxon_name)
      } else {
        globi_prey = c(globi_prey, r$source_taxon_name)
        globi_pred = c(globi_pred, r$target_taxon_name)
      }
    }
    globi_interactions = unique(
      data.frame(i = genus_name(globi_pred), j = genus_name(globi_prey))
      )
    return(globi_interactions)
  }
  return(NA)
}

multi_int_from_taxa = function(genus) {
  globi_int = data.frame()
  for(g in genus) {
    g_int = interactions_from_globi(g)
    if(!is.na(g_int)) globi_int = rbind(globi_int, g_int)
  }
  return(globi_int)
}

# Get original data
A = read.csv("./matrix.csv", h=T, sep=';', row.names=1)
u_sp = rownames(A)
genus = genus_name(u_sp)

prey = c()
pred = c()
for(i in c(1:nrow(A))){
  for(j in c(1:ncol(A))){
    if(A[i,j]==1){
      pred = c(pred, genus[i])
      prey = c(prey, genus[j])
    }
  }
}

interactions = unique(data.frame(i = pred, j = prey))
interactions = subset(interactions, i != 'Unidentified')
interactions = subset(interactions, i != 'Unknown')
interactions = subset(interactions, j != 'Unidentified')
interactions = subset(interactions, j != 'Unknown')

genus = sort(unique(c(interactions$i, interactions$j)))

# Add data from Globi
globi_int = multi_int_from_taxa(genus)
all_int = rbind(interactions, globi_int)
all_gen = unique(c(all_int$i, all_int$j))
globi_gen = sort(unique(c(globi_int$i, globi_int$j)))
new_globi_gen = globi_gen[!(globi_gen %in% genus)]
new_globi_int = multi_int_from_taxa(new_globi_gen)
new_globi_int = subset(new_globi_int, (i %in% all_gen) & (j %in% all_gen))
interactions = unique(rbind(all_int, new_globi_int))

# Get interactions in igraph
g = graph.data.frame(interactions)

# Get occurence data from gbif using spocc
sources = c('gbif', 'bison')
dat = occ(V(g)$name, from=sources, gbifopts=list(hasCoordinate=TRUE))

# Assemble occurences in a data frame
ppd = data.frame()
for(source in dat){
  for(sp in names(source$data)){
    X = source$data[[sp]]
    if(nrow(X)>0){
      if('latitude' %in% colnames(X)) ppd = rbind(ppd, X[,c('name', 'latitude', 'longitude')])
    }
  }
}

ppd$genus = genus_name(ppd$name)
ppd = unique(ppd[,c('genus', 'latitude', 'longitude')])

ppd = subset(ppd, genus %in% V(g)$name)

save(ppd, file="ppd.Rdata")
save(g, file="g.Rdata")
