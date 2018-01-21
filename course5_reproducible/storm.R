setwd("/home/pablote/Documents/r/coursera/5 Reproducible Research/assignment2/")
#library(ggplot2)
library(dplyr)

storm <- read.csv("repdata%2Fdata%2FStormData.csv.bz2")
#storm$BGN_DATE <- as.Date(storm$BGN_DATE)
storm$EVTYPE <- toupper(storm$EVTYPE)

head(storm, 10)
str(storm)
summary(storm)
dim(storm)

###Harmful
#stormFatalities <- filter(storm, FATALITIES > 0 & INJURIES == 0)
#stormInjuries <- filter(storm, FATALITIES == 0 & INJURIES > 0)
#stormBoth <- filter(storm, FATALITIES > 0 & INJURIES > 0)

storm$HARMFUL <- storm$FATALITIES + storm$INJURIES
harmfulDF <- filter(storm, HARMFUL > 0)

###Damage
#billions <- filter(storm, PROPDMGEXP == 'B')
#dmgexp <- filter(storm, PROPDMGEXP %in% c("K", "M", "B"))

applyDamageExp <- function (x, y) {
    if(x == "K") as.numeric(y) * 1000
    else if(x == "M") as.numeric(y) * 1000000
    else if (x == "B") as.numeric(y) * 1000000000
    else 0
}

#applyDamageExp("K", 25.0)
storm$PROPDMGAMT <- apply(storm[, c('PROPDMGEXP', 'PROPDMG')], 1, function(x) applyDamageExp(x['PROPDMGEXP'], x['PROPDMG']))
storm$CROPDMGAMT <- apply(storm[, c('CROPDMGEXP', 'CROPDMG')], 1, function(x) applyDamageExp(x['CROPDMGEXP'], x['CROPDMG']))
storm$DAMAGEAMT <- storm$PROPDMGAMT + storm$CROPDMGAMT
damageDF <- filter(storm, DAMAGEAMT > 0)

###Groupings
#select(storm, EVTYPE, HARMFUL, DAMAGEAMT)

harmful <- storm %>%
    group_by(EVTYPE) %>%
    summarize(counter = sum(HARMFUL)) %>%
    filter(counter > 0)


sf <-sapply(split(storm$FATALITIES, storm$EVTYPE), sum)
table(sf$EVTYPE)

count(storm, c("EVTYPE", "FATALITIES"))

storm[storm$EVTYPE == "FOG",]

s <- split(storm, f = storm$EVTYPE)
s
