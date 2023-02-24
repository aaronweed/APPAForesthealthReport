library(rFIA)

at <- rFIA::readFIA(dir = "FIA")

eco <- rgdal::readOGR('ecoregions/', 'at_ecoSub')

# Restrict to most recent inventory
atMatch_MR <- clipFIA(at, matchEval = TRUE, mostRecent = TRUE, mask = eco)

saveRDS(atMatch_MR, "data_prep/atMatch_MR.rds")


# Access all inventories
atMatch <- clipFIA(at, matchEval = TRUE, mostRecent = FALSE, mask = eco)

saveRDS(atMatch, "data_prep/atMatch.rds")