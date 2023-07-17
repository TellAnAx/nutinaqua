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
           sliderInput(inputId = "waterExchange",
                       label = "Daily water exchange rate (% V/d)",
                       min = 0, max = 250, value = 5),

           sliderInput(inputId = "FR",
                       label = "Feeding rate (% BW)",
                       min = 0.1, max = 5, value = 2)
    ),
    column(4,
           numericInput(inputId = "stockingDensity",
                        label = "Stocking density (kg/m^3)",
                        value = 100),

           numericInput(inputId = "rearingV", "Volume of rearing unit (m^3)",
                        value = 10),

           numericInput(inputId = "totalV",
                        label = "Total volume of RAS (m^3)",
                        value = 15)
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
