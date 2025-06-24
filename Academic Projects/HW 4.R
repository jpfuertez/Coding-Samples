#setting working directory
setwd("/Users/j.p./Downloads/EP5/Week 9/data")
library(tidyverse)

#1.1
df<-read_csv("brexit_clean.csv")
df<-select(df, council_id, leave_share, immigrant_share, median_wage_growth, 
           share_above_60, share_high_skill, unemployment,import_shock)

#1.2
df$leave_yes<-ifelse(df$leave_share>=50, 1, 0)

#1.3
mean(df$leave_yes)

#1.4
leave_EU<-subset(df, leave_yes==1)
mean(leave_EU$median_wage_growth)

#1.5 
stay_EU<-subset(df, leave_yes==0)
mean(stay_EU$median_wage_growth)
rm(main,xlab)

#2
hist(df$leave_share, xlab="Percent Who Voted Yes", 
     ylab="Frequency", main="Histogram of Regions That Voted to Leave the EU",
     col="grey")
lines(c(50,50), c(0,40), lty=2, col="red", lwd=3)

#3.1
df$vote_stay<-df$leave_yes>0
boxplot(df$unemployment ~ df$vote_stay,
        horizontal=T,
        main = "Average Unemployment Rate by Council Votes",
        xlab = "Average Unemployment Rate",
        ylab = "Voted Yes to Leave the EU")
        
#4
ggplot(df, mapping=aes(x=share_above_60, y=leave_share)) +
  geom_point() + xlab("Percent Above 60 Years of Age") +
  ylab("Fraction Voted to Leave the EU") +
  ggtitle("Relationship Between Percent of Council Above Age 60 and 
          Voting to Leave the EU")

#5.1
lm_age<- lm(leave_share ~ share_above_60, data = df)
lm_age

#6
install.packages("stargazer")
library(stargazer)
lm_import<-lm(leave_share ~ import_shock, data=df)
lm_import
lm_immigrant<-lm(leave_share ~ immigrant_share, data=df)

stargazer(lm_import, lm_immigrant, title="Regression Results of Import 
          Activity and Share of Immigrant Residents Per Council",
          align=TRUE, type="html", out="regtable.html")
