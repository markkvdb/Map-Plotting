# Author:       markvanderbroek@gmail.com
# Description:  Load spatial data from all countries and plot Europe map.

library(sf)
library(ggplot2)
library(dplyr)
library(ggthemes)

# Check if we already downloaded the data
if (!file.exists("data/natural-earth")) {
  tmp_file <- tempfile(fileext=".zip")
  download.file("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip", 
                tmp_file)
  unzip(tmp_file, exdir = "data/natural-earth")
}

# Read raw data into spatial data frame
map_data <- st_read("data/natural-earth/", "ne_10m_admin_0_countries")

# Since we want a map of Europe, filter data for Europe
europe_map_data <- map_data %>%
  filter(CONTINENT == "Europe") %>%
  st_crop(xmin=-25, xmax=55, ymin=35, ymax=71) 

# Plot first map
ggplot(europe_map_data) + geom_sf(aes(fill=SUBREGION)) +
  theme_minimal()

get_coordinates = function(data) {
  return_data = data %>%
    st_geometry() %>%
    st_centroid() %>%
    st_coordinates() %>%
    as_data_frame()
}

# Get centre point of each country
europe_centres = europe_map_data %>%
  group_by(NAME) %>%
  do(get_coordinates(.))