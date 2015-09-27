### Loading libraries
library(dplyr)
library(ggplot2)

### Loading data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### Reformatting data
NEI <- tbl_df(NEI)
SCC <- tbl_df(SCC)
SCC$SCC <- as.vector(SCC$SCC)

### Filtering data matching motor vehicle emissions
SCC.motor <- filter(SCC,grepl("[vV]ehicle", SCC.Level.Two))

motor <- (NEI 
          %>% filter(fips == "06037" | fips == "24510")
          %>% semi_join(SCC.motor, by = "SCC") 
          %>% group_by(year,fips) 
          %>% summarize(total = sum(Emissions))
          )

motor$fips <- gsub("06037", "Los Angeles County", motor$fips)
motor$fips <- gsub("24510", "Baltimore City", motor$fips)
motor <- rename(motor, city = fips)

### Plotting data
ggp <- ggplot(data = motor, aes(x = factor(year), y=total)) +
    geom_bar(aes(fill=year), stat="identity") +
    facet_grid(scales="free", space = "free", ~city) +
    guides(fill=FALSE) +
    theme(axis.text = element_text(size = 8)) +
    theme(axis.title = element_text(size = 8)) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
    theme(title = element_text(size = 12, hjust = 0.5)) +    
    labs(x = "Year", y = "Total PM2.5 Emission (tons)") +
    labs(title = "PM2.5 Emissions from Motor Vehicle Sources 
in Baltimore & LA, 1999-2008")

print(ggp)

### Saving the plot
ggsave(file = 'plot6.png', width = 6, height = 4, dpi = 200)