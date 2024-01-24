# RAINWATER----
read_rds(here("output", "interm", "water_cleaned_rain.rds")) %>% 
  ggplot(aes(x = value)) + 
  geom_boxplot() + 
  facet_wrap(facets = vars(analyte), scales = "free")

ggsave(here("output", "plots", "water_rain.png"))