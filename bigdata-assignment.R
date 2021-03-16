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
