
plot_google_map <- function(data,
                            longitude,
                            latitude,
                            maptype = "terrain",
                            scale_factor = 2,
                            zoom_factor = 2,
                            map_source = "stamen") {

  # Connect with API
  register_google(
    key = Sys.getenv("GOOGLE_MAPS_API_KEY"),
    account_type = "standard"
  )

  # Download map
  map <- get_map(location = c(lon = mean(longitude), lat = mean(latitude)), zoom = zoom_factor,
                 maptype = maptype, scale = scale_factor, source = map_source)

  ggmap(map) + # Plot map
    geom_point(data = data,
      aes(x = longitude, y = latitude,
          fill = "red", alpha = 0.8), size = 5, shape = 21) +
    guides(fill = FALSE, alpha = FALSE, size = FALSE)

}
