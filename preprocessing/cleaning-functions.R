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
  
  nrns <- read.neurons(input.dir, format="swc")
  
  for(nrn in nrns) {
    
  }
}