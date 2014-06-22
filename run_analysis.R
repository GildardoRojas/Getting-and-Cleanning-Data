## -----------------------------------------------------------------------------
## Getting and Cleaning Data - Course Project.
## Objective: Process file sets to produce tidy data sets ready for analysis.
## Data Science Specialization, Johns Hopkins University.
## Written by Gildardo Rojas Nandayapa
## Date: 06/22/2014
## ----------------------------------------------------------------------------- 
## ASSUMPTION: As per TAs suggestion in forums, this script assumes the data has
## been downloaded, unzipped and selected as working directory by using the
## setwd("UCI HAR Dataset") command.
## -----------------------------------------------------------------------------

## Load features and activities files
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")
## Read test data
testSet <- read.table("test/X_test.txt")
testLabels <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")
## Read training data
trainSet <- read.table("train/X_train.txt")
trainLabels <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")

## 1. Merge the test and training data sets.
fullSet <- rbind(testSet,trainSet)
fullLabels <- rbind(testLabels,trainLabels)
fullSubjects <- rbind(testSubjects,trainSubjects)
colnames(fullSubjects) <- "Subject" # Sets subjects colname for later use

## 2. Extracts only measurements on the mean and standard deviation
featuresSubset <- features[grep("mean", features$V2),]
featuresSubset <- rbind(featuresSubset,features[grep("std", features$V2),])
featuresSubset$V2 <- gsub("\\(\\)","",featuresSubset$V2) # Removes '()'
featuresSubset$V2 <- gsub("-","",featuresSubset$V2) # Removes '-'
colnames(fullSet) <- c(1:ncol(fullSet)) # Names columns with numbers
finalSet <- fullSet[,featuresSubset$V1] 

## 3. Use descriptive activity names
labels <- merge(fullLabels,activities,by = "V1")
colnames(labels) <- c("ActId","Activity") # Sets more readable names

## 4. Appropriately label with descriptive variable names
colnames(finalSet) <- featuresSubset$V2
tidySet <- cbind(labels$Activity,fullSubjects,finalSet)
colnames(tidySet)[1] <- "Activity" # Sets first column name
## Write full tidy data set to "tidySet.csv" file.
write.table(tidySet,"tidySet.csv",quote=FALSE,sep=",",row.names=FALSE)

## 5. Create a 2nd independent data set with the average of each variable for
##    each activity and each subject, this uses the "plyr" package.
install.packages("plyr")
library(plyr)
## An average grouped by Activity and Subject for a variable can be calculated
## with the ddply function.
gs<-ddply(tidySet,c("Activity","Subject"),summarise, meanX = mean(tBodyAccmeanX))
## gs is a data frame containing the averages by groups, it is then exported to
## the "meanBygrousSet.csv
write.table(gs,"meanBygroupsSet.csv",quote=FALSE,sep=",",row.names=FALSE)
## Row counts may be also performed
rc <- ddply(tidySet,c("Activity","Subject"),function(x) c(count=nrow(x)))
## ddply supports multiple variables, for simplicity only a sinlgle average value
## has been calculated.
## Thanks for reading!
