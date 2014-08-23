# Question 1:
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all
# sources for each of the years 1999, 2002, 2005, and 2008.

# Check to see if our data files are present in the cwd
if( !all( file.exists('./Source_Classification_Code.rds', './summarySCC_PM25.rds')) ) {
  stop('Error: Data files not found!!!')
}

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get emissions and dates
yrs <- NEI$year
pm <- NEI$Emissions

# Calculate total emissions per year
emissions <- tapply(pm, yrs, sum, na.rm=T)
years <- as.numeric(names(emissions))

# Generate plot

plot(years, emissions, xlab='Year', ylab='Total Emissions', xlim=c(1999,2008))
abline(lm(emissions ~ years), col='red')
title('Total Emissions from PM2.5 in the US')

# Generate png file
dev.copy(png, file = "./plot1.png")
dev.off()

