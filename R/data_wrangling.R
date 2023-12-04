# DATA WRANGLING FOR MAP PLOT-----------------------------------
gps_coordinates <- tibble(gps = data$water_tap[[1]]$GPS,
                          location = data$water_tap[[1]]$Location,
                          city = data$water_tap[[1]]$City,
                          country = data$water_tap[[1]]$Country,
                          source = data$water_tap[[1]]$Source) %>%
  drop_na(gps) %>%
  distinct(city, .keep_all = TRUE) %>%
  separate(gps, into = c("latitude", "longitude"),
           sep = ", ", convert = TRUE)



# DATA WRANGLING FOR FEED PLOT-----------------------------------
create_plot_data <- function(data_to_wrangle) {
  
  # Create dataset----
  data_to_wrangle %>% 
    pivot_longer(
      cols = c(P_gkg:Cu_mgkg, N_gkg),
      names_to = "name",
      values_to = "value"
    ) %>% 
    mutate(name = factor(name))
}
