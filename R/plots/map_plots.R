plot_google_map(data = gps_coordinates, 
                longitude = gps_coordinates$longitude, 
                latitude = gps_coordinates$latitude,
                longitude_limits = c(-11.5,38),
                latitude_limits = c(35,65),
                #shape_variable = gps_coordinates$country,
                fill_variable = gps_coordinates$source,
                center = c(10.08415861471605, # longitude; x-axis
                           49.905624997321596), # latitude; y-axis
                zoom_factor = 4, 
                map_source = "google")

ggsave(plot = last_plot(), filename = here("output", "plots", "map.png"))

# zoom_factor: an integer from 3 (continent) to 21 (building), default value 
# 10 (city). openstreetmaps limits a zoom of 18, and the limit on stamen maps 
# depends on the maptype. "auto" automatically determines the zoom for 
# bounding box specifications