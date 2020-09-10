# Author: Jess Strait
# The use case for this program is to intake data about houses and to predict the price of other houses based on the training data.

# Front Matter
rm(list = ls())
library(data.table)
library(caret)
library(Metrics)

# Import and explore data
houseTrain <- fread("Stat_380_train.csv")
houseTest <- fread("Stat_380_test.csv")
View(houseTrain)
class(houseTrain)

# Explore possible data relationships
pairs(SalePrice~GrLivArea+OverallQual+BedroomAbvGr, data=houseTrain[1:1000,])
pairs(SalePrice~GrLivArea+TotalBsmtSF+FullBath, data=houseTrain[1:1000,])
pairs(SalePrice~GrLivArea+TotalBsmtSF+FullBath+BedroomAbvGr, data=houseTrain[1:1000,])

# Build linear regression model based on variables of interest
model <- lm(SalePrice ~ OverallQual+GrLivArea+BedroomAbvGr+BldgType+FullBath+TotalBsmtSF, data=houseTrain)
summary(model)
# Save model
saveRDS(model, "SalePrice_lm.model")

# Generate predicted sale prices with linear regression model
houseTest$SalePrice<-predict(model,newdata = houseTest)
# Create data table with only variables of interest
submit <- houseTest[,.(Id=houseTest$Id, SalePrice)]
# Write data table to submission file
fwrite(submit,"submission2.csv")

