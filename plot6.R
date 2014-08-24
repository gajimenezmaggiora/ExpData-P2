# Question 6:
# Compare emissions from motor vehicle sources in Baltimore City
# with emissions from motor vehicle sources in Los Angeles County,
# California (fips == "06037"). Which city has seen greater changes
# over time in motor vehicle emissions?

# Check to see if our data files are present in the cwd
if( !all( file.exists('./Source_Classification_Code.rds', './summarySCC_PM25.rds')) ) {
  stop('Error: Data files not found!!!')
}

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get SCC codes that have the 'vehicle' keyword (case insensitive)
codesDF<-subset(SCC, grepl('vehicle', SCC.Level.Two,ignore.case=T))

# Merge the codes with the NEI data set
df <- merge(NEI, codesDF, by=c('SCC'))

# Subset just to Baltimore City
df2 <- subset(df, fips == "24510" | fips == "06037")

# Aggregate the total emissions by year and fips
pm <- with(df2, aggregate(Emissions, by=list(fips, year), sum, na.rm=T))
names(pm)<-c('fips', 'Year', 'Emissions')

# Change Fips codes to city codes
pm[pm$fips=='06037',]$fips<-'Los Angeles'
pm[pm$fips=='24510',]$fips<-'Baltimore'

# Create plot - log10(Emissions) to normalize
gplot <- qplot(Year, log10(Emissions), data=pm, color=fips, geom=c('point','smooth'), method='lm',
               main='Change in Total PM2.5 Emissions from Motor Vehicle-Related\nSources by City') +
  scale_colour_discrete(name = "City")

# Print plot
print(gplot)

# Generate png file
dev.copy(png, file = "./plot6.png")
dev.off()
