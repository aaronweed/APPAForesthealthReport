library(rFIA)
library(FIESTA)
library(tidyverse)
eco <- rgdal::readOGR('ecoregions/', 'at_ecoSub')
eco_sf <- sf::st_read("ecoregions/at_ecoSub.shp")
atMatch <- readRDS("data_prep/atMatch.rds")

ecogrp <- FIESTA::spGetEstUnit(xyplt = atMatch$PLOT,
                               uniqueid = "CN",
                               unit_layer = eco_sf,
                               unitvar = "SUBSECTION",
                               spMakeSpatial_opts = list(xvar = "LON",
                                                         yvar = "LAT")) 
plt <- ecogrp$pltassgn %>%
  group_by(SUBSECTION) %>%
  summarize(n_plots = n())

eco_sf <- eco_sf %>%
  full_join(plt, by = "SUBSECTION")

at_centerline <- sf::st_read("at_centerline/Appalachian_National_Scenic_Trail.shp")

# Plot 1
ggplot() +
  geom_sf(data = eco_sf, aes(fill = n_plots)) +
  geom_sf(data = at_centerline) +
  theme_minimal() +
  scale_fill_viridis_c() +
  labs(fill = "Number of FIA plots",
       title = "Number of FIA Plots Per Ecosubsection")
