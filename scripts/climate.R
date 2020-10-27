###############################################################################
# climate.R                                                                   #
# Loads and wrangles the airports, runways, and Köppen-Geiger climatic zones  #
###############################################################################

# Load common script for housekeeping
source("scripts/common.R")

# Define variables
cutoff <- .95 # Percentage of all 2019 passenger traffic to be included

# Load the 2019 passenger traffic by airport, define column types, load the comma-separated data and filter it based on the cutoff variable, and display the resulting data frame
url <- "https://raw.githubusercontent.com/TheAviationDoctor/ClimateChangeTakeoffPerformance/main/data/passenger-traffic-by-airport-in-2019.csv"
colnames <- c("IATA", "Passengers", "PassengersCum", "PassengersCumPer")
coltypes <- list(col_character(), col_integer(), col_double(), col_double())
traffic <- read_csv(url, col_names = colnames, col_types = coltypes) %>% filter(PassengersCumPer <= cutoff)
traffic

# Load the global airports database from OpenFlights, declare missing headers, define column types, load the comma-separate data without quotes, select the columns to keep, and display the resulting data frame
url <- "https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat"
colnames <- c("ID", "Name", "City", "Country", "IATA", "ICAO", "Latitude", "Longitude", "Altitude", "Timezone", "DST", "Olson", "Type", "Source")
coltypes <- list(col_integer(), col_character(), col_character(), col_character(), col_character(), col_character(), col_double(), col_double(), col_integer(), col_factor(), col_factor(), col_factor(), col_factor(), col_factor())
airports <- read_csv(url, col_names = colnames, col_types = coltypes) %>% select(ID, IATA, ICAO, City, Country, Altitude, Latitude, Longitude)
airports

# Look for values from the traffic data frame that don't exist in the airports data frame.
data <- anti_join(traffic, airports, by = "IATA")
data

# Impute data for the values in traffic that are missing in airports
airports_imputed <- airports %>%
  add_row(ID = max(airports$ID) + 1, IATA ="NTG", ICAO = "ZSNT", City = "Nantong", Country = "China", Altitude = 16, Latitude = 32.070833, Longitude = 120.975556) %>%
  add_row(ID = max(airports$ID) + 2, IATA ="THD", ICAO = "VVTX", City = "Sao Vàng", Country = "Vietnam", Altitude = 59, Latitude = 19.901667, Longitude = 105.467778)
  airports_imputed[which(airports_imputed$ICAO == "ZLIC"),2] <- "INC"

# Join the traffic and the airports_imputed data frames
data <- left_join(traffic, airports_imputed, by = "IATA")
data

# Round the latitude and longitude to the nearest .25 multiple and determine the Köppen-Geiger climatic zone for each airport
airports_climate <- data %>%
  mutate(rndCoord.lon = RoundCoordinates(Longitude), rndCoord.lat = RoundCoordinates(Latitude), climate = LookupCZ(data.frame(IATA, rndCoord.lon, rndCoord.lat)))

summary(airports_climate$climate)