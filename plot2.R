### Loading libraries
library(dplyr)

### Loading data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")

### Reformatting data
NEI <- tbl_df(NEI)

### Filtering data
baltimore <- (NEI
              %>% filter(fips == "24510")
              %>% group_by(year)
              %>% summarize(total = sum(Emissions))
              )

### Plotting and saving the data
ppi <- 200
png(file = 'plot2.png', width = 6*ppi, height = 4*ppi, res = ppi)

barplot(baltimore$total, names.arg = baltimore$year,
        xlab = "Year", ylab = "Total PM2.5 Emission (tons)",
        main = "PM2.5 Emissions in Baltimore City, 1999-2008")

dev.off()
