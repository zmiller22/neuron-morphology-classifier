#TODO Ensure that masks="none" prevents mask-contingent statstics from being calculated
convert.nrn <- function(nrn, base.path, masks="none", features="all", graphs="true") {
  nrn.name <- nrn$NeuronName
  nrn.graph <- as.ngraph(nrn, weights=TRUE)
  
  #TODO calculate spatial features
  #TODO calculate geometric features
  #TODO save feature vectors
  
  #FIX if this folder does not already exist, it will throw an error
  graph.path <- paste(base.path, "/graphs/", nrn.name, sep="")
  print(graph.path)
  print(nrn.name)
  
  igraph::write_graph(nrn.graph, graph.path, format="gml")
}
