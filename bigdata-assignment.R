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
library(corrr)
library(dbplot)

# Set up spark connection
sc <- spark_connect(master = "local", 
                    version = "2.3")

## 2.0 DATA IMPORTS ####
# Load first GBIF dataset to the spark connection (Tree Sparrow)

data <- spark_read_csv(sc, "final-data.csv")

# 3.0 EDA ####

# Number of observations over time
count(data) # 912

# look at average values of all data
summarise_all(data, mean) 

data2 <- data %>%
  select(Count, tas, tasmin, tasmax, rainfall, hurs, land)

# Look at correlation between variables
ml_corr(data2)

correlate(data2, use = "pairwise.complete.obs", method = "pearson") %>%
  shave() %>%
  rplot()

# Look at distributions of temperature variables
temp <- data2 %>%
  select(tas, tasmin, tasmax) %>%
  pivot_longer(names_to = "type", 
               values_to = "temperature",
               cols = 1:3)

ggplot(temp, aes(x = type, y = temperature)) +
  geom_boxplot() +
  geom_point(position = "jitter", alpha = 0.3)

# Linear Regression

data2 %>%
  ml_linear_regression(Count ~ .) %>%
  summary()

data_splits <- sdf_random_split(data2, training = 0.8, testing = 0.2, seed = 42)
data_train <- data_splits$training
data_test <- data_splits$testing

sdf_describe(data_train, cols = c("Count", "tas", "tasmin", "tasmax", "rainfall", "hurs"))

dbplot_histogram(data_train, tas)

# scale the variables 
# tas
scaled_values <- data_train %>%
  summarise(
    mean_tas = mean(tas),
    sd_tas = sd(tas),
    mean_tasmin = mean(tasmin),
    sd_tasmin = sd(tasmin),
    mean_tasmax = mean(tasmax),
    sd_tasmax = sd(tasmax),
    mean_rainfall = mean(rainfall),
    sd_rainfall = sd(rainfall),
    mean_hurs = mean(hurs),
    sd_hurs = sd(hurs)
  ) %>%
  collect()

data_train <- data_train %>%
  mutate(scaled_tas = (tas - !!scaled_values$mean_tas) / !!scaled_values$sd_tas) %>%
  mutate(scaled_tasmin = (tasmin - !!scaled_values$mean_tasmin) / !!scaled_values$sd_tasmin) %>%
  mutate(scaled_tasmax = (tasmax - !!scaled_values$mean_tasmax) / !!scaled_values$sd_tasmax) %>%
  mutate(scaled_rainfall = (rainfall - !!scaled_values$mean_rainfall) / !!scaled_values$sd_rainfall) %>%
  mutate(scaled_hurs = (hurs - !!scaled_values$mean_hurs) / !!scaled_values$sd_hurs)
  

dbplot_histogram(data_train, scaled_tas)
dbplot_histogram(data_train, scaled_tasmin)
dbplot_histogram(data_train, scaled_tasmax)
dbplot_histogram(data_train, scaled_rainfall)
dbplot_histogram(data_train, scaled_hurs)

glr <- ml_generalized_linear_regression(
  data_train,
  Count ~ tas + tasmin + tasmax + rainfall + hurs,
  family = "poisson"
)

tidy_glr <- tidy(glr)


# Disconnect spark connection
spark_disconnect(sc)



