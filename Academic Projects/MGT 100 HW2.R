library(tidyverse)

setwd("/Users/j.p./Downloads/MGT 100/data")
cust_dat <- read_csv("smartphone_customer_data.csv")

#Question 1
light_user <- cust_dat$total_minutes < 1200

cust_dat |> 
  group_by(brand, size_cat, light_user == "TRUE") |>
  count()

#Question 2
chat_minutes_2_years_ago <- cust_dat$chat[cust_dat$years_ago == 2]

hist(chat_minutes_2_years_ago, breaks = 30)

#Question 3
apple_a2_data <- cust_dat[cust_dat$phone_id == "A2" & cust_dat$size_cat == "l", ]

ggplot(apple_a2_data, aes(x = as.factor(years_ago), y = handsize)) +
  geom_boxplot() +
  facet_wrap(~ years_ago) +
  labs(title = "Hand Size Distribution for Large Apple Phones (A2) by Year", x = "Years Ago", y = "Hand Size")

#Question 4
ggplot(cust_dat, aes(x = gaming, y = video)) +
  geom_point(color = "#33A1C9", size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, color = "red") + 
  labs(title = "John's Scatterplot",  x = "Gaming Minutes", y = "Video Minutes") +  
  theme_minimal(base_size = 14) +  
  theme(axis.text = element_text(size = 12),  
        axis.title = element_text(size = 14, face = "bold"), 
        plot.title = element_text(size = 18, face = "bold")) 

#Question 5
scaled_data <- scale(cust_dat[, c("social", "gaming")])

set.seed(1234)

k <- 4 
nstart <- 10  
kmeans_result <- kmeans(scaled_data, centers = k, nstart = nstart)

# Count the frequency of each cluster membership
cluster_counts <- table(kmeans_result$cluster)

# Find the cluster with the highest frequency (largest segment)
largest_segment <- which.max(cluster_counts)

print(cluster_counts[largest_segment])

#Question 6
total_withinss <- kmeans_result$tot.withinss

rounded_withinss <- round(total_withinss)

print(rounded_withinss)

