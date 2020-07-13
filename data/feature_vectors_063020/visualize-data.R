library(rstudioapi)

setwd(dirname(getActiveDocumentContext()$path))
source("../../visualization/visualization-functions.R")

umap.data.path <- "mds_umap_10_dims.csv"
lbls.path <- "../metadata.csv"
plot.dir.path <- "plots"

umap.data <- read.csv(umap.data.path, row.names=1)
lbls <- read.csv(lbls.path, row.names=1)

combined.df <- transform(merge(umap.data, lbls[c("cell_type","gal4")], by="row.names", all.x=FALSE), 
                         row.names=Row.names, Row.names=NULL)




cc.pairs.plots(combined.df[,1:5], plot.dir.path, "umap_data", 
                combined.df[c("cell_type", "gal4")], "png", 
                "First 5 Dimensions of UMAP Data")