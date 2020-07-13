library(tsne)

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

X <- data.matrix(combined.df[,2:101])
X.tsne <- tsne(X, k=5)

tsne.data <- data.frame(X.tsne)
row.names(tsne.data) <- combined.df$Row.names
write.csv(tsne.data, file="/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/nblast/nblast_mds/nblast_dists_left_mds_100_tsne_5_062920.csv")

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

# Create PVPN subtype label groups
sct <- NA
sct[is.na(ct.lbls)] <- 1
sct[grep('PVPN Class 1', ct.lbls, fixed=FALSE)] <- 2
sct[grep('PVPN Class 2', ct.lbls, fixed=FALSE)] <- 3
sct[grep('PVPN Class 3', ct.lbls, fixed=FALSE)] <- 4
sct[grep('PVPN Class 4', ct.lbls, fixed=FALSE)] <- 5
sct[grep('PVPN Class 5', ct.lbls, fixed=FALSE)] <- 6
sct[grep('PVPN Class 6a', ct.lbls, fixed=FALSE)] <- 7
sct[grep('PVPN Class 6b', ct.lbls, fixed=FALSE)] <- 8
sct[grep('PVPN Class 7', ct.lbls, fixed=FALSE)] <- 9

# Set some paramters
nt.colors <- c(rgb(0.8,0.8,0.8,0.1), "purple", "red")
nt.styles <- c(1, 3, 4, 18, 16)
nt.legend.txt <- c("Unknown", "Gad1b", "vGlut2a")

ct.colors <- c(rgb(0.8,0.8,0.8,0.1), "purple", "red", "blue", "cyan")
ct.styles <- c(1, 15, 17, 18, 16)
ct.legend.txt <- c("Unkown", "PVPN Cells", "Eurydendroid Cells", "Mitral Cells", "Retinal Ganglion Cells")

sct.colors <- c(rgb(0.8,0.8,0.8,0.1), "purple", "red", "blue", "orange", "brown", "magenta", 
                "yellow", "cyan")
sct.styles <- c(1, 3, 4, 15, 16, 17, 18, 3, 4, 3)
sct.legend.txt <- c("Unkown", "PVPN Class 1", "PVPN Class 2","PVPN Class 3","PVPN Class 4",
                    "PVPN Class 5","PVPN Class 6a","PVPN Class 6b","PVPN Class 7")

# Plot pairs plot with nt labels
png("plots/300_dim_tsne_colored_nt_5v.png", width=20, height=15, units="in", res=300)
pairs(X.tsne,
      main="TSNE of 300 NBLAST MDS dimensions",
      col=nt.colors[nt],
      pch=nt.styles[nt],
      oma=c(3,3,5,15))
par(xpd=TRUE)
legend("topright", 
       fill=nt.colors,
       legend=nt.legend.txt)
dev.off()

# Plot pairs plot with ct labels
png("plots/300_dim_tsne_colored_ct_5v.png", width=20, height=15, units="in", res=300)
pairs(X.tsne,
      main="TSNE of 300 NBLAST MDS dimensions",
      col=ct.colors[ct],
      pch=ct.styles[ct],
      oma=c(3,3,5,18))
par(xpd=TRUE)
legend("topright", 
       fill=ct.colors, 
       legend=ct.legend.txt,
       cex=0.75)
dev.off()

# Plot with neurotransmitter labels colored
png("plots/300_dim_tsne_colored_sct_5v.png", width=20, height=15, units="in", res=300)
pairs(X.tsne,
      main="TSNE of 300 NBLAST MDS dimensions",
      col=sct.colors[sct],
      pch=sct.styles[sct],
      oma=c(3,3,5,18))
par(xpd=TRUE)
legend("topright", 
       fill=sct.colors, 
       legend=sct.legend.txt, 
       cex=0.75)
dev.off()

# Plot pairs plot with nt labels
png("plots/300_dim_tsne_colored_nt_5v_ds.png", width=12, height=8, units="in", res=300)
pairs(X.tsne,
      main="TSNE of 300 NBLAST MDS dimensions",
      col=nt.colors[nt],
      pch=nt.styles[nt],
      oma=c(3,3,5,15))
par(xpd=TRUE)
legend("topright", 
       fill=nt.colors,
       legend=nt.legend.txt)
dev.off()

# Plot pairs plot with ct labels
png("plots/300_dim_tsne_colored_ct_5v_ds.png", width=12, height=8, units="in", res=300)
pairs(X.tsne,
      main="TSNE of 300 NBLAST MDS dimensions",
      col=ct.colors[ct],
      pch=ct.styles[ct],
      oma=c(3,3,5,18))
par(xpd=TRUE)
legend("topright", 
       fill=ct.colors, 
       legend=ct.legend.txt,
       cex=0.75)
dev.off()

# Plot with neurotransmitter labels colored
png("plots/300_dim_tsne_colored_sct_5v_ds.png", width=12, height=8, units="in", res=300)
pairs(X.tsne,
      main="TSNE of 300 NBLAST MDS dimensions",
      col=sct.colors[sct],
      pch=sct.styles[sct],
      oma=c(3,3,5,18))
par(xpd=TRUE)
legend("topright", 
       fill=sct.colors, 
       legend=sct.legend.txt, 
       cex=0.75)
dev.off()


