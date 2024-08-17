# Load packages----
library(shiny)
library(tidyverse)
library(ggthemes)
library(ggridges)

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
  titlePanel(title = div(img(src="logo_frov_small.png"), 
    "Nutrient inputs into freshwater aquaculture systems"), 
    windowTitle = "Nutrient inputs into freshwater aquaculture"),
  
  tags$h4("An interactive visualisation of the shares of water and feed to 
  the total nutrient input into (closed) freshwater aquaculture systems."),
  
  
  sidebarLayout(
    sidebarPanel(
      tags$h3("Input Settings"),
      tags$text("Below you can select between two sources of water input into 
                your system and define the amount of makeup water that you use. 
                The plot will update automatically. Please scroll down for 
                further explanations."),
      tags$br(),
      tags$br(),
      selectInput("waterSource", "Water Source:", choices = c("Tap" = "tap", "Rain" = "rain")),
      numericInput("waterInput", "Freshwater (L/kg of feed):", value = 100, min = 1)
      ),
    
    mainPanel(
      plotOutput("waterPlot")
      )
  ),
  
  
  tags$h3("Background"),

  tags$h4("Water"),
  tags$text("The underlying tap water dataset consists of 89 water analysis 
            reports from local authorities and water utilities in the corresponding 
            municipalities, covering 23 countries all over Europe. Tap water 
            originates either from groundwater or surface water and thus resembles 
            both water sources."),
  tags$br(),
  tags$text("The rainwater dataset consists of 18 rainwater analyses collected 
            from literature."),
  
  tags$h4("Feed"),
  tags$text("The feed dataset consists of 66 observations collected in form of 
            feed manufacturer datasheets, and 16 data records from literature 
            studies in which commercial feeds were used. Another 8 records were 
            collected from the literature and 3 own feed analyses were added."),
  tags$br(),
  tags$text("Different nutrient retention levels were also considered based on
            literature studies."),
  tags$br(),
  tags$br(),
  tags$table(
    style = "width: 100%; border-collapse: collapse;",
    tags$tr(
      tags$th("Element"),
      tags$th("n"),
      tags$th("Retention (%)")
    ),
    tags$tr(
      tags$td("N"),
      tags$td("85"),
      tags$td("45-55%")
    ),
    tags$tr(
      tags$td("P"),
      tags$td("79"),
      tags$td("70-80%")
    ),
    tags$tr(
      tags$td("K"),
      tags$td("13"),
      tags$td("45-55%")
    ),
    tags$tr(
      tags$td("Ca"),
      tags$td("16"),
      tags$td("45-55%")
    ),
    tags$tr(
      tags$td("Mg"),
      tags$td("14"),
      tags$td("80-90%")
    ),
    tags$tr(
      tags$td("S"),
      tags$td("12"),
      tags$td("80-90%")
    ),
    tags$tr(
      tags$td("Fe"),
      tags$td("12"),
      tags$td("70-80%")
    ),
    tags$tr(
      tags$td("Cu"),
      tags$td("12"),
      tags$td("55-65%")
    ),
    tags$tr(
      tags$td("Zn"),
      tags$td("12"),
      tags$td("60-70%")
    )
  ),
  tags$br(),
  tags$text("The feeds all match the requirements of Common carp (", 
            tags$i("Cyprinus carpio"), "), ",
         "Pikeperch (", tags$i("Sander lucioperca"), "), ",
         "Nile tilapia (", tags$i("Oreochromis niloticus"), "), ",
         "African catfish (", tags$i("Clarias gariepinus"), "), and ",
         "Rainbow trout (", tags$i("Oncorhynchus mykiss"), "). ",
         "The mentioned species were chosen due to their cumulated share of 
         approximately 23% of world freshwater fish production (The State of 
         World Fisheries and Aquaculture 2022)."),
  
  
  
  tags$h3("Further information"),
  
  tags$text("This app is supplementary material of the following publication:"),
  tags$br(),
  tags$br(),
  tags$text("Tellbüscher, A.A., Gebauer, R., Mráz, J., 2024: Nutrients revisited:
            Review and meta-data analysis of nutrient inputs into freshwater 
            aquaculture systems. Aquaculture."),
  tags$a(href = "https://doi.org", 
         "https://doi.org"),
  tags$br(),
  tags$br(),
  
  
  tags$text("The data used for this app is publicly available on Zenodo following 
            the link below:"),
  tags$a(href = "https://zenodo.org/doi/10.5281/zenodo.10855065", 
         "https://zenodo.org/doi/10.5281/zenodo.10855065"),
  
  tags$br(),
  tags$br(),
  tags$b("written by:"),
  tags$a(href = "https://anil.tellbuescher.online", 
         "Anıl Axel Tellbüscher"),
  tags$text(", University of South Bohemia, Czech Republic"),
  tags$br(),
  tags$br()
)



# Load Server----
server <- function(input, output, session) {
  # Reactive expression to process data
  processed_data <- reactive({
    # Determine which dataset to use based on user selection
    selected_water_data <- if(input$waterSource == "tap") tap_data else rain_data
    
    # Calculate the amounts based on the input water level
    water_processed <- selected_water_data %>%
      mutate(water = conc * input$waterInput)  # Convert from concentration to mol
    
    # Join with feed data and calculate percentages
    combined_data <- water_processed %>%
      left_join(feed_data, 
                by = c("analyte" = "substance"),
                relationship = "many-to-many") %>%
      mutate(
        analyte = as.factor(analyte),
        sum = ifelse(is.na(feed), water, feed + water),
        percentage = 100 * water / sum # percentage of water contribution
      ) %>%
      drop_na() %>%
      mutate(analyte = fct_relevel(analyte, "N", "P", "K", "Ca", "Mg", "S", "Fe", "Cu", "Zn")) # Ensure correct order
    combined_data
  })

  # Render plot based on processed data
  output$waterPlot <- renderPlot({
    data <- processed_data()
    if (is.null(data)) return(NULL)  # Prevent errors before data is available

    ggplot(data, aes(x = percentage, 
                     y = fct_rev(analyte), 
                     fill = stat(quantile))) + 
      stat_density_ridges(quantile_lines = FALSE,
                          calc_ecdf = TRUE,
                          geom = "density_ridges_gradient",
                          quantiles = c(0.25, 0.5, 0.75)) +
      scale_fill_colorblind(name = "Prob. quantile",
                           labels = c("(0%, 25%]", "(25%, 50%]", "(50%, 75%]", "(75%, 100%]")) +
      scale_x_continuous(breaks = seq(0,100,10), 
                         labels = c("0","","20","","40","","60","", "80", "","100"),
                         limits = c(0,100)) +
      theme_bw() + 
      theme(
        legend.position = "top",
        text = element_text(size = 14),
        axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12)
      ) +
      labs(x = "Share of total nutrient input (%)",
           y = "")
  })
  
}



# Run the application----
shinyApp(ui = ui, server = server)
