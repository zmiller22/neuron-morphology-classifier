library(rstudioapi)
library(Rtsne)
library(umap)
library(vegan)
library(RDRToolbox)

# Set working directory to the current path and import preprocessing functions
setwd(dirname(getActiveDocumentContext()$path))
source("../../preprocessing/preprocessing-functions.R")
source("../../visualization/visualization-functions.R")

# Set paths
mds.data.path <- "../../data/feature_vectors_063020/nblast_mds_all_dims.csv"
lbl.path <- "../../data/metadata.csv"
tsne.data.output.dir <- "/reduced_dim_data/tsne"
umap.data.output.dir <- "/reduced_dim_data/umap"
isomap.data.output.dir <- "/reduced_dim_data/isomap"
tsne.plot.output.dir <- "/plots/tsne"
umap.plot.output.dir <- "/plots/umap"
isomap.plot.output.dir <- "/plots/isomap"

# Make sure all output directories exist, make them if they don't
#TODO fix the error output when the directory already exists

ifelse(!dir.exists(tsne.data.output.dir), 
       dir.create(file.path(paste(getwd(), tsne.data.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(umap.data.output.dir), 
       dir.create(file.path(paste(getwd(), umap.data.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(isomap.data.output.dir), 
       dir.create(file.path(paste(getwd(), isomap.data.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(tsne.plot.output.dir), 
       dir.create(file.path(paste(getwd(), tsne.plot.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(umap.plot.output.dir), 
       dir.create(file.path(paste(getwd(), umap.plot.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(isomap.plot.output.dir), 
       dir.create(file.path(paste(getwd(), isomap.plot.output.dir, sep="")), recursive=TRUE), FALSE)

# Read in the data and labels
temp.mds.data <- read.csv(mds.data.path, row.names=1)
temp.lbls <- read.csv(lbl.path, row.names=1)

# Make sure that all the rows are matched and do not include NA number values
combined.df <- transform(merge(temp.mds.data, temp.lbls[c("cell_type","gal4")], by="row.names", all.x=FALSE), 
                         row.names=Row.names, Row.names=NULL)
lbl.vars <- names(combined.df) %in% c("cell_type", "gal4")
mds.data <- combined.df[!lbl.vars]
lbls <- combined.df[lbl.vars]

# Write functions for running dimensionality techniques with differing parameters
my.tsne <- function(data, perplexity, name) {
  tsne.data <- Rtsne(data, dims=3, perplexity=perplexity)
  tsne.data.df <- data.frame(tsne.data$Y, row.names=rownames(mds.data))
  write.csv(tsne.data.df, file=paste(getwd(), "/", tsne.data.output.dir, "/", name, ".csv", sep=""),
            row.names=TRUE)
  return(tsne.data)
}

my.umap <- function(data, n_neighbors, name) {
  params <- umap.defaults
  params$n_components <- 5
  params$n_neighbors <- n_neighbors
  
  umap.data <- umap(data, params)
  umap.data.df <- umap.data$layout
  write.csv(umap.data.df, file=paste(getwd(), "/", umap.data.output.dir, "/", name, ".csv", sep=""),
            row.names=TRUE)
  return(umap.data)
}

my.isomap <- function(data, k, name) {
  
}

tsne.10.perp <- my.tsne(mds.data, perplexity=10, name="tsne_10_perp")
tsne.30.perp <- my.tsne(mds.data[,1:100], perplexity=30, name="tsne_30_perp")
tsne.50.perp <- my.tsne(mds.data, perplexity=50, name="tsne_50_perp")
tsne.70.perp <- my.tsne(mds.data, perplexity=70, name="tsne_70_perp")

cc.pairs.plots(tsne.10.perp$Y, substring(tsne.plot.output.dir, 2), "tsne.10.perp", lbls, "png", "TSNE MDS dimensions")
cc.pairs.plots(tsne.30.perp$Y, substring(tsne.plot.output.dir, 2), "tsne.30.perp", lbls, "png", "TSNE MDS dimensions")
cc.pairs.plots(tsne.50.perp$Y, substring(tsne.plot.output.dir, 2), "tsne.50.perp", lbls, "png", "TSNE MDS dimensions")
cc.pairs.plots(tsne.70.perp$Y, substring(tsne.plot.output.dir, 2), "tsne.70.perp", lbls, "png", "TSNE MDS dimensions")

umap.10.nn <- my.umap(mds.data, n_neighbors=10, name="umap_10_perp")
umap.30.nn <- my.umap(mds.data, n_neighbors=30, name="umap_30_perp")
umap.50.nn <- my.umap(mds.data, n_neighbors=50, name="umap_50_perp")
umap.70.nn <- my.umap(mds.data, n_neighbors=70, name="umap_70_perp")

cc.pairs.plots(umap.10.nn$layout, substring(umap.plot.output.dir, 2), "umap.10.nn", lbls, "png", "UMAP of MDS dimensions")
cc.pairs.plots(umap.30.nn$layout, substring(umap.plot.output.dir, 2), "umap.30.nn", lbls, "png", "UMAP of MDS dimensions")
cc.pairs.plots(umap.50.nn$layout, substring(umap.plot.output.dir, 2), "umap.50.nn", lbls, "png", "UMAP of MDS dimensions")
cc.pairs.plots(umap.70.nn$layout, substring(umap.plot.output.dir, 2), "umap.70.nn", lbls, "png", "UMAP of MDS dimensions")



my.umap.5v <- function(data, n_neighbors, name) {
  params <- umap.defaults
  params$n_components <- 10
  params$n_neighbors <- n_neighbors
  
  umap.data <- umap(data, params)
  umap.data.df <- umap.data$layout
  write.csv(umap.data.df, file=paste(getwd(), "/", umap.data.output.dir, "/", name, ".csv", sep=""),
            row.names=TRUE)
  return(umap.data)
}



umap.30.nn.10v <- my.umap.5v(mds.data, n_neighbors=30, name="umap_30_perp_10v")
cc.pairs.plots(umap.30.nn.10v$layout, substring(umap.plot.output.dir, 2), "umap.30.nn.10v", lbls, "png", "UMAP of MDS dimensions")



