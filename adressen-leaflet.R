library(leaflet)
library(htmltools)

# De meeste uitleg vind je hier https://rstudio.github.io/leaflet/  en  hier https://rstudio.github.io/leaflet/map_widget.html

setwd("/home/gehau/git/adressen")

adreslocaties <- read.csv("data/wel_en_niet_INTEGO_Antwerpen2.csv")
integolocaties <- subset(adreslocaties, INTEGO == "1")
nonintegolocaties <- subset(adreslocaties, INTEGO == "0")

map <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(data = integolocaties, lat = ~ Latitude, lng = ~ Longitude, 
                   radius = ~Aantal.artsen * 2, fillColor = "red" , color = "red", popup = ~htmlEscape(Praktijk)) %>% 
  addCircleMarkers(data = nonintegolocaties, lat = ~ Latitude, lng = ~ Longitude, 
                   radius = ~Aantal.artsen * 2, fillColor = "blue" , color = "blue", popup = ~htmlEscape(Praktijk))  
  
map

