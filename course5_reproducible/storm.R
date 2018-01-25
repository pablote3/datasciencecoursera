setwd("~/Documents/r/coursera/5 Reproducible Research/assignment2/")
library(ggplot2)
library(dplyr)

if (!file.exists("repdata%2Fdata%2FStormData.csv.bz2")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
    download.file(fileUrl, destfile = "repdata%2Fdata%2FStormData.csv.bz2", method = "curl")
}

storm <- read.csv("repdata%2Fdata%2FStormData.csv.bz2")
#storm$BGN_DATE <- as.Date(storm$BGN_DATE)
storm$EVTYPE <- toupper(storm$EVTYPE)
storm$EVTYPE <- sub("S$", "", storm$EVTYPE)

testDF <- storm %>%
    group_by(EVTYPE) %>%
    summarize(counter = sum(STATE__))

nrow(storm %>%
    group_by(EVTYPE) %>%
    summarize(counter = sum(STATE__)))


#storm$EVTYPE <- replace(storm$EVTYPE, storm$EVTYPE == "AVALANCE", "AVALANCHE")
#storm[storm$EVTYPE == "THUNDERSTORM WIND ",]

head(storm, 10)
str(storm)
summary(storm)
dim(storm)

###Harmful
#stormFatalities <- filter(storm, FATALITIES > 0 & INJURIES == 0)
#stormInjuries <- filter(storm, FATALITIES == 0 & INJURIES > 0)
#stormBoth <- filter(storm, FATALITIES > 0 & INJURIES > 0)
#harmfulDF <- filter(storm, HARMFUL > 0)
storm$HARMFUL <- storm$FATALITIES + storm$INJURIES


###Damage
#billions <- filter(storm, PROPDMGEXP == 'B')
#dmgexp <- filter(storm, PROPDMGEXP %in% c("K", "M", "B"))
#applyDamageExp("K", 25.0)
#damageDF <- filter(storm, DAMAGEAMT > 0)

applyDamageExp <- function (x, y) {
    if(x == "K") as.numeric(y)
    else if(x == "M") as.numeric(y) * 1000
    else if (x == "B") as.numeric(y) * 1000000
    else 0
}

applyDamageExp <- function (x, y) {
    if(x == "M") as.numeric(y) * 1000
    else if (x == "B") as.numeric(y) * 1000000
    else 0
}

applyDamageExp <- function (x, y) {
    if(x == "M") as.numeric(y)
    else if (x == "B") as.numeric(y) * 1000
    else 0
}

storm$PROPDMGAMT <- apply(storm[, c('PROPDMGEXP', 'PROPDMG')], 1, function(x) applyDamageExp(x['PROPDMGEXP'], x['PROPDMG']))
storm$CROPDMGAMT <- apply(storm[, c('CROPDMGEXP', 'CROPDMG')], 1, function(x) applyDamageExp(x['CROPDMGEXP'], x['CROPDMG']))
storm$DAMAGEAMT <- storm$PROPDMGAMT + storm$CROPDMGAMT


###Groupings
#select(storm, EVTYPE, HARMFUL, DAMAGEAMT)

harmfulDF <- storm %>%
    group_by(EVTYPE) %>%
    summarize(counter = sum(HARMFUL)) %>%
    filter(counter > 0) %>%
    arrange(desc(counter))
head(harmfulDF, 10)

ggplot(harmfulDF) +
    geom_histogram(aes(x=counter), binwidth = 5000, col="red", fill="grey") +
    ggtitle("Count of Number of People Harmed Per Severe Weather Event") +
    xlab("Harmful Count") +
    ylab("Number of Events")

ggplot(harmfulDF, aes(x=EVTYPE, y=counter, group=1)) +
    geom_line() +
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
    xlab("Event Type") +
    ggtitle("Impact of weather on population health")

damageDF <- storm %>%
    group_by(EVTYPE) %>%
    summarize(amt = sum(DAMAGEAMT)) %>%
    filter(amt > 0) %>%
    arrange(desc(amt))
head(damageDF, 10)

ggplot(damageDF) +
    geom_histogram(aes(x=amt/1000000), binwidth = 5000, col="red", fill="grey") +
    ggtitle("Accumulated Amount of Dollars of Damage Per Severe Weather Event") +
    xlab("Damage Amount (in millions)") +
    ylab("Number of Events")

ggplot(damageDF, aes(x=EVTYPE, y=amt/10^9,group=1)) +
    geom_line() +
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
    xlab("Event Type") +
    ggtitle("Impact of weather on Economic")
