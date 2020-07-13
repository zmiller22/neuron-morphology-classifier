library(nat)
library(magick)

# Set paths
nrns.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/neurons/mirrored_left"
lbl.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/metadata.csv"
gmm.class.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/Mclust_analysis/gmm_model_classifications/nt_lbled_nrns.csv"

# Read neurons and labels
nrns <- read.neurons(nrns.path, format="swc")
lbl.df <- read.csv(lbl.path, row.names=1)
gmm.class.df <- read.csv(gmm.class.path, row.names=1)

combined.df <- merge(lbl.df, gmm.class.df, by="row.names", all=TRUE)

# Attach metadata to neuron list
nrns[,] <- combined.df
nt.nrns <- subset(nrns, gal4=="vGlut2a"|gal4=="Gad1b (mpn155)")
glut.nrns <- subset(nrns, gal4=="vGlut2a")
gad.nrns <- subset(nrns, gal4=="Gad1b (mpn155)")

class.legend.txt <- c("GMM Class 1", "GMM Class 2")
class.legend.colors <- c("black", "red")

# Plot all gad neurons with GMM class colors
open3d()
rgl.viewpoint(theta=0, phi=-60, interactive=FALSE)
par3d(windowRect = c(0, 0, 1000, 800)) # make the window large
par3d(zoom = 0.8) # larger values make the image smaller
plot3d(gad.nrns, color=gad.nrns[,"classification"], soma=TRUE)
legend3d("topright", 
        fill=class.legend.colors, 
        legend=class.legend.txt,
        cex=2)

# Save gad neurons with GMM class colors to a gif
movie3d(
  movie="/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots/gmm_gad_nrns_class_lbls", 
  spin3d( axis = c(0, 0, 1), rpm = 4),
  duration = 15, 
  dir = "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots",
  type = "gif", 
  clean = TRUE
)

# Plot all glut neurons with GMM class colors
open3d()
rgl.viewpoint(theta=0, phi=-60, interactive=FALSE)
par3d(windowRect = c(0, 0, 1000, 800)) # make the window large
par3d(zoom = 0.8) # larger values make the image smaller
plot3d(glut.nrns, color=glut.nrns[,"classification"], soma=TRUE)
legend3d("topright", 
         fill=class.legend.colors, 
         legend=class.legend.txt,
         cex=2)

# Save glut neurons with GMM class colors to a gif
movie3d(
  movie="/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots/gmm_glut_nrns_class_lbls", 
  spin3d( axis = c(0, 0, 1), rpm = 4),
  duration = 15, 
  dir = "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots",
  type = "gif", 
  clean = TRUE
)
