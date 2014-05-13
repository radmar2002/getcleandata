##################################################################
######                  run_analysis.R                      ######            
##################################################################

### Author: Marius Radu
### Mail: radu_marius_florin@yahoo.com
### Coursera: Getting and Cleaning Data - Peer Assesment Project


### R script called run_analysis.R does the following: 
###
### 1. Extracts only the measurements on the mean and standard deviation for each measurement. 
### 2. Merges the training and the test sets to create one data set.
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive activity names. 
### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



### Prepare the work place directory

rm(list=ls()) ## clean memory
## if the directory is not explicitlly specified 
## the script will run in curent directory
gitDir <- "D:/WORK_2014/Certification_Data_Science/repos/getcleandata"
#gitDir <- "d:/COURSERA_DATA_SCIENCE/Getting_and_Cleaning_Data/Course_Project/getcleandata/"
#gitDir <- ""
if(gitDir!=""){
        setwd(gitDir)                               ## set working directory in the git clone of the project
}
list.files()                                        ## check the content of the folder


## we need "data.table" library for the operations in Step 5 
## and we install if it is not yet installed

if("data.table" %in% rownames(installed.packages()) == FALSE){
        install.packages("xtable")
}


### Download and extract the data on the local machine

# set the zip file URL source
sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()                                  ## create a temp. file name
download.file(sourceUrl ,temp)                      ## use download.file() to fetch the zip file into the temp. file
unzipfolder <- unzip(temp)                          ## use unzip() function to extract the target from temp. file
unlink(temp)                                        ## remove the temp file via unlink()
list.files()                                        ## check the new content of the folder

dateDownloaded <- date(); dateDownloaded            ## [1] "Sun May 11 13:18:57 2014"  date of download will apear in README file  


### load the features file
featuresFile <- read.table(paste(gitDir, "UCI HAR Dataset/features.txt",sep="/"), 
                            sep="", quote ="", col.names=c("Code","Name"))
#head(featuresFile)


### 1. Extracts only the measurements on the mean and standard deviation for each measurement. 

## This is the mapping (code,name) for the measures of mean and standard deviation. 
## and not including the weighted averages (e.g. meanFreq) angle variables wich are
## including mean measures e.g angle(tBodyAccJerkMean),gravityMean)
## featuresFile[grep("mean\\(|Mean|std",featuresFile$Name),]  

## Identificaton of measures that are measures of mean and standard deviation will reduce the number of columns in the data.
labelsPattern <- "mean\\(|std"
aimedColumns <- featuresFile[grep(labelsPattern, featuresFile$Name),1]

## Using colClases argument of read.table() will read in memory only the aimed variables regarding mean and std
## reading only columns of interest is faster (checked with system.time) and economical for memory
columnsClasses <- rep("NULL", 561)   
columnsClasses[aimedColumns] <- "numeric"  ##  'columnsClasse' is the given value for the colClasses argument               


### 2. Merges the training and the test sets to create one data set.

subjectTest <- read.table(paste(gitDir, "UCI HAR Dataset/test/subject_test.txt", sep="/"), header=FALSE, sep="") 
yTest <- read.table(paste(gitDir, "UCI HAR Dataset/test/y_test.txt", sep="/"), header=FALSE, sep="") 
XTest <- read.table(paste(gitDir, "UCI HAR Dataset/test/X_test.txt", sep="/"), header=FALSE, sep="", colClasses=columnsClasses) 
testSet <- data.frame(subjectTest, yTest, XTest)
rm("subjectTest", "yTest", "XTest")      ## release memory space

subjectTrain <- read.table(paste(gitDir, "UCI HAR Dataset/train/subject_train.txt", sep="/"), header=FALSE, sep="") 
yTrain <- read.table(paste(gitDir, "UCI HAR Dataset/train/y_train.txt", sep="/"), header=FALSE, sep="") 
XTrain <- read.table(paste(gitDir, "UCI HAR Dataset/train/X_train.txt", sep="/"), header=FALSE, sep="", colClasses=columnsClasses) 
trainSet <- data.frame(subjectTrain, yTrain, XTrain)
rm("subjectTrain", "yTrain", "XTrain")   ## release memory space


dataStep2 <- rbind(trainSet, testSet) 
#head(dataStep2); dim(dataStep2)         ## inspect the data
rm("trainSet", "testSet")                ## release memory space

### 3. Uses descriptive activity names to name the activities in the data set
### Replace row entries with activity english names (as provided in the data)

dataStep3 <- dataStep2
activityLabels <- read.table(paste(gitDir, "UCI HAR Dataset/activity_labels.txt", sep="/"), header=FALSE, sep="") 
activityLabelsTxt <- as.character(activityLabels[,2])
dataStep3[,2] <- factor(dataStep3[,2], levels=1:6, labels=activityLabelsTxt)

### 4. Appropriately labels the data set with descriptive activity names. 
### Replace column labels with more easily understood ones: camelCase

dataStep4 <- dataStep3
aimedColumnsNames <- featuresFile[grep(labelsPattern,featuresFile$Name),2]
##str(aimedColumnsNames) 
## aimedColumnsNames is factor and we need the labels as character
aimedColumnsNames <- as.character(aimedColumnsNames)

## rename the columns with more friendly names using gsubPlus local created function

from <- c("^t", "^f", "[[:punct:]]+", "mean", "std")
to <- c("time", "frequency", "","Mean", "Std")

gsubPlus <- function(pattern, replacement, x) {
        for(i in 1:length(pattern))
        x <- gsub(pattern[i], replacement[i], x, perl=TRUE)
        return(x)
}

aimedColumnsNames <- gsubPlus(from, to, aimedColumnsNames)
names(dataStep4) <- c("subjectID", "activity", aimedColumnsNames)

## Step 5: Of those columns that reflect the mean and standard deviation of the data, 
## calculate the mean for each person for each activity of that column.

## Using data.table package and a key will make the aggregations faster than (any) other 
## alternative procedures e.g. aggregate, plyr:ddply, reshape2:melt and cast, classic "for" loop
## vignette("datatable-timings") 

library(data.table)

DT <- data.table(dataStep4, key=c("subjectID", "activity"))                          ## create a 2-column key
# str(DT); tables()                                                                  ## inspect data structures
dataStep5 <- DT[,lapply(.SD, mean), by=c("subjectID", "activity")]  ## apply mean through columns by group

##  Export from R the tidy data set into a tab delimited .txt file
write.table(as.data.frame(dataStep5), "tidy.txt", row.names=FALSE, col.names=TRUE, sep="\t")

