# Libraries used in this script:
library(tidyverse)
library(here)
library(magrittr)
library(sf)
library(tmap)
library(janitor)
library(raster)
library(fasterize)
library(ggplot2)

# Read in bay counties boundary dataset - data from datasf.org
bay_counties <- st_read("raw/10/Bay_Area_Counties/geo_export_62185612-3f0e-4a14-9287-cd6307051d6a.shp")

# Read in tree canopy data - data from datasf.org
sf_trees <- st_read("raw/10/SF_Urban_Tree_Canopy.geojson")

# Extract only sf mainland plus treasure island from counties boundary dataset
sf_boundary <- bay_counties %>% filter(county == 'San Francisco') %>% st_crop(xmin=-122.541161, ymin=37.629731, xmax=-122.349243, ymax=37.843681)

# Extract bounds of resulting sf boundary
sf_bb <- st_bbox(sf_boundary)

# Create raster to store canopy data from scratch, use bounding box from sf_boundary
sf_raster <- raster(nrows=1000, ncols=1000, xmn=sf_bb[1], xmx = sf_bb[3], ymn=sf_bb[2], ymx=sf_bb[4])

# Rasterize tree canopy into sf_raster, with binary value of yes or no tree present
sf_tree_canopy <- fasterize(sf_trees, sf_raster_crop, background=0)

# Crop resulting raster to the sf boundary outline
sf_tree_canopy_mask <- rasterize(sf_boundary, sf_tree_canopy, mask=TRUE)

# Plot result to check it looks right
tm_shape(sf_tree_canopy_mask) + tm_raster(col="layer")

# Export to raster file - will map / style in QGIS
writeRaster(sf_tree_canopy_mask, "working/Day10_Raster/sf_tree_canopy_raster.grd")

