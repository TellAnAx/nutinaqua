library(here)
library(tidyverse)
library(dbplyr)
library(sf)
library(terra)
library(RSQLite)

# Connect to DB----
driver <- dbDriver("SQLite")
con <- dbConnect(driver, dbname = here("data", "HWSD2.sqlite"))
dbListTables(con)
