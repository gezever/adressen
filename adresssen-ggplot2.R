library(rgdal)
library(stringr)
library(ggplot2)

setwd("/home/gehau/git/adressen")

# Get data for sweden from 'world.cities' dataset
data(world.cities)
sweden.cities <- world.cities[world.cities$country.etc == "Sweden",]

##################
# importing data #
##################

# 'world.cities' didn't have data for all my cities
# so I added long and lat for them in excel and saved
# the new data as city.txt
sweden.cities <- read.delim("city.txt")
# load text file with info about where people live
data.txt <- scan("var.txt", character(0), sep = "\n")
# replace swedish å,ä,ö, since the regular expression
# wouldn't catch them.
data.txt <- gsub('(å|ä)', 'a', data.txt, ignore.case = TRUE)
data.txt <- gsub('ö', 'o', data.txt, ignore.case = TRUE)

###################
# Extracting data #
###################
# Use regular expression to extract rows with only 
# one word, i.e. city headings. Save as boolean. 
txt.pattern <- str_detect(data.txt, "^[[:alpha:]]*$")
# Create a list of city names
cities.txt <- grep("^[[:alpha:]]*$", data.txt, value=T)

# Create empty variables for each city
for (i in 1:length(cities.txt)) {
  assign(cities.txt[i], 0)
}

# Count number of rows after each city heading
# and assign that number to the corresponding city-variable
x <- 0 # row count
y <- 0 # index for cities.txt
for (i in 1:length(data.txt)) {
  if (txt.pattern[i] == TRUE) {
    if (y != 0) assign(cities.txt[y], x)
    x <- 0
    y <- y + 1
  } else x <- x + 1
}

# Combine individual city variables into one data.frame
for (i in 1:length(cities.txt)) {
  cities <- cities.txt[i]
  people <- eval(parse(text = cities))
  if (i == 1) {
    df <- data.frame("cities" = cities, "people" = people)
  } else df <- rbind(data.frame("cities" = cities, "people" = people), df)
}

# remove dummy row 'end'
df <- df[-1,]

# add capital letter for 'gsub'ed words.
df$cities <- as.character(df$cities)
df$cities[1] <- "Ostersund"
df$cities[2] <- "Ornskoldsvik"
df$cities[3] <- "Orebro"

# Get city long/lat data
match <- match(df$cities, sweden.cities$name)
df.coords <- sweden.cities[match,]

# add number of psychologists per city
df.coords <- cbind(df.coords, "people" = df$people)

# convert long/lat to Mercator coordinates
df.coords <- cbind(df.coords,projectMercator(df.coords$lat,df.coords$long))

# clean up workspace
list <- ls()
list <- list[-grep("df.coords", list)] 
rm(list=list)
rm(list)

# get openmap for sweden
mp <- openmap(c(69.2,9.303711), c(54,24.433594), zoom=6, type="osm")

########
# Plot #
########
autoplot(mp) + 
  geom_point(aes(x,y, size=people, color=people),
             alpha = I(8/10), data=df.coords) +
  opts(axis.line=theme_blank(),axis.text.x=theme_blank(),
       axis.text.y=theme_blank(),axis.ticks=theme_blank(),
       axis.title.x=theme_blank(),
       axis.title.y=theme_blank()) + 
  scale_size_continuous(range= c(1, 25)) +  
  scale_colour_gradient(low="blue", high="red") +
  opts(title="Where do we live?") 

# save plot
ggsave("plot.png", dpi=600)