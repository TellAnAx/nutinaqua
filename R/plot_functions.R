
plot_google_map <- function(data,
                            longitude,
                            latitude,
                            center = NULL,
                            shape_variable = NULL,
                            fill_variable = NULL,
                            maptype = "terrain",
                            scale_factor = 2,
                            zoom_factor = 2,
                            map_source = "google") {

  # Connect with API
  register_google(
    key = Sys.getenv("GGMAP_GOOGLE_API_KEY"),
    account_type = "standard"
  )

  # Download map
  map <- get_map(location = if(is.null(center)) {
                              center <-  c(lon = mean(longitude), lat = mean(latitude))
                              } else {center <- center},
                 zoom = zoom_factor, maptype = maptype, scale = scale_factor, source = map_source)

  ggmap(map) + # Plot map
    geom_point(data = data,
      aes(x = longitude, y = latitude,
          fill = as.factor(fill_variable), alpha = 0.8), size = 3, shape = ifelse(is.null(shape_variable),
                                                                                   21,
                                                                                   as.factor(shape_variable))) +
    guides(fill = FALSE, alpha = FALSE, size = FALSE) +
    labs(x = "longitude", y = "latitude")

}
