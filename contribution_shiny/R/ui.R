ui <- fluidPage(
  
  tags$head(tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "logo_frov.png")),
  titlePanel(title =  div(img(src="logo_frov_small.png"), "The Source of Nutrients in Aquaponic Systems"), 
             windowTitle = "Nutrient Sources in Aquaponics"), 
  
  inputPanel(
    sliderInput(inputId = "waterExchange", label = "Daily water exchange rate (% V/d)",min = 0, max = 250, value = 5),
    sliderInput(inputId = "FR", label = "Feeding rate (% BW)", min = 0.1, max = 5, value = 2),
    numericInput(inputId = "stockingDensity", label = "Stocking density (kg/m^3)", value = 100),
    numericInput(inputId = "rearingV", "Volume of rearing unit (m^3)", value = 10),
    numericInput(inputId = "totalV", label = "Total volume of RAS (m^3)", value = 15)    
  ),
  sidebarLayout(
    sidebarPanel(tableOutput(outputId = "resultsTable")),
    mainPanel(plotOutput(outputId = "resultsPlot")
              )
    ),
  
  tags$footer("written by Anil A. Tellbuescher. Contact for troubleshooting: admin@tellbuescher.online")
)