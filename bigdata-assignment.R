## HEADER ####
## Florence Galliers
## Big Data Assignment C7084
## 2021-03-16

## CONTENTS ####
# 1.0 Set Up
# 2.0 Data Imports
# 3.0 EDA

## 1.0 SET UP ####
# Install packages
system('java -version')
library(sparklyr)
packageVersion('sparklyr')
library(dplyr)
library(geospark)
library(ggplot2)
install.packages("sparkR")

# Set up spark connection
sc <- spark_connect(master = "local", 
                    version = "2.3")

## 2.0 DATA IMPORTS ####
# Load first GBIF dataset to the spark connection (Tree Sparrow)

data <- spark_read_csv(sc, "pm-data.csv")

# 3.0 EDA ####

# Number of observations over time
count(data) # 14902

# look at average values of all data
summarise_all(data, mean) 

# Most are multiple observations, but a lot of NAs
# do we assume the NAs are single birds, as they must be at the minimum one?
data %>%
  mutate(individuals = ifelse(individualCount == 1, "single", "multiple")) %>%
  group_by(individuals) %>%
  summarise(Count = n())

data2 <- data %>%
  select(year, tas, tasmin, tasmax, rainfall, hurs) %>%
  mutate(tas = as.numeric()) %>%
  collect()
         
count(data2)

values <- is.na(data2)
summary(values)



data3 <- na.omit(data2)

ml_corr(data2)


# Disconnect spark connection
spark_disconnect(sc)








