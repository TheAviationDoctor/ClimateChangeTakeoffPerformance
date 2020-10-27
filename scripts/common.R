###############################################################################
# common.R                                                                    #
# Common R code called by other scripts to take care of housekeeping          #
###############################################################################

# Clear the console
cat("\014")

# Install required packages, only if missing
packages_required = c("kgc", "tidyverse")
packages_not_installed <- packages_required[!(packages_required %in% installed.packages()[ , "Package"])]
if(length(packages_not_installed)) install.packages(packages_not_installed)
print(paste(length(packages_not_installed), "packages installed."))

library("kgc", "tidyverse")