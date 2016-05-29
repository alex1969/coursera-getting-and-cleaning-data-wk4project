---
title: "Code Book"
author: "Alexander Stevens"
date: "May 29, 2016"
output: html_document
---

This code book summarizes the resulting data fields in tidy.txt.


Identifiers

subject - The ID of the test subject
activity - The type of activity performed when the corresponding measurements were taken

Factors 

subject
activity 

Levels + labels

Activity
        Levels  Label                   Description
        
        1       WALKING:                subject was walking during the test
        2       WALKING_UPSTAIRS:       subject was walking up a staircase during the test
        3       WALKING_DOWNSTAIRS:     subject was walking down a staircase during the test
        4       SITTING:                subject was sitting during the test
        5       STANDING:               subject was standing during the test
        6       LAYING:                 subject was laying down during the test

Subject Note: 30 subjects = 1 to 30 levels)
        Levels  Label                   Description
        1       None                    None
        *       *                       *
        *       *                       *
        *       *                       *
        30      *                       *

Selected Features/Measurements

tBodyAccMeanX
tBodyAccMeanY
tBodyAccMeanZ
tBodyAccStdX
tBodyAccStdY
tBodyAccStdZ
tGravityAccMeanX
tGravityAccMeanY
tGravityAccMeanZ
tGravityAccStdX
tGravityAccStdY
tGravityAccStdZ
tBodyAccJerkMeanX
tBodyAccJerkMeanY
tBodyAccJerkMeanZ
tBodyAccJerkStdX
tBodyAccJerkStdY
tBodyAccJerkStdZ
tBodyGyroMeanX
tBodyGyroMeanY
tBodyGyroMeanZ
tBodyGyroStdX
tBodyGyroStdY
tBodyGyroStdZ
tBodyGyroJerkMeanX
tBodyGyroJerkMeanY
tBodyGyroJerkMeanZ
tBodyGyroJerkStdX
tBodyGyroJerkStdY
tBodyGyroJerkStdZ
tBodyAccMagMean
tBodyAccMagStd
tGravityAccMagMean
tGravityAccMagStd
tBodyAccJerkMagMean
tBodyAccJerkMagStd
tBodyGyroMagMean
tBodyGyroMagStd
tBodyGyroJerkMagMean
tBodyGyroJerkMagStd
fBodyAccMeanX
fBodyAccMeanY
fBodyAccMeanZ
fBodyAccStdX
fBodyAccStdY
fBodyAccStdZ
fBodyAccMeanFreqX
fBodyAccMeanFreqY
fBodyAccMeanFreqZ
fBodyAccJerkMeanX
fBodyAccJerkMeanY
fBodyAccJerkMeanZ
fBodyAccJerkStdX
fBodyAccJerkStdY
fBodyAccJerkStdZ
fBodyAccJerkMeanFreqX
fBodyAccJerkMeanFreqY
fBodyAccJerkMeanFreqZ
fBodyGyroMeanX
fBodyGyroMeanY
fBodyGyroMeanZ
fBodyGyroStdX
fBodyGyroStdY
fBodyGyroStdZ
fBodyGyroMeanFreqX
fBodyGyroMeanFreqY
fBodyGyroMeanFreqZ
fBodyAccMagMean
fBodyAccMagStd
fBodyAccMagMeanFreq
fBodyBodyAccJerkMagMean
fBodyBodyAccJerkMagStd
fBodyBodyAccJerkMagMeanFreq
fBodyBodyGyroMagMean
fBodyBodyGyroMagStd
fBodyBodyGyroMagMeanFreq
fBodyBodyGyroJerkMagMean
fBodyBodyGyroJerkMagStd
fBodyBodyGyroJerkMagMeanFreq

Transormation on data are as follows
```
tidydata2 <- function(workingdir, nameoffile, dataseturl){
        
        #### Uncomment the line below to clean the environment if you wish
        #rm(list=ls())
        
        #### Depreciated. Sets or disables Windows intenral funcs for Internet access
        # setInternet2(TRUE)
        
        #### Load necessary packages
        library(httr)
        library(tidyr)
        library(dplyr)
        library(reshape2)
        
        #### Set working directory and (optional)file path
        setwd(workingdir)
        #thefile <- file.path(getwd(), nameoffile)
        
        #### Download and unzip the dataset
        if (!file.exists(nameoffile)){
                download.file(dataseturl, nameoffile
                              , method="libcurl")
        }  
        if (!file.exists("UCI HAR Dataset")) { 
                unzip(nameoffile) 
        }
        #### Display download timestamp
        dateDownloaded <- date()
        dateDownloaded

        #### Read in the data then 
        rawactivityLabels <- tbl_df(read.table("UCI HAR Dataset/activity_labels.txt"))
        rawfeatures <- tbl_df(read.table("UCI HAR Dataset/features.txt"))
        
        #### Tidy the activity labels and features; output are clean labels and features
        editedactivityLabels <- gsub("_", "", rawactivityLabels$V2)
        editedfeatures <- gsub("-", "", rawfeatures$V2)
        
        #### Select the measurements for mean and std dev
        selectedmeasurements <- grep(".*mean.*|.*std.*", editedfeatures)
        
        #### Tidy the measurements names; output is compliant and tidy feature names vector of length 79
        namesofselectedmeasurements <- editedfeatures[selectedmeasurements]
        namesofselectedmeasurements = gsub('mean', 'Mean',namesofselectedmeasurements)
        namesofselectedmeasurements = gsub('std', 'Std',namesofselectedmeasurements)
        namesofselectedmeasurements <- gsub('[()]', '',namesofselectedmeasurements)
        
        #### Load only the relevant data
        train <- read.table("UCI HAR Dataset/train/X_train.txt")[selectedmeasurements]
        trainactivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
        trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
        
        test <- read.table("UCI HAR Dataset/test/X_test.txt")[selectedmeasurements]
        testactivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
        testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
        
        #### Column bind all tables
        train <- cbind(trainsubjects, trainactivities, train)
        test <- cbind(testsubjects, testactivities, test)
                
        #### Merge the datasets
        completedataset <- rbind(train, test)
        
        ####  Name the vars
        selectedmeasurements <- grep(".*mean.*|.*std.*", editedfeatures)
        namesofselectedmeasurements <- editedfeatures[selectedmeasurements]
        namesofselectedmeasurements = gsub('mean', 'Mean',namesofselectedmeasurements)
        namesofselectedmeasurements = gsub('std', 'Std',namesofselectedmeasurements)
        namesofselectedmeasurements <- gsub('[()]', '',namesofselectedmeasurements)
        namesofselectedmeasurements <- data.frame(namesofselectedmeasurements)
        namesofselectedmeasurements<- rbind(data.frame(namesofselectedmeasurements = "activity"), namesofselectedmeasurements)
        namesofselectedmeasurements<- rbind(data.frame(namesofselectedmeasurements = "subject"), namesofselectedmeasurements)
        colnames(completedataset) <- c(make.names(namesofselectedmeasurements$namesofselectedmeasurements))
        
        #### Convert activities & subjects into factors
        completedataset$activity <- factor(completedataset$activity, labels = editedactivityLabels)
        completedataset$subject <- as.factor(completedataset$subject)
        
        #### Melt and acuire average of each variable for each activity and each subject
        completedataset.melted <- melt(completedataset, id = c("subject", "activity"))
        completedataset.mean <- dcast(completedataset.melted, subject + activity ~ variable, mean)
        
        #### Store the dataset
        write.table(completedataset.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
}

```
