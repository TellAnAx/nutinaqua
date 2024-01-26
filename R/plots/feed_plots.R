# Feed composition----

#plot_feed_comp()

#ggsave(here::here("output", "plots", "feed_composition.png"))


# Feedstuff composition----
read_rds(here("output", "interm", "feedstuff_cleaned.rds")) %>%
  plot_feedstuff_comp()

ggsave(here::here("output", "plots", "feedstuff_composition.png"))
