#### Load the required packages ####
library(shiny) # shiny features
install.packages("htmltools")
library(shinydashboard) # shinydashboard functions
library(DT)  # for DT tables
library(dplyr)  # for pipe operator & data manipulations
library(plotly) # for data visualization and plots using plotly 
library(ggplot2) # for data visualization & plots using ggplot2
library(ggtext) # beautifying text on top of ggplot
library(maps) # for India map - boundaries used by ggplot for mapping
library(ggcorrplot) # for correlation plot
library(shinycssloaders) # to add a loader while graph is populating
library(readxl)
library(htmltools)


#### Dataset Manipulation ####
# Read the data from CSV file
my_data <- read.csv("TeleLawData.csv", stringsAsFactors = FALSE)

# Convert district and state columns to lowercase
my_data <- my_data %>%
  mutate(district = tolower(district),
         state = tolower(state))

# Column names without state. This will be used in the select input for choices in the shinydashboard
c1 <- names(my_data)

# Column names without state and UrbanPopulation. This will be used in the select input for choices in the shinydashboard
c2 <- my_data %>%
  select(-state, -district) %>%
  names()

#### Preparing data for Cases Map ####
# map data for India boundaries using the maps package
india <- map_data("world", region = "India")

## Add the latitude, longitude, and other info needed to draw the polygon for the state map
# For the state boundaries available - add the India info.
# Note that the boundaries for some regions may not be available
# You might need to merge the dataset with specific map data if needed

# Add state Abbreviations and center locations of each state. Create a dataframe out of it
st <- data.frame(abb = state.abb, stname = tolower(state.name), x = state.center$x, y = state.center$y)

# Join the state abbreviations and center location to the dataset for each of the observations in the merged dataset
# There might be specific map data needed for this, depending on the visualization requirements
# new_join <- left_join(merged, st, by = c("state" = "stname"))