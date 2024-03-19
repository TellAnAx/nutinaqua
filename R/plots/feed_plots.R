source(here("R", "plot_functions.R"))

# Feed composition----

#plot_feed_comp()

#ggsave(here::here("output", "plots", "feed_composition.png"))


# Feedstuff composition----

mean_aquatic <- read_rds(here("output", "interm", "feedstuff_cleaned.rds")) %>%
  filter(cat2 == "aquatic") %>%
  group_by(analyte) %>%
  summarise(mean = mean(value))


scientific_10 = function(x) {
  ifelse(
    x==0, "0",
    parse(text = sub("e[+]?", " %*% 10^", scales::scientific_format()(x)))
  )
}

read_rds(here("output", "interm", "feedstuff_cleaned.rds")) %>%
  mutate(analyte = fct_relevel(analyte, "N (g/kg)", "P (g/kg)", "K (g/kg)",
                               "Fe (mg/kg)", "Mn (mg/kg)", "Zn (mg/kg)"),
         cat2 = fct_relevel(cat2, "aquatic", "terrestrial", "plant", "insect", "microbial"),
         cat3 = fct_relevel(cat3, "fish", "crustacean", 
                            "mammal", "poultry", 
                            "legume", "grain", "roots",
                            "insect",
                            "microbial")) %>% 
  plot_feedstuff_comp() +
  geom_vline(data = mean_aquatic, aes(xintercept = mean),
             linetype = "dashed", color = "red", alpha = .7) +
  labs(fill = "",
       x = expression(log[10]("inclusion")),
       y = "") +
  scale_x_log10(breaks = c(0.01,0.1,1,10,100,1000), labels = scales::label_comma())
  #scale_x_log10(breaks = 10^(-2:3), labels = scales::trans_format("log10", scales::math_format(10^.x)))
  

ggsave(here::here("output", "plots", "feedstuff_composition.png"))



