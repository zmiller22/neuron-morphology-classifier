library(mclust)
library(rstudioapi)
library(pdfCluster)

# Set working directory to current path
setwd(dirname(getActiveDocumentContext()$path))

# Set paths
lbl.path <- "../../data/metadata.csv"
umap.data.path <- "../../data/feature_vectors_063020/mds_umap_5_dims.csv"
updated.lbls.output.path <- "updated_lbls.csv"
gl.breakdown.output.path <- "gl_breakdown.csv"

#TODO Set output directories and check to make sure they exist

# Read in the data and labels
temp.umap.data <- read.csv(umap.data.path, row.names=1)
temp.lbls <- read.csv(lbl.path, row.names=1)

# Make sure that all the rows are matched and do not include NA number values
combined.df <- transform(merge(temp.umap.data, temp.lbls[c("cell_type","gal4")], by="row.names", all.x=FALSE), 
                         row.names=Row.names, Row.names=NULL)
lbl.vars <- names(combined.df) %in% c("cell_type", "gal4")
umap.data <- combined.df[!lbl.vars]
lbls <- combined.df[lbl.vars]

# Use Mclust() to fit a gaussian mixture model 
mod <- Mclust(umap.data, G=1:100, modelNames="VVV")
saveRDS(object=mod, file = "fitted_model.rds")
summary(mod)

plot(mod, what="BIC", ylim = range(mod$BIC, na.rm = TRUE),
     legendArgs = list(x="bottomright", cex=0.5, pt.cex=1.2), main="Mclust Model Fits", oma=c(3,3,10,18))

# Evaluate model performance
# Create neurotransmitter label groups
nt.lbls <- combined.df$gal4
nt <- NA
nt[nt.lbls!="vGlut2a" & nt.lbls!="Gad1b"] <- 1
nt[is.na(nt)] <- 1
nt[nt.lbls=="Gad1b (mpn155)"] <- 2
nt[nt.lbls=="vGlut2a"] <- 3

# Save data
updated.lbls.full <- transform(merge(temp.lbls, preds, by="row.names", all.x=TRUE), 
                               row.names=Row.names, Row.names=NULL)
write.csv(updated.lbls.full, file=updated.lbls.output.path, row.names=TRUE)

# Get model predictions and attach to the dataframe
preds <- mod$classification
updated.lbls <- transform(merge(lbls, preds, by="row.names", all.x=TRUE), 
                          row.names=Row.names, Row.names=NULL)
updated.lbls$nt <- nt

gl.breakdown <- as.data.frame.matrix(table(nt, preds), 
                                     row.names=c("Unkown", "Gad1b", "vGlut2a"))
write.csv(gl.breakdown, file=gl.breakdown.output.path, row.names=TRUE)

# Calculate ARI
# Get only labeled data
ari.data <- updated.lbls[which(updated.lbls$nt==2 | updated.lbls$nt==3),]
ARI <- adjustedRandIndex(ari.data$y, ari.data$nt)


