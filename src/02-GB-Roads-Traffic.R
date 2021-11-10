library(tidyverse)
library(here)
library(magrittr)
library(sf)
library(tmap)

traffic_data <- read_csv('raw/02/dft_traffic_counts_aadf.csv')

traffic_data_2019 <- traffic_data %>% filter(year==2019) %>% filter(road_type=="Major")

traffic_data_2020 <- traffic_data %>% filter(year==2020) %>% filter(road_type=="Major")

#td_2019_sdf <- st_as_sf(traffic_data_2019, coords = c("easting", "northing"), crs=27700)
#td_2020_sdf <- st_as_sf(traffic_data_2020, coords = c("easting", "northing"), crs=27700)
#td_2019_sdf_motors <- td_2019_sdf %>% select(c(1, 31, 32))
#td_2020_sdf_motors <- td_2020_sdf %>% select(c(1, 31, 32))

road_network_2019 <- st_read('raw/02/mrdb-2019/MRDB_2019_published.shp')

road_network_2020 <- st_read('raw/02/mrdb-2020/MRDB_2020.shp')

road_traffic_2019 <- left_join(road_network_2019, traffic_data_2019, by = c("CP_Number" = "count_point_id"))

road_traffic_2020 <- left_join(road_network_2020, traffic_data_2020, by = c("CP_Number" = "count_point_id"))

road_traffic_2019_sm <- road_traffic_2019 %>% select(c(1, 34, 35))

colnames(road_traffic_2019_sm) <- c("CP_Number", "2019_traffic", "geometry")

colnames(road_traffic_2020_sm) <- c("CP_Number", "2020_traffic", "geometry")

all_road_traffic <- left_join(road_traffic_2019_sm, as.data.frame(road_traffic_2020_sm), by = c("CP_Number" = "CP_Number"))

road_traffic_2020_sm <- road_traffic_2020 %>% select(c(1, 34, 35))

all_road_traffic <- all_road_traffic %>% select(c(1,2,3, 4))

all_road_traffic <- all_road_traffic %>% mutate(actualdifference = `2020_traffic` - `2019_traffic`)

all_road_traffic <- all_road_traffic %>% mutate(perdiff = (`actualdifference`/`2019_traffic`)*100)

tm_shape(road_traffic_2020) + tm_lines(col="all_motor_vehicles")

st_write(road_traffic_2019_sm, "Day2_Lines_Traffic/road_traffic_2019.shp")

st_write(road_traffic_2020_sm, "Day2_Lines_Traffic/road_traffic_2020.shp")

st_write(all_road_traffic, "Day2_Lines_Traffic/road_traffic_covid.shp")

