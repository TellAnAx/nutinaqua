# Feed composition----

#plot_feed_comp()

#ggsave(here::here("output", "plots", "feed_composition.png"))


# Feedstuff composition----

mean_aquatic <- read_rds(here("output", "interm", "feedstuff_cleaned.rds")) %>%
  filter(cat2 == "aquatic") %>% 
  group_by(analyte) %>% 
  summarise(mean = mean(value))

read_rds(here("output", "interm", "feedstuff_cleaned.rds")) %>% 
  plot_feedstuff_comp() + 
  geom_vline(data = mean_aquatic, aes(xintercept = mean),
             linetype = "dashed", color = "red")

ggsave(here::here("output", "plots", "feedstuff_composition.png"))
