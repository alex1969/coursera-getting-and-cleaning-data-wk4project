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
        trainobs <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))
        
        testsubjects <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))
        testactivities <- tbl_df(read.table("UCI HAR Dataset/test/Y_test.txt"))
        testobs <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))

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
        
        #### Convert activities & subjects into factors
        completedataset$activity <- factor(completedataset$activity, labels = editedactivityLabels)
        completedataset$subject <- as.factor(completedataset$subject)
        
        #### Melt and acquire average of each variable for each activity and each subject
        completedataset.melted <- melt(completedataset, id = c("subject", "activity"))
        completedataset.mean <- dcast(completedataset.melted, subject + activity ~ variable, mean)
        
        #### Store the dataset
        write.table(completedataset.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
}
