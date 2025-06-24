rm(list=ls())

library(mlogit)
library(tidyverse)

setwd("/Users/j.p./Downloads/MGT 100/data")
cust_dat <- read_csv("smartphone_customer_data.csv")

#Question 1
#Show brand shares for three years ago and last year
brand_shares <- cust_dat |>
  filter(years_ago == 1) |>
  count(brand) |>
  mutate(shr = n / sum(n))

brand_shares

brand_shares2 <- cust_dat |>
  filter(years_ago == 3) |>
  count(brand) |>
  mutate(shr = n / sum(n))

brand_shares2

#take the difference
mrkt_diff <- brand_shares$shr-brand_shares2$shr

#from left to right: apple, huawei, samsung
mrkt_diff

#Question 2 
#using mdat1 dataset from in class script
out1 <- mlogit(choice ~ apple + samsung |0, data = mdat1)

coef(out1)

#Question 3
#used coefficient command from previous question

#Question 4
#coefficients
out1 <- mlogit(choice ~ apple + samsung + price |0, data = mdat1)

summary(out1)

round(coef(out1), 3)

#hit rate
brand_hit_rate <- function(data, model) {
  preds <- apply(predict(model, newdata = data), 1, which.max)
  actuals <- apply(matrix(data$choice, ncol = 6, byrow = T), 1, which.max)
  mean(ceiling(preds / 2) == ceiling(actuals / 2))
}

round(brand_hit_rate(mdat1, out1), 3)

#rsquare
ll_ratio <- function(data, model) {
  N <- nrow(model$probabilities)
  J <- ncol(model$probabilities)
  ll0 <- N * log(1 / J)   
  ll1 <- as.numeric(model$logLik)   
  1 - ll1 / ll0
}

round(ll_ratio(mdat1, out1), 3)

#Questions 5,6,7 answered on canvas

#Question 8
out2 <- mlogit(choice ~ A2 + S1 + S2 + H1 + H2 + price |0, data=mdat1)
str(out2)
summary(out2)
round(coef(out2), 4)

#Question 9
out3 <- mlogit(choice ~ A2 + S1 + S2 + H1 + H2 + price |0, data=mdat2)
str(out3)
summary(out3)
round(coef(out3), 4)
