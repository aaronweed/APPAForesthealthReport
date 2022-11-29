library(rFIA)
library(tidyverse)
library(leaflet)
eco <- rgdal::readOGR('ecoregions/', 'at_ecoSub')
eco_sf <- sf::st_read("ecoregions/at_ecoSub.shp")
atMatch <- readRDS("data_prep/atMatch.rds")


# n_plots_per_ecosubsection ----------------------------------------------------
plt <- rFIA::biomass(atMatch, byPlot = TRUE, grpBy = ECOSUBCD) %>%
  group_by(ECOSUBCD) %>%
  summarize(n_plots = n())

eco_sf <- eco_sf %>%
  full_join(plt, by = c("SUBSECTION" = "ECOSUBCD"))

n_plots_per_ecosubsection <- st_transform(eco_sf, '+proj=longlat +datum=WGS84')
saveRDS(n_plots_per_ecosubsection, "summary_data/n_plots_per_ecosubsection.rds")
# ------------------------------------------------------------------------------


# at_centerline ----------------------------------------------------------------
at_centerline <- sf::st_read("at_centerline/Appalachian_National_Scenic_Trail.shp") %>%
  mutate(region_3cl = case_when(
    Region == "New England" ~ "Northeast",
    Region == "Mid-Atlantic" ~ "Mid-Atlantic",
    Region %in% c("Southern", "Virginia") ~ "Southeast"
  ))

saveRDS(at_centerline, file = "summary_data/at_centerline.rds")
# ------------------------------------------------------------------------------


# div --------------------------------------------------------------------------
div <- rFIA::diversity(atMatch, polys = eco, treeDomain = DIA >= 5, nCores = 6) %>%
  left_join(n_plots_per_ecosubsection) %>% 
  st_as_sf()
saveRDS(div, "summary_data/div.rds")
# ------------------------------------------------------------------------------


# div_year ---------------------------------------------------------------------
div_year <- rFIA::diversity(atMatch, polys = eco, treeDomain = DIA >= 5, nCores = 6,
                            grpBy = MEASYEAR)
saveRDS(div_year, "summary_data/div_year.rds")
# ------------------------------------------------------------------------------


# bio_top10 --------------------------------------------------------------------
bio <- biomass(atMatch, polys = eco, treeDomain = DIA >= 5, nCores = 6,
           bySpecies = TRUE, bySizeClass = TRUE, totals = TRUE)
top10 <- bio %>%
  group_by(SCIENTIFIC_NAME) %>%
  summarize(n = n()) %>%
  arrange(desc(n)) %>%
  head(10)

bio$newClass <- makeClasses(bio$sizeClass, interval = 5)

bio_top10 <- bio %>%
  filter(SCIENTIFIC_NAME %in% top10$SCIENTIFIC_NAME)

saveRDS(bio_top10, "summary_data/bio_top10.rds")
# ------------------------------------------------------------------------------


# bio_year_top10 ---------------------------------------------------------------
bio_year <- biomass(atMatch, treeDomain = DIA >= 5, nCores = 6,
               bySpecies = TRUE, totals = TRUE, grpBy = MEASYEAR)

bio_year_top10 <- bio_year %>%
  filter(SCIENTIFIC_NAME %in% top10$SCIENTIFIC_NAME)

saveRDS(bio_year_top10, "summary_data/bio_year_top10.rds")
# ------------------------------------------------------------------------------

bio_year_top10 %>%
  ggplot(aes(x = MEASYEAR, y = BIO_ACRE)) +
  geom_point() +
  geom_line() +
  facet_wrap(~SCIENTIFIC_NAME) +
  theme_bw()

library(RColorBrewer)
nb.cols <- 10
mycolors <- colorRampPalette(brewer.pal(8, "Accent"))(nb.cols)

bio_top10 %>%
  ggplot(aes(x = newClass,
             y = BIO_ACRE,
             fill = COMMON_NAME)) +
  geom_col() +
  theme_bw() +
  scale_fill_manual(values = mycolors)
  scale_fill_brewer(type = "qual",
                    palette = 8)
