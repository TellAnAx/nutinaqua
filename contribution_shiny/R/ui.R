ui <- fluidPage(
  
  tags$head(tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "logo_frov_small.png")),
  titlePanel(title =  div(img(src="logo_frov_small.png"), "The Source of Nutrients in Aquaponic Systems"), 
             windowTitle = "Nutrient Sources in Aquaponics"), 
  
  inputPanel(
    sliderInput(inputId = "waterExchange", label = HTML(paste0("Water Exchange Rate (% V d",tags$sup("-1"), ')')),min = 0, max = 50, value = 5),
    sliderInput(inputId = "FR", label = "Feeding rate (% BW)", min = 0.1, max = 5, value = 2),
    numericInput(inputId = "stockingDensity", label = HTML(paste0("Stocking Density (kg m",tags$sup("-3"), ')')), value = 100),
    numericInput(inputId = "rearingV", label = HTML(paste0("Volume of Rearing Unit (m",tags$sup("3"), ')')), value = 10),
    numericInput(inputId = "totalV", label = HTML(paste0("Total Volume of RAS (m",tags$sup("3"), ')')), value = 15)    
  ),
  sidebarLayout(
    sidebarPanel(tableOutput(outputId = "resultsTable")),
    mainPanel(plotOutput(outputId = "resultsPlot")
              )
    ),
  
  tags$footer("written by Anil A. Tellbuescher. Contact for troubleshooting: admin@tellbuescher.online")
)