library(rstudioapi)
library(Rtsne)
library(umap)
library(ggplot2)

setwd(dirname(getActiveDocumentContext()$path))
source("../../preprocessing/preprocessing-functions.R")
source("../../visualization/visualization-functions.R")
source("../../utils/r-utils.R")

# Input paths
geometric.features.path <- "../../data/feature_vectors_072320/geometric_features.csv"
spatial.features.path <- "../../data/feature_vectors_072320/spatial_features.csv"
lbl.path <- "../../data/metadata.csv"

# Output paths
feature.output.dir <- "/data_visualization"
pca.output.dir <- "/reduced_dim_data/pca"
umap.output.dir <- "/reduced_dim_data/umap"
lol.output.dir <- "/reduced_dim_data/lol"

# Ensure all output directories exist
ifelse(!dir.exists(feature.output.dir), 
       dir.create(file.path(paste(getwd(), feature.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(pca.output.dir), 
       dir.create(file.path(paste(getwd(), pca.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(umap.output.dir), 
       dir.create(file.path(paste(getwd(), umap.output.dir, sep="")), recursive=TRUE), FALSE)

ifelse(!dir.exists(lol.output.dir), 
       dir.create(file.path(paste(getwd(), lol.output.dir, sep="")), recursive=TRUE), FALSE)


# Read in the data and labels
geometric.features <- read.csv(geometric.features.path, row.names=1)
spatial.features <- read.csv(spatial.features.path, row.names=1)
lbls <- read.csv(lbl.path, row.names=1)

geometric.data <- merge.dfs(list(lbls, geometric.features))
spatial.data <- merge.dfs(list(lbls, spatial.features))
combined.data <- merge.dfs(list(lbls, spatial.features, geometric.features))

#### Plot the raw data ####
lbl.cols <- c("gal4", "cell_type")

# Look at the variance of all the variables
scaled.geometric.data <- data.frame(scale.default(geometric.data[,3:ncol(geometric.data)]))
scaled.geometric.data$gal4 <- geometric.data$gal4


all.data.m <- reshape2::melt(scaled.geometric.data[,names(scaled.geometric.data) !="gal4"], 
                             id.vars=NULL)
ggplot(all.data.m, aes(x=variable, y=value, fill=variable)) + 
  geom_violin() +
  ggtitle("Variable Distributions")

gad.data.m <-  reshape2::melt(scaled.geometric.data[which(scaled.geometric.data$gal4=="Gad1b (mpn155)"),
                                                    names(scaled.geometric.data)!="gal4"], id.vars=NULL)
glut.data.m <-  reshape2::melt(scaled.geometric.data[which(scaled.geometric.data$gal4=="vGlut2a"),
                                                    names(scaled.geometric.data)!="gal4"], id.vars=NULL)

ggplot(gad.data.m, aes(x=variable, y=value, fill=variable)) +
  geom_violin() +
  geom_jitter(position=position_jitter(0.1)) +
  ylim(-2, 6) +
  ggtitle("Gad Variable Distributions")
  
ggplot(glut.data.m, aes(x=variable, y=value, fill=variable)) + 
  geom_violin() +
  geom_jitter(position=position_jitter(0.1)) +
  ylim(-2, 6) +
  ggtitle("Glut Variable Distributions")

# Just the mean locations
cc.pairs.plots(spatial.data[,c("nrnX", "nrnY", "nrnZ")], substring(feature.output.dir, 2), 
               "mean_loc", spatial.data[,lbl.cols], "png", "Mean Cell Locations")

# Just the soma locations
cc.pairs.plots(spatial.data[,c("somaX", "somaY", "somaZ")], substring(feature.output.dir, 2), 
               "soma_loc", spatial.data[,lbl.cols], "png", "Soma Locations")

# All spatial features
cc.pairs.plots(spatial.data[,3:ncol(spatial.data)], substring(feature.output.dir, 2), 
               "all_loc", spatial.data[,lbl.cols], "png", "All Spatial Features")

#### Look at the pca of the different data ####

# Run pca on all the data combos
combined.pca <- prcomp(combined.data[,3:ncol(combined.data)], scale.=TRUE)
geometric.pca <- prcomp(geometric.data[,3:ncol(geometric.data)], scale.=TRUE)
spatial.pca <- prcomp(spatial.data[,3:ncol(spatial.data)], scale.=TRUE)

# Remerge the data to ensure row names match
combined.pca.data <- merge.dfs(list(lbls, data.frame(combined.pca$x)))
geometric.pca.data <- merge.dfs(list(lbls, data.frame(geometric.pca$x)))
spatial.pca.data <- merge.dfs(list(lbls, data.frame(spatial.pca$x)))

# Create pairs plots
cc.pairs.plots(combined.pca.data[,3:7], substring(pca.output.dir, 2), 
               "combined", combined.pca.data[,lbl.cols], "png", "PCA of Combined Features")
cc.pairs.plots(geometric.pca.data[,3:7], substring(pca.output.dir, 2),
               "geometric", geometric.pca.data[,lbl.cols], "png", "PCA of Geometric Features")
cc.pairs.plots(spatial.pca.data[,3:7], substring(pca.output.dir, 2), 
               "spatial", spatial.pca.data[,lbl.cols], "png", "PCA of Combined Features")

#### Look at the umap of the different data ####

# Create function for running UMAP
my.umap <- function(data, n_neighbors, name) {
  params <- umap.defaults
  params$n_components <- 3
  params$n_neighbors <- n_neighbors
  
  umap.data <- umap(data, params)
  umap.data.df <- umap.data$layout
  write.csv(umap.data.df, file=paste(getwd(), "/", umap.output.dir, "/", name, ".csv", sep=""),
            row.names=TRUE)
  return(umap.data)
}

geom.umap.10.nn <- my.umap(geometric.data[,3:ncol(geometric.data)], n_neighbors=10, 
                           name="geometric_umap_10_perp")
geom.umap.30.nn <- my.umap(geometric.data[,3:ncol(geometric.data)], n_neighbors=30, 
                           name="geometric_umap_30_perp")
geom.umap.50.nn <- my.umap(geometric.data[,3:ncol(geometric.data)], n_neighbors=50, 
                           name="geometric_umap_50_perp")
geom.umap.70.nn <- my.umap(geometric.data[,3:ncol(geometric.data)], n_neighbors=70, 
                           name="geometric_umap_70_perp")


cc.pairs.plots(geom.umap.10.nn$layout, substring(umap.output.dir, 2), "umap.10.nn", 
               geometric.data[,lbl.cols], "png", "UMAP of Geometric Features")
cc.pairs.plots(geom.umap.30.nn$layout, substring(umap.output.dir, 2), "umap.30.nn", 
               geometric.data[,lbl.cols], "png", "UMAP of Geometric Features")
cc.pairs.plots(geom.umap.50.nn$layout, substring(umap.output.dir, 2), "umap.50.nn", 
               geometric.data[,lbl.cols], "png", "UMAP of Geometric Features")
cc.pairs.plots(geom.umap.70.nn$layout, substring(umap.output.dir, 2), "umap.70.nn", 
               geometric.data[,lbl.cols], "png", "UMAP of Geometric Features")
