## 

### Create subset_mg
```{r}
subset_mg <- empirical_data %>% 
  select(-ends_with('_const')) %>% 
  select(-c('Include', 'temp_degC', 'EC_uScm')) %>%  
  select(-ends_with('_belowLimit')) %>% 
  pivot_longer(
    N.NH4_mgL:Na_mgL,
    names_to = c("nutrient", ".value"),
    names_pattern = "(.+)_(.+)*"
  ) %>% 
  print()
```



```{r}
subset_mg %>% 
  left_join(subset_belowLimit)
```





### Create subset_belowLimit
```{r}
subset_belowLimit <- empirical_data %>% 
  select(-ends_with('_const')) %>% 
  select(-c('Include', 'temp_degC', 'EC_uScm')) %>%  
  select(-ends_with('_mgL')) %>% 
  pivot_longer(
    NH4_belowLimit:Na_belowLimit,
    names_to = "nutrient",
    values_to = "belowLimit",
    names_pattern = "(.+)_belowLimit*"
  ) %>% 
  print()
```



### Calculate values below detection limit using MLE
```{r include=FALSE}
# Calculation of Maximum Likelihood estimates and 95% confidence interval for censored tap water quality data

# Create processing datatset
procdata <- subset_mg %>% 
  left_join(subset_belowLimit) %>% 
  mutate(
    nutrient = as.factor(nutrient),
    belowLimit = as.logical(belowLimit)
  ) %>% 
  drop_na(mgL)

# Extract nutrients for looping
object <- levels(procdata$nutrient)

# Create results data frame
results <- data.frame(nutrient = vector(mode = "character"), lconf = vector(mode = "numeric"), hconf = vector(mode = "numeric"))

results <- data.frame()

for(number in 1:length(object)) {
  
  # Create subset for each nutrient
  temp <- filter(procdata, nutrient == object[1]) %>%
    drop_na()
  
  # Create results dataframe with 95% confInts
  results[number,1] <- object[number]
  results[number,2] <- mean(cenmle(temp$mgL, temp$belowLimit, dist = 'gaussian'))[c(3)]
  results[number,3] <- mean(cenmle(temp$mgL, temp$belowLimit, dist = 'gaussian'))[c(4)]
}

rm(subset_mg, subset_belowLimit, procdata, object)
```