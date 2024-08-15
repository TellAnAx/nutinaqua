server <- function(input, output, session) {
  
  # Load datasets at the start
  tap_data <- read_rds(here("output", "interm", "water_cleaned_tap_MLE.rds")) %>% 
    tidyr::pivot_longer(c(min, meanconf, max),
                 names_to = "name",
                 values_to = "conc") %>% 
    dplyr::distinct(conc, .keep_all = TRUE) %>% 
    mutate(
      water = conc * 1e-6, # Convert µmol to mol
      unit = "mol/L"
    ) %>% 
    select(analyte, unit, conc)
    
  
  rain_data <- read_rds(here("output", "interm", "water_cleaned_rain.rds")) %>% 
    mutate(
      water = conc * 1e-6, # Convert µmol to mol
      unit = "mol/L"
    ) %>% 
    select(analyte, unit, conc)
  
  feed_data <- read_rds(here("output", "interm", "permutation_feed_with_assumptions.rds"))
  
  observeEvent(input$submit, {
    # Determine which dataset to use based on user selection
    selected_water_data <- if(input$waterSource == "tap") tap_data else rain_data
    
    # Calculate the amounts based on the input water level
    water_processed <- selected_water_data %>%
      mutate(
        water = conc * input$waterInput * 1e-6,  # Convert volume from L and concentration from µmol to mol
        unit = "mol",
        dailyFreshwater = input$waterInput
      ) %>%
      rename(substance = analyte) %>%
      select(substance, unit, water)
    
    # Join with feed data and calculate percentages
    combined_data <- water_processed %>%
      left_join(feed_data, by = c("substance", "unit")) %>%
      mutate(
        sum = ifelse(is.na(feed), water, feed + water),
        perc_feed = 100 * feed / sum,
        perc_water = 100 * water / sum
      )
    
    # Store for plotting
    output$waterPlot <- renderPlot({
      if (is.null(combined_data)) return(NULL)
      ggplot(combined_data, aes(x = substance, y = perc_water, fill = as.factor(dailyFreshwater))) +
        geom_bar(stat = "identity", position = position_dodge()) +
        labs(x = "Substance", y = "Percentage Water", fill = "Daily Freshwater (L)") +
        theme_minimal()
    })
  })
}
