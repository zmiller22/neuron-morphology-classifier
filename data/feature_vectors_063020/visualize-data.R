library(rstudioapi)

setwd(dirname(getActiveDocumentContext()$path))
source("../../visualization/visualization-functions.R")

umap.data.10.path <- "mds_umap_10_dims.csv"
umap.data.5.path <- "mds_umap_5_dims.csv"
lbls.path <- "../metadata.csv"
plot.dir.path <- "plots"

umap.data.10 <- read.csv(umap.data.10.path, row.names=1)
umap.data.5 <- read.csv(umap.data.5.path, row.names=1)
lbls <- read.csv(lbls.path, row.names=1)

combined.10.df <- transform(merge(umap.data.10, lbls[c("cell_type","gal4")], by="row.names", all.x=FALSE), 
                         row.names=Row.names, Row.names=NULL)
combined.5.df <- transform(merge(umap.data.5, lbls[c("cell_type","gal4")], by="row.names", all.x=FALSE), 
                            row.names=Row.names, Row.names=NULL)




cc.pairs.plots(combined.10.df[,1:5], plot.dir.path, "umap_data_10_v", 
                combined.10.df[c("cell_type", "gal4")], "png", 
                "First 5 Dimensions of UMAP Data")

cc.pairs.plots(combined.5.df[,1:5], plot.dir.path, "umap_data_5_v", 
               combined.5.df[c("cell_type", "gal4")], "png", 
               "First 5 Dimensions of UMAP Data")