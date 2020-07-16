library(nat)
library(rstudioapi)
library(rgl)

setwd(dirname(getActiveDocumentContext()$path))
source("../../visualization/visualization-functions.R")


nrns.path <- "../../data/neurons/mirrored_right"
updated.lbls.path <- "updated_lbls.csv"

# Read neurons and labels
nrns <- read.neurons(nrns.path, format="swc")
lbl.df <- read.csv(updated.lbls.path, row.names=1)

# Add nt labels to the dataframe
nt.lbls <- lbl.df$gal4
nt <- NA
nt[nt.lbls!="vGlut2a" & nt.lbls!="Gad1b"] <- 1
nt[is.na(nt)] <- 1
nt[nt.lbls=="Gad1b (mpn155)"] <- 2
nt[nt.lbls=="vGlut2a"] <- 3

lbl.df$nt <- nt

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

# Get all the class nrns
class.nrns.list <- list()
for (class in sort(unique(na.omit(nrns[,]$y)))) {
  class.name <- paste("class", toString(class))
  class.nrns <- subset(nrns, y==class)
  class.nrns.list[[class.name]] <- class.nrns
}

nt.colors <- c(rgb(0.8,0.8,0.8,0.1), "purple", "red")

#### Create some useful functions ####

# Get all the neurons of a class and their colors
get.class.nrns <- function(class.num) {
  class <- paste("class", as.character(class.num))
  nrns <- class.nrns.list[[class]]
  colors <- nt.colors[class.nrns.list[[class]][,"nt"]]
  print(colors)
  
  return(list(nrns, colors))
}

# Create a function for plotting all class neurons color-coded
my.plot <- function(class.num) {
  class <- paste("class", as.character(class.num))
  nrns <- class.nrns.list[[class]]
  colors <- nt.colors[class.nrns.list[[class]][,"nt"]]
  open3d()
  plot3d(nrns, soma=TRUE, color=colors, main=class)
}

# Create a function for making a gif of all class neurons color-coded
make.class.gif <- function(class.num) {
  class <- paste("class", as.character(class.num))
  nrns <- class.nrns.list[[class]]
  colors <- nt.colors[class.nrns.list[[class]][,"nt"]]
  legend.colors <- nt.colors
  legend.txt <- c("Uknown", "Gad1b", "vGlut2a")
  output.dir <- "class_gifs"
  output.name <- paste("class_", as.character(class.num), sep="")
  
  invisible(create.gif(nrns, colors, legend.colors=legend.colors, legend.txt=legend.txt, 
             rotation.angle=3, gif.delay=10, output.dir=output.dir,
             output.name=output.name))
}


