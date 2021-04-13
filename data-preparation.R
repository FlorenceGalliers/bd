## Data Preparation for Big Data Assignment ####
## 2020-04-06

library(ncdf4) 
library(raster) 
library(rgdal) 
library(ggplot2)
library(tidyverse)
library(sf)

# Read in GBIF observation data for Tree Sparrow (Passer montanus)
pm <- read.csv("passer-montanus.csv")

# create loop that makes a new object for each year only containing observations for that year
for (i in 2001:2019){
    nam <- paste("_pm", i, sep = "")
    assign(nam, 
           st_transform(st_as_sf(x = (pm %>%
                   filter(year == i) %>%
                   dplyr::select(decimalLongitude, decimalLatitude)),
                   coords = c("decimalLongitude", "decimalLatitude"),
                   crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"),
                   crs = "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +a=6377563.396 +b=6356256.909
+units=m +no_defs")
           )
}

pm_data <- ls(pattern = glob2rx("_pm*"))
pm_obs <- seq(pm_data) 

# selection only observations from 2019 and lat and lon
#pm1 <- pm %>%
#  filter(year == 2015) %>%
#  dplyr::select(decimalLongitude, decimalLatitude)

# convert to sf object
#pm2 <- st_as_sf(x = pm1, coords = c("decimalLongitude", "decimalLatitude"),
#                        crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
# transform to projection of climate data
#pm3 <- st_transform(pm2, crs="+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +a=6377563.396 +b=6356256.909
#+units=m +no_defs")

# TEMPERATURE DATA

# create loop that makes raster object for average temperature for each year

filenames <- Sys.glob("data/tas/tas_hadukgrid_uk_5km_ann_*.nc")
filenumber <- seq(filenames)

for (i in filenumber) {
  tas_data <- nc_open(filenames[i], write = TRUE)
  ncvar_change_missval(tas_data, varid = "tas", missval = 9.96921e+36 )
  lon <- ncvar_get(tas_data, varid = "projection_y_coordinate")
  lat <- ncvar_get(tas_data, varid = "projection_x_coordinate")
  tas <- ncvar_get(tas_data, varid = "tas")
  nc_close(tas_data)
  a <- (i+2000)
  nam <- paste("pm_tas_", a, sep = "")
  assign(nam, brick(filenames[i], varname="tas"))
}


# EXTRACT temperature data from observation points
pm_tas_2001 <- data.frame(raster::extract(pm_tas_2001, pm2001), 2001)
colnames(pm_tas_2001) <- c("tas", "year")
pm_tas_2002 <- data.frame(raster::extract(pm_tas_2002, pm2002), 2002)
colnames(pm_tas_2002) <- c("tas", "year")
pm_tas_2003 <- data.frame(raster::extract(pm_tas_2003, pm2003), 2003)
colnames(pm_tas_2003) <- c("tas", "year")
pm_tas_2004 <- data.frame(raster::extract(pm_tas_2004, pm2004), 2004)
colnames(pm_tas_2004) <- c("tas", "year")
pm_tas_2005 <- data.frame(raster::extract(pm_tas_2005, pm2005), 2005)
colnames(pm_tas_2005) <- c("tas", "year")
pm_tas_2006 <- data.frame(raster::extract(pm_tas_2006, pm2006), 2006)
colnames(pm_tas_2006) <- c("tas", "year")
pm_tas_2007 <- data.frame(raster::extract(pm_tas_2007, pm2007), 2007)
colnames(pm_tas_2007) <- c("tas", "year")
pm_tas_2008 <- data.frame(raster::extract(pm_tas_2008, pm2008), 2008)
colnames(pm_tas_2008) <- c("tas", "year")
pm_tas_2009 <- data.frame(raster::extract(pm_tas_2009, pm2009), 2009)
colnames(pm_tas_2009) <- c("tas", "year")
pm_tas_2010 <- data.frame(raster::extract(pm_tas_2010, pm2010), 2010)
colnames(pm_tas_2010) <- c("tas", "year")
pm_tas_2011 <- data.frame(raster::extract(pm_tas_2011, pm2011), 2011)
colnames(pm_tas_2011) <- c("tas", "year")
pm_tas_2012 <- data.frame(raster::extract(pm_tas_2012, pm2012), 2012)
colnames(pm_tas_2012) <- c("tas", "year")
pm_tas_2013 <- data.frame(raster::extract(pm_tas_2013, pm2013), 2013)
colnames(pm_tas_2013) <- c("tas", "year")
pm_tas_2014 <- data.frame(raster::extract(pm_tas_2014, pm2014), 2014)
colnames(pm_tas_2014) <- c("tas", "year")
pm_tas_2015 <- data.frame(raster::extract(pm_tas_2015, pm2015), 2015)
colnames(pm_tas_2015) <- c("tas", "year")
pm_tas_2016 <- data.frame(raster::extract(pm_tas_2016, pm2016), 2016)
colnames(pm_tas_2016) <- c("tas", "year")
pm_tas_2017 <- data.frame(raster::extract(pm_tas_2017, pm2017), 2017)
colnames(pm_tas_2017) <- c("tas", "year")
pm_tas_2018 <- data.frame(raster::extract(pm_tas_2018, pm2018), 2018)
colnames(pm_tas_2018) <- c("tas", "year")
pm_tas_2019 <- data.frame(raster::extract(pm_tas_2019, pm2019), 2019)
colnames(pm_tas_2019) <- c("tas", "year")

pm_tas_data <- rbind(pm_tas_2001,
                     pm_tas_2002, pm_tas_2003, pm_tas_2004,
                     pm_tas_2005, pm_tas_2006, pm_tas_2007,
                     pm_tas_2008, pm_tas_2009, pm_tas_2010,
                     pm_tas_2011, pm_tas_2012, pm_tas_2013,
                     pm_tas_2014, pm_tas_2015, pm_tas_2016,
                     pm_tas_2017, pm_tas_2018, pm_tas_2019)


## MAX TEMP DATA - tasmax

# create loop that makes raster object for average temperature for each year
filenames2 <- Sys.glob("data/tasmax/tasmax_hadukgrid_uk_5km_ann_*.nc")
filenumber2 <- seq(filenames2)

for (i in filenumber2) {
  tasmax_data <- nc_open(filenames2[i], write = TRUE)
  ncvar_change_missval(tasmax_data, varid = "tasmax", missval = 9.96921e+36 )
  lon <- ncvar_get(tasmax_data, varid = "projection_y_coordinate")
  lat <- ncvar_get(tasmax_data, varid = "projection_x_coordinate")
  tasmax <- ncvar_get(tasmax_data, varid = "tasmax")
  nc_close(tasmax_data)
  a <- (i+2000)
  nam <- paste("pm_tasmax_", a, sep = "")
  assign(nam, brick(filenames2[i], varname="tasmax"))
}

# EXTRACT temperature data from observation points
pm_tasmax_01 <- data.frame(raster::extract(pm_tasmax_2001, pm2001), 2001)
colnames(pm_tasmax_01) <- c("tasmax", "year")
pm_tasmax_02 <- data.frame(raster::extract(pm_tasmax_2002, pm2002), 2002)
colnames(pm_tasmax_02) <- c("tasmax", "year")
pm_tasmax_03 <- data.frame(raster::extract(pm_tasmax_2003, pm2003), 2003)
colnames(pm_tasmax_03) <- c("tasmax", "year")
pm_tasmax_04 <- data.frame(raster::extract(pm_tasmax_2004, pm2004), 2004)
colnames(pm_tasmax_04) <- c("tasmax", "year")
pm_tasmax_05 <- data.frame(raster::extract(pm_tasmax_2005, pm2005), 2005)
colnames(pm_tasmax_05) <- c("tasmax", "year")
pm_tasmax_06 <- data.frame(raster::extract(pm_tasmax_2006, pm2006), 2006)
colnames(pm_tasmax_06) <- c("tasmax", "year")
pm_tasmax_07 <- data.frame(raster::extract(pm_tasmax_2007, pm2007), 2007)
colnames(pm_tasmax_07) <- c("tasmax", "year")
pm_tasmax_08 <- data.frame(raster::extract(pm_tasmax_2008, pm2008), 2008)
colnames(pm_tasmax_08) <- c("tasmax", "year")
pm_tasmax_09 <- data.frame(raster::extract(pm_tasmax_2009, pm2009), 2009)
colnames(pm_tasmax_09) <- c("tasmax", "year")
pm_tasmax_10 <- data.frame(raster::extract(pm_tasmax_2010, pm2010), 2010)
colnames(pm_tasmax_10) <- c("tasmax", "year")
pm_tasmax_11 <- data.frame(raster::extract(pm_tasmax_2011, pm2011), 2011)
colnames(pm_tasmax_11) <- c("tasmax", "year")
pm_tasmax_12 <- data.frame(raster::extract(pm_tasmax_2012, pm2012), 2012)
colnames(pm_tasmax_12) <- c("tasmax", "year")
pm_tasmax_13 <- data.frame(raster::extract(pm_tasmax_2013, pm2013), 2013)
colnames(pm_tasmax_13) <- c("tasmax", "year")
pm_tasmax_14 <- data.frame(raster::extract(pm_tasmax_2014, pm2014), 2014)
colnames(pm_tasmax_14) <- c("tasmax", "year")
pm_tasmax_15 <- data.frame(raster::extract(pm_tasmax_2015, pm2015), 2015)
colnames(pm_tasmax_15) <- c("tasmax", "year")
pm_tasmax_16 <- data.frame(raster::extract(pm_tasmax_2016, pm2016), 2016)
colnames(pm_tasmax_16) <- c("tasmax", "year")
pm_tasmax_17 <- data.frame(raster::extract(pm_tasmax_2017, pm2017), 2017)
colnames(pm_tasmax_17) <- c("tasmax", "year")
pm_tasmax_18 <- data.frame(raster::extract(pm_tasmax_2018, pm2018), 2018)
colnames(pm_tasmax_18) <- c("tasmax", "year")
pm_tasmax_19 <- data.frame(raster::extract(pm_tasmax_2019, pm2019), 2019)
colnames(pm_tasmax_19) <- c("tasmax", "year")

pm_tasmax_data <- rbind(pm_tasmax_01,
                     pm_tasmax_02, pm_tasmax_03, pm_tasmax_04,
                     pm_tasmax_05, pm_tasmax_06, pm_tasmax_07,
                     pm_tasmax_08, pm_tasmax_09, pm_tasmax_10,
                     pm_tasmax_11, pm_tasmax_12, pm_tasmax_13,
                     pm_tasmax_14, pm_tasmax_15, pm_tasmax_16,
                     pm_tasmax_17, pm_tasmax_18, pm_tasmax_19)


## MINIMUM TEMP DATA - TASMIN
filenames3 <- Sys.glob("data/tasmin/tasmin_hadukgrid_uk_5km_ann_*.nc")
filenumber3 <- seq(filenames3)

for (i in filenumber3) {
  tasmin_data <- nc_open(filenames3[i], write = TRUE)
  ncvar_change_missval(tasmin_data, varid = "tasmin", missval = 9.96921e+36 )
  lon <- ncvar_get(tasmin_data, varid = "projection_y_coordinate")
  lat <- ncvar_get(tasmin_data, varid = "projection_x_coordinate")
  tasmin <- ncvar_get(tasmin_data, varid = "tasmin")
  nc_close(tasmin_data)
  a <- (i+2000)
  nam <- paste("pm_tasmin_", a, sep = "")
  assign(nam, brick(filenames3[i], varname="tasmin"))
}


# EXTRACT temperature data from observation points
pm_tasmin_01 <- data.frame(raster::extract(pm_tasmin_2001, pm2001), 2001)
colnames(pm_tasmin_01) <- c("tasmin", "year")
pm_tasmin_02 <- data.frame(raster::extract(pm_tasmin_2002, pm2002), 2002)
colnames(pm_tasmin_02) <- c("tasmin", "year")
pm_tasmin_03 <- data.frame(raster::extract(pm_tasmin_2003, pm2003), 2003)
colnames(pm_tasmin_03) <- c("tasmin", "year")
pm_tasmin_04 <- data.frame(raster::extract(pm_tasmin_2004, pm2004), 2004)
colnames(pm_tasmin_04) <- c("tasmin", "year")
pm_tasmin_05 <- data.frame(raster::extract(pm_tasmin_2005, pm2005), 2005)
colnames(pm_tasmin_05) <- c("tasmin", "year")
pm_tasmin_06 <- data.frame(raster::extract(pm_tasmin_2006, pm2006), 2006)
colnames(pm_tasmin_06) <- c("tasmin", "year")
pm_tasmin_07 <- data.frame(raster::extract(pm_tasmin_2007, pm2007), 2007)
colnames(pm_tasmin_07) <- c("tasmin", "year")
pm_tasmin_08 <- data.frame(raster::extract(pm_tasmin_2008, pm2008), 2008)
colnames(pm_tasmin_08) <- c("tasmin", "year")
pm_tasmin_09 <- data.frame(raster::extract(pm_tasmin_2009, pm2009), 2009)
colnames(pm_tasmin_09) <- c("tasmin", "year")
pm_tasmin_10 <- data.frame(raster::extract(pm_tasmin_2010, pm2010), 2010)
colnames(pm_tasmin_10) <- c("tasmin", "year")
pm_tasmin_11 <- data.frame(raster::extract(pm_tasmin_2011, pm2011), 2011)
colnames(pm_tasmin_11) <- c("tasmin", "year")
pm_tasmin_12 <- data.frame(raster::extract(pm_tasmin_2012, pm2012), 2012)
colnames(pm_tasmin_12) <- c("tasmin", "year")
pm_tasmin_13 <- data.frame(raster::extract(pm_tasmin_2013, pm2013), 2013)
colnames(pm_tasmin_13) <- c("tasmin", "year")
pm_tasmin_14 <- data.frame(raster::extract(pm_tasmin_2014, pm2014), 2014)
colnames(pm_tasmin_14) <- c("tasmin", "year")
pm_tasmin_15 <- data.frame(raster::extract(pm_tasmin_2015, pm2015), 2015)
colnames(pm_tasmin_15) <- c("tasmin", "year")
pm_tasmin_16 <- data.frame(raster::extract(pm_tasmin_2016, pm2016), 2016)
colnames(pm_tasmin_16) <- c("tasmin", "year")
pm_tasmin_17 <- data.frame(raster::extract(pm_tasmin_2017, pm2017), 2017)
colnames(pm_tasmin_17) <- c("tasmin", "year")
pm_tasmin_18 <- data.frame(raster::extract(pm_tasmin_2018, pm2018), 2018)
colnames(pm_tasmin_18) <- c("tasmin", "year")
pm_tasmin_19 <- data.frame(raster::extract(pm_tasmin_2019, pm2019), 2019)
colnames(pm_tasmin_19) <- c("tasmin", "year")

pm_tasmin_data <- rbind(pm_tasmin_01,
                     pm_tasmin_02, pm_tasmin_03, pm_tasmin_04,
                     pm_tasmin_05, pm_tasmin_06, pm_tasmin_07,
                     pm_tasmin_08, pm_tasmin_09, pm_tasmin_10,
                     pm_tasmin_11, pm_tasmin_12, pm_tasmin_13,
                     pm_tasmin_14, pm_tasmin_15, pm_tasmin_16,
                     pm_tasmin_17, pm_tasmin_18, pm_tasmin_19)


## RAINFALL DATA - rainfall

filenames4 <- Sys.glob("data/rainfall/rainfall_hadukgrid_uk_5km_ann_*.nc")
filenumber4 <- seq(filenames4)

for (i in filenumber4) {
  rainfall_data <- nc_open(filenames4[i], write = TRUE)
  ncvar_change_missval(rainfall_data, varid = "rainfall", missval = 9.96921e+36 )
  lon <- ncvar_get(rainfall_data, varid = "projection_y_coordinate")
  lat <- ncvar_get(rainfall_data, varid = "projection_x_coordinate")
  rainfall <- ncvar_get(rainfall_data, varid = "rainfall")
  nc_close(rainfall_data)
  a <- i+2000
  nam <- paste("pm_rainfall_", a, sep = "")
  assign(nam, brick(filenames4[i], varname="rainfall"))
}


# EXTRACT temperature data from observation points
pm_rainfall_01 <- data.frame(raster::extract(pm_rainfall_2001, pm2001), 2001)
colnames(pm_rainfall_01) <- c("rainfall", "year")
pm_rainfall_02 <- data.frame(raster::extract(pm_rainfall_2002, pm2002), 2002)
colnames(pm_rainfall_02) <- c("rainfall", "year")
pm_rainfall_03 <- data.frame(raster::extract(pm_rainfall_2003, pm2003), 2003)
colnames(pm_rainfall_03) <- c("rainfall", "year")
pm_rainfall_04 <- data.frame(raster::extract(pm_rainfall_2004, pm2004), 2004)
colnames(pm_rainfall_04) <- c("rainfall", "year")
pm_rainfall_05 <- data.frame(raster::extract(pm_rainfall_2005, pm2005), 2005)
colnames(pm_rainfall_05) <- c("rainfall", "year")
pm_rainfall_06 <- data.frame(raster::extract(pm_rainfall_2006, pm2006), 2006)
colnames(pm_rainfall_06) <- c("rainfall", "year")
pm_rainfall_07 <- data.frame(raster::extract(pm_rainfall_2007, pm2007), 2007)
colnames(pm_rainfall_07) <- c("rainfall", "year")
pm_rainfall_08 <- data.frame(raster::extract(pm_rainfall_2008, pm2008), 2008)
colnames(pm_rainfall_08) <- c("rainfall", "year")
pm_rainfall_09 <- data.frame(raster::extract(pm_rainfall_2009, pm2009), 2009)
colnames(pm_rainfall_09) <- c("rainfall", "year")
pm_rainfall_10 <- data.frame(raster::extract(pm_rainfall_2010, pm2010), 2010)
colnames(pm_rainfall_10) <- c("rainfall", "year")
pm_rainfall_11 <- data.frame(raster::extract(pm_rainfall_2011, pm2011), 2011)
colnames(pm_rainfall_11) <- c("rainfall", "year")
pm_rainfall_12 <- data.frame(raster::extract(pm_rainfall_2012, pm2012), 2012)
colnames(pm_rainfall_12) <- c("rainfall", "year")
pm_rainfall_13 <- data.frame(raster::extract(pm_rainfall_2013, pm2013), 2013)
colnames(pm_rainfall_13) <- c("rainfall", "year")
pm_rainfall_14 <- data.frame(raster::extract(pm_rainfall_2014, pm2014), 2014)
colnames(pm_rainfall_14) <- c("rainfall", "year")
pm_rainfall_15 <- data.frame(raster::extract(pm_rainfall_2015, pm2015), 2015)
colnames(pm_rainfall_15) <- c("rainfall", "year")
pm_rainfall_16 <- data.frame(raster::extract(pm_rainfall_2016, pm2016), 2016)
colnames(pm_rainfall_16) <- c("rainfall", "year")
pm_rainfall_17 <- data.frame(raster::extract(pm_rainfall_2017, pm2017), 2017)
colnames(pm_rainfall_17) <- c("rainfall", "year")
pm_rainfall_18 <- data.frame(raster::extract(pm_rainfall_2018, pm2018), 2018)
colnames(pm_rainfall_18) <- c("rainfall", "year")
pm_rainfall_19 <- data.frame(raster::extract(pm_rainfall_2019, pm2019), 2019)
colnames(pm_rainfall_19) <- c("rainfall", "year")

pm_rainfall_data <- rbind(pm_rainfall_01,
                        pm_rainfall_02, pm_rainfall_03, pm_rainfall_04,
                        pm_rainfall_05, pm_rainfall_06, pm_rainfall_07,
                        pm_rainfall_08, pm_rainfall_09, pm_rainfall_10,
                        pm_rainfall_11, pm_rainfall_12, pm_rainfall_13,
                        pm_rainfall_14, pm_rainfall_15, pm_rainfall_16,
                        pm_rainfall_17, pm_rainfall_18, pm_rainfall_19)

## HUMIDITY DATA - hurs

filenames5 <- Sys.glob("data/hurs/hurs_hadukgrid_uk_5km_ann_*.nc")
filenumber5 <- seq(filenames5)

for (i in filenumber5) {
  hurs_data <- nc_open(filenames5[i], write = TRUE)
  ncvar_change_missval(hurs_data, varid = "hurs", missval = 9.96921e+36 )
  lon <- ncvar_get(hurs_data, varid = "projection_y_coordinate")
  lat <- ncvar_get(hurs_data, varid = "projection_x_coordinate")
  hurs <- ncvar_get(hurs_data, varid = "hurs")
  nc_close(hurs_data)
  a <- i+2000
  nam <- paste("pm_hurs_", a, sep = "")
  assign(nam, brick(filenames5[i], varname="hurs"))
}

# EXTRACT temperature data from observation points
pm_hurs_01 <- data.frame(raster::extract(pm_hurs_2001, pm2001), 2001)
colnames(pm_hurs_01) <- c("hurs", "year")
pm_hurs_02 <- data.frame(raster::extract(pm_hurs_2002, pm2002), 2002)
colnames(pm_hurs_02) <- c("hurs", "year")
pm_hurs_03 <- data.frame(raster::extract(pm_hurs_2003, pm2003), 2003)
colnames(pm_hurs_03) <- c("hurs", "year")
pm_hurs_04 <- data.frame(raster::extract(pm_hurs_2004, pm2004), 2004)
colnames(pm_hurs_04) <- c("hurs", "year")
pm_hurs_05 <- data.frame(raster::extract(pm_hurs_2005, pm2005), 2005)
colnames(pm_hurs_05) <- c("hurs", "year")
pm_hurs_06 <- data.frame(raster::extract(pm_hurs_2006, pm2006), 2006)
colnames(pm_hurs_06) <- c("hurs", "year")
pm_hurs_07 <- data.frame(raster::extract(pm_hurs_2007, pm2007), 2007)
colnames(pm_hurs_07) <- c("hurs", "year")
pm_hurs_08 <- data.frame(raster::extract(pm_hurs_2008, pm2008), 2008)
colnames(pm_hurs_08) <- c("hurs", "year")
pm_hurs_09 <- data.frame(raster::extract(pm_hurs_2009, pm2009), 2009)
colnames(pm_hurs_09) <- c("hurs", "year")
pm_hurs_10 <- data.frame(raster::extract(pm_hurs_2010, pm2010), 2010)
colnames(pm_hurs_10) <- c("hurs", "year")
pm_hurs_11 <- data.frame(raster::extract(pm_hurs_2011, pm2011), 2011)
colnames(pm_hurs_11) <- c("hurs", "year")
pm_hurs_12 <- data.frame(raster::extract(pm_hurs_2012, pm2012), 2012)
colnames(pm_hurs_12) <- c("hurs", "year")
pm_hurs_13 <- data.frame(raster::extract(pm_hurs_2013, pm2013), 2013)
colnames(pm_hurs_13) <- c("hurs", "year")
pm_hurs_14 <- data.frame(raster::extract(pm_hurs_2014, pm2014), 2014)
colnames(pm_hurs_14) <- c("hurs", "year")
pm_hurs_15 <- data.frame(raster::extract(pm_hurs_2015, pm2015), 2015)
colnames(pm_hurs_15) <- c("hurs", "year")
pm_hurs_16 <- data.frame(raster::extract(pm_hurs_2016, pm2016), 2016)
colnames(pm_hurs_16) <- c("hurs", "year")
pm_hurs_17 <- data.frame(raster::extract(pm_hurs_2017, pm2017), 2017)
colnames(pm_hurs_17) <- c("hurs", "year")
pm_hurs_18 <- data.frame(raster::extract(pm_hurs_2018, pm2018), 2018)
colnames(pm_hurs_18) <- c("hurs", "year")
pm_hurs_19 <- data.frame(raster::extract(pm_hurs_2019, pm2019), 2019)
colnames(pm_hurs_19) <- c("hurs", "year")

pm_hurs_data <- rbind(pm_hurs_01,
                        pm_hurs_02, pm_hurs_03, pm_hurs_04,
                        pm_hurs_05, pm_hurs_06, pm_hurs_07,
                        pm_hurs_08, pm_hurs_09, pm_hurs_10,
                        pm_hurs_11, pm_hurs_12, pm_hurs_13,
                        pm_hurs_14, pm_hurs_15, pm_hurs_16,
                        pm_hurs_17, pm_hurs_18, pm_hurs_19)

#### LANDCOVER VARIBALES

for (i in 2001:2019){
  nam <- paste("pm", i, sep = "")
  assign(nam, 
         st_transform(st_as_sf(x = (pm %>%
                                      filter(year == i) %>%
                                      dplyr::select(decimalLongitude, decimalLatitude)),
                               coords = c("decimalLongitude", "decimalLatitude"),
                               crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"),
                      crs = "+proj=sinu +lon_0=0 +x_0=0 +y_0=0",
                      "+a=6371007.181 +b=6371007.181 +units=m +no_defs")
  )
}


pm_land_2001 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2001001_aid0001.tif"), pm2001), 2001)
pm_land_2002 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2002001_aid0001.tif"), pm2002), 2002)
pm_land_2003 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2003001_aid0001.tif"), pm2003), 2003)
pm_land_2004 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2004001_aid0001.tif"), pm2004), 2004)
pm_land_2005 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2005001_aid0001.tif"), pm2005), 2005)
pm_land_2006 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2006001_aid0001.tif"), pm2006), 2006)
pm_land_2007 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2007001_aid0001.tif"), pm2007), 2007)
pm_land_2008 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2008001_aid0001.tif"), pm2008), 2008)
pm_land_2009 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2009001_aid0001.tif"), pm2009), 2009)
pm_land_2010 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2010001_aid0001.tif"), pm2010), 2010)
pm_land_2011 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2011001_aid0001.tif"), pm2011), 2011)
pm_land_2012 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2012001_aid0001.tif"), pm2012), 2012)
pm_land_2013 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2013001_aid0001.tif"), pm2013), 2013)
pm_land_2014 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2014001_aid0001.tif"), pm2014), 2014)
pm_land_2015 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2015001_aid0001.tif"), pm2015), 2015)
pm_land_2016 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2016001_aid0001.tif"), pm2016), 2016)
pm_land_2017 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2017001_aid0001.tif"), pm2017), 2017)
pm_land_2018 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2018001_aid0001.tif"), pm2018), 2018)
pm_land_2019 <- data.frame(raster::extract(raster("data/land/MCD12Q1.006_LC_Type2_doy2019001_aid0001.tif"), pm2019), 2019)

colnames(pm_land_2001) <- c("land", "year")
colnames(pm_land_2002) <- c("land", "year")
colnames(pm_land_2003) <- c("land", "year")
colnames(pm_land_2004) <- c("land", "year")
colnames(pm_land_2005) <- c("land", "year")
colnames(pm_land_2006) <- c("land", "year")
colnames(pm_land_2007) <- c("land", "year")
colnames(pm_land_2008) <- c("land", "year")
colnames(pm_land_2009) <- c("land", "year")
colnames(pm_land_2010) <- c("land", "year")
colnames(pm_land_2011) <- c("land", "year")
colnames(pm_land_2012) <- c("land", "year")
colnames(pm_land_2013) <- c("land", "year")
colnames(pm_land_2014) <- c("land", "year")
colnames(pm_land_2015) <- c("land", "year")
colnames(pm_land_2016) <- c("land", "year")
colnames(pm_land_2017) <- c("land", "year")
colnames(pm_land_2018) <- c("land", "year")
colnames(pm_land_2019) <- c("land", "year")

pm_land_data <- rbind(pm_land_2001, pm_land_2002, pm_land_2003, pm_land_2004,
                      pm_land_2005, pm_land_2006, pm_land_2007, pm_land_2008,
                      pm_land_2009, pm_land_2010, pm_land_2011, pm_land_2012,
                      pm_land_2013, pm_land_2014, pm_land_2015, pm_land_2016,
                      pm_land_2017, pm_land_2018, pm_land_2019)


# combine all variables together into one data frame
finaldata <- cbind(pm_tas_data, pm_tasmin_data, pm_tasmax_data, pm_rainfall_data, pm_hurs_data, pm_land_data)
finaldata <- finaldata[, c(-4, -6, -8, -10, -12)]

pm <- pm %>%
  filter(year>=2001) %>%
  select(-year)

pm_finaldata <- cbind(finaldata, pm)
head(pm_finaldata)
pm_finaldata <- pm_finaldata %>%
  select (decimalLongitude, decimalLatitude, year, tas, tasmin, tasmax, rainfall, hurs, land) %>%
  drop_na()

head(pm_finaldata)
summary(pm_finaldata)

write.csv(pm_finaldata, file = "pm-data.csv")

# Find number of observations in each 0.1 degree grid square

# create function to count number of observations per grid cell
gridfunc <- function(xy, origin = c(0,0), cellsize = c(0.1,0.1)) {
  t(apply(xy, 1, function(z) cellsize/2+origin+cellsize*(floor((z - origin)/cellsize))))
}

data.df <- read.csv("pm-data.csv")

for (i in 2001:2019){
  data <- data.df %>%
    filter(year == i)
  coords <- gridfunc(cbind(data$decimalLongitude, data$decimalLatitude))
  data$X <- coords[, 1]
  data$Y <- coords[, 2]
  data$Cell <- paste(data$X, data$Y)
  counts <- by(data, data$Cell, function(d) c(d$X[1], d$Y[1], nrow(d)))
  counts2 <- matrix(unlist(counts), nrow=3)
  rownames(counts2) <- c("X", "Y", "Count")
  
  # put count data into csv file
  name <- paste("grid", i, sep = "_")
  write.csv(as.data.frame(t(counts2)), file = paste0("grid_data/", name, ".csv"))
  
  # aggregate data over cells, giving mean values for each environmental variable
  name2 <- paste("mean_", i, sep = "")
  assign(name2, data %>%
    select(tas, tasmin, tasmax, rainfall, hurs, Cell, year) %>%
    aggregate(by = list(data$Cell), FUN = mean) %>%
    select(-Cell, -Group.1))
  
  # turn land classifications into factor variables and find largest proportion of land for each Cell
  data$land <- as.factor(data$land)
  name3 <- paste("land_", i, sep = "")
  assign(name3, data %>%
           group_by(Cell, land) %>%
           summarise(c = n()) %>%
           filter(row_number(desc(c)) == 1) %>%
           select(land))
}

gridfiles <- Sys.glob("grid_data/grid_*.csv")
gridfile00 <- seq(gridfiles)

for (i in gridfile00){
  total <- read.csv(gridfiles[i])
  a <- (i+2000)
  name4 <- paste("count_", a, sep = "")
  assign(name4, total %>%
           select(Count))
}

# make new data frame containing all the variables ready to be used
# 5 environmental variables from mean_*
# land classes from land_*
# count variable from count_*

# first use rbind() to combine 2001-2019 objects for each of the three variables

mean_data <- rbind(mean_2001, mean_2002, mean_2003, mean_2004,
                   mean_2005, mean_2006, mean_2007, mean_2008,
                   mean_2009, mean_2010, mean_2011, mean_2012,
                   mean_2013, mean_2014, mean_2015, mean_2016,
                   mean_2017, mean_2018, mean_2019)

land_data <- rbind(land_2001, land_2002, land_2003, land_2004,
                   land_2005, land_2006, land_2007, land_2008,
                   land_2009, land_2010, land_2011, land_2012,
                   land_2013, land_2014, land_2015, land_2016,
                   land_2017, land_2018, land_2019)

count_data <- rbind(count_2001, count_2002, count_2003, count_2004,
                    count_2005, count_2006, count_2007, count_2008,
                    count_2009, count_2010, count_2011, count_2012,
                    count_2013, count_2014, count_2015, count_2016,
                    count_2017, count_2018, count_2019)

dd <- cbind(mean_data, land_data)
DD <- cbind(dd, count_data)
write.csv(DD, "final_data.csv")

read.csv("final_data.csv")




