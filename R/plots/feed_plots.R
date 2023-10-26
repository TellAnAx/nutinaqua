plot_data <- data$feed_commercial[[1]] %>% 
  select(c(producer:size_mm, P_gkg:Cu_mgkg)) %>% 
  pivot_longer(
    cols = P_gkg:Cu_mgkg,
    names_to = "name",
    values_to = "value"
  )

q1 <- plyr::ddply(plot_data, "name", summarise,
                  grp.q1 = quantile(value, probs = 0.25, na.rm = TRUE))
med <- plyr::ddply(plot_data, "name", summarise, 
                   grp.median = median(value, na.rm = TRUE))
mea <- plyr::ddply(plot_data, "name", summarise, 
                   grp.mean = mean(value, na.rm = TRUE))
q3 <- plyr::ddply(plot_data, "name", summarise,
                  grp.q3 = quantile(value, probs = 0.75, na.rm = TRUE))

plot_data %>% 
  ggplot(aes(x = value, fill = name)) + 
  geom_density(alpha = 0.5) +
  facet_wrap(facets = vars(name), 
             scales = "free") +
  theme(legend.position = "none") +
  geom_vline(data = q1, aes(xintercept = grp.q1), linetype = "dashed") +
  geom_vline(data = med, aes(xintercept = grp.median), linetype = "solid") +
  geom_vline(data = mea, aes(xintercept = grp.mean), linetype = "solid", color = "red") +
  geom_vline(data = q3, aes(xintercept = grp.q3), linetype = "dashed")


