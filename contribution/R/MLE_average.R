#
# TITLE:
#               Average plant nutrient concentrations in tap water
#
# DESCRIPTION:
#               Average concentrations of plant nutrients in tap water from
#               different suppliers all over the world. 
#               Results calculated from censored data using Maximum-Likelihood-
#               Estimation (MLE) method with cenmle() function from the NADA
#               package.
#
#
#
# written by: Anil Axel Tellbuescher
#
# date written:: July 18th, 2022
# last modified: July 18th, 2022
#
#
#
###############################################################################

# Extract nutrients for looping
object <- levels(plotdata$nutrient)

# Create results data frame
results <- data.frame(nutrient = vector(mode = "character"), meanConc_mgL = vector(mode = "numeric"))

for (number in 1:length(object)) {
  
  # Create subset for each nutrient
  temp <- filter(plotdata, nutrient == object[number]) %>%
    drop_na()
  
  # Create results dataframe with 95% confInts
  results[number,1] <- object[number]
  results[number,2] <- mean(cenmle(temp$mgL, temp$belowLimit, dist = 'gaussian'))[1]
}