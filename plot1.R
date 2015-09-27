### Loading libraries
library(dplyr)

### Loading data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")

### Reformatting data
NEI <- tbl_df(NEI)

### Filtering data
NEI.total <- (NEI
        %>% group_by(year)
        %>% summarize(total = sum(Emissions)/1e3)
        )

### Plotting and saving the data
ppi <- 200
png(file = 'plot1.png', width = 6*ppi, height = 4*ppi, res = ppi)

barplot(NEI.total$total, names.arg = NEI.total$year,
        xlab = "Year", ylab = "Total PM2.5 Emission (10^3 tons)",
        main = "PM2.5 Emissions across the United States, 1999-2008")

dev.off()
