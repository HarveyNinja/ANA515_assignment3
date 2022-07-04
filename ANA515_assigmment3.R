getwd()
library(tidyverse)
library(dplyr)
library(stringr)
library(ggplot2)

Stormdata <- read_csv("/Users/liupeide/Desktop/R_code/StormEvents_details-ftp_v1.0_d1992_c20220425.csv")

#2select variable
limitvars <-c("BEGIN_YEARMONTH","BEGIN_DAY",
              "BEGIN_TIME","END_YEARMONTH","END_DAY","END_TIME",
              "EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_TYPE",
              "CZ_FIPS","CZ_NAME","EVENT_TYPE","SOURCE",
              "BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
df1 <-Stormdata[limitvars]
head(df1,6)

#3
df1 %>%
  arrange(STATE)
#4.	Change state and county names to title case 
df1$STATE <-str_to_title(df1$STATE)
head(df1$STATE,6)
                            
#str_to_title(df1$STATE)
#5. Limit to the events listed by county FIPS 
df1 <- filter(df1,CZ_TYPE =="C")
df1 <- select(df1,-CZ_TYPE)

#6
df1$STATE_FIPS <-str_pad(df1$STATE_FIPS,width = 3,side = "left",pad = "0")
df1$CZ_FIPS <- str_pad(df1$CZ_FIPS,width =3,side = "left",pad = "0")
unite(df1,"fips",c(STATE_FIPS,CZ_FIPS),sep = "")

#7
df1 <-rename_all(df1,tolower)

#8
us_state_info<-data.frame(state=state.name,region=state.region,area=state.area)

#9
Newset <-data.frame(table(df1$state))
Newset1<-rename(Newset,c("state"="Var1"))

merged<-merge(x=Newset1,y=us_state_info,by.x = "state",by.y = "state")
head(merged)
view(merged)
#10
storm_plot <- ggplot(merged,aes(x = area, y = Freq))+
  geom_point(aes(color=region))+
  labs(x ="land area (square miles)",
       y ="# of storm events in 2017")
storm_plot



