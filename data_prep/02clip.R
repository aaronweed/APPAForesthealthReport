library(rFIA)

at <- rFIA::readFIA(dir = "FIA")

eco <- rgdal::readOGR('ecoregions/', 'at_ecoSub')

atMatch <- clipFIA(at, matchEval = TRUE, mostRecent = TRUE, mask = eco)

saveRDS(atMatch, "data_prep/atMatch.rds")
