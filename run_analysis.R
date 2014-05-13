##################################################################
######                  run_analysis.R                      ######            
##################################################################

### Author: Marius Radu
### Mail: radu_marius_florin@yahoo.com
### Coursera: Getting and Cleaning Data - Peer Assesment Project


### R script called run_analysis.R does the following: 
###
### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive activity names. 
### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



### Prepare the workspace

rm(list=ls())                                       ## clean memory
git_dir <- "D:/WORK_2014/Certification_Data_Science/repos/getcleandata"
if(!file.exists(git_dir)){dir.create(git_dir)}      ## check if forlder already exists
setwd(git_dir)                                      ## set working directory in the git clone of the project
list.files()                                        ## check the content of the folder


## we need "data.table" library for the operations in Step 5 
## and we install if it is not yet installed

if("data.table" %in% rownames(installed.packages()) == FALSE){install.packages("xtable")}


### Download and extract the data on the local machine

## set the zip file URL source
sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()                                  ## create a temp. file name
download.file(sourceUrl ,temp)                      ## use download.file() to fetch the zip file into the temp. file
unzipfolder <- unzip(temp); unzipfolder             ## use unzip() function to extract the target from temp. file
unlink(temp)                                        ## remove the temp file via unlink()
list.files()                                        ## check the new content of the folder

dateDownloaded <- date(); dateDownloaded            ## [1] "Sun May 11 13:18:57 2014"  date of download will apear in README file  


### Inspect the content to learn more about the data within 

list.files(paste(git_dir, "UCI HAR Dataset", sep="/"))


### Create instrumental variables that will be used in data processing

all_txt_files <- list.files(git_dir, pattern="*txt$" , full.names=TRUE, recursive=TRUE)
all_txt_files[2]

features_file <- read.table(paste(git_dir, "UCI HAR Dataset/features.txt",sep="/"), 
                            sep="", quote ="", col.names=c("Code","Name"))
head(features_file)

features_file[grep("mean|std",features_file$Name),]
features_file[grep("mean\\(",features_file$Name),]   ## Weighted averages are not included
features_file[grep("std",features_file$Name),]
dim(features_file[grep("mean\\(|std",features_file$Name),])
dim(features_file[grep("Mean|mean|std",features_file$Name),])
features_file[grep("Mean|mean|std",features_file$Name),]


### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

## This is the mapping (code,name) for the measures of mean and standard deviation. 
## including the weighted averages (e.g. meanFreq)
features_file[grep("mean\\(|Mean|std",features_file$Name),]  

## Identificaton of measures that are measures of mean and standard deviation will reduce the number of columns in the data.
aimed_columns <- features_file[grep("mean\\(|Mean|std",features_file$Name),1]
length(aimed_columns); aimed_columns


## Using colClases argument of read.table() will read in memory only the aimed variables regarding mean and std
## reading only columns of interest is faster (checked with system.time) and economical for memory
col_classes <- rep("NULL", 561)   
col_classes[aimed_columns] <- "numeric"  ##  'col_classes' is the given value for the colClasses argument               


### 1. Merges the training and the test sets to create one data set.

subject_test <- read.table(paste(git_dir, "UCI HAR Dataset/test/subject_test.txt", sep="/"), header=FALSE, sep="") 
y_test <- read.table(paste(git_dir, "UCI HAR Dataset/test/y_test.txt", sep="/"), header=FALSE, sep="") 
X_test <- read.table(paste(git_dir, "UCI HAR Dataset/test/X_test.txt", sep="/"), header=FALSE, sep="", colClasses=col_classes) 
test_set <- data.frame(subject_test, y_test, X_test)
rm("subject_test", "y_test", "X_test")      ## release memory space

subject_train <- read.table(paste(git_dir, "UCI HAR Dataset/train/subject_train.txt", sep="/"), header=FALSE, sep="") 
y_train <- read.table(paste(git_dir, "UCI HAR Dataset/train/y_train.txt", sep="/"), header=FALSE, sep="") 
X_train <- read.table(paste(git_dir, "UCI HAR Dataset/train/X_train.txt", sep="/"), header=FALSE, sep="", colClasses=col_classes) 
train_set <- data.frame(subject_train, y_train, X_train)
rm("subject_train", "y_train", "X_train")   ## release memory space


data_step2 <- rbind(train_set, test_set) 
head(data_step2)
rm("train_set", "test_set")                 ## release memory space

### 3. Uses descriptive activity names to name the activities in the data set
### Replace row entries with activity english names (as provided in the data)

data_step3 <- data_step2
class(data_step3[,2]); str(data_step3[,2])
activity_labels <- read.table(paste(git_dir, "UCI HAR Dataset/activity_labels.txt", sep="/"), header=FALSE, sep="") 
activity_labels_txt <- as.character(activity_labels[,2])
data_step3[,2] <- factor(data_step3[,2], levels=1:6, labels=activity_labels_txt)
class(data_step3[,2]); str(data_step3[,2])
head(data_step3)


### 4. Appropriately labels the data set with descriptive activity names. 
### Replace column labels with more easily understood ones

data_step4 <- data_step3

aimed_columns_names <- features_file[grep("mean\\(|Mean|std",features_file$Name),2]
str(aimed_columns_names) 
## aimed_columns_names is factor and we need the labels as character
aimed_columns_names <- as.character(aimed_columns_names)

## rename the columns with more friendly names using gsub_plus local created function

from <- c("()-", "()", ",", "(", ")", "-")
to <- c("_", "", "_and_", "_", "", "_")

gsub_plus <- function(pattern, replacement, x, fixed=TRUE, ...) {    ## use 'fixed' for the readibility reasons
        for(i in 1:length(pattern))
        x <- gsub(pattern[i], replacement[i], x, fixed=TRUE, ...)
        return(x)
}

aimed_columns_names <- gsub_plus(from, to, aimed_columns_names)
names(data_step4) <- c("subject_ID", "activity", aimed_columns_names)

## Step 5: Of those columns that reflect the mean and standard deviation of the data, 
## calculate the mean for each person for each activity of that column.

## Using data.table package and key will make the aggregations faster than (any) other 
## alternative procedures e.g. aggregate, plyr:ddply, reshape2:melt and cast, classic "for" loop
## vignette("datatable-timings")

library(data.table)

DT <- data.table(data_step4, key=c("subject_ID", "activity"))                          ## create a 2-column key
# str(DT); tables()                                                                    ## inspect data structures
data_step5 <- DT[,lapply(.SD, mean(..., na.rm=TRUE)), by=c("subject_ID", "activity")]  ## apply mean through columns by group

##  Export from R the tidy data set into a tab delimited .txt file
write.table(as.data.frame(data_step5), "tidy.txt", row.names=FALSE, col.names=TRUE, sep="\t")

