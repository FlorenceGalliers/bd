## HEADER ####
## Florence Galliers
## Big Data Assignment C7084
## 2021-03-16

## CONTENTS ####
# 1.0 Set Up
# 2.0 Data Imports
# 3.0 EDA
# 4.0 Linear Regression

## 1.0 SET UP ####
# Install packages
system('java -version')
library(sparklyr)
packageVersion('sparklyr')
library(dplyr)
library(geospark)
library(ggplot2)
library(corrr)
library(dbplot)
library(maps)

# Set up spark connection
sc <- spark_connect(master = "local", 
                    version = "2.3")

## 2.0 DATA IMPORTS ####
# Load in Data set for Analysis (final_data.csv)
# Load raw GBIF dataset (Tree Sparrow) (passer-montanus.csv)
# Load world map data for mapping observation locations

data <- spark_read_csv(sc, "final_data.csv")
pm_data <- spark_read_csv(sc, "passer-montanus.csv")
world <- map_data('world')

# 3.0 EDA ####

# Look at the observation data locations
pm_plot <- pm_data %>%
  select(decimalLongitude, decimalLatitude, year) %>%
  filter(year >= 2001) %>%
  collect() %>% 
  ggplot() + 
  geom_polygon(data = world, 
                        aes(x = long, 
                            y = lat, 
                            group = group),
                        fill = "grey95",
                        color = "grey20") + 
  coord_fixed(ratio = 1.2,
              xlim = c(-10,3), 
              ylim = c(50.3, 59)) +
  theme_minimal() +
  geom_point(pm_data,
             mapping = aes(x = decimalLongitude,
                 y = decimalLatitude),
             color = "seagreen4",
             alpha = 0.5) +
  labs(title = "Tree Sparrow (Passer Montanus) Observations\nin the UK 2001 - 2019",
       x = "",
       y = "") +
  theme(
    plot.title = element_text(family = "Avenir",
                              size = 12,
                              hjust = 0.5),
    axis.text = element_blank(),
    legend.position = "none",
    panel.grid = element_blank()
  )

ggsave("pm_plot.png", plot = pm_plot, width = 20, height = 20, units = "cm")

# Look at frequency over time of observation data

time_plot <- pm_data %>%
  group_by(year) %>%
  summarise(sum = n()) %>%
  collect() %>%
  ggplot(aes(x = year, y = sum)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Tree Sparrow Observations per year",
       x = "Year",
       y = "Total no of observations") +
  theme_minimal() +
  theme(
    plot.title = element_text(family = "Avenir",
                              size = 12,
                              hjust = 0.5),
    axis.title = element_text(family = "Avenir",
                              size = 10),
    axis.text = element_text(family = "Avenir",
                             size = 8),
    axis.text.x = element_text(angle = 90),
    panel.grid = element_blank()
  )

ggsave("time_plot.png", time_plot, width = 20, height = 10, unit = "cm")

# look at average values of all data
summarise_all(data, mean) 

data2 <- data %>%
  select(Count, tas, tasmin, tasmax, rainfall, hurs, land, year)

# Look at correlation between variables
ml_corr(data2)

correlate(data2, use = "pairwise.complete.obs", method = "pearson") %>%
  shave() %>%
  rplot()

# Look at distributions of temperature variables
temp_plot <- data2 %>%
  select(tas, tasmin, tasmax) %>%
  pivot_longer(names_to = "type", 
               values_to = "temperature",
               cols = 1:3) %>%
  ggplot(aes(x = type, y = temperature)) +
  geom_boxplot() +
  geom_point(position = "jitter", alpha = 0.3)

## 4.0 Linear Regression ####

# Look at the data in the table
sdf_describe(data2, cols = c("Count", "tas", "tasmin", "tasmax", "rainfall", "hurs", "year", "land"))

count_plot <- data2 %>%
  select(Count) %>%
  ggplot(aes(x = Count)) +
  geom_histogram(bins = 300)

