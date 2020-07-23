library(nat)

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