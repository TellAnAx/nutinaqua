# Install required packages if not already installed
# install.packages(c("shiny", "ggplot2", "ggridges", "forcats", "colorblindr", "readr", "here"))

library(shiny)
library(ggplot2)
library(ggridges)
library(forcats)
#library(colorblindr)
library(readr)
library(here)

# Load the data from the .rds file
data <- read_rds(here("output", "interm", "permutation_combined_percentage_shiny.rds"))

# Define UI
ui <- fluidPage(
  titlePanel("Nutrient Input Plot"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("dailyFreshwater", "Select dailyFreshwater values:",
                         choices = levels(data$dailyFreshwater),
                         selected = levels(data$dailyFreshwater)),
      checkboxGroupInput("source2", "Select source2 values:",
                         choices = levels(data$source2),
                         selected = levels(data$source2))
    ),
    mainPanel(
      plotOutput("ridgePlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$ridgePlot <- renderPlot({
    filtered_data <- data[data$dailyFreshwater %in% input$dailyFreshwater & data$source2 %in% input$source2, ]
    
    ggplot(filtered_data, aes(x = percentage, y = fct_rev(substance), fill = stat(quantile))) + 
      stat_density_ridges(quantile_lines = FALSE,
                          calc_ecdf = TRUE,
                          geom = "density_ridges_gradient",
                          quantiles = c(0.25, 0.5, 0.75)) +
      #scale_fill_colorblind(name = "Prob. quantile", 
      #                      labels = c("(0%, 25%]", "(25%, 50%]", "(50%, 75%]", "(75%, 100%]")) +
      scale_x_continuous(breaks = seq(0, 100, 10), 
                         labels = c("0", "", "20", "", "40", "", "60", "", "80", "", "100"),
                         limits = c(0, 100)) +
      facet_grid(cols = vars(dailyFreshwater), rows = vars(source2)) + 
      theme_bw() + 
      theme(legend.position = "top") +
      labs(x = "Share of total nutrient input (%)",
           y = "")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
