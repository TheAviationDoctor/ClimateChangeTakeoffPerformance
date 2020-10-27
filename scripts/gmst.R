###############################################################################
# gmst.R                                                                      #
# Loads and wrangles the land-ocean temperature index from NASA               #
###############################################################################

# Load common script for housekeeping
source("scripts/common.R")
#install.packages("tidyverse")
library(tidyverse)

# Load the land-ocean temperature index from NASA
url <- "https://raw.githubusercontent.com/TheAviationDoctor/ClimateChangeTakeoffPerformance/main/data/land-ocean-temperature-index-1880-2019.csv"
#colnames <- c("Year", "Unsmoothed", "Smoothed")
coltypes <- list(col_character(), col_double(), col_double())
gmst <- read_csv(url, col_names = TRUE, col_types = coltypes, skip = 5)
gmst