# Scale the variables to have a mean of 0 as they are all in different units
scaled_values <- data2 %>%
  summarise(
    # tas
    mean_tas = mean(tas),
    sd_tas = sd(tas),
    # tasmin
    mean_tasmin = mean(tasmin),
    sd_tasmin = sd(tasmin),
    # tasmax
    mean_tasmax = mean(tasmax),
    sd_tasmax = sd(tasmax),
    # rainfall
    mean_rainfall = mean(rainfall),
    sd_rainfall = sd(rainfall),
    # hurs
    mean_hurs = mean(hurs),
    sd_hurs = sd(hurs)
  ) %>%
  collect()

data3 <- data2 %>%
  mutate(scaled_tas = (tas - !!scaled_values$mean_tas) / !!scaled_values$sd_tas) %>%
  mutate(scaled_tasmin = (tasmin - !!scaled_values$mean_tasmin) / !!scaled_values$sd_tasmin) %>%
  mutate(scaled_tasmax = (tasmax - !!scaled_values$mean_tasmax) / !!scaled_values$sd_tasmax) %>%
  mutate(scaled_rainfall = (rainfall - !!scaled_values$mean_rainfall) / !!scaled_values$sd_rainfall) %>%
  mutate(scaled_hurs = (hurs - !!scaled_values$mean_hurs) / !!scaled_values$sd_hurs)
  
# One hot encode the land variables as it is categorical with each number representing one land type
data4 <- ft_one_hot_encoder(data3, input_cols = 'land', output_cols = 'type')
data4[14]

data5 <- data4 %>% 
  mutate(pmcount = case_when(Count == 1 ~ "one",
                             Count >=2 ~ "many"))

analysis_data <- data5 %>%
  select(pmcount, year, type, scaled_tas, scaled_tasmin, scaled_tasmax, scaled_rainfall, scaled_hurs)

# split data into testing and training sets
data_splits <- sdf_random_split(data5, train = 70, test = 30, seed = 10)
data_train <- data_splits$train
data_test <- data_splits$test

ml_formula <- formula(pmcount ~ scaled_tas + scaled_tasmin + scaled_tasmax + scaled_rainfall + scaled_hurs + type + year)

# Logistic Regression
ml_log <- ml_logistic_regression(
  data_train,
  ml_formula
)

ml_log

validation_summary <- ml_evaluate(ml_log, data_test)


## Decision Tree
ml_dt <- ml_decision_tree(data_train, ml_formula)

## Random Forest
ml_rf <- ml_random_forest(data_train, ml_formula)

## Gradient Boosted Tree
ml_gbt <- ml_gradient_boosted_trees(data_train, ml_formula)


# Bundle the modelss into a single list object
ml_models <- list(
  "Logistic" = ml_log,
  "Decision Tree" = ml_dt,
  "Random Forest" = ml_rf,
  "Gradient Boosted Trees" = ml_gbt
)

# Create a function for scoring
score_test_data <- function(model, data = data_test){
  pred <- sdf_predict(model, data)
  select(pred, pmcount, prediction)
}

# Score all the models
ml_score <- lapply(ml_models, score_test_data)


dt <- ml_tree_feature_importance(ml_dt) 
gbt <- ml_tree_feature_importance(ml_gbt)
rf <- ml_tree_feature_importance(ml_rf)

aa <- merge(dt, gbt, 
      by = "feature")

importances <- merge(aa, rf, 
                     by = "feature")

# Plot results
importances %>%
  ggplot(aes(reorder(feature, importance.x), importance, fill = Model)) + 
  facet_wrap(~Model) +
  geom_bar(stat = "identity") + 
  coord_flip() +
  xlab("") +
  ggtitle("Feature Importance")





# Plot an ROC curve
# this plots sensitivity against specificity 
roc <- validation_summary$roc() %>%
  collect() %>%
  ggplot(aes(x = FPR, y = TPR)) +
  geom_line() +
  geom_abline(lty = "dashed")

validation_summary$area_under_roc()

# generalised linear regression
glr <- ml_generalized_linear_regression(
  data_train,
  pmcount ~ scaled_tas + scaled_tasmin + scaled_tasmax + scaled_rainfall + scaled_hurs + type + year,
  family = "binomial"
)

pred <- ml_predict(glr, data_test)

ml_regression_evaluator(pred, label_col = "Count")


validation_summary <- ml_evaluate(glr, data_test)
validation_summary$aic()



# Disconnect spark connection
spark_disconnect(sc)



