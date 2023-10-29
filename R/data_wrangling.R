### MAP PLOT DATA-----------------------------------
gps_coordinates <- tibble(gps = data$water_tap[[1]]$GPS,
                          location = data$water_tap[[1]]$Location,
                          city = data$water_tap[[1]]$City,
                          country = data$water_tap[[1]]$Country,
                          source = data$water_tap[[1]]$Source) %>%
  drop_na(gps) %>%
  distinct(city, .keep_all = TRUE) %>%
  separate(gps, into = c("latitude", "longitude"),
           sep = ", ", convert = TRUE)
