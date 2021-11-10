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

# Read in sf outline
sf_outline <- st_read("raw/10/Bay_Area_Counties/geo_export_62185612-3f0e-4a14-9287-cd6307051d6a.shp")

# Read in tree canopy data
sf_trees <- st_read("raw/10/SF_Urban_Tree_Canopy.geojson")