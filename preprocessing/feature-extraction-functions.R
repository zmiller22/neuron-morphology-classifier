library(nat)
library(reticulate)

get.spatial.features <- function(nrns) {
  #TODO add option to pick features
  
  col.names <- list("somaX", "somaY", "somaZ", "nrnX", "nrnY", "nrnZ")
  row.names <- list()
  
  # Create an empty dataframe with column names
  df <- data.frame(matrix(nrow=0, ncol=6))
  colnames(df) <- col.names
  
  # Iterate over all the neurons in the neuron list
  for (nrn in nrns) {
    nrn.data <- nrn$d
    nrn.name <- nrn$NeuronName
    
    # Get soma avg. coordinates
    soma.X <- mean(nrn.data[ which(nrn.data$Label==1), ]$X)
    soma.Y <- mean(nrn.data[ which(nrn.data$Label==1), ]$Y)
    soma.Z <- mean(nrn.data[ which(nrn.data$Label==1), ]$Z)
    
    # Get neuron avg. coordinates
    nrn.X <- mean(nrn.data$X)
    nrn.Y <- mean(nrn.data$Y)
    nrn.Z <- mean(nrn.data$Z)
    
    # Keep track of the names for rows
    row.names <- append(row.names, nrn.name)
    
    # Add new row of features to the dataframe
    feature.list <- list(soma.X, soma.Y, soma.Z, nrn.X, nrn.Y, nrn.Z)
    df[nrow(df)+1,] = feature.list
  }
  
  # Set the row names of the dataframe to the neuron names for easy column
  # merging with other files
  rownames(df) <- row.names
  
  return(df)
}

get.geometric.features <- function(input.dir, output.path=0) {
  #TODO add option to select only specific features
  #TODO figure out a way to make sure reticulate finds the proper python
  # installation on different peoples systems
  
  use_condaenv("neuron_classifier")
  source_python("/home/zack/Desktop/Lab_Work/Projects/neuron-morphology-classifier/preprocessing/get-geometric-data.py")
  
  df <- getGeometricFeatureDF(input.dir, output.path)
  
  return(df)
}