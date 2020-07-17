library(nat)

remove.unflipped <- function(input.dir, output.dir, axis="x", value=284,
                             nrn.side="right") {
  nrns <- read.neurons(input.dir, format="swc")
  
  soma.coords <- list()
  
  for(nrn in nrns) {
    nrn.data <- nrn$d
    nrn.name <- nrn$NeuronName
    soma.x <- mean(nrn.data[ which(nrn.data$Label==1),]$X)
    soma.coords[[nrn.name]] <- soma.x
  }
  
  bad.nrn.names <- names(soma.coords[soma.coords>284])
  good.nrns <- nrns[names(nrns)!=bad.nrn.names]
  
  return(soma.coords)

}

fix.compartment.lbls <- function(input.dir, output.dir) {
  #' Function that will fix erroneous compratment labels for .swc files obtained
  #' from MPIN. This fixed neurons with all comprartments marked as somas, and
  #' compartment labels that are 0 instead of 6
  #' @param input.dir Path the the directory containing neurons to be fixed
  #' @param output.dir Path to the directory for the fixed neurons to be written
  #' to

  nrns <- read.neurons(input.dir, format="swc")
  
  for(nrn in nrns) {
    nrn.data <- nrn$d
    
    # Check for neurons where all compartment labels are the same and fix
    if(var(nrn.data$Label)==0) {
      nrn.data$Label[1] <- 1
      nrn.data$Label[-1] <- 6
    }
    
    # Fix incorrect compartment labels
    nrn.data$Label[nrn.data$Label==0] <- 6
    
    # Add fixed data back to neuron object
    nrn$d <- nrn.data
    
    # write fixed neuron to the new directory
    write.neuron(nrn, dir=output.dir, normalise.ids=TRUE)
  }
}