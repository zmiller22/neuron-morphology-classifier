library(nat)
library(parallel)
library(rstudioapi)

setwd(dirname(getActiveDocumentContext()$path))
source("preprocessing-functions.R")

## Take first command line argument as the input directory and the second command line argument as the
## base output directory that will contain all the outputs
#args <- commandArgs(trailingOnly=TRUE)
#input.dir <- args[1]
#output.dir.base <- args[2]

# Testing only 
input.dir <- "/home/zack/Desktop/Lab_Work/Data/neuron_morphologies/Zebrafish/aligned_040120/MPIN_neurons"
output.dir <- "/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/testing"

# Check to make sure directories into which generated files will be placed exist, if not then create
# them
ifelse(!dir.exists(paste(output.dir, "/graphs", sep="")), 
       dir.create(file.path(paste(output.dir, "/graphs", sep=""))), FALSE)

ifelse(!dir.exists(paste(output.dir, "/fvs", sep="")), 
       dir.create(file.path(paste(output.dir, "/fvs", sep=""))), FALSE)

# Read in neurons into a neuron.list
in.nrns <- read.neurons(input.dir, format="swc")

# Iterate over neuron.list in paralell and calculate all the 
invisible(mclapply(in.nrns, convert.nrn, base.path=output.dir, mc.cores=10))
