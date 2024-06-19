## Jordy van Langen

## figure creation for 'ggrain' manuscript to Journal of Open Source Software

## Use and pre-load to setwd() all documents in : "Workshop8 - Brain development day" 

if (!require(pacman)) {
  install.packages("pacman")
}
pacman::p_load(patchwork, tidyverse, lavaan, ggpp, plyr,
               ggrain) #for rainclouds


source("geom_flat_violin.R") #this only works if you set the right path!
source("fn_summary_SE.r") # This does the summary. For each group's data frame, return a vector with
# N, mean, median, and sd

#################################################
# first we will start by simulating some data! :)
#################################################
m <- 50 # mean
s <- 25 # sd
sim_n <- 250 # draws

# Calculate log-normal parameters ----
location <- log(m^2 / sqrt(s^2 + m^2))
shape <- sqrt(log(1 + (s^2 / m^2)))

# Set seed to get same data everytime ----
set.seed(42)

# Create data by hand ----
simdat_group1 <- rlnorm(sim_n, location, shape)
simdat_group2 <- rnorm(sim_n, m, s)

simdat <- c(simdat_group1, simdat_group2) %>% as_tibble() %>% dplyr::rename(score = 1)
simdat <- simdat %>% mutate(group = 
                              fct_inorder(c(rep("A", times = sim_n),
                                            rep("B", times = sim_n))))

# Calculate summary stats ----
summary_simdat <- fn_summary_SE(simdat, score, group)

# lets look at the data
head(simdat)
str(simdat)
summary_simdat



## simple figure

p_simple <- ggplot(simdat, aes(x=group,y=score, fill = group, colour = group)) +
  geom_rain(rain.side = "r",
            boxplot.args = list(color = "black", outlier.color = NA)) + 
  theme_minimal(base_size = 20) 
p_simple

# loading the data: make sure to get getwd() and do setwd()
rep_data <- read_csv("repeated_measures_data.csv", 
                     col_types = cols(group = col_factor(levels = c("1", "2")), 
                                      time = col_factor(levels = c("1", "2", "3"))))

sumrepdat <- fn_summary_SE(rep_data, "score", c("group", "time"))
head(sumrepdat); str(sumrepdat)

#*answer
table(rep_data$time)

rep_data <- rep_data[order(rep_data$time),]
rep_data$id <- rep(1:29,3)



## complex figure
rep_data <- rep_data[rep_data$time != "3",]
p_complex <- ggplot(rep_data, aes(x = time, y = score, fill = group, color = group)) +
  geom_rain(id.long.var = "id", rain.side = "f2x2",
            boxplot.args = list(color = "black", outlier.color = NA),
            violin.args = list(adjust = 1.5, trim = FALSE)) +
  #scale_color_brewer(palette = "Dark2") + scale_fill_brewer(palette = "Dark2") +
  theme_minimal(base_size = 20) 

p_complex

p_all <- p_simple / p_complex + plot_annotation(tag_levels = "a")

#ggsave("PATH/JOSS_figure.png", bg = "white", dpi=700)
