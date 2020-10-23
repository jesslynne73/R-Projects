# Generating PA per capita for a state's counties
# Author: Jess Strait

rm(list = ls())

# Load packages
library(DataComputing)
library(mosaic)
library(dplyr)

# Wrangle public assistance data
padata <- read.csv("PublicAssistanceData.csv")
padata1 <- padata %>% select(stateCode, declarationDate, damageCategoryCode, projectAmount, county, countyCode)
padata1$declarationDate <- substr(padata1$declarationDate, 0, 4)
padata1 <- padata1 %>% filter(stateCode == 'SD') %>% group_by(declarationDate, stateCode, countyCode) %>% mutate(countyYearTotal = sum(projectAmount)) %>% select(stateCode, declarationDate, county, countyCode, countyYearTotal)
padata2 <- padata1 %>% unique()
padata2 %>% arrange(declarationDate)

# Bring in census data and computer per capita value
kypop <- read.csv("KYPop.csv")
newdata <- merge(padata2, kypop, by='county')
newdata
newdata <- newdata %>% mutate(perCap = round((countyYearTotal/pop)))
newdata
write.csv(newdata, "KYPAByCountyByYearPerCap.csv")

# Compute for 20 years


# Wrangle public assistance data
padata <- read.csv("PublicAssistanceData.csv")
padata1 <- padata %>% select(stateCode, declarationDate, damageCategoryCode, projectAmount, county, countyCode)
padata1$declarationDate <- substr(padata1$declarationDate, 0, 4)
padata1 <- padata1 %>% filter(stateCode == 'CA') %>% filter(as.integer(declarationDate) > 1999) %>% group_by(stateCode, countyCode) %>% mutate(countyTotal = sum(projectAmount)) %>% select(stateCode, county, countyCode, countyTotal)
padata2 <- padata1 %>% unique() %>% filter(county != 'Statewide')
padata2 

# Bring in census data and computer per capita value
lapop <- read.csv("county_census_data.csv")
lapop <- lapop %>% filter(State == 'California') %>% select('County', 'TotalPop')
lapop$county <- lapop$County
lapop <- lapop %>% select('county', 'TotalPop')
newdata <- merge(padata2, lapop, by='county')
newdata
newdata <- newdata %>% mutate(perCap = round((countyTotal/TotalPop)))
newdata %>% arrange(-perCap)
write.csv(newdata, "CAPAByCountyPerCap20Year.csv")
