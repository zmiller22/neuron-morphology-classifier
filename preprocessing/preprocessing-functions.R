library(nat)
library(nat.nblast)
library(Rtsne)
library(umap)

#TODO Ensure that masks="none" prevents mask-contingent statstics from being calculated
convert.nrn <- function(nrn, base.path, masks="none", features="all", graphs="true") {
  nrn.name <- nrn$NeuronName
  nrn.graph <- as.ngraph(nrn, weights=TRUE)
  
  #FIX if this folder does not already exist, it will throw an error
  graph.path <- paste(base.path, "/graphs/", nrn.name, sep="")
  print(graph.path)
  print(nrn.name)
  
  igraph::write_graph(nrn.graph, graph.path, format="gml")
}


my.nblast <- function(nrns, out.file.path, method, norm.method) {
  #' Applies NBLAST all-by-all with desired parameters and writes the results to a .csv file.
  #' Returns the NBLAST results as a data.frame
  #' 
  #' @param nrns A nat neuron list object
  #' @param out.file.path Path the .csv file is to be written to 
  #' @param method One of "distance" or "score" for NBLAST calculations
  #' @param norm.method NBLAST all-by-all normalization method to be applied
  
  # Convert neurons to dotprops
  nrns.dps <- dotprops(nrns, stepsize=1, OmitFailures=TRUE)
  
  # Perform NBLAST all-by-all for desired method
  if (method=="distance") {
    nrn.dists <- nblast_allbyall(nrns.dps, distance=TRUE, normalisation=norm.method)
    write.csv(nrn.dists, out.file.path, row.names = TRUE)
    return(nrn.dists)
  } else if (method=="score") {
    nrn.scores <- nblast_allbyall(nrns.dps, distance=FALSE, normalization=norm.method)
    write.csv(nrn.scores, out.file.path, row.names = TRUE)
    return(nrn.scores)
  }
}

my.nblast.mds <- function(in.file.path, out.file.path, k) {
  #' Performs multi-dimensional scaling on a NBLAST distance matrix and writes the results
  #' to a .csv file. Returns the resulting mds object
  #' @param in.file.path Path to the .csv file to be read in
  #' @param out.file.path Path to the .csv file to be written to
  #' @param k Number of mds dimensions to keep, k=0 results in keeping the maximum number
  #' of dimensions
  
  # Read in the neuron distances
  nrn.dists <- read.csv(in.file.path, row.names=1)
  
  # Perfrom MDS and write MDS vectors to .csv
  if (k==0) {
    num.cols <- dim(nrn.dists)[2]
    mds.fit <- cmdscale(nrn.dists, eig=TRUE, k=num.cols-1)
    write.csv(mds.fit$points, out.file.path, row.names=TRUE)
  } else {
    mds.fit <- cmdscale(nrn.dists, eig=TRUE, k=k)
    write.csv(mds.fit$points, out.file.path, row.names=TRUE)
  }
  return(mds.fit)
}

my.tsne <- function(data, out.file.path, dims, initial_dims=50, perplexity=30, 
                 max_iter=1000, pca=TRUE, row.names=1, num_threads=1) {
  #' Applies tsne to a given .csv file and writes the results to another .csv
  #' @param data Data to apply TSNE to
  #' @param out.file.path Path to the .csv file to be written to 
  #' @param dims Number of dimensions TSNE output dimensions
  
  # Apply tsne with specified parameters and write results to .csv
  data.tsne <- Rtsne(data, dims=dims, initial_dims=initial_dims, perplexity=perplexity, 
                     max_iter=max_iter, pca=pca, num_threads=num_threads)
  write.csv(data.tsne, out.file.path, row.names=TRUE)
  
  return(data.tsne)
}

my.umap <- function(data, out.file.path, dims, n_neighbors) {
  params <- umap.defaults
  params$n_components <- dims
  params$n_neighbors <- n_neighbors
  
  umap.data <- umap(data, params)
  umap.data.df <- umap.data$layout
  write.csv(umap.data.df, file=out.file.path, row.names=TRUE)
  return(umap.data)
}

#my.umap <- function(data, out.file.path, )

#TODO create a function that paralellizes the NBLAST all-by-all function, but first
# check with Greg Jeffris to see if this already exists