# ======================================================
#   *** Getting and Cleaning Data Course project ***
#
# Author: Radovan Parrak
# Date: 3/14/2016
# ======================================================
rm(list = ls())

# libraries
library("sqldf")
library("dplyr")
library("stringr")

# ------------------------------------------------------
# 0) Download the data
# ------------------------------------------------------
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")

# ------------------------------------------------------
# 1) Merge training set and test set
# ------------------------------------------------------
# train:
X_train       <- read.table("./dataset/UCI HAR Dataset/train/X_train.txt")
y_train       <- read.table("./dataset/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./dataset/UCI HAR Dataset/train/subject_train.txt")

# test
X_test        <- read.table("./dataset/UCI HAR Dataset/test/X_test.txt")
y_test        <- read.table("./dataset/UCI HAR Dataset/test/y_test.txt")
subject_test  <- read.table("./dataset/UCI HAR Dataset/test/subject_test.txt")

# overall
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

# ------------------------------------------------------
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# ------------------------------------------------------
variableNames <- read.table("./dataset/UCI HAR Dataset/features.txt")
variableNames <- as.character(variableNames[,2])

# Select only features related to mean and sd
variableNamesSel <- variableNames[grepl("mean()",variableNames) | grepl("std()",variableNames)]
X             <- X[ ,grepl("mean()",variableNames) | grepl("std()",variableNames)] 

# ------------------------------------------------------
# 3) Uses descriptive activity names to name the activities in the data set
# ------------------------------------------------------
# join activity labels with activity values
activityLabels <- read.table("./dataset/UCI HAR Dataset/activity_labels.txt")
yExt <- sqldf("SELECT a.V1 as value, b.V2 as Label 
              FROM y a
              LEFT JOIN activityLabels b
              ON a.V1 = b.v1")

# ------------------------------------------------------
# 4) Appropriately labels the data set with descriptive variable names.
# ------------------------------------------------------
# use as column names
colnames(X) <- variableNamesSel

# generate a final scoring data-set:
scoringDataSet <- cbind(response = yExt$Label, X, subjectID = subject$V1)

# ------------------------------------------------------
# 5) From the data set in step 4, creates a second, 
# independent tidy data set with the average of each 
# variable for each activity and each subject.
# ------------------------------------------------------
scoringDataSetAggregated <- scoringDataSet %>% group_by(response, subjectID) %>% summarise_each(funs(mean))

# ------------------------------------------------------
# Save the output
# ------------------------------------------------------
write.table(scoringDataSetAggregated, "tidyDataSet.txt", row.name = FALSE) 
