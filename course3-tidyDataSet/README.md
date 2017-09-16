
Installation

	1.  Install Samsung data.  This directory is considered the working directory.

	2.  Copy run_analysis.R to the working directory.


Execution

	1.  Open run_analysis.R using R or R Studio.
	
	2.  Step through R script by pressing <Ctrl><Enter> at each line until reaching the end of the script.


Steps
	
	1.  Read X_test and X_train files into dataframes named 'testX' and 'trainX'.
	
	2.  Create a vector of values that represent the columns of interest named 'keepers'.
	
	3.  Remove unneeded columns from 'testX' and 'trainX' by rebuilding the data sets of only columns whose names are found in keepers'.
	
	4.  Read feature_labels.txt file into dataframe named 'featureLbl'.  This file provides feature names.
	
	5.  Convert 'featureLbl' into a vector named 'featureLabels'.
	
	6.  Replace column names in 'testX' and 'trainX' with those provided in 'featureLabels' vector passed through a tolower translation.
	
	7.  Read y_test and y_train files into dataframes named 'testY' and 'trainY'.
	
	8.  Combine dataframe 'testY' into 'testX'.
	
	9.  Combine dataframe 'trainY' into 'trainX'.
	
	10. Read activity_labels.txt file into dataframe named 'activityLbl'.  This file provides activity descriptions.
	
	11. Convert 'activity description' column from 'activityLbl' to lower case.
	
	12. Merge activity name from 'activityLbl' into 'testX' and 'trainX' using 'V1' column match from each dataframe.
	
	13. Remove unneed first column, activity labels, from 'testX' and 'trainX'.
	
	14. Move last column, activity descriptions, in 'testX' and 'trainX' to first position.
	
	15. Rename first column, activity descriptions, in 'testX' and 'trainX' to 'activity'.
	
	16. Read subject_test and subject_train files into dataframes named 'testSubject' and 'trainSubject'.  These files provide subject identifier.
	
	17. Combine dataframe 'testSubject' into 'testX'.
	
	18. Combine dataframe 'trainSubject' into 'trainX'.
	
	19. Rename first column, subject identifier, in 'testX' and 'trainX' to'subject'.
	
	20. Bind dataframes 'testX' and 'trainX' together into dataframe 'final1'.
	
	21. Using dataframe 'final1', group 'activity' and 'subject' columns and summarize the mean of all columns producing dataframe 'final2'.
	
	22. Write 'final2' dataframe to text file 'assignment.txt'.
