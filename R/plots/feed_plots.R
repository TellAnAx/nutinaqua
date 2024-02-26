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
             linetype = "dashed", color = "red") +
  labs(fill = "class",
       x = expression(log[10]("inclusion")),
       y = "") +
  scale_x_log10()

ggsave(here::here("output", "plots", "feedstuff_composition.png"),
       height = 10, width = 10, units = "cm")



