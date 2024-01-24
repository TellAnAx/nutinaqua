# WATER DATA-----------------------------------
data$water_cleaned <- data$water[[1]] %>% 
  drop_na(gps) %>% 
  distinct(city, source, .keep_all = TRUE) %>% 
  write_rds(here("output", "interm", "water_cleaned.rds"))



# MAP PLOT-----------------------------------
gps_coordinates <- tibble(gps = data$water_cleaned$gps,
                          location = data$water_cleaned$location,
                          city = data$water_cleaned$city,
                          country = data$water_cleaned$country,
                          source = data$water_cleaned$source) %>%
  separate(gps, into = c("latitude", "longitude"),
           sep = ", ", convert = TRUE) %>% 
  write_rds(here("output", "interm", "gps_coordinates.rds"))



# FEED PLOT-----------------------------------
create_plot_data <- function(data_to_wrangle) {
  
  # Create dataset----
  data_to_wrangle %>% 
    pivot_longer(
      cols = c(P_gkg:Cu_mgkg, N_gkg),
      names_to = "name",
      values_to = "value"
    ) %>% 
    mutate(name = factor(name))
}



# FEEDSTUFF DATA-----------------------------------
data$feedstuff <- data$iaffd_overview[[1]] %>% 
  
  # join with XXX
  left_join(data$iaffd_composition[[1]], by = c("code","description")) %>% 
  
  # Data cleaning
  select(-c("code", "winfeed.x", "winfeed.y")) %>% 
  mutate(description = str_extract(description, "^[^,]+")) %>% 
  drop_na(cat1) %>%
  
  
  mutate(
    class = case_when(
      cat1=="animal"&grepl("[Ff]ish", cat2) ~ "fish",
      grepl("[Cc]rustacean", cat2) ~ "crustacean",
      cat1=="animal"&cat2=="insect" ~ "insect",
      grepl("[Mm]icro", cat1) ~ "microbial",
      grepl("[Mm]ammal", cat2) ~ "mammal",
      grepl("[Pp]oultry", cat2) ~ "poultry",
      grepl("[Ll]egumes", cat2) ~ "legume",
      grepl("[Gg]rains", cat2) ~ "grain",
      cat2=="Roots and tubers" ~ "roots"
    ),
    
    class = fct_relevel(class, 
                        "fish", "crustacean", "mammal", "poultry", "legume", "grain", "roots", "insect", "microbial"),
    
    colclass = case_when(
      class %in% c("fish", "crustacean") ~ "aquatic",
      class %in% c("mammal", "poultry") ~ "terrestrial",
      class %in% c("legume", "grain", "roots") ~ "plant",
      class == "insect" ~ "insect",
      class == "microbial" ~ "microbial"
    ) 
  ) %>% 
  drop_na(class) %>% 
  
  mutate(across(contains("(%)"), ~ . * 10)) %>% 
  
  
  write_rds(here("output", "interm", "feedstuff_wide.rds")) %>% 
  
  # longtable
  pivot_longer(`Dry Matter (%)`:`SID Tyr - poultry (%)`,
               names_to = "analyte", values_to = "value") %>% 
  
  filter(grepl("Protein", analyte) | 
           grepl("Potassium", analyte) | 
           grepl("Phosphorus", analyte) | 
           grepl("Iron", analyte) | 
           grepl("Manganese", analyte) | 
           grepl("Zinc", analyte)) %>% 
  write_rds(here("output", "interm", "feedstuff_long.rds"))
