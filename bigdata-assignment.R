## HEADER ####
## Florence Galliers
## Big Data Assignment C7084
## 2021-03-16

## Import GBIF Data

install.packages("rgbif")
library(rgbif)
library(dismo)
library(dplyr)

puffin <- gbif("Fratercula", "arctica", geo = T)

names(puffin)

puffin$year <- as.factor(puffin$year)

year_tally <- puffin %>% group_by(year) %>% 
  summarise(count = n())

plot(year_tally)

ebird <- read.csv("ebird-gbif2.csv")

ebird2 <- ebird %>%
  dplyr::select(species, decimalLatitude, decimalLongitude, day, month, year)

ebird2$species <- as.factor(ebird2$species)

tallybird <- ebird2 %>%
  group_by(species, year) %>%
  summarise(count = n())

devtools::install_github("azizka/speciesgeocodeR")
library(speciesgeocodeR)

sp.ras <- RichnessGrid(ebird2, reso = 0.1)
plot(sp.ras)

dir.create("clim_data")
clim <- getData("worldclim", var="bio", res=10, download=T, path="clim_data")

clim

head(raster::extract(x = clim, 
                     y = data.frame(ebird2[,c('decimalLongitude','decimalLatitude')])))

gbid_ebird2 <- cbind(ebird2, 
                     raster::extract(x = clim,
                                     y = data.frame(ebird2[,c('decimalLongitude','decimalLatitude')])))

glm()




farmland <- read.csv("farmland-gbif.csv")

farmland2 <- farmland %>%
  dplyr::select(species, decimalLatitude, decimalLongitude, day, month, year)

farmland2$species <- as.factor(farmland2$species)


colpal <- rev(c("#440154","#482677", "#404788", "#33638D", "#287D8E", "#1F968B", "#29AF7F", "#55C667", "#95D840", "#DCE319"))

farmland.ras <- RichnessGrid(farmland2, reso = 0.1)
plot(farmland.ras,
     bty = "n",
     xaxt = "n",
     yaxt = "n",
     main = "Species Richness of 10 Farmland Birds in the UK",
     col = colpal,
     legend = F)
box(col = "white",
    lwd = 3)
legend("topright",
       legend = c(10:1),
       fill = rev(colpal),
       bty = "n",
       title = "No. of Species",
       cex = 0.7)

