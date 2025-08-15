# Description: Load necessary libraries and create directories

# Create Directories and load necessary packages ----
rm(list=ls())
want <- c("RColorBrewer","plm","lfe","sandwich","lmtest","multiwayvcov","nlme","boot", "sf","terra","RColorBrewer","Matrix","tmaptools","rworldmap", "av", "magick", "maps", "mapproj", "utils")
need <- want[!(want %in% installed.packages()[,"Package"])]
if (length(need)) install.packages(need)
lapply(want, function(i) require(i, character.only=TRUE))
rm(want, need)

dir <- list()
dir$root <- dirname(getwd())
dir$data   <- paste(dir$root,"/data",sep="")
dir$output <- paste(dir$root,"/output",sep="")
dir$raster <- paste(dir$root,"/data/raster",sep="")
dir$shape <- paste(dir$root,"/data/shapefile",sep="")

# Section 1: Load Air Quality Data
air_quality_oct <- paste(dir$data,"/oct2024_hourlyMonitoring.csv", sep = "")
air_quality_oct <- read.csv(air_quality_oct)
air_quality_nov <- paste(dir$data,"/nov2024_hourlyMonitoring.csv", sep = "")
air_quality_nov <- read.csv(air_quality_nov)
air_quality_dec <- paste(dir$data,"/dec2024_hourlyMonitoring.csv", sep = "")
air_quality_dec <- read.csv(air_quality_dec)
air_quality_jan <- paste(dir$data,"/jan2025_hourlyMonitoring.csv", sep = "")
air_quality_jan <- read.csv(air_quality_jan)
air_quality_feb <- paste(dir$data,"/feb2025_hourlyMonitoring.csv", sep = "")
air_quality_feb <- read.csv(air_quality_feb)


# Section 2: Load EZ Pass Data
ez_pass <- paste(dir$data,"/EZ_Pass.csv", sep = "")
ez_pass <- read.csv(ez_pass)

ez_pass_2023_2024 <- paste(dir$data,"/EZ_Pass_2023_2024.csv", sep = "")
ez_pass_2023_2024 <- read.csv(ez_pass_2023_2024)

ez_pass_2022_2023 <- paste(dir$data,"/EZ_Pass_2022_2023.csv", sep = "")
ez_pass_2022_2023 <- read.csv(ez_pass_2022_2023)
# Due to large size may take a few minutes to load


# Section 3: Load Raster and Shape file Data for Borough Visualization ----

# Load Raster data and shape files
fname <- paste(dir$shape,"/Borough Boundaries/geo_export_54d23f71-68b8-40ec-9f00-0492bfe7d77e.shp",sep="")

# Read the data and gather geometries
boroughs <- st_read(fname)
stgeo <- st_geometry(boroughs)


# Section 4: Load the MTA Ridership Data ----

# Load the Data
MTA_ridership_data <- paste(dir$data,"/MTA_Daily_Ridership_Data__2020_-_2025_20250409.csv", sep = "")
MTA_ridership_data <- read.csv(MTA_ridership_data)


# Section 5: Load the NYC Arrests Data ----

# Load the data, might take a few minutes for a large data set
NYC_arrests_data <- paste(dir$data,"/NYPD_Arrest_Data__Year_to_Date__20250410.csv", sep = "")
NYC_arrests_data <- read.csv(NYC_arrests_data)
