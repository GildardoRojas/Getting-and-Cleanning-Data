Getting and Cleaning Data Course Project
===================
THE CODE BOOK
===================
**GENERAL INFORMATION**

Here are the data for the project:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 

1.	Variables. A variables description can be found in the README.txt. file that comes with the data set. An online description of the data set can be seen here: [[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones ](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones )]

2.	Summary choices made. A full wide tidy data set was produced. This was later used as a source for grouping and averaging data producing another tidy data set.

3.	Experimental design made.


**ASSUMPTIONS**
- According to TAs recommendations, it has been assumed that the data has been downloaded and unzipped (the 'UCI HAR Dataset' folder) and enabled as the working directory.
- Also according to TAs recommendations, the data contained in the 'Inertial Signals' folder has not been considered for simplicity.

**STUDY DESIGN**

There are many ways to do this project, I decided to create a full wide tidy data set and a sample averaging by group file as sample of further processing requested in step 5.

INPUT FILES

- 'features.txt': List of all features (Column labels).
- 'activity_labels.txt': List with activity names.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'train/subject_test.txt': : Subjects of the train data set.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'test/subject_test.txt': Subjects of the test data set.

PROCESS

1. Read 2 catalog data sets (features & activities) and 6 data sets (train and test files).
2. Merge train and test data, 3 data sets are generated: activity (fullLabels), subject (fullSubjects) and data measurements (fullSet).
3. Extract only measures with mean and standard deviation. This reduces the number of columns in the 'fullSet' data frame. 
4. The Activity column is replaced with descriptive names instead of codes.
5. Change activity names with descriptive names. This process sets more readable column names; '()' '-' characters are removed to avoid data management errors later.
6. Average calculations on variables grouping by "Activity", "Subject" can be done by using the ddply function. This requires the plyr package to be installed and loaded. 

OUTPUT FILES

- 'tidySet.csv': Full Tidy Data Set, wide format
- 'averageByGroupsSet.csv': Tidy Data Set, with average per Activity and Subject groups, this sample corresponds to step 5.


**INSTRUCTION LIST**

    ## Load features and activities files
    > features <- read.table("features.txt")
    > activities <- read.table("activity_labels.txt")
    
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
    ## each activity and each subject, this uses the "plyr" package.
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
    
