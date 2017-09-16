#import initial data files
testX <- read.table("./test/X_test.txt", sep = "", header = FALSE)
trainX <- read.table("./train/X_train.txt", sep = "", header = FALSE)

#eliminate columns not defined in keepers vector
keepers <- c("V1", "V2", "V3", "V4", "V5", "V6", "V41", "V42", "V43", "V44", "V45", "V46", "V81", "V82", "V83", "V84", "V85", "V86",
             "V121", "V122", "V123", "V124", "V125", "V126", "V161", "V162", "V163", "V164", "V165", "V166", "V201", "V202", "V214",
             "V215", "V227", "V228", "V240", "V241", "V253", "V254", "V266", "V267", "V268", "V269", "V270", "V271", "V345", "V346", 
             "V347", "V348", "V349", "V350", "V424", "V425", "V426", "V427", "V428", "V429", "V503", "V504", "V516", "V517", "V529", 
             "V530", "V542", "V543")
testX <- testX[, which(names(testX) %in% keepers) ]
trainX <- trainX[, which(names(trainX) %in% keepers) ]

#update column names from feature labels file
featureLbl <- read.table("./feature_labels.txt", sep = "", header = FALSE)
featureLabels <- as.vector(featureLbl[,1])
colnames(testX) <- tolower(featureLabels)
colnames(trainX) <- tolower(featureLabels)

#column bind activity labels
testY <- read.table("./test/y_test.txt", sep = "", header = FALSE)
trainY <- read.table("./train/y_train.txt", sep = "", header = FALSE)
testX <- cbind(testY, testX)
trainX <- cbind(trainY, trainX)

#merge activity descriptions to activity labels
activityLbl <- read.table("./activity_labels.txt", sep = "", header = FALSE)
activityLbl[, 2] <- tolower(activityLbl[, 2])
testX <- merge(testX, activityLbl, by.x="V1", by.y="V1", all=TRUE)
trainX <- merge(trainX, activityLbl, by.x="V1", by.y="V1", all=TRUE)

#remove first column (activity labels)
testX <- testX[, -1]
trainX <- trainX[, -1]

#move last column (activity descriptions) to first position
testX <- testX[,c(ncol(testX),1:(ncol(testX)-1))]
trainX <- trainX[,c(ncol(trainX),1:(ncol(trainX)-1))]

#rename activity desciptions column
colnames(testX)[1] <- "activity"
colnames(trainX)[1] <- "activity"

#column bind subject
testSubject <- read.table("./test/subject_test.txt", sep = "", header = FALSE)
trainSubject <- read.table("./train/subject_train.txt", sep = "", header = FALSE)
testX <- cbind(testSubject, testX)
trainX <- cbind(trainSubject, trainX)

#rename subject column
colnames(testX)[1] <- "subject"
colnames(trainX)[1] <- "subject"

#rbind test and train together
final1 <- rbind(testX, trainX)

#group by activity and subject, then take average of all columns
library(dplyr)
final2 <- final1 %>% group_by(activity, subject) %>% summarise_all(funs(mean))

#export summarized assignment
write.table(final2, "assignment.txt", row.names = FALSE)
