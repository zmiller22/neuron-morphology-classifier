library(nat)
library(magick)

# Set paths
nrns.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/neurons/mirrored_left"
lbl.path <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/data/metadata.csv"

# Read neurons and labels
nrns <- read.neurons(nrns.path, format="swc")
lbl.df <- read.csv(lbl.path, row.names=1)

# Convert datatypes of columns from factors to strings
fct.cols <- sapply(lbl.df, is.factor)
lbl.df[,fct.cols] <- sapply(lbl.df[,fct.cols], as.character)

# Attach metadata to neuron list
nrns[,] <- lbl.df

# Get all neuron type subsets
ec.nrns <- subset(nrns, cell_type=="Eurydendroid Cells")
mc.nrns <- subset(nrns, cell_type=="Mitral Cells")
rgc.nrns <- subset(nrns, cell_type=="Retinal Ganglion Cells")
pvpn.nl.nrns <- subset(nrns, cell_type=="PVPN")
pvpn.1.nrns <- subset(nrns, cell_type=="PVPN Class 1")
pvpn.2.nrns <- subset(nrns, cell_type=="PVPN Class 2")
pvpn.3.nrns <- subset(nrns, cell_type=="PVPN Class 3")
pvpn.4.nrns <- subset(nrns, cell_type=="PVPN Class 4")
pvpn.5.nrns <- subset(nrns, cell_type=="PVPN Class 5")
pvpn.6a.nrns <- subset(nrns, cell_type=="PVPN Class 6a")
pvpn.6b.nrns <- subset(nrns, cell_type=="PVPN Class 6b")
pvpn.7.nrns <- subset(nrns, cell_type=="PVPN Class 7")
glut.nrns <- subset(nrns, gal4=="vGlut2a")
gad.nrns <- subset(nrns, gal4=="Gad1b (mpn155)")

# Create some plotting parameters
ct.colors <- c("purple", "red", "blue", "cyan")
ct.styles <- c(1, 15, 17, 18, 16)
ct.legend.txt <- c("PVPN Cells", "Eurydendroid Cells", "Mitral Cells", "Retinal Ganglion Cells")

nt.colors <- c("purple", "red")
nt.styles <- c(1, 3, 4, 18, 16)
nt.legend.txt <- c("Gad1b", "vGlut2a")

sct.colors <- c("purple", "red", "blue", "orange", "brown", "magenta", 
                "yellow", "cyan")
sct.styles <- c(1, 3, 4, 15, 16, 17, 18)
sct.legend.txt <- c("PVPN Class 1", "PVPN Class 2","PVPN Class 3","PVPN Class 4",
                    "PVPN Class 5","PVPN Class 6a","PVPN Class 6b","PVPN Class 7")



# Plot all PVPN subtypes with different colors
open3d()
plot3d(pvpn.1.nrns, soma=TRUE, color="purple")
plot3d(pvpn.2.nrns, soma=TRUE, color="red")
plot3d(pvpn.3.nrns, soma=TRUE, color="blue")
plot3d(pvpn.4.nrns, soma=TRUE, color="orange")
plot3d(pvpn.5.nrns, soma=TRUE, color="brown")
plot3d(pvpn.6a.nrns, soma=TRUE, color="magenta")
plot3d(pvpn.6b.nrns, soma=TRUE, color="yellow")
plot3d(pvpn.7.nrns, soma=TRUE, color="cyan")

# Plot PVPN class 3 vs 5
open3d()
plot3d(gad.nrns, soma=TRUE, color="purple")
plot3d(glut.nrns, soma=TRUE, color="red")

# Plot PVPN class 3 vs 4
open3d()
plot3d(pvpn.3.nrns, soma=TRUE, color="blue")
plot3d(pvpn.4.nrns, soma=TRUE, color="orange")

# Plot all gad and glut neurons
open3d()
rgl.viewpoint(theta=0, phi=-60, interactive=FALSE)
par3d(windowRect = c(0, 0, 1000, 800)) # make the window large
par3d(zoom = 0.8) # larger values make the image smaller
plot3d(gad.nrns, soma=TRUE, color="purple")
plot3d(glut.nrns, soma=TRUE, color="red")
legend3d("topright", 
         fill=nt.colors, 
         legend=nt.legend.txt,
         cex=2)
#play3d( spin3d( axis = c(0, 0, 1), rpm = 6), duration=10 )

# Save all gad and glut neurons to a gif
movie3d(
  movie="/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots/nt", 
  spin3d( axis = c(0, 0, 1), rpm = 4),
  duration = 15, 
  dir = "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots",
  type = "gif", 
  clean = TRUE
)

# Plot all neuron types
open3d()
rgl.viewpoint(theta=0, phi=-60, interactive=FALSE)
par3d(windowRect = c(0, 0, 1000, 800)) # make the window large
par3d(zoom = 0.8) # larger values make the image smaller
plot3d(pvpn.1.nrns, soma=TRUE, color="purple")
plot3d(pvpn.2.nrns, soma=TRUE, color="purple")
plot3d(pvpn.3.nrns, soma=TRUE, color="purple")
plot3d(pvpn.4.nrns, soma=TRUE, color="purple")
plot3d(pvpn.5.nrns, soma=TRUE, color="purple")
plot3d(pvpn.6a.nrns, soma=TRUE, color="purple")
plot3d(pvpn.6b.nrns, soma=TRUE, color="purple")
plot3d(pvpn.7.nrns, soma=TRUE, color="purple")
plot3d(ec.nrns, soma=TRUE, color="red")
plot3d(mc.nrns, soma=TRUE, color="blue")
plot3d(rgc.nrns, soma=TRUE, color="cyan")
legend3d("topright", 
       fill=ct.colors, 
       legend=ct.legend.txt,
       cex=1.5)
#play3d( spin3d( axis = c(0, 0, 1), rpm = 6), duration=10 )

# Save all gad and glut neurons to a gif
movie3d(
  movie="/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots/nt", 
  spin3d( axis = c(0, 0, 1), rpm = 4),
  duration = 15, 
  dir = "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots",
  type = "gif", 
  clean = TRUE
)

# Plot all PVPN subtypes
open3d()
rgl.viewpoint(theta=0, phi=-60, interactive=FALSE)
par3d(windowRect = c(0, 0, 1000, 800)) # make the window large
par3d(zoom = 0.8) # larger values make the image smaller
plot3d(pvpn.1.nrns, soma=TRUE, color="purple")
plot3d(pvpn.2.nrns, soma=TRUE, color="red")
plot3d(pvpn.3.nrns, soma=TRUE, color="blue")
plot3d(pvpn.4.nrns, soma=TRUE, color="orange")
plot3d(pvpn.5.nrns, soma=TRUE, color="brown")
plot3d(pvpn.6a.nrns, soma=TRUE, color="magenta")
plot3d(pvpn.6b.nrns, soma=TRUE, color="yellow")
plot3d(pvpn.7.nrns, soma=TRUE, color="cyan")
legend3d("topright", 
         fill=sct.colors, 
         legend=sct.legend.txt,
         cex=1.5)
play3d( spin3d( axis = c(0, 0, 1), rpm = 6), duration=10 )

# Save all gad and glut neurons to a gif
movie3d(
  movie="/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots/sct", 
  spin3d( axis = c(0, 0, 1), rpm = 4),
  duration = 15, 
  dir = "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/eda/neruon_visualization/plots",
  type = "gif", 
  clean = TRUE
)

