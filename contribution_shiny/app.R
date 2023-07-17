#
# TITLE:
#         Shinyapp - Impact of water exchange
#
#
# DESCRIPTION:
#         How does a change in the daily water exchange rate affect the nutrient
#         contribution of the water in an aquaponic system compared with the
#         daily input of feed?
#
#
#
#
# written by: Anil Axel Tellbuescher
#
# date written:: June 8th, 2022
# last modified: July 17th, 2023
#
#
#

# Setup----
library(tidyverse)
library(shiny)
library(here)


# Load data----
data <- read_csv2(here("data", "nutrient_contribution.csv"),
                  col_types = c("f", "n", "n", "n", "n"))


# Load Server and UI----
source(here("contribution_shiny","R","server.R"))
source(here("contribution_shiny","R","ui.R"))


# Run app----
shinyApp(ui, server)





