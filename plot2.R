# load library required for 
#       -fread (large datasets): data.table
#       -Date variable casting: lubridate
#       -handling data tables: dplyr

library(data.table)
library(dplyr)
library(lubridate)

# download file
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename<-"ElectricpowerConsumption.zip"
download.file(url, destfile=filename)

# unzip downloaded zip file and store in wd
unzip(filename)

# read dataset, convert to tiblle and store in variable "epowercon"
epowercon <- as_tibble(fread("household_power_consumption.txt"))

# cast first two columns to date
# cast rest of columns (3 to 9) to numeric

num_colnames <- names(epowercon)[3:9]
epowercon %>% mutate(Date=dmy(Date),Time=hms(Time)) %>% mutate_at(num_colnames,as.numeric)->epowercon

# reduce dataset to entries from dates: 2007-02-01 and 2007-02-02 (ymd assumed) 

date_th <- c("2007-02-01","2007-02-02")
epowercon %>% filter(Date>=ymd(date_th[1]),Date<=ymd(date_th[2]))-> epowercon


# histogramm, with red bars, breaks: default
png(file="figure/plot1.png", width=480, height=480, units="px")
hist(epowercon$Global_active_power,main="Global Active Power", xlab="Global Active Power (kilowatts)",col="red")
dev.off()


