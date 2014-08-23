# Question 3:
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
# variable, which of these four sources have seen decreases in emissions from 1999–2008
# for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the
# ggplot2 plotting system to make a plot answer this question.

# Check to see if our data files are present in the cwd
if( !all( file.exists('./Source_Classification_Code.rds', './summarySCC_PM25.rds')) ) {
  stop('Error: Data files not found!!!')
}

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load ggplot2 library
library(ggplot2)

# Subset data
NEIsub <- subset(NEI, fips=='24510')

# Get emissions and dates
yrs <- NEIsub$year
pm <- NEIsub$Emissions
pts <- NEIsub$type

# Create a data frame
df <- data.frame(years=yrs, emissions=pm, points=pts)

# Aggregate the emission date by years and sources
df2<-with(df, aggregate(emissions, by=list(years,points), sum, na.rm=T))
names(df2)<-c('year','type','emissions')

# Create plot
gplot <- qplot(year, emissions, data=df2, color=type, geom=c('point', 'smooth'),
method='lm',
main='Total Emissions from PM2.5 in Baltimore City, MD by Source',
xlab='Year',
ylab='Total Emissions') +
facet_wrap(~type, nrow=2) +
scale_colour_discrete(name = "Source")

# Print plot
print(gplot)

# Generate png file
dev.copy(png, file = "./plot3.png")
dev.off()


