# Description: Use the uploaded data that has been cleaned to plot necessary visualizations

# Plot 1: Outline of Congestion Charge ----

# Plot the data
borough_colors <- c("1" = "red", "2" = "darkgray", "3" = "lightgray", "4" = "wheat", "5" = "linen")
png(filename = "../output/Borough_Outline.png", width = 480, height = 480)
plot(stgeo, main = "Outline of NYC Congestion Charge")
for (i in 1:length(boroughs$borocode)) {
  plot(stgeo[boroughs$borocode == i,], col = borough_colors[i], add = T, border = "black") 
}
legend("topleft", legend = c("Manhattan", "The Bronx", "Brooklyn", "Queens", "Staten Island"), col = c("red", "darkgray", "lightgray", "wheat", "linen"), fill = borough_colors, title = "Boroughs")
dev.off()


# Plot 2: Initial Plots of PM2.5 in NYC ----

# Create a png displaying PM 2.5 data in NYC from Oct 2024 - Feb 2025
png(filename = "../output/PM2.5_NYC.png", width = 800, height = 600)

plot(air_quality_nyc$week, air_quality_nyc$Value, type = "l", col = "black", xlab = "Date (Week)", ylab = "PM2.5 Value", cex.lab = 1.5, cex.axis = 1.5, main = "PM 2.5 in NYC", cex.main = 2)
abline(v = implementation_date, lty = 2, col = "red")

dev.off()


# Plot 3: Speed captured by EZ Pass Tolls

# Create a png file displaying average speed in frames per second captured by NYC EZ Pass Tolls
png(filename = "../output/EZ_Pass_Speeds.png", width = 800, height = 600)

plot(ez_pass$week, ez_pass$median_speed_fps, type = "l", col = "black", xlab = "Date (Week)", ylab = "Average Speed (FPS)", cex.lab = 1.5, cex.axis = 1.5, main = "Average Speed Captured by EZ Pass Tolls", cex.main = 2)
abline(v = implementation_date, lty = 2, col = "red")

dev.off()

png(filename = "../output/Speed_Comparisons.png", width = 1200, height = 600)
layout(matrix(c(1, 2), nrow = 1, byrow = TRUE), heights = c(1, 1), widths = c(1, 1))
par(oma = c(2, 2, 4, 2))
par(mar = c(4, 6, 4, 6))

plot(ez_pass$week_number, ez_pass$median_speed_fps, type = "l", col = "black", ylim = c(9, 22), xlab = "", ylab = "Average Speed (FPS)", cex.lab = 1.5, cex.axis = 1.5, main = "")
lines(ez_pass_2022_2023$week_number, ez_pass_2022_2023$median_speed_fps, type = "l", col = "blue")
lines(ez_pass_2023_2024$week_number, ez_pass_2023_2024$median_speed_fps, type = "l", col = "purple")
abline(v = 10.25, lty = 2, col = "red")
legend("bottomleft", legend = c("Nov. 2022 - Jan. 2023", "Nov. 2023 - Jan. 2024", "Nov. 2024 - Jan. 2025"), fill = c("blue", "purple", "black"), xpd = TRUE)

plot(ez_pass$week_number[11:14], ez_pass$median_speed_fps[11:14]+2.2671, type = "l", col = "black", ylim = c(16, 19), xlab = "", ylab = "Average Speed (FPS)", yaxt = "n", cex.lab = 1.5, cex.axis = 1.5, main = "")
lines(ez_pass_2022_2023$week_number[11:14], ez_pass_2022_2023$median_speed_fps[11:14]-2.11599, type = "l", col = "blue")
lines(ez_pass_2023_2024$week_number[11:14], ez_pass_2023_2024$median_speed_fps[11:14], type = "l", col = "purple")
legend("bottomleft", legend = c("Jan. 2023", "Jan. 2024", "Jan. 2025"), fill = c("blue", "purple", "black"), xpd = TRUE)

mtext("Comparison Speeds", side = 3, line = 0.5, font = 1, cex = 2, outer = TRUE)
mtext("Weeks from November to February", side = 1, line = 0.5, font = 1, cex = 1.5, outer = TRUE)

dev.off()


# Plot 4: Initial Demand Plots Post Congestion Charge ----

