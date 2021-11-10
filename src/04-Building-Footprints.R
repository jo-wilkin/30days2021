# Hexing Building Footprints from Google & Facebook
# Day 4

library(tidyverse)
library(here)
library(magrittr)
library(sf)
#library(hexbin)
library(tmap)

# Load in Tanzania outline
tnz_outline <- read_sf('raw/04/tanzania_gadm/gadm36_TZA_0.shp')

# Transform into TNZ CRS
tnz_outline <- tnz_outline %>% st_transform(21035)

# Make HEX GRID of TNZ
hex_grid <- st_make_grid(tnz_outline,
                         50 * 1000,
                         crs=st(crs(tnz_outline)),
                         what = "polygons",
                         square = FALSE)

# Make HEX GRID sf
hex_grid <- st_sf(index = 1: length(lengths(hex_grid)), hex_grid)

# Only keep hexes in Tanzana
cent_grid <- st_centroid(hex_grid)
cent_merge <- st_join(cent_grid, tnz_outline, left = F)
hex_grid_new <- inner_join(hex_grid, st_drop_geometry(cent_merge))

#microsoft_buildings <- read_sf('raw/04/Tanzania.geojson')

sf::sf_use_s2(FALSE)

#mb_point <- microsoft_buildings %>% st_centroid()

#mb_point <- mb_point %>% st_transform(21035)

#hex_grid_new$mb_count <- lengths(st_intersects(hex_grid_new, mb_point))

#st_write(hex_grid_new, 'raw/04/msb_hex.shp')

google_buildings <- read_csv('raw/04/open_buildings_v1_polygons_ne_110m_TZA.csv')

half <- length(google_buildings$full_plus_code)/2

#google_building_1 <- google_buildings %>% slice(1:half)

#gb_building_1 <- st_as_sf(google_building_1, wkt="geometry")

# google_building_2 <- google_buildings %>% slice((half+1):length(google_buildings$full_plus_code))
# 
# gb_building_2 <- st_as_sf(google_building_2, wkt="geometry")

#gb_point_1 <- gb_building_1 %>% st_centroid()

#st_crs(gb_point_1) <- 4326

# gb_point_1_crs <- st_transform(gb_point_1, 21035)
# 
# hex_grid_new$gb1_count <- lengths(st_intersects(hex_grid_new, gb_point_1_crs))
# 
# st_write(hex_grid_new, 'raw/04/gb1_hex.shp')

# google_building_2 <- google_buildings %>% slice((half+1):(half+6570923))
#  
# gb_building_2 <- st_as_sf(google_building_2, wkt="geometry")
# 
# gb_point_2 <- gb_building_2 %>% st_centroid()
# 
# st_crs(gb_point_2) <- 4326
# 
# gb_point_2_crs <- st_transform(gb_point_2, 21035)
# 
# hex_grid_new$gb2_count <- lengths(st_intersects(hex_grid_new, gb_point_2_crs))
# 
# st_write(hex_grid_new, 'raw/04/gb2_hex.shp')

google_building_3 <- google_buildings %>% slice((half+6570924):length(google_buildings$full_plus_code))

gb_building_3 <- st_as_sf(google_building_3, wkt="geometry")

gb_point_3 <- gb_building_3 %>% st_centroid()

st_crs(gb_point_3) <- 4326

gb_point_3_crs <- st_transform(gb_point_3, 21035)

hex_grid_new$gb3_count <- lengths(st_intersects(hex_grid_new, gb_point_3_crs))

st_write(hex_grid_new, 'raw/04/gb3_hex.shp')

hex_grid_1 <- st_read('raw/04/gb1_hex.shp') %>% as.data.frame()

hex_grid_2 <- st_read('raw/04/gb2_hex.shp') %>% as.data.frame()

hex_grid_join <- left_join(hex_grid_new, hex_grid_1, by = c("index"="index"))

hex_grid_join <- left_join(hex_grid_new, hex_grid_2, by = c("index"="index"))

hex_grid_final <- hex_grid_join %>% select(1, 4, 7, 8, 9)

hex_grid_final <- hex_grid_final %>% mutate(gb_count = gb3_count + gb1_count + gb2_count)

st_write(hex_grid_final, 'raw/04/gb_hex.shp')

