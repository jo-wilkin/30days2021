library(tidyverse)
library(here)
library(magrittr)
library(sf)
library(tidygeocoder)
library(tmap)

# Load COP locations
COP_locations <- read_csv('Day1_Points_COP/COP-locations.csv')

# Create columns for lat and lon
COP_locations$lat <- NA
COP_locations$lon <- NA

# Run tidygeocoder geocoder
COP_coords <- COP_locations %>% geocode(address="Place", lat = "lat", long = "lon", method = 'arcgis')

COP_coords <- COP_coords %>% select(c(1:6, 9, 10))

COP_coords <- COP_coords %>% rename("lat" = lat...9, "lon" = lon...10)

COP_sdf <- st_as_sf(COP_coords, coords = c("lon", "lat"), crs=4326) #%>% st_transform(54030)

# Load world dataset
world_outline <- read_sf('Day1_Points_COP/UIA_World_Countries_Boundaries/World_Countries__Generalized_.shp')

robin <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

tm_shape(world_outline, projection = robin) + tm_fill() + 
  tm_shape(COP_sdf, projection = robin) + tm_dots(col='black') #+ 
  #tm_shape(COP_sdf) + tm_text("COP")

st_write(COP_sdf, 'Day1_Points_COP/COP-locations.shp')