
cc.pairs.plots <- function(data, output.dir.path, output.name, lbl.df, output.type, title) {
  #TODO force creation of output directory if it does not exist
  #' Plots three pairs plots of the given data with labels for neurotransmitter type,
  #' cell type, and PVPN cell subtypes
  #' 
  #' @param data A dataframe or matrix of the data to be plotted
  #' @param output.dir.path Path to directory for the plots to be written to
  #' @param lbl.df Dataframe containing metadata on the data to be plotted
  #' @param output.type One of "png" or "pdf" to detirmine plot output type
  #' @param title String to be used as the title for the plots
  
  # Create neurotransmitter label groups
  nt.lbls <- lbl.df$gal4
  nt <- NA
  nt[nt.lbls!="vGlut2a" & nt.lbls!="Gad1b"] <- 1
  nt[is.na(nt)] <- 1
  nt[nt.lbls=="Gad1b (mpn155)"] <- 2
  nt[nt.lbls=="vGlut2a"] <- 3
  
  # Create cell type label groups
  ct.lbls <- lbl.df$cell_type
  ct <- NA
  ct[is.na(ct.lbls)] <- 1
  ct[grep('PVPN', ct.lbls, fixed=FALSE)] <- 2
  ct[ct.lbls=="Eurydendroid Cells"] <- 3
  ct[ct.lbls=="Mitral Cells"] <- 4
  ct[ct.lbls=="Retinal Ganglion Cells"] <- 5
  
  # Create PVPN subtype label groups
  sct <- NA
  sct[is.na(ct.lbls)] <- 1
  sct[grep('PVPN Class 1', ct.lbls, fixed=FALSE)] <- 2
  sct[grep('PVPN Class 2', ct.lbls, fixed=FALSE)] <- 3
  sct[grep('PVPN Class 3', ct.lbls, fixed=FALSE)] <- 4
  sct[grep('PVPN Class 4', ct.lbls, fixed=FALSE)] <- 5
  sct[grep('PVPN Class 5', ct.lbls, fixed=FALSE)] <- 6
  sct[grep('PVPN Class 6a', ct.lbls, fixed=FALSE)] <- 7
  sct[grep('PVPN Class 6b', ct.lbls, fixed=FALSE)] <- 8
  sct[grep('PVPN Class 7', ct.lbls, fixed=FALSE)] <- 9
  
  # Set some plotting parameters
  nt.colors <- c(rgb(0.8,0.8,0.8,0.1), "purple", "red")
  nt.styles <- c(1, 3, 4, 18, 16)
  nt.legend.txt <- c("Unknown", "Gad1b", "vGlut2a")
  
  ct.colors <- c(rgb(0.8,0.8,0.8,0.1), "purple", "red", "blue", "cyan")
  ct.styles <- c(1, 15, 17, 18, 16)
  ct.legend.txt <- c("Unkown", "PVPN Cells", "Eurydendroid Cells", "Mitral Cells", "Retinal Ganglion Cells")
  
  sct.colors <- c(rgb(0.8,0.8,0.8,0.1), "purple", "red", "blue", "orange", "brown", "magenta", 
                  "yellow", "cyan")
  sct.styles <- c(1, 3, 4, 15, 16, 17, 18, 3, 4, 3)
  sct.legend.txt <- c("Unkown", "PVPN Class 1", "PVPN Class 2","PVPN Class 3","PVPN Class 4",
                      "PVPN Class 5","PVPN Class 6a","PVPN Class 6b","PVPN Class 7")
  
  # Create paths for output plots
  dim <- dim(data)[2]
  width <- 4*dim
  height<- 4*dim
  
  if (output.type=="png") {
    # Create output paths
    nt.output.path <- paste(output.dir.path, "/", output.name, "_colored_nt_", dim, "v.png", sep="")
    ct.output.path <- paste(output.dir.path, "/", output.name, "_colored_ct_", dim, "v.png", sep="")
    sct.output.path <- paste(output.dir.path, "/", output.name, "_colored_sct_", dim, "v.png", sep="")
    
    # Plot pairs plot with nt labels
    png(nt.output.path, width=width, height=height, units="in", res=300)
    pairs(data,
          main=title,
          col=nt.colors[nt],
          pch=nt.styles[nt],
          oma=c(3,3,5,15))
    par(xpd=TRUE)
    legend("topright", 
           fill=nt.colors,
           legend=nt.legend.txt)
    dev.off()
    
    # Plot pairs plot with ct labels
    png(ct.output.path, width=width, height=height, units="in", res=300)
    pairs(data,
          main=title,
          col=ct.colors[ct],
          pch=ct.styles[ct],
          oma=c(3,3,5,18),
          cex=0.75)
    par(xpd=TRUE)
    legend("topright", 
           fill=ct.colors,
           legend=ct.legend.txt)
    dev.off()
    
    # Plot pairs plot with sct labels
    png(sct.output.path, width=width, height=height, units="in", res=300)
    pairs(data,
          main=title,
          col=sct.colors[sct],
          pch=sct.styles[sct],
          oma=c(3,3,5,18),
          cex=0.75)
    par(xpd=TRUE)
    legend("topright", 
           fill=sct.colors,
           legend=sct.legend.txt)
    dev.off()
    
  } else if (output.type=="pdf") {
    nt.output.path <- paste(output.dir.path, "/", output.name, "_colored_nt_", dim, "v.pdf", sep="")
    ct.output.path <- paste(output.dir.path, "/", output.name, "_colored_ct_", dim, "v.pdf", sep="")
    sct.output.path <- paste(output.dir.path, "/", output.name, "_colored_sct_", dim, "v.pdf", sep="")
    
    # Plot pairs plot with nt labels
    pdf(nt.output.path)
    pairs(data,
          main=title,
          col=nt.colors[nt],
          pch=nt.styles[nt],
          oma=c(3,3,5,15))
    par(xpd=TRUE)
    legend("topright", 
           fill=nt.colors,
           legend=nt.legend.txt)
    dev.off()
    
    # Plot pairs plot with ct labels
    pdf(ct.output.path)
    pairs(data,
          main=title,
          col=ct.colors[ct],
          pch=ct.styles[ct],
          oma=c(3,3,5,18))
    par(xpd=TRUE)
    legend("topright", 
           fill=ct.colors,
           legend=ct.legend.txt,
           cex=0.5)
    dev.off()
    
    # Plot pairs plot with sct labels
    pdf(sct.output.path)
    pairs(data,
          main=title,
          col=sct.colors[sct],
          pch=sct.styles[sct],
          oma=c(3,3,5,18))
    par(xpd=TRUE)
    legend("topright", 
           fill=sct.colors,
           legend=sct.legend.txt,
           cex=0.5)
    dev.off()
  }
}