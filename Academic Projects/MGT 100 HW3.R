rm(list=ls())
library(tidyverse)

setwd("/Users/j.p./Downloads/MGT 100/data")
cust_dat <- read_csv("smartphone_customer_data.csv")

#Question 1
# Subset the data to include only customers who bought their phone two years ago
subset_data <- cust_dat[cust_dat$years_ago == 2, ]

# Select the six variables measuring minutes of usage on various activities
subset_data <- subset_data[, c("gaming", "chat", "maps", "video", "social", "reading")]

# Scale the selected variables
scaled_data <- scale(subset_data)

# Calculate correlations between each pair of variables
correlation_matrix <- cor(scaled_data)

# Find the two activities that are most highly correlated
max_correlation <- max(correlation_matrix[upper.tri(correlation_matrix, diag = FALSE)])
indices <- which(correlation_matrix == max_correlation, arr.ind = TRUE)
variable_names <- colnames(correlation_matrix)
activity1 <- variable_names[indices[1, 1]]
activity2 <- variable_names[indices[1, 2]]

# Output the results
print(paste("The two activities most highly correlated are:", activity1, "and", activity2, "with correlation coefficient:", round(max_correlation, 2)))

#Question 2
pca_result <- prcomp(subset_data, scale. = TRUE)

# Extract the variance explained by each principal component
variance_explained <- pca_result$sdev^2

# Calculate the cumulative variance explained by the first two principal components
cumulative_variance <- cumsum(variance_explained) / sum(variance_explained)

# Output the cumulative variance captured by the first two principal components
round(cumulative_variance[2], 2)

#Question 3
pca_result <- prcomp(subset_data, scale. = TRUE)

# Extract the variance explained by each principal component
variance_explained <- pca_result$sdev^2

# Calculate the cumulative variance explained by the first three principal components
cumulative_variance <- cumsum(variance_explained) / sum(variance_explained)

# Output the cumulative variance captured by the first three principal components
round(cumulative_variance[3], 2)

#Question 4
pc_data <- data.frame(PC1 = pca_result$x[, 1], PC2 = pca_result$x[, 2])

# Plot the data using ggplot
ggplot(pc_data, aes(x = PC1, y = PC2)) +
  geom_point() +
  labs(x = "Principal Component 1", y = "Principal Component 2", 
       title = "PCA Plot of Respondents")




