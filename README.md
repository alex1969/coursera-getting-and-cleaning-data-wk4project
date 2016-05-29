# Johns Hopkins Data Science Getting and Cleaning Data Coursera Week  Four Project

#Project Overview
	Purpose: To demonstrate one's ability to collect, work with, and clean a data set. 
	Goal: 	 To prepare tidy data that can be used for later analysis.  
	Dataset to be cleaned and tidied: Human Activity Recognition Using Smartphones (Anguita et al, 2013). 
	Note:	A full description of the data used in this project can be found at The UCI Machine Learning Repository
		  A full description is available at the site where the data was obtained:

		  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

		  Here are the data for the project:

		  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Students are required to submit: 

	1) a tidy data set,

	2) a link to a Github repository with script for performing the analysis, and 

	3) a code book that describes the variables, the data, and any transformations called CodeBook.md.

	4) a README.md explaining how all of the scripts work and how they are connected.

#The R script, run_analysis.R, does the following:

	Download the dataset if it does not already exist in the working directory

	Load the activity and feature info

	Loads the activity and subject data for each dataset, and tidies up the names therein 

	Loads both the training and test datasets, filtering out all except those columns for mean or standard deviation

	Merges the two datasets

	Merges the activity and subject columns with the dataset

	Converts the activity and subject columns into factors

	Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.

	The result is stored in the file tidy.txt.

#Implementation of run_analysis.R

	Create three variables to use in the function call
		workingdir = your path in quotes " " (either relative or literal) to the directory you wish to use
		nameoffile = the name you wish to give to the soon-to-be downloaded file, again, in quotes " "
		dataseturl = the url for the source of the document, again, in quotes " "
	
	Call the function	
		tidydata2 <- function(workingdir, nameoffile, dataseturl)
	
	Look in your working dir for a file called "tidy.txt"

#References
To use the dataset in publications author(s) must cite the following.

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
