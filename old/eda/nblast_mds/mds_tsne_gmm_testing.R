library(mclust)

lbl.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/metadata.csv"
mds.tsne.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/nblast/nblast_mds/nblast_dists_left_mds_100_tsne_5_062920.csv"
# Load mds results and labels
mds.tsne <- read.csv(file=mds.tsne.path, row.names=1)
lbl.df <- read.csv(file=lbl.path, row.names=1)

# Merge into one df
combined.df <- merge(mds.tsne,lbl.df[c("cell_type","gal4")], by="row.names", all.x=FALSE)

# Check results 
head(combined.df)

# Create neurotransmitter label groups
nt.lbls <- combined.df$gal4
nt <- NA
nt[nt.lbls!="vGlut2a" & nt.lbls!="Gad1b"] <- 1
nt[is.na(nt)] <- 1
nt[nt.lbls=="Gad1b (mpn155)"] <- 2
nt[nt.lbls=="vGlut2a"] <- 3

# Create cell type label groups
ct.lbls <- combined.df$cell_type
ct <- NA
ct[is.na(ct.lbls)] <- 1
ct[grep('PVPN', ct.lbls, fixed=FALSE)] <- 2
ct[ct.lbls=="Eurydendroid Cells"] <- 3
ct[ct.lbls=="Mitral Cells"] <- 4
ct[ct.lbls=="Retinal Ganglion Cells"] <- 5

# Create all data labels
ant <- NA
ant[nt.lbls!="vGlut2a" & nt.lbls!="Gad1b"] <- 1
ant[is.na(nt)] <- 1
ant[nt.lbls=="Gad1b (mpn155)"] <- 2
ant[nt.lbls=="vGlut2a"] <- 3
ant[grep('PVPN', ct.lbls, fixed=FALSE)] <- 2
ant[ct.lbls=="Eurydendroid Cells"] <- 3
ant[ct.lbls=="Mitral Cells"] <- 3
ant[ct.lbls=="Retinal Ganglion Cells"] <- 3



# Check that the numbers of each are roughly correct
table(ct)

# Check that the numbers of each are roughly correct
table(nt)

X <- data.matrix(combined.df[,2:6])
mod <- Mclust(X, G=1:100, modelNames="VVV")
summary(mod)

plot(mod, what="BIC", ylim = range(mod$BIC, na.rm = TRUE),
     legendArgs = list(x = "bottomright"), main="Mclust Model Fits", oma=c(3,3,10,18))

drmod <- MclustDR(mod, lambda = 1)
summary(drmod)