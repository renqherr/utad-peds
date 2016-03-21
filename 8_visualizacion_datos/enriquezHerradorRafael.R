#############################################################################
## Rafael Enriquez-Herrador
## U-TAD - PEDS 2ED - 2015
## 8 - Visualizacion de Datos
## Practica
#############################################################################

library(ggplot2)
library(data.table)

dt.SFCSS <- read.table(file = "datasets/SFCC/train.csv",
                       header = T,
                       sep = ",",
                       stringsAsFactors = F,
                       numerals = c("no.loss"))

options(digits = 16)

dt.SFCSS$X <- as.numeric(dt.SFCSS$X)
dt.SFCSS$Y <- as.numeric(dt.SFCSS$Y)
dt.SFCSS$Dates <- as.Date(dt.SFCSS$Dates)
dt.SFCSS$Category <- as.factor(dt.SFCSS$Category)
dt.SFCSS$DayOfWeek <- as.factor(dt.SFCSS$DayOfWeek)
dt.SFCSS$PdDistrict <- as.factor(dt.SFCSS$PdDistrict)
dt.SFCSS$Resolution <- as.factor(dt.SFCSS$Resolution)

dt.SFCSS <- as.data.table(dt.SFCSS)
dt.SFCSS$Years <- year(dt.SFCSS$Dates)

levels(dt.SFCSS$Category)

ggplot(dt.SFCSS, aes(x = Category, fill = Years)) +
  geom_bar(binwidth = 0.75, show_guide = F) +
  coord_flip() + facet_wrap(~Years)

thefts <- subset(dt.SFCSS, dt.SFCSS$Category == c("LARCENY/THEFT",
                                                  "ASSAULT",
                                                  "BURGLARY",
                                                  "ROBBERY",
                                                  "VEHICLE THEFT"))

thefts$Category <- as.factor(as.character(thefts$Category))

ggplot(thefts, aes(x = PdDistrict, colour = Years)) +
  geom_freqpoly(aes(group = Years), show_guide = F) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

arrests <- subset(thefts, Resolution == "ARREST, BOOKED" | Resolution == "ARREST, CITED")
arrests$Resolution = as.factor(as.character(arrests$Resolution))

#install.packages("ggmap")
library(ggmap)

## Obtener mapa
sfmap <- get_map(location = "san francisco",
                 zoom = 12,
                 maptype = "watercolor",
                 source = "osm",
                 color = "bw")

## Iniciar mapa
SFMap <- ggmap(sfmap, extent = "device", legend = "topleft")

## Localización de arrestos 2010 ~ 2015
SFMap <- SFMap +
  stat_bin2d(
    data = arrests,
    aes(x = X, y = Y, colour = Category, fill = Category),
    size = .5,
    bins = 100,
    alpha = .4) +
  theme_bw()

## Concentracion de robos por Año 2010 ~ 2015
SFMap <- SFMap +
  stat_density2d(
    data = thefts,
    aes(x = X, y = Y, fill = Category, alpha = ..level..),
    size = 1,
    bins = 10,
    geom = "polygon",
    na.rm = T) +
  facet_grid(Category~Years) +
  theme_bw()

## Pintar mapa
SFMap
