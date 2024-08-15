# Load packages----
library(shiny)
library(tidyverse)
library(ggridges)
library(here)

# Load datasets----

## Tap water----
tap_data <- readRDS("./water_cleaned_tap_MLE.rds") %>% 
  pivot_longer(c(min, meanconf, max),
               names_to = "name",
               values_to = "conc") %>% 
  distinct(conc, .keep_all = TRUE) %>% 
  mutate(
    conc = conc * 1e-6, # Convert µmol to mol
    unit = "mol/L"
  ) %>% 
  select(analyte, conc)

## Rain water----
rain_data <- readRDS("./water_cleaned_rain.rds") %>% 
  mutate(
    conc = conc * 1e-6, # Convert µmol to mol
    unit = "mol/L"
  ) %>% 
  select(analyte, conc)

## Feed----
feed_data <- readRDS("./permutation_feed_with_assumptions.rds") %>% 
  select(-unit)



# Load UI----
ui <- fluidPage(
  titlePanel("Dynamic Water Input Analysis"),
  sidebarLayout(
    sidebarPanel(
      numericInput("waterInput", "Enter Daily Freshwater Level (L):", value = 100, min = 1),
      selectInput("waterSource", "Select Water Source:", choices = c("Tap" = "tap", "Rain" = "rain")),
      actionButton("submit", "Update")
    ),
    mainPanel(
      plotOutput("waterPlot")
    )
  )
)



# Load Server----
server <- function(input, output, session) {
  
  observeEvent(input$submit, {
    # Determine which dataset to use based on user selection
    selected_water_data <- if(input$waterSource == "tap") tap_data else rain_data
    
    # Calculate the amounts based on the input water level
    water_processed <- selected_water_data %>%
      mutate(water = conc * input$waterInput)  # Convert from concentration to mol
    
    
    # Join with feed data and calculate percentages
    combined_data <- water_processed %>%
      left_join(feed_data, join_by("analyte" == "substance"),
                relationship = "many-to-many") %>%
      mutate(
        sum = ifelse(is.na(feed), water, feed + water),
        percentage = 100 * water / sum # percentage of water contribution
      ) %>% 
      drop_na()
    
    # Store for plotting
    output$waterPlot <- renderPlot({
      combined_data %>% 
        ggplot(aes(x = percentage, 
                   y = fct_rev(analyte), fill = stat(quantile))) + 
        stat_density_ridges(quantile_lines = FALSE,
                            calc_ecdf = TRUE,
                            geom = "density_ridges_gradient",
                            quantiles = c(0.25, 0.5, 0.75)) +
        #scale_fill_colorblind(name = "Prob. quantile", 
        #                      labels = c("(0%, 25%]", "(25%, 50%]", "(50%, 75%]", "(75%, 100%]")) +
        scale_x_continuous(breaks = seq(0,100,10), 
                           labels = c("0","","20","","40","","60","", "80", "","100"),
                           limits = c(0,100)) +
        theme_bw() + 
        theme(legend.position = "bottom") +
        labs(x = "Share of total nutrient input (%)",
             y = "")
    })
  })
}



# Run the application----
shinyApp(ui = ui, server = server)
