### MAP PLOT DATA-----------------------------------
gps_coordinates <- tibble(gps = data$water_tap$GPS,
                          location = data$water_tap$Location,
                          city = data$water_tap$City,
                          country = data$water_tap$Country,
                          source = data$water_tap$Source) %>%
  drop_na(gps) %>%
  distinct(city, .keep_all = TRUE) %>%
  separate(gps, into = c("latitude", "longitude"),
           sep = ", ", convert = TRUE)
