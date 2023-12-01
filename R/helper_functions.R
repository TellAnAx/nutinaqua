process_col <- function(column1 = col1, column2 = col2, data = dta){
  dta %>%
    rstatix::tukey_hsd(as.formula(paste0(column1," ~ ", column2)))
}

map_dfr(names(iris)[1:4], "Species", process_col, data = iris)
