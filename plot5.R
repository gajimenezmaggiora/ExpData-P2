# Question 5:
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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
df2 <- subset(df, fips == "24510")

# Aggregate the total emissions by year
pm <- with(df2, aggregate(Emissions, by=list(year), sum, na.rm=T))
names(pm)<-c('year', 'emissions')

# Generate plot
with(pm, plot(year,emissions, xlab='Year', ylab='Total Emissions', xlim=c(1999,2008)))
abline(with(pm,lm(emissions~year)), col='red')
title('Total PM2.5 Emissions from Motor Vehicle-Related\nSources in Baltimore City, MD', cex.main=.9)

# Generate png file
dev.copy(png, file = "./plot5.png")
dev.off()

