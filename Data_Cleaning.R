# Description: Clean and manipulate the uploaded data, for plotting and regressing

# Section 1: Air Quality Data ----

# Add column for Month
air_quality_oct$month <- "oct"
air_quality_nov$month <- "nov"
air_quality_dec$month <- "dec"
air_quality_jan$month <- "jan"
air_quality_feb$month <- "feb"

# Combine the datasets
air_quality_nyc <- rbind(air_quality_oct, air_quality_nov, air_quality_dec, air_quality_jan, air_quality_feb)
air_quality_nyc$ObservationTimeUTC <- as.Date(air_quality_nyc$ObservationTimeUTC)

# Create weekly data of means from each day
air_quality_nyc$week <- cut(air_quality_nyc$ObservationTimeUTC, breaks = "week")
air_quality_nyc <- aggregate(Value ~ week, data = air_quality_nyc, FUN = mean)
air_quality_nyc$week <- as.Date(air_quality_nyc$week)


# Section 2: EZ Pass Data ----

# Convert time stamps to dates, create week breaks
ez_pass$median_calculation_timestamp <- as.Date(ez_pass$median_calculation_timestamp, format = "%m/%d/%Y %I:%M:%S %p")
ez_pass$week <- cut(ez_pass$median_calculation_timestamp, breaks = "week")

ez_pass_2023_2024$median_calculation_timestamp <- as.Date(ez_pass_2023_2024$median_calculation_timestamp, format = "%m/%d/%Y %I:%M:%S %p")
ez_pass_2023_2024$week <- cut(ez_pass_2023_2024$median_calculation_timestamp, breaks = "week")

ez_pass_2022_2023$median_calculation_timestamp <- as.Date(ez_pass_2022_2023$median_calculation_timestamp, format = "%m/%d/%Y %I:%M:%S %p")
ez_pass_2022_2023$week <- cut(ez_pass_2022_2023$median_calculation_timestamp, breaks = "week")

# Find the weekly mean of the speed captured by EZ Pass tolls
ez_pass <- aggregate(median_speed_fps ~ week, data = ez_pass, FUN = mean)
ez_pass$week <- as.Date(ez_pass$week)
ez_pass$week_number <- 1:nrow(ez_pass)

ez_pass_2023_2024 <- aggregate(median_speed_fps ~ week, data = ez_pass_2023_2024, FUN = mean)
ez_pass_2023_2024$week <- as.Date(ez_pass_2023_2024$week)
ez_pass_2023_2024$week_number <- 1:nrow(ez_pass_2023_2024)

ez_pass_2022_2023 <- aggregate(median_speed_fps ~ week, data = ez_pass_2022_2023, FUN = mean)
ez_pass_2022_2023$week <- as.Date(ez_pass_2022_2023$week)
ez_pass_2022_2023$week_number <- 1:nrow(ez_pass_2022_2023)


# Section 3: MTA Ridership Data ----

# Clean the MTA Ridership Data
MTA_ridership_data$Date <- as.Date(MTA_ridership_data[,1], "%m/%d/%Y")
MTA_ridership_data <- MTA_ridership_data[, -c(3, 5, 6, 7, 9, 11, 13, 15)]
MTA_ridership_data <- MTA_ridership_data[MTA_ridership_data$Date >= as.Date("2024-01-01"), ]
MTA_ridership_data$week <- cut(MTA_ridership_data$Date, breaks = "week")
MTA_ridership_data <- MTA_ridership_data[, -c(1)]

# Condense the data to weekly means of total ridership
Subway_weekly_avg <- tapply(MTA_ridership_data$Subways..Total.Estimated.Ridership, MTA_ridership_data$week, mean)
Bus_weekly_avg <- tapply(MTA_ridership_data$Buses..Total.Estimated.Ridership, MTA_ridership_data$week, mean)
MetroNorth_weekly_avg <- tapply(MTA_ridership_data$Metro.North..Total.Estimated.Ridership, MTA_ridership_data$week, mean)
Access_a_Ride_weekly_avg <- tapply(MTA_ridership_data$Access.A.Ride..Total.Scheduled.Trips, MTA_ridership_data$week, mean)
Bridge_Tunnel_traffic_weekly_avg <- tapply(MTA_ridership_data$Bridges.and.Tunnels..Total.Traffic, MTA_ridership_data$week, mean)
StatenIsland_Railway_weekly_avg <- tapply(MTA_ridership_data$Staten.Island.Railway..Total.Estimated.Ridership, MTA_ridership_data$week, mean)

