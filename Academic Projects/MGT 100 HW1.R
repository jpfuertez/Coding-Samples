setwd("/Users/j.p./Downloads/MGT 100/data")
getwd()
library(tidyverse)

cust_dat <- read_csv("/Users/j.p./Downloads/MGT 100/data/smartphone_customer_data.csv")

#Question 3

cust_dat |> 
  group_by(brand, years_ago==1, size_cat == "l") |>
  summarize(avg_gaming = mean(gaming))

#Question 4

cust_dat |> 
  group_by(brand, size_cat, years_ago) |>
  summarize(cons_count = n()) |>
  arrange(desc(cons_count))

#Question 5

no_dis <- is.na(cust_dat$discount)

cust_dat |>
  filter(no_dis == "TRUE") |>
  count()

#Question 6

phone_dis <- cust_dat$discount == cust_dat$phone_id

cust_dat |>
  filter(phone_dis == "TRUE") |>
  count()

#Question 7

ggplot(cust_dat, aes(x=screen_size, y=price)) +
  geom_point() + 
  geom_text(
    label= cust_dat$brand,
    nudge_y= 8) +
  geom_smooth(method=lm , color="red")

#Question 8

#Used graph from previous question to answer