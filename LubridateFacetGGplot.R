#Lubridate and faceting with ggplot2
#Tess Grynoch
#Based off of the Software Carpentry R for Social Scientists lesson

#install tidyverse package - only need to do once per computer/environment
#install.packages("tidyverse")

#libraries
library(tidyverse)

#create some folders to put our data and plots
dir.create("data")
dir.create("fig_output")

#download messy data
download.file(
  "https://raw.githubusercontent.com/datacarpentry/r-socialsci/main/episodes/data/SAFI_clean.csv",
  "data/SAFI_clean.csv", mode = "wb"
)

#data
interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")

##Lubridate##
#if you're using an older version of tidyverse (pre-2022) 
#you made need to load lubridate seperately 
#library(lubridate)

#if we look at the structure of the data, 
#we have dates in the interview_date column
str(interviews)

#extract the date column
dates <- interviews$interview_date
str(dates)

#create new columns for day, month, and year
interviews$day <- day(dates)
interviews$month <- month(dates)
interviews$year <- year(dates)
interviews

#we have formatted dates in our data but we can also use
#lubridate to change non-date vectors into a date vector
char_dates <- c("7/31/2012", "8/9/2014", "4/30/2016")
str(char_dates)

#convert to date vector
as_date(char_dates, format = "%m/%d/%Y")
#Nice summary table of formatting dates: https://www.statology.org/r-date-format/

#Capitalization is important. Try:
as_date(char_dates, format = "%m/%d/%y") #should get warning

#Order is important. Try:
as_date(char_dates, format = "%d/%m/%y") #will also get warning

#can also use mdy() function to convert from character to date
mdy(char_dates)

#similar functions ymd() and dmy() for character dates in other formats

##Faceting with ggplot2##
#Clean data
interviews_plotting <- interviews %>%
  ## pivot wider by items_owned
  separate_rows(items_owned, sep = ";") %>%
  ## if there were no items listed, changing NA to no_listed_items
  replace_na(list(items_owned = "no_listed_items")) %>%
  mutate(items_owned_logical = TRUE) %>%
  pivot_wider(names_from = items_owned,
              values_from = items_owned_logical,
              values_fill = list(items_owned_logical = FALSE)) %>%
  ## add some summary columns
  mutate(number_items = rowSums(select(., bicycle:car)))

#Build our basic bar plot
interviews_plotting %>% 
  ggplot(aes(x = respondent_wall_type)) +
  geom_bar(aes(fill = village))

#add some fill
interviews_plotting %>% 
ggplot(aes(x = respondent_wall_type)) +
  geom_bar(aes(fill = village))

#changed from stacked bar to side-by-side
interviews_plotting %>% 
  ggplot(aes(x = respondent_wall_type)) +
  geom_bar(aes(fill = village), dodge)

#use facet to show so each village has its own plot
interviews_plotting %>% 
  ggplot(aes(x = respondent_wall_type)) +
  geom_bar(position= "dodge")+
  facet_wrap(~village)

#More complex example - look at percent of household with items
percent_items <- interviews_plotting %>%
  group_by(village) %>%
  summarize(across(bicycle:no_listed_items, ~ sum(.x) / n() * 100)) %>%
  pivot_longer(bicycle:no_listed_items, names_to = "items", values_to = "percent")

#Create more complex plot
percent_items %>% 
  ggplot(aes(x=village, y=percent))+
  geom_bar(stat = "identity", position = "dodge")+
  facet_wrap(~items)+
  theme_light()+ #add theme
  theme(panel.grid = element_blank())+ #remove grid lines
  labs(title="Proportion of households in each village that own surveyed items", 
       x="Village",
       y="Percent") #add title and labels for axes

#change labels for facets 
#first, create named character vector with label names
item_labs <- c("bicycle"="Bicycle", 
               "cow_cart"="Cow cart", 
               "cow_plough"="Cow plough", 
               "mobile_phone"="Mobile phone", 
               "motorcyle"="Motorcycle", 
               "no_listed_items"="No items", 
               "radio"="Radio", 
               "solar_panel"="Solar panel", 
               "solar_torch"="Solar torch", 
               "table"="Table", 
               "television"="TV")

#Add new labels with labeller to facet_wrap
percent_items %>% 
  ggplot(aes(x=village, y=percent))+
  geom_bar(stat = "identity", position = "dodge")+
  facet_wrap(~items, labeller = as_labeller(item_labs))+
  theme_light()+ #add theme
  theme(panel.grid = element_blank())+ #remove grid lines
  labs(title="Proportion of households in each village that own surveyed items", 
       x="Village",
       y="Percent")








