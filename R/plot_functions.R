
plot_google_map <- function(data,
                            longitude,
                            latitude,
                            longitude_limits, # x-axis
                            latitude_limits, # y-axis
                            center = NULL,
                            shape_variable = 21,
                            fill_variable = "black",
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
          fill = fill_variable,
          alpha = 0.8), 
      size = 3, 
      shape = shape_variable) +
    guides(fill = FALSE, alpha = FALSE, size = FALSE) +
    labs(x = "longitude", y = "latitude") + 
    scale_x_continuous(limits = longitude_limits, expand = c(0,0)) + 
    scale_y_continuous(limits = latitude_limits, expand = c(0,0))

}
