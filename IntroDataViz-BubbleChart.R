# Data Visualition with ggplot2: Creating a Bubble Chart
# Instructor: Tess Grynoch, tess.grynoch@umassmed.edu
# October 25, 2022

# Add libraries from tidyverse
library(ggplot2)
library(dplyr)

# Add the dataset from the gapminder library
#install.packages("gapminder") #if needed
library(gapminder)
data <- gapminder %>% filter(year=="2007") %>% dplyr::select(-year)
summary(data)

#Most basic bubble plot - plot life expectancy over GDP per capita 
#with size of bubble being the population 
ggplot(data, aes(x=gdpPercap, y=lifeExp, size = pop))+ #defining the plot area and variables
  geom_point(alpha=0.7) #alpha = opacity

?geom_point #check out all the aesthetics and arguments available for geom_point

### plot wish list ###
# Arrange the size of the bubbles so the large bubbles don't block the small ones 
# Increase the range in size of the bubbles
# Change the legend name
# Add colors
# Lighten the background, change color of grid lines (theme)
# Change axis titles
# Change the shape so the outline and fill can be adjusted
# Change title for the fill legend
# Update colors used in fill scale
# Add a label for the United States

#You may have noticed that the difference in size of the bubbles is not large
#We can change this with range argument within scale_size()
#Let's double check that this is setting the scales using area over radius
#because we don't want to distort our image
?scale_size

#Arrange the size of the bubbles so the large bubbles don't block the small ones
#using dplyr's arrange. Going to use the pipe, %>% to organize my code. Pipes 
#can lead straight into a ggplot function.
#Add scale_size and set range and name of the legend
data %>%
  arrange(desc(pop)) %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, size = pop)) +
  geom_point(alpha=0.5) +
  scale_size(range = c(.1, 24), name="Population (Millions)")

#We have continent as part of this data so we can group our countries by color
data %>%
  arrange(desc(pop)) %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, size = pop, color=continent)) +
  geom_point(alpha=0.5) +
  scale_size(range = c(.1, 24), name="Population (Millions)")

#Change axis title with with xlab and ylab 
#Change the theme of the chart to change background, grid lines, 
#and overall appearance 
#There are many themes to choose from. theme_light() is my favorite

data %>%
  arrange(desc(pop)) %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, size = pop, color=continent)) +
  geom_point(alpha=0.5) +
  scale_size(range = c(.1, 24), name="Population (Millions)") +
  theme_light()+ 
  ylab("Life expectancy") +
  xlab("GDP per capita")

#Change the shape of geom point so the outline can be separate from the fill
#Shapes 21-25 allow separate outline and fill colors, shape 21 is a circle
#Note: The color aesthetic for a geom_point shape which has both outline and fill
#denotes the outline color. Also, the color set in geom_point overrides the color
#set for our ggplot aes because it is processed after the ggplot aesthetic. 
#So we will need to add an aesthetic of fill for our geom_point to bring the 
#continent color back in. Once we do that, we can remove the color aesthetic 
#from the ggplot function.

data %>%
  arrange(desc(pop)) %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, size = pop)) +
  geom_point(alpha=0.5, shape=21, color="black", aes(fill =continent)) +
  scale_size(range = c(.1, 24), name="Population (Millions)") +
  theme_light()+ 
  ylab("Life expectancy") +
  xlab("GDP per capita")

#Update fill scale name and colors
#Library of Paul Tol's color schemes - color-blind friendly
#More information: https://personal.sron.nl/~pault/

#installed in ggthemes
library(ggthemes)

data %>%
  arrange(desc(pop)) %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, size = pop)) +
  geom_point(alpha=0.5, shape=21, color="black", aes(fill =continent)) +
  scale_size(range = c(.1, 24), name="Population (Millions)") +
  scale_fill_ptol(name="Continent")+
  theme_light()+ 
  ylab("Life expectancy") +
  xlab("GDP per capita")

#Add a label for the United States
#first need to create data for geom
USA <- data %>% 
  filter(country=="United States")

data %>%
  arrange(desc(pop)) %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, size = pop)) +
  geom_point(alpha=0.5, shape=21, color="black", aes(fill =continent)) +
  scale_size(range = c(.1, 24), name="Population (Millions)") +
  scale_fill_ptol(name="Continent")+
  theme_light()+ 
  ylab("Life expectancy") +
  xlab("GDP per capita")+
  geom_text(data = USA, aes(x=gdpPercap, y=lifeExp, label = "USA"), size = 3)

# Great videos of other gapminder data charts narrated by Gapminder co-founder, 
# Hans Rosling
## Child mortality in developing countries: https://www.youtube.com/watch?v=OwII-dwh-bk
## Lifespan over income per person: https://www.youtube.com/watch?v=jbkSRLYSojo

# Data visualization with ggplot2 resources
## Cheat sheet download: https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-visualization.pdf
## The R Graph Gallery by Yan Holtz: https://r-graph-gallery.com/index.html 



