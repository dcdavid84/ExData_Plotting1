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

# combine Date and time into 1 variable, zse strptime to convert into POSIXlt variable
# cast to PoSIXct as otherwise not accepted by dplyr
date_and_time=with(epowercon,paste(Date,Time))
epowercon %>% mutate(Date=dmy(Date),date_and_time=as.POSIXct(strptime(date_and_time,"%d/%m/%Y %H:%M:%S"))) %>% mutate_at(num_colnames,as.numeric)->epowercon

# reduce dataset to entries from dates: 2007-02-01 and 2007-02-02 (ymd assumed) 

date_th <- c("2007-02-01","2007-02-02")
epowercon %>% filter(Date>=ymd(date_th[1]),Date<=ymd(date_th[2]))-> epowercon

# generate line plot, x=Date, y=Global active power and plot to png graphics device
png(file="figure/plot2.png", width=480, height=480, units="px")
plot(epowercon$date_and_time, epowercon$Global_active_power,xlab="", ylab="Global Active Power (kilowatts)",type="l")
dev.off()


