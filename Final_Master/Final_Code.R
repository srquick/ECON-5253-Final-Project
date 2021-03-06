#SAM QUICK FINAL PROJECT CODE


library(EIAdata)
library(tidyverse)
library(data.table)
library(GGally)
library(plotly)
library(rvest)
library(stringr)
library(magrittr)
library(corrplot)
library(lmtest)
library(fredr)
library(stargazer)
library(xtable)


# EIA API Data for WTI and Henry-Hub
EIAkey <- "INSERT KEY"

getCatEIA(key=EIAkey)
getCatEIA(key=EIAkey, cat=40827)
wtidata <- getEIA(ID = "PET.RWTC.A", key = EIAkey)
henrydata <- getEIA(ID = "NG.RNGWHHD.A", key = EIAkey)

# Fred API Data for GDP
fredr_set_key("INSERT KEY")
gdpdata <- fredr_series_observations(
  series_id = "GDPC1",
  observation_start = as.Date("1997-01-01"),
  frequency = "a"
)

# Data Cleaing and df creation
n = 11
newwtidata = tail(wtidata, -n)
m = 22
newgdpdata = head(gdpdata, m)

newgdpdata['PET.RWTC.A'] = newwtidata$PET.RWTC.A
newgdpdata['NG.RNGWHHD.A'] = henrydata$NG.RNGWHHD.A
masterDF = newgdpdata

# Checking column type (due to error)
class(masterDF$value)
class(masterDF$PET.RWTC.A)
class(masterDF$NG.RNGWHHD.A)

# Changing columns to numerical for apples-to-apples comparison
masterDF['NUM.PET.RWTC.A'] = as.numeric(masterDF$PET.RWTC.A)
masterDF['NUM.NG.RNGWHHD.A'] =as.numeric(masterDF$NG.RNGWHHD.A)

# Granger Analysis set up
x <- masterDF$NUM.PET.RWTC.A
y <- masterDF$NUM.NG.RNGWHHD.A
z <- as.numeric(masterDF$value)

summary(x)
summary(y)
summary(z)

# With WTI and rGDP
grangertest(x, z, order = 2)

# With H-H and rGDP
grangertest(y, z, order = 2)

# With WTI and H-H
grangertest(x, y, order = 2)


# Visuals
plot(masterDF$PET.RWTC.A)
plot(masterDF$date, masterDF$value, typ='l')
plot(masterDF$NG.RNGWHHD.A)


