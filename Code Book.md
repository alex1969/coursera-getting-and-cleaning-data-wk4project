---
title: "Code Book"
author: "Alexander Stevens"
date: "May 29, 2016"
output: html_document
---

This code book summarizes the resulting data fields in tidy.txt.

        For each record it is provided:
        ======================================
        - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
        - Triaxial Angular velocity from the gyroscope. 
        - A 561-feature vector with time and frequency domain variables. 
        - Its activity label. 
        - An identifier of the subject who carried out the experiment

        Notes: 
        ======
        - Features are normalized and bounded within [-1,1]. Thus dimsionsal units (e.g. m/s^2, g) are not required 
        - Each feature vector is a row on the text file (Anguita et al, 2013).

#Identifiers

subject - The ID of the test subject

activity - The type of activity performed when the corresponding measurements were taken

#Factors 

subject

activity 

#Levels + labels

        Activity
        Levels  Label                   Description
        
        1       WALKING:                subject was walking during the test
        2       WALKING_UPSTAIRS:       subject was walking up a staircase during the test
        3       WALKING_DOWNSTAIRS:     subject was walking down a staircase during the test
        4       SITTING:                subject was sitting during the test
        5       STANDING:               subject was standing during the test
        6       LAYING:                 subject was laying down during the test

        Subject 
        Note: 30 subjects = 1 to 30 levels)
        Levels  Label                   Description
        1       None                    None
        *       *                       *
        *       *                       *
        *       *                       *
        30      *                       *

#Selected Features/Measurements

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

#Transormation on data are as follows
```
##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Alexander Stevens
## 05-28-2016

# run_analysis.r File Description:
##########################################################################################################

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Download and unzip the files to the user specified working directory
# 2. Reads in the data and performs tidying of variables and sets up a logical selection vector
# 3. Merge the training and the test sets to create one data set.
# 4. Extract only the measurements on the mean and standard deviation for each measurement. 
# 5. Use descriptive activity names to name the activities in the data set
# 6. Appropriately label the data set with descriptive activity names. 
# 7. Creates a second, independent tidy data set (tidy.txt) with the average of each variable for each activity and each subject. 

##########################################################################################################
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

        #### Read in All datasets
        trainsubjects <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt"))
        trainactivities <- tbl_df(read.table("UCI HAR Dataset/train/Y_train.txt"))
        trainobs <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))#[selectedmeasurements]
        
        testsubjects <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))
        testactivities <- tbl_df(read.table("UCI HAR Dataset/test/Y_test.txt"))
        testobs <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))#[selectedmeasurements]

        rawactivityLabels <- tbl_df(read.table("UCI HAR Dataset/activity_labels.txt"))
        rawfeatures <- tbl_df(read.table("UCI HAR Dataset/features.txt"))
        
        #### Tidy the activity labels and features; output are clean labels and features
        editedactivityLabels = gsub("_", "", rawactivityLabels$V2)
        editedfeatures = tolower(gsub("-", "", rawfeatures$V2))
        editedfeatures = gsub('[()]', '',editedfeatures)
        
        #### Select the measurements for mean and std dev
        selectedmeasurements <- grep(".*mean.*|.*std.*", editedfeatures)
        
        #### Merge the datasets
        completedataset <- rbind(cbind(trainsubjects, trainactivities, trainobs[selectedmeasurements]), cbind(testsubjects, testactivities, testobs[selectedmeasurements]))

        #### Tidy the measurements names; output is compliant and tidy feature names 
        namesofselectedmeasurements <- editedfeatures[selectedmeasurements]
        namesofselectedmeasurements <- data.frame(namesofselectedmeasurements)
        namesofselectedmeasurements <- rbind(data.frame(namesofselectedmeasurements = "activity"), namesofselectedmeasurements)
        namesofselectedmeasurements <- rbind(data.frame(namesofselectedmeasurements = "subject"), namesofselectedmeasurements)
        names(completedataset) <- c(make.names(namesofselectedmeasurements$namesofselectedmeasurements))
        
        #### Convert activities & subjects into factors ## (bgentry, 2015, line#44, 45)
        completedataset$activity <- factor(completedataset$activity, labels = editedactivityLabels)
        completedataset$subject <- as.factor(completedataset$subject)
        
        #### Melt and acquire average of each variable for each activity and each subject ## (bgentry, 2015, line#47, 48)
        completedataset.melted <- melt(completedataset, id = c("subject", "activity"))
        completedataset.mean <- dcast(completedataset.melted, subject + activity ~ variable, mean)
        
        #### Store the dataset
        write.table(completedataset.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
}

```
#References
To use the dataset in publications author(s) must cite the following.

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited



Author: bgentry
Date: 03-22-2015
Title: run_analysis.R
Code version: unknown
Availability: https://github.com/bgentry/coursera-getting-and-cleaning-data-project/blob/master/run_analysis.R


#Notes
Use of bgentry's code as cited in this code was due to this author's appreciation for the elegance of how bgentry 
created factors and the use of melt (which I have not used in this manor before. i chose to incorporate those items in my 
code to study and learn how they work. )

