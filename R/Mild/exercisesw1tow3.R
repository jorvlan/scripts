## MILD course Utrecht summer school

# Lab Week 1-3 with R: Basics of N=1 time series modeling

# install packages
library(foreign)
library(rjags)
library(coda)
library(psych)


mydata_Jane= read.spss("/Users/maaikeschumer/Desktop/Jordy_PHD/MILD/Week1to3/Exercises/Rlab_w1to3/dat2.sav", use.value.labels = FALSE, 
                       to.data.frame = FALSE, 
                       trim.factor.names = FALSE, 
                       trim_values = TRUE, reencode = NA,
                       use.missings = TRUE) 



mydata_Mary = read.spss("/Users/maaikeschumer/Desktop/Jordy_PHD/MILD/Week1to3/Exercises/Rlab_w1to3/dat4.sav", use.value.labels = FALSE,
                        to.data.frame = FALSE,
                        trim.factor.names = FALSE,
                        trim_values = TRUE, reencode = NA,
                        use.missings = TRUE)

## Extracting mood from Jane's dataset
dat_Jane <- data.frame(mydata_Jane$scale)
dat_Jane <- as.matrix(dat_Jane)
colnames(dat_Jane) <- c("mood")



## Extracting mood from Mary's dataset
dat_Mary <- data.frame(mydata_Mary$scale)
dat_Mary <- as.matrix(dat_Mary)
colnames(dat_Mary) <- c("mood")

## View the univariate time series for Jane's variable 'mood':
View(dat_Jane)

min(dat_Jane, na.rm = TRUE) 
max(dat_Jane, na.rm = TRUE) 

## what do you notice
## 91 timepoints, some NA's (missing data), minimum value 40, maximum value 100.
## We see that typically her scores are more towards the higher end of the scale, indicating that typically her mood is quite ok. There is however variation in her mood from day to day (Row to row), and sometimes her mood dips to the lower half of the scale. 

## View the univariate time series for Jane's variable 'mood':
View(dat_Mary)

min(dat_Mary, na.rm = TRUE) 
max(dat_Mary, na.rm = TRUE) 

## what do you notice
## 105 timepoints, some NA's (missing data), minimum value 25 maximum value 90
## Her scores vary from day to day. It seems her scores may tend more towards the middle and hihger ends of the scale: overall one may notice that is seems she rates her mood lower compared to how Jane rates her mood. 

## Visualize the time series with a time series plot for Jane
ts.plot(dat_Jane, col = "mediumseagreen", lwd=4, ylab = "Jane's mood")

## What do you notice? 
## missing data represented by gaps, lowest and highest value ranges on y-axis, trend wise looks like a slight increase in average mood.
## For Jane, we see her 91 measurements seem to fluctuate around a mood score of about 70-80, with some sharper dips in mood, and overall scores ranging from 40 to 100. At the beginning of the time series we observe more dips in mood, while at the end of the series we observe more missing observations. Based on the measurements we do have, it seems the series characteristics, particularly the variability, may be different in the beginning than at the end of the scale (which could be an indication of non-stationarity, which we'll discuss a bit more later in the course). However, it could also be the case that here data is stationary, but towards the end of the series the missing observations are precisely when her mood is low (a missing non-at-random pattern). Unfortunately for these data we have no way of knowing, and we will ignore this mostly during our analyses here. It however does highlight some of the features of time series data to consider in general.



## Visualize the time series with a time series plot for Mary, 
ts.plot(dat_Mary, col = "mediumpurple", lwd=4, ylab = "Mary's mood")
## What do you notice? 
# missing data represented by gaps, lowest and highest value ranges on y-axis, trend wise looks like no increase/decrease.
##  Mary's time series look different from Jane's overall, with her mood fluctuating around a bit lower scores than Jane. Overall, Jane and Mary have a similar range of scores, but Mary's seem a bit more variable typically. Mary's data seems fairly stationary based on this first glance, given that the variability (width of the time series judged from the y-axis) and central tendency of her scores (the approximate center of her scores as judged from the y-axis) seems to remain approximately the same over the whole series, for example.

## Now we get the means, range, variance and standard deviation for Jane. Also how many observations are missing
mean(dat_Jane, na.rm = TRUE)
range(dat_Jane, na.rm = TRUE)
var(dat_Jane, na.rm = TRUE)
sd(dat_Jane, na.rm = TRUE)
sum(is.na(dat_Jane))
mean(is.na(dat_Jane)) 

## Now we get the means, range, variance and standard deviation for Jane. Also how many observations are missing
mean(dat_Mary, na.rm = TRUE)
range(dat_Mary, na.rm = TRUE)
var(dat_Mary, na.rm = TRUE)
sd(dat_Mary, na.rm = TRUE)
sum(is.na(dat_Mary))
mean(is.na(dat_Mary)) 

## what do we notice?

