##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Alexander Stevens
## 05-28-2016

# run_analysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Download and unzip the files to the user specified working directory
# 2. Reads in the data and performs tidying of variables and sets up a logical selection vector
# 3. Merge the training and the test sets to create one data set.
# 4. Extract only the measurements on the mean and standard deviation for each measurement. 
# 4. Use descriptive activity names to name the activities in the data set
# 5. Appropriately label the data set with descriptive activity names. 
# 6. Creates a second, independent tidy data set (tidy.txt) with the average of each variable for each activity and each subject. 

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
