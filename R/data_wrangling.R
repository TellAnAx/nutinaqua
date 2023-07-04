### MAP PLOT DATA-----------------------------------
gps_coordinates <- tibble(gps = data$water$GPS,
                              location = data$water$Location,
                              city = data$water$City,
                              country = data$water$Country) %>%
  drop_na() %>%
  distinct(city, .keep_all = TRUE) %>%
  separate(gps, into = c("latitude", "longitude"),
           sep = ", ", convert = TRUE)