# Create a png file, specify parameters and multi-graph layout
png(filename = "../output/Daily_Ridership.png", width = 1000, height = 800)
layout(matrix(c(1, 2, 3, 4, 5, 6, 7, 7, 7), nrow = 3, byrow = TRUE), heights = c(1, 1, 1, 0.5), widths = c(1, 1, 1, 1))
par(oma = c(2, 2, 4, 2))
par(mar = c(4, 6, 4, 6))

type_of_transport <- c("Subways", "Busses", "Metro_North", "Access_A_Ride", "Bridges_Tunnels", "Staten_Island_railroad")
colors <- c("black", "pink", "blue", "green", "orange", "purple")
ylabs <- c("Mean Ridership", "Mean Ridership", "Mean Ridership", "Mean Ridership", "Mean Traffic", "Mean Ridership")

# Plots each mode of transportation and a vertical line for implementation date of congestion charge
for (i in 1:length(type_of_transport)) {
  plot(weekly_averages$week, weekly_averages[[type_of_transport[i]]], type = "l", col = colors[i], xlab = "Date (Week)", ylab = ylabs[i], cex.lab = 1.5, cex.axis = 1.5)
  abline(v = implementation_date, lty = 2, col = "red")
}

# Define parameters and create an empty plot, which is filled by the legend
par(mar = c(0, 0, 0, 0))
plot.new()
legend("center", horiz = TRUE, legend = c("Subway", "Bus", "Metro North", "Access a Ride", "Bridge/Tunnel Traffic", "Staten Island Railway"), fill = c("black", "pink", "blue", "green", "orange", "purple"), cex = 1.5, title = "Mode of Transportation")

# main title of plot
mtext("Public Transportation Ridership in NYC", side = 3, line = 0.5, font = 1, cex = 2, outer = TRUE)

dev.off()


# Plot 5: Weekly Arrest Frequency per Borough ----

# Create a png file and set parameters
png(filename = "../output/Arrests_by_Borough.png", width = 1000, height = 800)
layout(matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2), heights = c(1, 1, 1, 0.5), widths = c(1, 1, 1, 1))
layout.show()
par(oma = c(2, 2, 4, 2))
par(mar = c(4, 6, 4, 6))

# Plot the Data
borough_crime_list <- list(Manhattan = Manhattan_crime, Bronx = Bronx_crime, Brooklyn = Brooklyn_crime, Queens = Queens_crime, StatenIsland = StatenIsland_crime)
colors_borough <- c("black", "pink", "blue", "green", "purple")
for (i in 1:length(borough_crime_list)) {
  crime_data <- borough_crime_list[[i]]
  plot(crime_data$Date, crime_data$Arrests, type = "l", col = colors_borough[i], xlab = "Date (Week)", ylab = "Arrests", cex.lab = 1.5, cex.axis = 1.5)
  abline(v = implementation_date, lty = 2, col = "red")
}

# Define parameters and create an empty plot, which is filled by the legend
par(mar = c(0, 0, 0, 0))
plot.new()
legend("center", horiz = TRUE, legend = c("Manhattan", "Bronx", "Brooklyn", "Queens", "Staten Island"), fill = c("black", "pink", "blue", "green", "purple"), cex = 1.25, title = "Borough")

# main title of plot
mtext("Arrests by Borough", side = 3, line = 0.5, font = 1, cex = 2, outer = TRUE)

dev.off()


# Plot 6: Model 1 Regression Results ----

# Create a png file and send output to correct folder
png(filename = "../output/Parallel_pretrends_visualization.png", width = 800, height = 600)

# Plot the Data
plot(manhattan_pre_trends$Date, manhattan_pre_trends$Arrests, type = "l", col = "black", xlab = "Date", ylab = "Arrests", main = "Visualization of Parallel Pre Trends")
lines(non_manhattan_pretrends$Date, non_manhattan_pretrends$Arrests, type = "l", col = "black", lty = 2)

# Vertical line for implementation date and legend
abline(v = implementation_date, col = "red", lty = 2)
legend("bottomleft", legend = c("Manhattan Arrests", "Other Boroughs Arrests"), lty = c(1, 2), col = c("black", "black"))

dev.off()