## ## Jane has a mean of about 75, while Mary's is about 62. So Jane rates her mood lower than Mary on average. Mary's reported mood is however a bit more more variable (although their variance and standard deviations are not wildly different) Both have a percentage of missings of about 15% (Mary's a bit lower than Jane's), so for the large majority of days we have observed their mood. Note we are not formally testing any of these differences in their descriptive statistics, so we do not know if they are generalizable to the full population of daily mood for these women. Note that our goal here is also mainly illustrating how basic descriptives work for time series (they work the same as for other data!


## We can get the autocorrelation function (ACF), and the partial autocorrelation functions (PACF) for the data of each pp.

# Jane
acf(dat_Jane, na.action=na.pass)
pacf(dat_Jane, na.action=na.pass)

# Mary
acf(dat_Mary, na.action=na.pass)
pacf(dat_Mary, na.action=na.pass)

## the autocorrelations and partial autocorrelations from Mary are lower compared to Jane.

## When we look at the acf function plotted for Jane, we see on the y-axis the value of the autocorrelations, and on the x-axis the lag that is being considered. the ACF plot starts at lag 0, which is the variable correlated with itself without shifiting it in time. Hence, this autocorrelation will always be 1, and is not very interesting. If we look at the remaining lags, we see for many lags the autocorrelations are fairly close to zero. The highest two autocorrelations are for lag 2 and lag 9, where they are also just higher than the plotted confidence bounds, indicating that these significantly differ from zero. Lag 2 indicates the correlation between scores that are two days apart - today's with the day before yesterday's moods. It is positive, so if Jane's score is relatively high today, it also tends to be relatively high the day after tomorrow. We observe no such relationship for lag 1, so today's score does not predict/relate to tomorrow's score. We also see a positive relationship between scores 9 day's apart, so between today's score and a week after the day after tomorrow. We do not have information about Jane that could make these results more intuitive (e.g., maybe she has different two different schedules or habits that alternatve every day). Also note that any of these results may of course also be the result of statistical errors, such as type 1 errors.
## 
## The PACF shows the autocorrelation when we control for all previous lags (so the lag 2 result is corrected for the lag 1 autocorrelation, the lag 3 for both the lag 1 and lag 2 autocorrelation, etc). This plot does not include lag 0 like the acf did, but immediately starts at lag 1. We see that for Jane then only the lag 2 relationship remains significant; the lag 9 relationship is no longer significant after controlling for all the previous lags. 
##     
## For Mary, the acf shows one significant autocorrelation, namely a positive one for lag 1, indicating that her current mood predicts here mood one day later. For the pacf, we see one additional significant partial autocorrelation that is negative, for lag 18. This would indicate that when her score tends to be relatively high one day, 18 days later it tends to be relatively low. We can think of no theoretical/intuitive reason for this particular result (note again any of these results could be statistical errors, such as type 1 errors).


## Exercises 2 ##

## a function for creating lagged variables
lagmatrix <- function(x,max.lag)
  embed(c(rep(NA,max.lag), x), max.lag+1)

y1L_Jane <- lagmatrix(dat_Jane,1)[,2]
cbind(dat_Jane, y1L_Jane)

## We see that for the lagged variable, the second observation is what was the first observation for the original variable, the third observation is what was the second observation in the original variable, and so on. The first occasion is missing, because for the origginal variable tht would be an observation 1 day before we started taking our measurements (tjat is, we don't have it!). 

## calculate autocorrelation between predictor lagged variable and original variable

cor(dat_Jane, y1L_Jane, use="complete") #correlation between lagged 1 variable and original variable
acf(dat_Jane, na.action=na.pass)
acf(y1L_Jane, na.action=na.pass)

## visualize this correlation with a scatterplot
plot(y=dat_Jane, x=y1L_Jane, xlab = "Mood at lag 1", ylab = "Mood")

## now that we have create the lagged variable, we can regress y(t) on y(t-1) 

ar1_in_lm <- lm(dat_Jane~y1L_Jane)
summary(ar1_in_lm)

## Interpret the results.
## the regression coefficient is 0.067 with a p-value of 0.569 hence Jane's mood today is not significantly predicted by Jane's mood yesterday.
## Due to missingness in the data (25 timepoints) the regression coefficient differs from the one in the cor() function between today and yesterday (y(t) & y(t-1))
## ## We see that for Jane, the lag 1 autocorrelation is close to zero (0.07), as we also saw from the acf() function in the previous exercise. We see from the regression analysis that the autoregression coefficient is non-significant; the pvalue is relatively large, and the standard error is larger than the regression coefficient itself. Hence, we do not have evidence for a lag 1 autoregressive effect for Jane. We see Jane's intercept is about 71, which indicates that if her previous score (yesterdays score) is equal to zero, her current mood would be expected to be about 71, which is a pretty good mood.


## Do the same analysis for Mary, and interpret the results.

