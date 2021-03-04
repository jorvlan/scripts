## Making maps of Deventer

library(tidyverse)
library(osmdata)
library(sf)

## bounding box 
bb_deventer <- getbb("Deventer The Netherlands")

## streets

streets <- getbb("Deventer The Netherlands")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary", "tertiary")) %>%
  osmdata_sf()

## figure 1

f1 <- ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = .4,
          alpha = .8) +
  coord_sf(xlim = c(bb_deventer[1,1], bb_deventer[1,2]), 
           ylim = c(bb_deventer[2,1], bb_deventer[2,2]),
           expand = FALSE) 
f1

## small streets 
small_streets <- getbb("Deventer The Netherlands")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            "unclassified",
                            "service", "footway")) %>%
  osmdata_sf()

## rivers
river <- getbb("Deventer The Netherlands")%>%
  opq()%>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()


## figure 2

f4 <- ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "black",
          size = .6,
          alpha = .8) +
  geom_sf(data = small_streets$osm_lines,
         inherit.aes = FALSE,
         color = "black",
         size = .4,
         alpha = .6) +
  geom_sf(data = river$osm_lines,
         inherit.aes = FALSE,
         color = "dodgerblue",
         size = .7,
         alpha = .9) +
  coord_sf(xlim = c(bb_deventer[1,1], bb_deventer[1,2]-0.15), 
           ylim = c(bb_deventer[2,1]+0.01, bb_deventer[2,2]-0.03),
           expand = FALSE) +
  theme_classic()
f4

ggsave("deventer3.png", units = 'in', dpi = 600)


f3 <- f2 + annotate("text", label = "bold(L33)", x = 6.17, y = 52.2614, size = 3, color = 'dodgerblue', alpha = .9, parse = TRUE, angle = 45)
f3
