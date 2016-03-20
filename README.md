# gettingAndCleaningData_2

In what follows, the code is to described in a step-by-step fashion:

----------------------------------
STEP(0) Downloading the data
----------------------------------
Downloading the data using "download.file" function. Then:
- unzip the file into folder "dataset"
- leave the unzipped folder in the working directory and 
- keep the structure of the folder unchanged.

----------------------------------
STEP(1) Reading-in and merging data
----------------------------------
Individual files are read-in (using read.table) and merged
using cbind and rbind respectively.

Features are stored in data.frame "X", response in array "y".
Data.frame "subject_ID" contains individual subjects.

----------------------------------
STEP(2) Extracting mean() and std() features
----------------------------------

After feature-names are loaded in from "features.txt", only
features that have "mean()" or "std()" in their names are kept in.

----------------------------------
STEP(3) Fetching activity labels
----------------------------------
Library sqldf is used to left-join activity labels to the response 'y'.

----------------------------------
STEP(4) Labeling of features and generating the final scoringDataSet
----------------------------------
The scoringDataSet is a composed from selected features and the response

----------------------------------
STEP(5) Summarizing
----------------------------------
ScoringDataSet is grouped by subject and response and for each group and
average is computed for each of the group.
