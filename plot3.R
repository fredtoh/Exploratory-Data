### Loading libraries
library(dplyr)
library(ggplot2)

### Loading data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")

### Reformating data
NEI <- tbl_df(NEI)

### Filtering data matching motor vehicle emissions
baltimore <- (NEI 
          %>% filter(fips == "24510")
          %>% group_by(year,type)
          %>% summarize(total = sum(Emissions))
          )

### Plotting the data
ggp <- ggplot(data = baltimore, aes(x = factor(year), y=total)) +
    geom_bar(aes(fill=year), stat="identity") +
    facet_grid(scales="free", space = "free", ~type) +
    guides(fill=FALSE) +
    theme(axis.text = element_text(size = 8)) +
    theme(axis.title = element_text(size = 8)) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
    theme(title = element_text(size = 12, hjust = 0.5)) +
    labs(x = "Year", y = "Total PM2.5 Emission (tons)") +
    labs(title = "PM2.5 Emissions from Various Source Types 
in Baltimore City, 1999-2008")

print(ggp)

### Saving the plot
ggsave(file = 'plot3.png', width = 6, height = 4, dpi = 200)