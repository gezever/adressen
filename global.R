library(dplyr)

adreslocaties <- read.csv("data/wel_en_niet_INTEGO_Antwerpen2.csv")
integolocaties <- subset(adreslocaties, INTEGO == "1")
nonintegolocaties <- subset(adreslocaties, INTEGO == "0")