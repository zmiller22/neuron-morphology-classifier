library(mclust)
library(parallel)

#### Load data and format with labels ####
lbl.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/metadata.csv"
mds.dist.left.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/nblast/nblast_mds/nblast_dists_left_mds_062220.csv"

# Load mds results and labels
mds.dist.left <- read.csv(file=mds.dist.left.path, row.names=1)
lbl.df <- read.csv(file=lbl.path, row.names=1)

# Merge into one df
combined.df <- merge(mds.dist.left,lbl.df[c("cell_type","gal4")], by="row.names", all.x=FALSE)

# Convert datatypes of columns from factors to strings
fct.cols <- sapply(combined.df, is.factor)
combined.df[,fct.cols] <- sapply(combined.df[,fct.cols], as.character)

# Check results 
head(combined.df)

# Get all neurotransmitter labels
nt.lbls <- combined.df$gal4[which(combined.df$gal4=="Gad1b (mpn155)" | combined.df$gal4=="vGlut2a")]


#### Run Mclust for 2-100 MDS dimensions
X <- data.matrix(combined.df[,2:101])
func <- function(i, x=X) {return(list(Mclust(x[,1:i], G=2, modelName="VEV")))}
mod.vec <- mcmapply(func, i=2:100, mc.cores=10)
drmod.vec <- mclapply(mod.vec, MclustDR, lambda=1, mc.cores=10)

ari.vec <- c()
for (mod in mod.vec) {
  # Get only predictions for cells with labels
  class.preds <- mod$classification[which(combined.df$gal4=="Gad1b (mpn155)" | combined.df$gal4=="vGlut2a")]
  
  # Calculate and save ARI
  ari <- adjustedRandIndex(nt.lbls, class.preds)
  ari.vec <- c(ari.vec, ari)
}


plot(2:100, ari.vec, type="o",
     main="MDS Dimensions vs ARI",
     ylab="ARI",
     xlab="MDS Dimensions")

#### Run Mclust for 2-100 MDS dimensions for only labeled data ####
Y <- data.matrix(combined.df[which(combined.df$gal4=="Gad1b (mpn155)" | combined.df$gal4=="vGlut2a"), 2:101])

func <- function(i, x=Y) {return(list(Mclust(x[,1:i], G=2, modelName="VEV")))}
mod.vec.nt <- mcmapply(func, i=2:100, mc.cores=10)
drmod.vec.nt <- mclapply(mod.vec.nt, MclustDR, lambda=1, mc.cores=10)

ari.vec.nt <- c()
for (mod in mod.vec.nt) {
  # Get only predictions for cells with labels
  class.preds <- mod$classification
  
  # Calculate and save ARI
  ari <- adjustedRandIndex(nt.lbls, class.preds)
  ari.vec.nt <- c(ari.vec.nt, ari)
}


plot(2:100, ari.vec.nt, type="o",
     main="MDS Dimensions vs ARI (labeled data only)",
     ylab="ARI",
     xlab="MDS Dimensions")

#### Write out the best ARI models for all neurons and labeled only ####
best.mod <- mod.vec[[which.max(ari.vec)]]
best.mod.nt <- mod.vec.nt[[which.max(ari.vec.nt)]]

class.df <- data.frame(best.mod["classification"])
row.names(class.df) <- combined.df$Row.names
write.csv(class.df, "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/Mclust_analysis/gmm_model_classifications/all_nrns.csv")

class.nt.df <- data.frame(best.mod.nt["classification"])
row.names(class.nt.df) <- combined.df$Row.names[which(combined.df$gal4=="Gad1b (mpn155)" | combined.df$gal4=="vGlut2a")]
write.csv(class.nt.df, "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/Mclust_analysis/gmm_model_classifications/nt_lbled_nrns.csv")
