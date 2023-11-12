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

  # Connect with API----
  register_google(
    key = Sys.getenv("GGMAP_GOOGLE_API_KEY"),
    account_type = "standard"
  )

  # Download map----
  map <- get_map(location = if(is.null(center)) {
                              center <-  c(lon = mean(longitude), lat = mean(latitude))
                              } else {center <- center},
                 zoom = zoom_factor, maptype = maptype, scale = scale_factor, source = map_source)

  # Plot map----
  ggmap(map) + 
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



plot_feed_comp <- function(data_to_plot) {
  
  # Create indicator lines----
  q1 <- plyr::ddply(data_to_plot, "name", summarise,
                    grp.q1 = quantile(value, probs = 0.25, na.rm = TRUE))
  med <- plyr::ddply(data_to_plot, "name", summarise, 
                     grp.median = median(value, na.rm = TRUE))
  mea <- plyr::ddply(data_to_plot, "name", summarise, 
                     grp.mean = mean(value, na.rm = TRUE))
  q3 <- plyr::ddply(data_to_plot, "name", summarise,
                    grp.q3 = quantile(value, probs = 0.75, na.rm = TRUE))
  # Create plot----
  data_to_plot %>% 
    ggplot(aes(x = value, fill = name)) + 
    geom_density(alpha = 0.5) +
    facet_wrap(facets = vars(name), 
               scales = "free") +
    geom_vline(data = q1, aes(xintercept = grp.q1), linetype = "dashed") +
    geom_vline(data = med, aes(xintercept = grp.median), linetype = "solid") +
    geom_vline(data = mea, aes(xintercept = grp.mean), linetype = "solid", color = "red") +
    geom_vline(data = q3, aes(xintercept = grp.q3), linetype = "dashed") + 
    theme_bw() +
    theme(legend.position = "none")
}
