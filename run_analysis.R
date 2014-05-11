##################################################################
######                  run_analysis.R                      ######            
##################################################################

### Author: Marius Radu
### Mail: radu_marius_florin@yahoo.com


### R script called run_analysis.R does the following: 
###
### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive activity names. 
### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



### Prepare the workspace

rm(list=ls())                      ## clean memory
git_dir <- getwd(); git_dir        ## check if we are in the git clone of the project
list.files()                       ## check the content of the folder
#install.packages("reshape")       ## we need this library for the operations in Step 5 ; reshape2 package is another option

### Download and extract the data on the local machine

## set the zip file URL source
sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()                                  ## create a temp. file name
download.file(sourceUrl ,temp)                      ## use download.file() to fetch the zip file into the temp. file
unzipfolder <- unzip(temp); unzipfolder             ## use unzip() function to extract the target from temp. file
unlink(temp)                                        ## remove the temp file via unlink()
list.files()                                        ## check the new content of the folder


### Inspect the content to learn more about the data within 

list.files(paste(git_dir, "UCI HAR Dataset", sep="/"))
list.files(paste(git_dir, "UCI HAR Dataset/test", sep="/"))
list.files(paste(git_dir, "UCI HAR Dataset/train", sep="/"))
list.files(paste(git_dir, "UCI HAR Dataset/test/Inertial Signals", sep="/"))
list.files(paste(git_dir, "UCI HAR Dataset/train/Inertial Signals", sep="/"))

## Print the names ad dimensions of the files
## from train and respectively test data files

main_dir <- paste(git_dir, "UCI HAR Dataset", sep="/")
list_train <- list.files(main_dir, pattern = "*train.txt$",full.names=TRUE, recursive=TRUE)
list_test <- list.files(main_dir, pattern = "*test.txt$",full.names=TRUE, recursive=TRUE)

for(fl in list_train){
        curfile <- read.table(fl, header=FALSE, sep="")   ##  sep = "" (the default for read.table) the separator is ‘white space’, that is one or !more spaces
        print(fl)
        print(dim(curfile))
}

for(fl in list_test){
        curfile <- read.table(fl, header=FALSE, sep="")   ##  sep = "" (the default for read.table) the separator is ‘white space’, that is one or !more spaces
        print(fl)
        print(dim(curfile))
}


### Create instrumental variables that will be used in data processing

all_txt_files <- list.files(git_dir, pattern="*txt$" , full.names=TRUE, recursive=TRUE)
all_txt_files[2]

features_file <- read.table(all_txt_files[2], sep="", col.names=c("Code","Name"))
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
col_classes[aimed_columns] <- "numeric"
col_classes    ##  This is the value for the colClasses argument               


### 1. Merges the training and the test sets to create one data set.

subject_test <- read.table(all_txt_files[14], header=FALSE, sep="") 
y_test <- read.table(all_txt_files[16], header=FALSE, sep="") 
X_test <- read.table(all_txt_files[15], header=FALSE, sep="", colClasses=col_classes) 
test_set <- data.frame(subject_test, y_test, X_test)

subject_train <- read.table(all_txt_files[26], header=FALSE, sep="") 
y_train <- read.table(all_txt_files[28], header=FALSE, sep="") 
X_train <- read.table(all_txt_files[27], header=FALSE, sep="", colClasses=col_classes) 
train_set <- data.frame(subject_train, y_train, X_train)

data_step2 <- rbind(train_set, test_set) 
head(data_step2)


### 3. Uses descriptive activity names to name the activities in the data set
### Replace row entries with activity english names (as provided in the data)

data_step3 <- data_step2
class(data_step3[,2]); str(data_step3[,2])
activity_labels <- read.table(all_txt_files[1], header=FALSE, sep="") 
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
aimed_columns_names <- sub("()-","_", aimed_columns_names, fixed=TRUE)
aimed_columns_names <- sub("()","", aimed_columns_names, fixed=TRUE)
aimed_columns_names <- gsub("\\(","_", aimed_columns_names)
aimed_columns_names <- gsub("\\)","", aimed_columns_names)
aimed_columns_names <- gsub("-","_", aimed_columns_names, fixed=TRUE)
aimed_columns_names <- sub(",","_and_", aimed_columns_names, fixed=TRUE)
aimed_columns_names

str(aimed_columns_names)

names(data_step4) <- c("subject_ID", "activity", aimed_columns_names)

head(data_step4)


## Step 5: Of those columns that reflect the mean and standard deviation of the data, 
## calculate the mean for each person for each activity of that column.
data_step5 <- data_step4
head(data_step5)
dim(data_step5)

# will use the melt and cast functions from "reshape" library
library(reshape)
melted_data_step5 <- melt(data_step5, id=c("subject_ID","activity")) 
head(melted_data_step5)
dim(melted_data_step5)

cast_data_step5 <- cast(melted_data_step5, subject_ID + activity ~ variable, mean)
head(cast_data_step5,10)
dim(cast_data_step5)

##  Export from R the tidy data set into a tab delimited .txt file
write.table(cast_data_step5, "tidy.txt", row.names=FALSE, col.names=TRUE, sep="\t")


# should check this...
# In the previous run of the course, students have generally ignored the "Inertial Signals" folder.
# It seemed to be an acceptable choice in the case it was documented appropriately.
# Documenting the steps you are following is an important aspect of this project.


