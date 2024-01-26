# WATER DATA-----------------------------------
data$water_cleaned <- data$water[[1]] %>% 
  drop_na(gps) %>% 
  distinct(city, source, .keep_all = TRUE) %>% 
  write_rds(here("output", "interm", "water_cleaned.rds"))



# MAP PLOT-----------------------------------
gps_coordinates <- tibble(gps = data$water_cleaned$gps,
                          location = data$water_cleaned$location,
                          city = data$water_cleaned$city,
                          country = data$water_cleaned$country,
                          source = data$water_cleaned$source) %>%
  separate(gps, into = c("latitude", "longitude"),
           sep = ", ", convert = TRUE) %>% 
  write_rds(here("output", "interm", "gps_coordinates.rds"))



# FEED PLOT-----------------------------------
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



# FEEDSTUFF DATA-----------------------------------
