library(here)
library(tidyverse)
library(dbplyr)
library(sf)
library(terra)
library(tidyterra)
library(RSQLite)
library(RColorBrewer)

# Connect to DB----
driver <- dbDriver("SQLite")
con <- dbConnect(driver, dbname = here("data", "HWSD2.sqlite"))
dbListTables(con)

# Import raster image----
raster_image <- rast(here("data", "HWSD2_RASTER", "hwsd2.bil"))
print(raster_image)

# Examine raster image properties----
class(raster_image)

nrow(raster_image); ncol(raster_image); ncell(raster_image)


res(raster_image)
ext(raster_image)

st_crs(raster_image)$proj4string # retrieve coordinate system


# Selecting a region----
## Selecting a bounding box----
raster_image_cropped <- crop(raster_image, 
                             ext(c(-11.5, 38, 35, 65)))

nrow(raster_image_cropped); ncol(raster_image_cropped); st_bbox(raster_image_cropped)

dim(unique(raster_image_cropped))

head(unique(raster_image_cropped)[1])

tail(unique(raster_image_cropped)[1])


# Display tile----
plot(raster_image_cropped, main = "HWSD v2 map unit codes, Europe")
boxplot(unique(raster_image_cropped)[1])


# Replace outliers with NA----
raster_image_cropped_wrangled <- app(raster_image_cropped, 
                                     fun=function(x){ 
                                       x[x > 30000|x < 9000] <- NA; 
                                       return(x)} 
)
boxplot(unique(raster_image_cropped_wrangled)[1])
head(unique(raster_image_cropped_wrangled)[1])
plot(raster_image_cropped_wrangled, main = "HWSDv2 map unit codes, Europe")

raster_image_cropped_wrangled3 <- (raster_image_cropped_wrangled%/%100) 
freq(raster_image_cropped_wrangled3)



# Project image to Universal Transmercator (UTM) coordinate reference system (CRS)----
print(paste("UTM zone:", 
            utm.zone <-floor(((st_bbox(hwsd.zhnj3)$xmin + st_bbox(hwsd.zhnj3)$xmax)/2 + 180)/6) + 1))

(epsg <- 32600 + utm.zone)

hwsd.zhnj3.utm <- project(hwsd.zhnj3, paste0("EPSG:", epsg), method = "near") 
(cell.dim <- res(hwsd.zhnj3.utm))

plot(hwsd.zhnj3.utm,
     col=brewer.pal(n = dim(unique(hwsd.zhnj3))[1],"Accent"),
     type = "classes"); grid()


# Compute the area covered by each code----
(cell.area <- cell.dim[1]*cell.dim[2]/10^4)

print(freq(hwsd.zhnj3.utm))

(total.area <- sum(freq(hwsd.zhnj3.utm)[,"count"]*cell.area/10^2))

rm(hwsd.zhnj3.utm) rm(utm.zone, cell.dim, cell.area, total.area)




# Do stuff with Google----

plot_google_map <- function(data,
                            longitude,
                            latitude,
                            longitude_limits, # x-axis
                            latitude_limits, # y-axis
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
    geom_spatraster(data = raster_image_cropped_wrangled) +
    scale_fill_continuous(na.value = NA) +
    geom_point(data = data,
               aes(x = longitude, y = latitude,
                   fill = ifelse(is.null(fill_variable),
                                 NULL,
                                 as.factor(fill_variable))
                   , alpha = 0.8), 
               size = 3, 
               shape = ifelse(is.null(shape_variable),
                              21,
                              as.factor(shape_variable))) +
    guides(fill = FALSE, alpha = FALSE, size = FALSE) +
    labs(x = "longitude", y = "latitude") + 
    scale_x_continuous(limits = longitude_limits, expand = c(0,0)) + 
    scale_y_continuous(limits = latitude_limits, expand = c(0,0))
  
}
