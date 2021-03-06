#' Function to merge the morphology and data on X- and Y-coordinates into one file for further processing
#' 
#' This function merges the files containing morphology and coordinates (one for each video) into large dataset,
#' and saves it to the directory where the single files are located
#' @param to.data path to the working directory
#' @param particle.data.folder directory to which the data is saved as a text file
#' @export

organise_particle_data <- function(to.data, particle.data.folder) {
  
  #pixel_to_scale<-NULL
  
  IJ_output.dir <- paste(to.data, particle.data.folder, sep = "")
  
  ## the macro file names
  all.files <- dir(path = IJ_output.dir, pattern = "ijout", full.names=T)
  ijout.files <- all.files[grep("ijout", all.files)]
  mylist <- lapply(ijout.files, fread, header=T)
  mylist <- mylist[lapply(mylist,length)>0]
  dd <- rbindlist(mylist)
  dd$file <- gsub(".ijout.txt", "", rep(dir(path = IJ_output.dir, pattern = "ijout"), lapply(mylist, nrow)))
  ## change column names because R is replacing missing header with X causing confusion with real X and Y positions
  old_names <- colnames(dd) 
  new_names <- c("obs", "Area", "Mean", "Min", "Max", "X", "Y", "Perimeter", "Major", "Minor", "Angle", "Circ.", "Slice", 
                 "AR", "Round", "Solidity", "file")
  setnames(dd,old_names,new_names)
  
  morphology.data <- as.data.frame(dd)
  
  # convert morphology to real dimensions
  morphology.data$Area <-   morphology.data$Area*pixel_to_scale
  morphology.data$Perimeter <- morphology.data$Perimeter*pixel_to_scale
  morphology.data$Major <- morphology.data$Major*pixel_to_scale
  morphology.data$Minor <-  morphology.data$Minor*pixel_to_scale
  
  save(morphology.data, file = paste(IJ_output.dir, "particle.RData", sep = "/"))
} 

