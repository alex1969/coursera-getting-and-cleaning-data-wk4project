# coursera-getting-and-cleaning-data-wk4project
Purpose: to demonstrate one's ability to collect, work with, and clean a data set. 
Goal: to prepare tidy data that can be used for later analysis. One will be graded by peers on a series of yes/no questions and will be required to submit: 

	1) a tidy data set,

	2) a link to a Github repository with script for performing the analysis, and 

	3) a code book that describes the variables, the data, and any transformations called CodeBook.md.

	4) a README.md explaining how all of the scripts work and how they are connected.

The R script, run_analysis.R, does the following:

	Download the dataset if it does not already exist in the working directory

	Load the activity and feature info

	Loads the activity and subject data for each dataset, and tidies up the names therein 

	Loads both the training and test datasets, filtering out all except those columns for mean or standard deviation

	Merges the two datasets

	Merges the activity and subject columns with the dataset

	Converts the activity and subject columns into factors

	Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.

	The result is stored in the file tidy.txt.

Implementation of run_analysis.R

	Create three variables to use in the function call
		workingdir = your path in quotes " " (either relative or literal) to the directory you wish to use
		nameoffile = the name you wish to give to the soon-to-be downloaded file, again, in quotes " "
		dataseturl = the url for the source of the document, again, in quotes " "
	
	Call the function	
		tidydata2 <- function(workingdir, nameoffile, dataseturl)
	
	Look in you working fir for a file called "tidy.txt"
