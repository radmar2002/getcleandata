===============================================================
Peer Assessment Project for Coursera Course:  Getting and Cleaning Data
===============================================================
<p>Marius Florin RADU
<br>Cluj-Napoca, Cluj, ROMANIA
<br>mail: radu_marius_florin@yahoo.com</p>
===============================================================


The repo includes the following files:
---------------------------------------------------------------

- `README.md`
- `CodeBook.md`
- `run_analysis.R`
- `tidy.txt`


The script called run_analysis.R script does the following:
---------------------------------------------------------------
1. Prepare the working directory
2. Download and extract the data on the local machine
3. Extracts only the measurements on the mean and standard deviation for each measurement. 
4. Merges the training and the test sets to create one data set.
5. Uses descriptive activity names to name the activities in the data set
6. Appropriately labels the data set with descriptive activity names. 
7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


The run_analysis.R script can be used as follows:
```{r}
<path>/Rscript run_analysis.R

# or

<path>/R CMD run_analysis.R
```


About the data set called tidy.txt:
---------------------------------------------------------------
- it is a tab delimited text file 
- it contains the tidy data obtained by processing data from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), using the script **run_analysis.R**


Note on Licence:
---------------------------------------------------------------
The data dataset used for script development is part of the following publication work [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

For more information about **tidy.txt* dataset contact: `radu_marius_florin@yahoo.com`.


Last date of download of the raw data directory is Fri May 16 18:05:49 2014
