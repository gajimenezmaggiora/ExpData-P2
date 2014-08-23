# Question 2:
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.

# Check to see if our data files are present in the cwd
if( !all( file.exists('./Source_Classification_Code.rds', './summarySCC_PM25.rds')) ) {
  stop('Error: Data files not found!!!')
}

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset data
NEIsub <- subset(NEI, fips=='24510')

# Get emissions and dates
yrs <- NEIsub$year
pm <- NEIsub$Emissions

# Calculate total emissions per year
emissions <- tapply(pm, yrs, sum, na.rm=T)
years <- as.numeric(names(emissions))

# Generate plot

plot(years, emissions, xlab='Year', ylab='Total Emissions', xlim=c(1999,2008))
abline(lm(emissions ~ years), col='red')
title('Total Emissions from PM2.5 in Baltimore City, MD')

# Generate png file
dev.copy(png, file = "./plot2.png")
dev.off()
