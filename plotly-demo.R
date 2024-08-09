#Plot.ly demo
#August 9, 2024
#Tess Grynoch

#libraries
library(ggplot2)
library(dplyr)
library(gapminder)
library(ggthemes)

#Recreate ggplot2 chart using plotly library
data <- gapminder %>% filter(year=="2007") %>% dplyr::select(-year)

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

#install plotly
#install.packages("plotly")

#library
library(plotly)

#data we're using today
str(data)

#create basic chart
plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp)

#note that it auto-detects type of chart
#and it looks different and has different features
#than a basic chart in ggplot2
#shows in viewer not plots

#let's look at the help documentation to see if we can find a bubble chart option
?plot_ly
#help documentation on the plotly website is also helpful: https://plotly.com/r/

#try the type argument - actually want to leave as scatter
plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp,
        size=~pop,
        marker= list(sizemode= "diameter", opacity=0.5),
        type= "scatter",
        mode="markers")

#change color of points to continents
plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp,
        size=~pop,
        color=~continent,
        colors="Set2", #using Colorbrewer2 palette
        marker= list(sizemode= "diameter", opacity=0.5),
        type= "scatter",
        mode="markers")

#Can use colors to change all points to the same color, 
#specify a color palette from colorbrewer2, or set a custom palette
#check out colorbrewer2 palettes: https://r-graph-gallery.com/38-rcolorbrewers-palettes.html

#Identify the countries in the hover text and add info
plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp,
        size=~pop,
        color=~continent,
        colors="Set2", 
        marker= list(sizemode= "diameter", opacity=0.5),
        type= "scatter",
        mode="markers",
        text=~paste(country,
                    "<br>",
                    "Life Expectancy:", round(lifeExp,0), "years",
                    "<br>",
                    "GDP Per Capita: $", round(gdpPercap, 0), "(US)",
                    "<br>",
                    "Population:", pop), 
        hoverinfo="text")

#Add title and edit axes titles
plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp,
        size=~pop,
        color=~continent,
        colors="Set2", 
        marker= list(sizemode= "diameter", opacity=0.5),
        type= "scatter",
        mode="markers",
        text=~paste(country,
                    "<br>",
                    "Life Expectancy:", round(lifeExp,0), "years",
                    "<br>",
                    "GDP Per Capita: $", round(gdpPercap, 0), "(US)",
                    "<br>",
                    "Population:", pop), 
        hoverinfo="text") %>% 
  layout(title="Country's life expectancy in 2007 based on GDP per capita and population",
         xaxis=list(title="GDP per capita"),
         yaxis=list(title="Life expectancy"))

#Add annotation for USA
plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp,
        size=~pop,
        marker= list(sizemode= "diameter", opacity=0.5),
        type= "scatter",
        mode="markers",
        color=~continent,
        colors="Set2",
        text=~paste(country,
                    "<br>",
                    "Life Expectancy:", round(lifeExp,0), "years",
                    "<br>",
                    "GDP Per Capita: $", round(gdpPercap, 0), "(US)",
                    "<br>",
                    "Population:", pop), 
        hoverinfo="text") %>% 
  layout(title="Country's life expectancy in 2007 based on GDP per capita and population",
         xaxis=list(title="GDP per capita"),
         yaxis=list(title="Life expectancy")) %>% 
  add_annotations(
    x=data$gdpPercap[data$country=="United States"],
    y=data$lifeExp[data$country=="United States"],
    text = "USA",
    showarrow = FALSE
  )

#remove plotly toolbar
plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp,
        size=~pop,
        marker= list(sizemode= "diameter", opacity=0.5),
        type= "scatter",
        mode="markers",
        color=~continent,
        colors="Set2",
        text=~paste(country,
                    "<br>",
                    "Life Expectancy:", round(lifeExp,0), "years",
                    "<br>",
                    "GDP Per Capita: $", round(gdpPercap, 0), "(US)",
                    "<br>",
                    "Population:", pop), 
        hoverinfo="text") %>% 
  layout(title="Country's life expectancy in 2007 based on GDP per capita and population",
         xaxis=list(title="GDP per capita"),
         yaxis=list(title="Life expectancy")) %>% 
  add_annotations(
    x=data$gdpPercap[data$country=="United States"],
    y=data$lifeExp[data$country=="United States"],
    text = "USA",
    showarrow = FALSE
  ) %>% 
  config(displayModeBar=FALSE)

#Export chart
#assign plot to variable name
lifeexp2007 <- plot_ly(data=data, 
        x=~gdpPercap,
        y=~lifeExp,
        size=~pop,
        marker= list(sizemode= "diameter", opacity=0.5),
        type= "scatter",
        mode="markers",
        color=~continent,
        colors="Set2",
        text=~paste(country,
                    "<br>",
                    "Life Expectancy:", round(lifeExp,0), "years",
                    "<br>",
                    "GDP Per Capita: $", round(gdpPercap, 0), "(US)",
                    "<br>",
                    "Population:", pop), 
        hoverinfo="text") %>% 
  layout(title="Country's life expectancy in 2007 based on GDP per capita and population",
         xaxis=list(title="GDP per capita"),
         yaxis=list(title="Life expectancy")) %>% 
  add_annotations(
    x=data$gdpPercap[data$country=="United States"],
    y=data$lifeExp[data$country=="United States"],
    text = "USA",
    showarrow = FALSE
  ) %>% 
  config(displayModeBar=FALSE)

#need to use kaleido which requires the reticulate package
library(reticulate)
# Simulate a conda environment to use Kaleido 
#may need to restart R if you already have python installed on your computer
reticulate::install_miniconda()
reticulate::conda_install('r-reticulate', 'python-kaleido')
reticulate::conda_install('r-reticulate', 'plotly', channel = 'plotly')
reticulate::use_miniconda('r-reticulate')

save_image(lifeexp2007, "lifeexp2007.png")





