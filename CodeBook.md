===============================================================
Course Project for Coursera Course:  Getting and Cleaning Data
===============================================================
<p>Marius Florin RADU
<br>Cluj-Napoca, Cluj, ROMANIA
<br>mail: radu_marius_florin@yahoo.com</p>
===============================================================
Code Book:
===============================================================


Variables Description
---------------------------------------------------------------


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

**subjectID** - contains the ID for all 30  volunteers involved in experiment

**activity** - is a cathegorical variable which contains the type of activity performed diring the experiments (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 


Using its embedded accelerometer and gyroscope, experiments authors (Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita) captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. During the experiments Fast Fourier Transform (FFT) was applied to some of these signals. The signals were used to estimate variables of the feature vector for each pattern: 'variableNameX', 'variableNameY', 'variableNameZ' is used to denote 3-axial signals in the X, Y and Z directions.

The cleaning R script selects only the from the main (raw) set only the variables regarding means or standard deviations estimates.
N.B. For the tidy data set were not included/selected the weighted averages (e.g. meanFreq) or angle variables e.g angle(tBodyAccJerkMean),gravityMean) even if these might be considered means in generic sense.

The variables regarding **means** and **std** rename the variables from original set using 'camelCase'. Regarding naming stile I've opted for mixed capitalization (camelCase). This naming style is compliant with [Google'S R Style Guide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml) and also it appears to have wide adoption in other 'data science' languages (e.g. Python, Clojure, or even JavaScript)
N.B. the **t** and **f** prefixes from original variables were explicitly adopted in tidy data set names as **time** and respectively **frequency**

<br>**timeBodyAccMeanX**
<br>**timeBodyAccMeanY**
<br>**timeBodyAccMeanZ**
<br>**timeBodyAccStdX**
<br>**timeBodyAccStdY**
<br>**timeBodyAccStdZ**
<br>**timeGravityAccMeanX**
<br>**timeGravityAccMeanY**
<br>**timeGravityAccMeanZ**
<br>**timeGravityAccStdX**
<br>**timeGravityAccStdY**
<br>**timeGravityAccStdZ**
<br>**timeBodyAccJerkMeanX**
<br>**timeBodyAccJerkMeanY**
<br>**timeBodyAccJerkMeanZ**
<br>**timeBodyAccJerkStdX**
<br>**timeBodyAccJerkStdY**
<br>**timeBodyAccJerkStdZ**
<br>**timeBodyGyroMeanX**
<br>**timeBodyGyroMeanY**
<br>**timeBodyGyroMeanZ**
<br>**timeBodyGyroStdX**
<br>**timeBodyGyroStdY**
<br>**timeBodyGyroStdZ**
<br>**timeBodyGyroJerkMeanX**
<br>**timeBodyGyroJerkMeanY**
<br>**timeBodyGyroJerkMeanZ**
<br>**timeBodyGyroJerkStdX**
<br>**timeBodyGyroJerkStdY**
<br>**timeBodyGyroJerkStdZ**
<br>**timeBodyAccMagMean**
<br>**timeBodyAccMagStd**
<br>**timeGravityAccMagMean**
<br>**timeGravityAccMagStd**
<br>**timeBodyAccJerkMagMean**
<br>**timeBodyAccJerkMagStd**
<br>**timeBodyGyroMagMean**
<br>**timeBodyGyroMagStd**
<br>**timeBodyGyroJerkMagMean**
<br>**timeBodyGyroJerkMagStd**
<br>**frequencyBodyAccMeanX**
<br>**frequencyBodyAccMeanY**
<br>**frequencyBodyAccMeanZ**
<br>**frequencyBodyAccStdX**
<br>**frequencyBodyAccStdY**
<br>**frequencyBodyAccStdZ**
<br>**frequencyBodyAccJerkMeanX**
<br>**frequencyBodyAccJerkMeanY**
<br>**frequencyBodyAccJerkMeanZ**
<br>**frequencyBodyAccJerkStdX**
<br>**frequencyBodyAccJerkStdY**
<br>**frequencyBodyAccJerkStdZ**
<br>**frequencyBodyGyroMeanX**
<br>**frequencyBodyGyroMeanY**
<br>**frequencyBodyGyroMeanZ**
<br>**frequencyBodyGyroStdX**
<br>**frequencyBodyGyroStdY**
<br>**frequencyBodyGyroStdZ**
<br>**frequencyBodyAccMagMean**
<br>**frequencyBodyAccMagStd**
<br>**frequencyBodyBodyAccJerkMagMean**
<br>**frequencyBodyBodyAccJerkMagStd**
<br>**frequencyBodyBodyGyroMagMean**
<br>**frequencyBodyBodyGyroMagStd**
<br>**frequencyBodyBodyGyroJerkMagMean**
<br>**frequencyBodyBodyGyroJerkMagStd**

Data Sescription
---------------------------------------------------------------
- it is a tab delimited text file 
- it contains the tidy data obtained by processing data from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), using the script **run_analysis.R**



Transformations performed to clean up the data 
---------------------------------------------------------------

<br>**Prepare the working directory**
<br>**Download and extract the data on the local machine**
<br>**Extracts only the measurements on the mean and standard deviation for each measurement.**
<br>**Merges the training and the test sets to create one data set.**
<br>**Uses descriptive activity names to name the activities in the data set**
<br>**Appropriately labels the data set with descriptive activity names.**
<br>**Creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

