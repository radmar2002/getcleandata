===============================================================
Peer Assessment Project for Coursera Course:  Getting and Cleaning Data
===============================================================
<p>Marius Florin RADU
<br>Cluj-Napoca, Cluj, ROMANIA
<br>mail: radu_marius_florin@yahoo.com</p>
===============================================================
Code Book:
===============================================================

<br>
Variables Description
---------------------------------------------------------------


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

**subjectID** - contains the ID for all 30  volunteers involved in experiment

**activity** - is a cathegorical variable which contains the type of activity performed diring the experiments:

<br>`WALKING`
<br>`WALKING_UPSTAIRS`
<br>`WALKING_DOWNSTAIRS`
<br>`SITTING`
<br>`STANDING`
<br>`LAYING`


Using its embedded accelerometer and gyroscope, experiments authors (Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita) captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. During the experiments Fast Fourier Transform (FFT) was applied to some of these signals. The signals were used to estimate variables of the feature vector for each pattern: `variableNameX`, `variableNameY`, `variableNameZ` is used to denote 3-axial signals in the `X`, `Y` and `Z` directions.

The cleaning R script selects only the from the main (raw) set only the variables regarding means or standard deviations estimates.
N.B. For the tidy data set were not included/selected the weighted averages (e.g. `meanFreq` ) or angle variables ( e.g `angle(tBodyAccJerkMean,gravityMean)` ) even if these might be considered means in a generic sense.

The variables regarding **means** and **std** rename the variables from original set using 'camelCase'. Regarding naming stile I've opted for mixed capitalization (camelCase). This naming style is compliant with [Google'S R Style Guide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml) and also it appears to have wide adoption in other 'data science' languages (e.g. Python, Clojure, or even JavaScript)
**N.B.** the prefixes **t** and **f** from original variables were explicitly adopted in tidy data set names as **time** and respectively **frequency**

<br>`timeBodyAccMeanX`
<br>`timeBodyAccMeanY`
<br>`timeBodyAccMeanZ`
<br>`timeBodyAccStdX`
<br>`timeBodyAccStdY`
<br>`timeBodyAccStdZ`
<br>`timeGravityAccMeanX`
<br>`timeGravityAccMeanY`
<br>`timeGravityAccMeanZ`
<br>`timeGravityAccStdX`
<br>`timeGravityAccStdY`
<br>`timeGravityAccStdZ`
<br>`timeBodyAccJerkMeanX`
<br>`timeBodyAccJerkMeanY`
<br>`timeBodyAccJerkMeanZ`
<br>`timeBodyAccJerkStdX`
<br>`timeBodyAccJerkStdY`
<br>`timeBodyAccJerkStdZ`
<br>`timeBodyGyroMeanX`
<br>`timeBodyGyroMeanY`
<br>`timeBodyGyroMeanZ`
<br>`timeBodyGyroStdX`
<br>`timeBodyGyroStdY`
<br>`timeBodyGyroStdZ`
<br>`timeBodyGyroJerkMeanX`
<br>`timeBodyGyroJerkMeanY`
<br>`timeBodyGyroJerkMeanZ`
<br>`timeBodyGyroJerkStdX`
<br>`timeBodyGyroJerkStdY`
<br>`timeBodyGyroJerkStdZ`
<br>`timeBodyAccMagMean`
<br>`timeBodyAccMagStd`
<br>`timeGravityAccMagMean`
<br>`timeGravityAccMagStd`
<br>`timeBodyAccJerkMagMean`
<br>`timeBodyAccJerkMagStd`
<br>`timeBodyGyroMagMean`
<br>`timeBodyGyroMagStd`
<br>`timeBodyGyroJerkMagMean`
<br>`timeBodyGyroJerkMagStd`
<br>`frequencyBodyAccMeanX`
<br>`frequencyBodyAccMeanY`
<br>`frequencyBodyAccMeanZ`
<br>`frequencyBodyAccStdX`
<br>`frequencyBodyAccStdY`
<br>`frequencyBodyAccStdZ`
<br>`frequencyBodyAccJerkMeanX`
<br>`frequencyBodyAccJerkMeanY`
<br>`frequencyBodyAccJerkMeanZ`
<br>`frequencyBodyAccJerkStdX`
<br>`frequencyBodyAccJerkStdY`
<br>`frequencyBodyAccJerkStdZ`
<br>`frequencyBodyGyroMeanX`
<br>`frequencyBodyGyroMeanY`
<br>`frequencyBodyGyroMeanZ`
<br>`frequencyBodyGyroStdX`
<br>`frequencyBodyGyroStdY`
<br>`frequencyBodyGyroStdZ`
<br>`frequencyBodyAccMagMean`
<br>`frequencyBodyAccMagStd`
<br>`frequencyBodyBodyAccJerkMagMean`
<br>`frequencyBodyBodyAccJerkMagStd`
<br>`frequencyBodyBodyGyroMagMean`
<br>`frequencyBodyBodyGyroMagStd`
<br>`frequencyBodyBodyGyroJerkMagMean`
<br>`frequencyBodyBodyGyroJerkMagStd`

<br>
Data Description
---------------------------------------------------------------
- it is a tab delimited text file 
- it contains the tidy data obtained by processing data from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), using the script **run_analysis.R**

<br>
Transformations performed to clean up the data 
---------------------------------------------------------------

<br>**Prepare the working directory**

- set working directory in the git clone of the project.
- check the content of the folder.
- load "data.table" library for the operations in to be done in Step 5 (install if it is not yet installed).


<br>**Download and extract the data on the local machine**

- set the zip file URL source.
- create a temp. file name.
- use download.file() to fetch the zip file into the temp. file.
- use unzip() function to extract the target from temp. file
- remove the temp file via `unlink`.
- check the new content of the folder.
- write the last date of download into the README file.

<br>**Extracts only the measurements on the mean and standard deviation for each measurement.**

- Identify the measures for the means and standard deviations to reduce the number of columns in the data.
To optimize the file reading and memory load the variables of interest are determined prior to data files reading.

<br>**Merges the training and the test sets to create one data set.**

- it wil be used the `rbind` function to merge the data sets.

<br>**Uses descriptive activity names to name the activities in the data set**

- replace row entries with activity english names (as provided in the data).

<br>**Appropriately labels the data set with descriptive activity names.**

- replace column labels with more easily understood ones: `camelCase`

<br>**Creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

- calculate the mean for each person for each activity of that column.
Using `data.table` package and a key will make the aggregations faster than (any) other alternative procedures e.g. `aggregate`, `plyr:ddply`, `reshape2:melt` and `cast`, classic `for-loop` (see more `vignette("datatable-timings")` ) 
