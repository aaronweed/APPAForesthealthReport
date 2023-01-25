# ggplot() +
#   geom_sf(data = eco_sf, aes(fill = n_plots)) +
#   geom_sf(data = at_centerline) +
#   theme_minimal() +
#   scale_fill_viridis_c() +
#   labs(fill = "Number of FIA plots",
#        title = "Number of FIA Plots Per Ecosubsection")

div_year %>%
  ggplot(aes(x = MEASYEAR, y = H_a)) +
  geom_point() + 
  geom_line() +
  facet_wrap(~SUBSECTION)


pal <- colorBin("Purples", domain = div[["H_a"]], bins = 9)

div %>%
  left_join(eco_sf_transformed) %>% 
  st_as_sf() %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(fillColor = ~ pal(div[["H_a"]]),
              fillOpacity = 1,
              opacity = 0,
              popup = paste0("<b>Ecosubsection: </b>",
                             div[["SUBSECTION"]],
                             "<br> <b>mean Shannon's Diversity Index,<br> alpha (stand) level: </b>",
                             round(div[["H_a"]], 3))) %>%
  addPolylines(data = at_centerline,
               color = "black",
               opacity = 1,
               weight = 2) %>%
  addLegend(pal = pal,
            values = ~div[["H_a"]],
            title = "mean Shannon's Diversity Index, alpha (stand) level") 