# Libraries used in this script:
library(tidyverse)
library(here)
library(magrittr)
library(sf)
library(tmap)
library(janitor)
library(RColorBrewer)
library(leaflet)
library(osmdata)
library(ggplot2)

# Read in gb outline
gb_outline <- st_read("raw/02/gb_outline/gb_outline.shp")

# # Define our bbox coordinates, here we extract the coordinates from our london
# # outline using the st_bbox function Note we also temporally reproject the
# # london_outline spatial dataframe before obtaining the bbox We need our bbox
# # coordinates in WGS84 (not BNG), hence reprojection
# p_bbox <- st_bbox(st_transform(gb_outline, 4326))
# 
# # Pass our bounding box coordinates into the OverPassQuery (opq) function
# pubs_osm <- opq(bbox = p_bbox) %>%
#   # Pipe this into the add_osm_feature data query function to extract our stations
#   add_osm_feature(key = "amenity", value = "pub") %>%
#   # Pipe this into our osmdata_sf object
#   osmdata_sf()

# Downloaded in QGIS as certificate issues ongoing in R

# Read in gb-pubs
gb_pubs <- st_read("raw/05/amenity_pub_points.geojson")

gb_pubs_BNG <- gb_pubs %>% st_transform(27700)

gb_pubs_BNG_tidy <- gb_pubs_BNG %>% st_intersection(gb_outline)

gb_pubs_BNG_tidy_2 <- select(gb_pubs_BNG_tidy, c("osm_id", "name", "geometry"))

st_write(gb_pubs_BNG_tidy_2, "raw/05/gb-pubs-tidy.shp")

red_gb_pubs <- gb_pubs_BNG_tidy_2 %>% filter(grepl(' Red | red ', name))

st_write(red_gb_pubs, "raw/05/red_gb_pubs.shp")

red_gb_pubs_names <- count(red_gb_pubs, name)

tm_shape(gb_outline) + tm_borders() +
  tm_shape(red_gb_pubs) + tm_dots()

st_write(red_gb_pubs, "raw/05/red-gb-pubs.shp")

write_csv(red_gb_pubs_names, "raw/05/red-gb-pubs-names.csv")

red_gb_pubs_names <- red_gb_pubs_names %>% as.data.frame %>% arrange(n)

top_10 

ggplot(data=red_gb_pubs_names, aes(x=name, y=n)) + 
  geom_bar(stat = "identity") +
  coord_flip()






