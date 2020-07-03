library(nat)
library(parallel)
library(rstudioapi)

# Set working directory to the current path and import preprocessing functions
setwd(dirname(getActiveDocumentContext()$path))
source("../../preprocessing/preprocessing-functions.R")

nrns.path <- "../neurons/mirrored_right"
nblast.csv.path <- "nblast_aba_distance.csv"
mds.csv.path <- "nblast_mds_all_dims.csv"
lbls.path <- "../metadata.csv"

# Read in the data
nrns <- read.neurons(nrns.path, format="swc")

# Calculate pairwise distances between neurons with NBLAST
nblast.dists <- my.nblast(nrns, nblast.csv.path, method="distance", norm.method="mean")

# Perform MDS on NBLAST distance matrix
nblast.mds <- my.nblast.mds(nblast.csv.path, mds.csv.path, k=0)




