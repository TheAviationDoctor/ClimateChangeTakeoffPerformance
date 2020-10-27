###############################################################################
# gmst.R                                                                      #
# Loads and wrangles the land-ocean temperature index from NASA               #
###############################################################################

# Load common script for housekeeping
source("scripts/common.R")
install.packages("tidyverse")
library(tidyverse)

# Load the land-ocean temperature index from NASA
url <- "https://data.giss.nasa.gov/gistemp/graphs/graph_data/Global_Mean_Estimates_based_on_Land_and_Ocean_Data/graph.txt"
colnames <- c("Year", "Unsmoothed", "Smoothed")
coltypes <- list(col_character(), col_double(), col_double())
gmst <- read_delim(url, delim = "     ", col_names = colnames, col_types = coltypes, skip = 5)
gmst

