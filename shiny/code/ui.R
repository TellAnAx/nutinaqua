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
