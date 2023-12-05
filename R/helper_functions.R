# Converts a chemical formula given as character string to 
# a vector of the elements so that the mass function from the PeriodicTable 
# package can replace the elements with the respective molar mass.
convert_formula <- function(formula) {
  # Use regular expression to match elements and their counts
  matches <- gregexpr("[A-Z][a-z]?\\d*", formula)
  
  # Extract matched substrings
  strings <- regmatches(formula, matches)
  
  # Initialize an empty list to store the elements
  elements <- list()
  
  
  for(string_no in 1:length(strings)){
    single_string <- strings[[string_no]]
    
    atoms <- c()
    
  for (substring in single_string) {
      element <- gsub("\\d", "", substring)  # Extract element
      count <- as.numeric(gsub("[A-Za-z]", "", substring))  # Extract count, if any
      
      # If no count is specified, default to 1
      count[is.na(count)] <- 1
      
      atoms <- c(atoms, rep(element, count))
    }
    # Repeat the element according to its count and append to the vector
    elements[[string_no]] <- atoms
  }

  return(elements)
}


#
process_col <- function(column1 = col1, 
                        column2 = col2, 
                        data){
  data %>%
    rstatix::tukey_hsd(as.formula(paste0(column1," ~ ", column2)))
}

map_dfr(names(iris)[1:4], "Species", process_col, data = iris)