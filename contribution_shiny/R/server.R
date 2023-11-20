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
        'Daily freshwater volume (m3/d)',
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
    # Load data----
    read_delim(here("contribution_shiny", "data", "nutrient_contribution.csv"),
                      col_types = c("f", "n", "n", "n", "n")) %>%
      mutate(
        WaterContribution = input$totalV * (input$waterExchange/100) * `concWater_g/m3`,
        FeedContribution = input$rearingV * input$stockingDensity * (input$FR / 100) * `feedComp_g/kg` * digestibility
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