y1L_Mary <- lagmatrix(dat_Mary,1)[,2]
cbind(dat_Mary, y1L_Mary)

## calculate autocorrelation between predictor lagged variable and original variable

cor(dat_Mary, y1L_Mary, use="complete") #correlation between lagged 1 variable and original variable
acf(dat_Mary, na.action=na.pass)
acf(y1L_Mary, na.action=na.pass)

## visualize this correlation with a scatterplot
plot(y=dat_Mary, x=y1L_Mary, xlab = "Mood at lag 1", ylab = "Mood")

## now that we have create the lagged variable, we can regress y(t) on y(t-1) 

ar1_in_lm_Mary <- lm(dat_Mary~y1L_Mary)
summary(ar1_in_lm_Mary)

## the regression coefficient is 0.3039 with a p-value of 0.0095 hence Mary's mood today is significantly predicted by Mary's mood yesterday.
## Due to missingness in the data (28 timepoints) the regression coefficient differs from the one in the cor() function between today and yesterday (y(t) & y(t-1))
#### We see that for Mary, the lag 1 autocorrelation is about 0.3, as we also saw from the acf() function in the previous exercise. Accordinly for a simple stationary AR(1) model, here autoregression coefficient is also about 0.3, and differs significantly from zero. This indicates that if her mood is relatively high today, we'd predict here mood to also be relatively high tomorrow. Specifically, if yesterdays score increases by 1 point, we'd expect todays score to increase by 0.3 points. That is, about 30% of yesterdays score is carried over to todays score. We also see that Mary's intercept is about 43, so if her previous day score was zero, we'd expect her current mood to be about 43 (not great).

## 2.2 Autoregressive modeling using function arima
?arima

## fit an AR(1) model to the data of Jane using the 'arima' function

arima(dat_Jane, c(1,0,0))

arima(dat_Mary, c(1,0,0))

#Given this information:
  
#Interpret the results. Compare the results with those obtained with the least squares approach used above.
#Do the same for Mary.

## for both fitted ar(1) models of Jane and Mary, it's respective autoregressive coefficients are higher compared to the regression coefficients from 'lm()'
##. ## The results are very similar to when we fitted the models with lm() (so for substantive interpretations of the parameters, see the results for lm() in the previous exercise!). There are differences, which is a result of arima not having to listwise delete missing observations. Hence, I would personally trust the results of arima more. Note that p-values are not reported with the output, but you can still use the standard errors to judge significance of the results (for example by making a confidence interval). You do get the estimated loglikelihood, and the information criterion AIC, which is handy for model selection purposes.

arima(dat_Jane, c(2,0,0))

arima(dat_Mary, c(2,0,0))


## Interpret the results for both Mary and Jane.

## for both fitted ar(2) models of Jane and Mary, it's respective autoregressive coefficients are higher than the regression coefficients from lm().
## ## For Jane, the lag 1 autoregression coefficient is non-significant, but the lag 2 autoregression coefficient is. This is in line with the results from the acf() function we used in exercise 1. This indicate that her current mood is predicted by her mood the day before yesterday, but not by her mood yesterday. As noted earlier, we do not have information about Jane that explains this result. The AIC for the AR(1) model is about 612, while the AIC for the AR(2) model is about 600, which indicates that the AR(2) model is also the best fitting model for Jane, out of these two. 
##     
##  For Mary, the lag 1 autoregression coefficient is significant, but the lag 2 autoregression coefficient is non-significant. This is in line with the results from the acf() function we used in exercise 1 as well. This indicate that her current mood is predicted by her mood yesterday, but not by her mood the day before yesterday. The AIC for the AR(1) model is about 739, while the AIC for the AR(2) model is about 740, which indicates that the AR(1) model is the best fitting model for Mary, out of these two.

## Use the reported information criteria with these results, and the ones for the AR(1) model, to select the best model for Mary, and the best model for Jane.

## based on the AIC the best model for Jane is the ar(2) model (602.43) compared to the ar(1) model (612.29)
## based on the AIC the best model for Mary is the ar(1) model (739.17) compared to the ar(2) model (740.47)



## If you want, you can try out more models!

## innovations can be thought of e.g., listening to a nice song which has an effect on my mood and that effect on my mood has a carry over effect to my mood later that day.

## innovations only capture unexplained variance that is due to effects that carry over through the Autoregressive effect over time. This means that the AR model , innovations and other parts of the model so far, do not account for time point specific variance. 
## innovations capture all kinds of unmodeled influences on the variable (influences that are not explained by the AR effect). innovations do not capture measurement errors. not accounting for measurement errors can mess up your results. 
## measurement error are timepoint specific effects and if we want to include them in the AR model, we add them at the top. the measurement error only has an effect on the observed score and are not carried over through dynamics to other time points. we can actively model this, which will be discussed in the measurement part of the course. 

## innovations at yt-1 on the observed variable yt-1 are carried over through the autoregressive effect on yt