weekly_averages <- data.frame(week = names(Subway_weekly_avg), Subways = Subway_weekly_avg, Busses = Bus_weekly_avg, Metro_North = MetroNorth_weekly_avg, Access_A_Ride = Access_a_Ride_weekly_avg, Bridges_Tunnels = Bridge_Tunnel_traffic_weekly_avg, Staten_Island_railroad = StatenIsland_Railway_weekly_avg)
weekly_averages$week <- as.Date(weekly_averages[,1], "%Y-%m-%d")

# Date in which congestion charge went into effect
implementation_date <- as.Date("2025-01-03")


# Section 4: NYC Arrests Data ----

# Change Borough Labels
NYC_arrests_data$ARREST_BORO[NYC_arrests_data$ARREST_BORO == "M"] <- "Manhattan"
NYC_arrests_data$ARREST_BORO[NYC_arrests_data$ARREST_BORO == "B"] <- "Bronx"
NYC_arrests_data$ARREST_BORO[NYC_arrests_data$ARREST_BORO == "K"] <- "Brooklyn"
NYC_arrests_data$ARREST_BORO[NYC_arrests_data$ARREST_BORO == "Q"] <- "Queens"
NYC_arrests_data$ARREST_BORO[NYC_arrests_data$ARREST_BORO == "S"] <- "Staten Island"

# Clean the data
NYC_arrests_data$ARREST_DATE <- as.Date(NYC_arrests_data[,2], "%m/%d/%Y")
NYC_arrests_data$week <- cut(NYC_arrests_data$ARREST_DATE, breaks = "week")
NYC_arrests_data <- NYC_arrests_data[, -c(2)]
crime_stats <- data.frame(table(NYC_arrests_data$ARREST_BORO, NYC_arrests_data$week))

# Change Data Frame Labels
colnames(crime_stats)[colnames(crime_stats) == "Var1"] <- "Borough"
colnames(crime_stats)[colnames(crime_stats) == "Var2"] <- "Date"
colnames(crime_stats)[colnames(crime_stats) == "Freq"] <- "Arrests"

# Separate each Borough
Manhattan_crime <- crime_stats[crime_stats$Borough == "Manhattan",]
Manhattan_crime <- Manhattan_crime[, -c(1)]

Bronx_crime <- crime_stats[crime_stats$Borough == "Bronx",]
Bronx_crime <- Bronx_crime[, -c(1)]

Brooklyn_crime <- crime_stats[crime_stats$Borough == "Brooklyn",]
Brooklyn_crime <- Brooklyn_crime[, -c(1)]

Queens_crime <- crime_stats[crime_stats$Borough == "Queens",]
Queens_crime <- Queens_crime[, -c(1)]

StatenIsland_crime <- crime_stats[crime_stats$Borough == "Staten Island",]
StatenIsland_crime <- StatenIsland_crime[, -c(1)]

# Convert Borough Arrest Dates back to Date Types
Manhattan_crime$Date <- as.Date(Manhattan_crime$Date, "%Y-%m-%d")
Bronx_crime$Date <- as.Date(Bronx_crime$Date, "%Y-%m-%d")
Brooklyn_crime$Date <- as.Date(Brooklyn_crime$Date, "%Y-%m-%d")
Queens_crime$Date <- as.Date(Queens_crime$Date, "%Y-%m-%d")
StatenIsland_crime$Date <- as.Date(StatenIsland_crime$Date, "%Y-%m-%d")


# Section 5: Data Manipulations for Regression ----

# Create a data frame with all the necessary information for initial regression
crime_stats$Date <- as.Date(crime_stats$Date, format = "%Y-%m-%d")
crime_stats$Manhattan <- ifelse(crime_stats$Borough == "Manhattan", 1, 0)
pre_treatment_period <- subset(crime_stats, Date < as.Date("2025-01-03"))

pre_treatment_period$Borough <- as.factor(pre_treatment_period$Borough)

# Data for Pre Treatment Plot
manhattan_pre_trends <- subset(pre_treatment_period, Manhattan == 1)
non_manhattan_pretrends <- subset(pre_treatment_period, Manhattan == 0)

non_manhattan_pretrends <- non_manhattan_pretrends[, -c(1)]
non_manhattan_pretrends <- aggregate(Arrests ~ Date, data = non_manhattan_pretrends, FUN = mean)

