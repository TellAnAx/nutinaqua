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
# last modified: June 8th, 2022
#
#
#
###############################################################################

library(tidyverse)
library(shiny)





###############################################################################

# Load nutrient data
  data <- read.csv2(
    "data/contribution/nutrient_contribution.csv"
  )

# Convert classes
  data[,1] <- factor(data[,1], levels = c('N', 'P', 'K', 'Ca', 'Mg', 'S', 'B', 'Fe', 'Mn', 'Zn', 'Cu', 'Mo', 'Ni'))
  data[,2:5] <- apply(data[,2:5], 2, as.numeric)





###############################################################################

ui <- fluidPage(
  
  titlePanel("The Source of Nutrients in Aquaponic Systems"),
  
  fluidRow(
    column(8,
           h2("Data input")
           ),
    column(4,
           h2("Results")
           )
  ),
  fluidRow(
    column(4,
           # Water exchange rate
           sliderInput(inputId = "waterExchange", label = "Daily water exchange rate (% V/d)", min = 0, max = 250, value = 5),
           
           # Feeding rate
           sliderInput(inputId = "FR", label = "Feeding rate (% BW)", min = 0.1, max = 5, value = 2)
    ),
    column(4,
           
           # Stocking density
           numericInput(inputId = "stockingDensity", label = "Stocking density (kg/m^3)", value = 100),
           
           # Volume rearing unit
           numericInput(inputId = "rearingV", "Volume of rearing unit (m^3)", value = 10),
           
           # Volume total
           numericInput(inputId = "totalV",label = "Total volume of RAS (m^3)", value = 15)
    ),
    column(4,
           tableOutput(outputId = "resultsTable")
           )
  ),
  fluidRow(
    column(12,
           plotOutput(outputId = "resultsPlot")
           )
  )
)

  
  
  

###############################################################################
  
server <- function(input, output, session) {

  # TABLE 
  
  dailyFreshwaterR <- reactive(input$totalV * (input$waterExchange / 100))
  biomassR <- reactive(input$rearingV * input$stockingDensity)
  dailyFeedR <- reactive(biomassR() * (input$FR / 100))
  waterEx_perFeedR <- reactive((dailyFreshwaterR() * 1e3) / dailyFeedR())
  
  
  output$resultsTable <- renderTable(expr = {
    
    dailyFreshwater <- dailyFreshwaterR()
    biomass <- biomassR()
    dailyFeed <- dailyFeedR()
    waterEx_perFeed <- waterEx_perFeedR()
    
    results <- data.frame(
      Value = c(
       'Total biomass (kg)',
       'Daily feed fed (kg/d)',
       'Daily freshwater volume (m^3/d)',
       'Daily freshwater per feed (L/kg/d)'
        ),
      Results = c(
      biomass,
      dailyFeed,
      dailyFreshwater,
      waterEx_perFeed
      )
    )
    
    results
  })
  
  
  # PLOT

  output$resultsPlot <- renderPlot(expr = {
  data %>%
    mutate(
      WaterContribution = dailyFreshwaterR() * concWater_g.m3,
      FeedContribution = dailyFeedR() * feedComp_g.kg * digestibility
      ) %>%
      select(c(compound, WaterContribution, FeedContribution)) %>%
      pivot_longer(
        cols = c(WaterContribution, FeedContribution), 
        names_to = 'Contribution', 
        names_pattern = '(.*)Contribution',
        values_to = 'Total'
      ) %>%
      ggplot(aes(x = compound, y = Total, fill = Contribution)) + 
      geom_col(position = 'fill') + 
      labs(
        x = ""
        ,y = "Nutrient contribution (%)"
        ,fill = "Source:"
      ) +
      theme_bw() + 
      theme(
        legend.position = "bottom",
        text=element_text(size=20), #change font size of all text
        axis.text=element_text(size=14), #change font size of axis text
        axis.title=element_text(size=20), #change font size of axis titles
        plot.title=element_text(size=20), #change font size of plot title
        legend.text=element_text(size=20), #change font size of legend text
        legend.title=element_text(size=20) #change font size of legend title 
      )
  })
  
}

  
  
  
  

shinyApp(ui, server)





