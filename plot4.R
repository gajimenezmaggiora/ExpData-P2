# Question 4:
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

# Check to see if our data files are present in the cwd
if( !all( file.exists('./Source_Classification_Code.rds', './summarySCC_PM25.rds')) ) {
  stop('Error: Data files not found!!!')
}

# Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get SCC codes that have keywords 'coal' and 'combustion' (case insensitive)
codesDF<-subset(SCC, grepl('coal',SCC.Level.Three, ignore.case=T) & grepl('combustion',SCC.Level.One, ignore.case=T))

# Merge the codes with the NEI data set
df <- merge(NEI, codesDF, by=c('SCC'))

# Aggregate the total emissions by year
pm <- with(df, aggregate(Emissions, by=list(year), sum, na.rm=T))
names(pm)<-c('year', 'emissions')

# Generate plot
with(pm, plot(year,emissions, xlab='Year', ylab='Total Emissions', xlim=c(1999,2008)))
abline(with(pm,lm(emissions~year)), col='red')
title('Total PM2.5 Emissions from\nCoal Combustion-Related Sources in US')

# Generate png file
dev.copy(png, file = "./plot4.png")
dev.off()




