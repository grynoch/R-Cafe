#Maps demo
#R Cafe October 11, 2024
#Tess Grynoch

#install packages if needed: dplyr and ggplot2 in tidyverse
#install.packages("tidyverse")
library(ggplot2) #add layers for visualization

#usmap package
install.packages("usmap")
library(usmap)
?plot_usmap

#blank map of the US
plot_usmap(regions = "states") + 
  labs(title = "U.S. States",
       subtitle = "This is a blank map of the United States.") + 
  theme(panel.background=element_blank())

#blank map of all counties of the US
plot_usmap(regions = "counties") + 
  labs(title = "U.S. counties",
       subtitle = "This is a blank map of the United States.") + 
  theme(panel.background=element_blank())

#Just looking at Northeast region
plot_usmap(include = .northeast_region, labels = TRUE)

#can exclude NY, NJ, and PA to get New England
plot_usmap(include = .northeast_region, exclude=c("NY", "NJ", "PA"), labels = TRUE)

#or select the states of interest to get New England
plot_usmap(include = c("CT","ME","MA", "NH","VT"))+
  labs(title="New England Region")+
  theme(panel.background = element_rect(color="blue"))

#there is also a region for New England
plot_usmap(include = .new_england, labels = TRUE)

#Not sure what the extent of data included with plot_usmap is
#population and poverty percentage are available
head(countypov) #2021
head(countypop) #2022
plot_usmap(data = countypov, values="pct_pov_2021", include = .new_england, color="blue")+
  scale_fill_continuous(low = "white", high = "blue", name="Poverty Percentage Estimates", label = scales::comma)+
  labs(title = "New England Region", subtitle = "Poverty Percentage Estimates for New England Counties in 2021") +
  theme(legend.position = "right")

#Want to check why CT is grey.
library(tidyverse)
countypov %>% 
  filter(abbr=="CT")

#using ggplot2 and maps and mapdata
install.packages("maps")
install.packages("mapdata")
library(maps)
library(mapdata)

#pull usa information from map_data to build US map
usa <- map_data('usa')

ggplot(data=usa, aes(x=long, y=lat, group=group))+
  geom_polygon(fill="lightblue")+
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  ggtitle('U.S. Map') +
  coord_fixed(1.3)

#pull state information from map_data to build US map with states
state <- map_data("state")

ggplot(data=state, aes(x=long, y=lat, fill=region, group=group)) + 
  geom_polygon(color = "white") + 
  guides(fill=FALSE) + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  ggtitle('U.S. Map with States') + 
  coord_fixed(1.3)

#pull data for Massachusetts counties to create map
massachusetts <- subset(state, region =="massachusetts")
counties <- map_data("county")
ma_county <- subset(counties, region=="massachusetts")

ma_map <- ggplot(data=massachusetts, mapping=aes(x=long, y=lat, group=group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color="black", fill="gray") + 
  geom_polygon(data=ma_county, fill=NA, color="white") + 
  geom_polygon(color="black", fill=NA) + 
  ggtitle('Massachusetts Map with Counties') + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank())
ma_map

#above based on source code from community contributions for the 
#STAT GR 5702 "EDAV" Fall 2019 course at Columbia University
#Chapter 41 Different ways of plotting U.S. Map in R by Zhiyi Guo and Fan Wu
#https://jtr13.github.io/cc19/different-ways-of-plotting-u-s-map-in-r.html


#sf package example from Chapter 8 of 
#Pebesma, E.; Bivand, R. (2023). 
#Spatial Data Science: With Applications in R (1st ed.). 
#Chapman and Hall/CRC, Boca Raton. https://doi.org/10.1201/9780429459016
#available from: https://r-spatial.org/book/08-Plotting.html 

#install.packages("sf")
library(sf)

#pull data for North Carolina
nc <- read_sf(system.file("gpkg/nc.gpkg", package = "sf"))

#plot of births in North Carolina by county 
plot(nc["BIR74"], reset = FALSE, key.pos = 4)

#Add polygon around county of interest
plot(st_buffer(nc[1,1], units::set_units(10, km)), col = 'NA', 
     border = 'red', lwd = 2, add = TRUE)
