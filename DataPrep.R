# This script prepares data for the World Infant Mortality shiny app
library(dplyr)
library(tidyr)
## Download Data
url <- "http://apps.who.int/gho/athena/data/data-text.csv?target=GHO/CM_01,CM_02,CM_03&profile=text&filter=COUNTRY:*;REGION:*"
download.file(url,destfile="infants.csv",method = "curl")
infants <- read.csv("infants.csv",header=TRUE)
population <- read.csv("population.csv")

##Build Data sets for each measure
Infant_Deaths <- infants %>% filter(Indicator =="Number of infant deaths (thousands)") %>%
        select(Year,WHO.region, World.Bank.income.group, Country, Infant_Deaths=Numeric) 
Neonatal_Deaths <- infants %>% filter(Indicator =="Number of neonatal deaths (thousands)")  %>%
        select(Year,WHO.region, World.Bank.income.group, Country, Neonatal_Deaths=Numeric) 
Under5_Deaths <- infants %>% filter(Indicator =="Number of under-five deaths (thousands)")  %>%
        select(Year,WHO.region, World.Bank.income.group, Country, Under5_Deaths=Numeric) 
population <- population %>% select(-Country.Code,-Indicator.Name,-Indicator.Code) %>% 
        gather(Year,pop,X1960:X2015) %>% mutate(Year=as.integer(substr(Year,2,5)),Country=Country.Name)

## Correct country name mismatches
country_lkp <- matrix(c(
        "Bahamas", "Bolivia (Plurinational State of)", "Congo", "Côte d'Ivoire", "Democratic People's Republic of Korea",  
        "Democratic Republic of the Congo", "Egypt", "Gambia", "Iran (Islamic Republic of)", "Kyrgyzstan", 
        "Lao People's Democratic Republic", "Micronesia (Federated States of)", "Republic of Korea", 
        "Republic of Moldova", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", 
        "Slovakia", "The former Yugoslav republic of Macedonia", "United Kingdom of Great Britain and Northern Ireland", 
        "United Republic of Tanzania", "United States of America", "Venezuela (Bolivarian Republic of)", 
        "Viet Nam", "Yemen",
        "Bahamas, The", "Bolivia",        "Congo, Rep.",        "Cote d'Ivoire",        "Korea, Dem. Rep.",
        "Congo, Dem. Rep.",        "Egypt, Arab Rep.", "Gambia, The", "Iran, Islamic Rep.", "Kyrgyz Republic",
        "Lao PDR",  "Micronesia, Fed. Sts.",      "Korea, Rep.",
        "Moldova",        "St. Kitts and Nevis",        "St. Lucia",        "St. Vincent and the Grenadines",
        "Slovak Republic",       "Macedonia, FYR",        "United Kingdom",
        "Tanzania",        "United States",        "Venezuela, RB",
        "Vietnam",        "Yemen, Rep."),
        nrow=25,
        ncol=2)
colnames(country_lkp) <- c("NewCountry","Country")
country_lkp <- as.data.frame(country_lkp)

##Put the data together
X<- left_join(Infant_Deaths,Neonatal_Deaths,by=c("Country"="Country", "Year"="Year"))
Y <- left_join(X, Under5_Deaths, by=c("Country"="Country", "Year"="Year"))
population <- left_join(population,country_lkp, by=c("Country.Name"="Country"))
population <- population %>% mutate(Country=ifelse(is.na(NewCountry),as.character(Country),as.character(NewCountry))) %>%
        select(Year,Country,pop)
Z <- left_join(Y, population,by=c("Country"="Country", "Year"="Year"))

## Prepare final dataset
kid_stats <- Z %>% filter(!(is.na(pop))) %>%
        select(Year,Region=WHO.region.x, Income_Group=World.Bank.income.group.x, 
               Country,  Population=pop, Infant_Deaths,Neonatal_Deaths,Under5_Deaths) %>% 
        mutate(Infant_Deaths_Per_Million=as.integer(Infant_Deaths*1000*1000000/Population),
               Neonatal_Deaths_Per_Million=as.integer(Neonatal_Deaths*1000*1000000/Population),
               Under5_Deaths_Per_Million=as.integer(Under5_Deaths*1000*1000000/Population))

##Write dataset to file for server.r to use
write.csv(kid_stats,file="kid_stats.csv",row.names = FALSE)
        

