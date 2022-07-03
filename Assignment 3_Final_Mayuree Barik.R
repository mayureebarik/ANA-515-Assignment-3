#install.packages("tidyverse")
library(tidyverse)

##1)Read csv file
my_data <- read.csv(file = "StormEvents.csv", stringsAsFactors = FALSE)
my_data
head(my_data,6)

##2)Limit data frame
x.sub <- subset(my_data, select = c("BEGIN_DATE_TIME", "END_DATE_TIME", "EPISODE_ID", "EVENT_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON"))
x.sub
head(x.sub)

#3)Arrange data by state
x.sub<-arrange(x.sub, STATE)
x.sub

#4)Converting to title case
str_to_title(x.sub$STATE)
str_to_title(x.sub$CZ_NAME)
x.sub

#5a)Filter data 
filter(x.sub, CZ_TYPE == "C")
x.sub1 <- filter(x.sub, CZ_TYPE == "C")

#5b)Remove column
select(x.sub1,-c(CZ_TYPE))

#6a)Pad STATE_FIPS
str_pad(x.sub$STATE_FIPS,width = 3,side = "left",pad = "0" )
x.sub$STATE_FIPS <- str_pad(x.sub$STATE_FIPS,width = 3,side = "left",pad = "0" )

#6b)Pad CZ_fIPS
str_pad(x.sub$CZ_FIPS,width = 3,side = "left",pad = "0" )
x.sub$CZ_FIPS <- str_pad(x.sub$CZ_FIPS,width = 3,side = "left",pad = "0" )

#6c)Unite the STATE_FIPS & CZ_FIPS into 'FIPS' columns
unite(x.sub, col='FIPS', c('STATE_FIPS', 'CZ_FIPS'), sep = "")

#7)Change all the column names to lower case
x.sub <- rename_all(x.sub,tolower)

#8)Create a new dataframe with base R
us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)
us_state_info

#9a)Dataframe with the no of events per state in the year of birth
freq_table <- data.frame(table(x.sub$state))
freq_table <- rename(freq_table, state = Var1)
freq_table
us_state_info_new <- mutate_all(us_state_info, toupper) 

#9b)Merging the state information dataframe with state in year of my birth
merged <- merge(x=freq_table, y=us_state_info_new, by.x="state", by.y="state")
merged$area <- as.double(merged$area)

#10)Creating a scatter plot
library(ggplot2)
storm_plot_by_state <- ggplot(merged, aes(x=area, y=Freq)) +
  geom_point(aes(color=region)) +
  labs(x = "Land area (square miles)",
       y = "# of storm events(1996)")
storm_plot_by_state