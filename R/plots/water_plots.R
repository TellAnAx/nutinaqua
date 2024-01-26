# RAINWATER----
read_rds(here("output", "interm", "water_cleaned_rain.rds")) %>%
  ggplot(aes(y = conc)) +
  geom_boxplot() +
  facet_wrap(facets = vars(analyte), scales = "free") +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

ggsave(here("output", "plots", "water_rain.png"))
