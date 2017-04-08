# Coursera project

# ****************************************************************************************************************
# 1. Load and unzip the dataset
library(reshape2)
library(dplyr)
library("downloader")
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="dataset.zip",mode="wb")
unzip("dataset.zip")

#*******************************************************************************************************************
# 2. Reading activity and features data
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
colnames(activityLabels) <- c("activity", "activity_description")
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#*******************************************************************************************************************
# 3. Extract only mean and standard deviation from features data
featuresreq <- grep(".*mean.*|.*std.*", features[,2])
featuresreq.names <- features[featuresreq,2]
featuresreq.names = gsub('-mean', 'Mean', featuresreq.names)
featuresreq.names = gsub('-std', 'Std', featuresreq.names)
featuresreq.names <- gsub('[()-]', '', featuresreq.names)

#*******************************************************************************************************************
# 4. Load the training datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train <- train[featuresreq]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
# Column binding the training data set
train <- cbind(trainSubjects, trainActivities, train)

#*******************************************************************************************************************
# 5. Load the test data sets
test <- read.table("UCI HAR Dataset/test/X_test.txt")
test <- test[featuresreq]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
# Column binding the test data set
test <- cbind(testSubjects, testActivities, test)

#*******************************************************************************************************************
# 6. Merge and add labels data 
consol_data <- rbind(train,test)
# Add labels
colnames(consol_data) <- c("subject", "activity", featuresreq.names)

#*******************************************************************************************************************
# 7.Fetching activity description from activity labels and ordering columns

consol_data_left <- left_join(consol_data,activityLabels)
consol_data_left <- select (consol_data_left, subject, starts_with("activity"), tBodyAccmeanX: fBodyBodyGyroJerkMagmeanFreq, -activity)
consol_data_left$activity_description <- as.factor(consol_data_left$activity_description)

#*******************************************************************************************************************
# 8. Create independent tidy data set

# Grouping data by subject and activity description
consol_data_group <- group_by(consol_data_left,subject,activity_description)
# Summarizing variables to find mean
consol_data_group <- summarise_each(consol_data_group, funs(mean))
# Exporting tidy data set
write.table(consol_data_group, "tidy.txt", row.names = FALSE, quote = FALSE)

#*****************************************************************************************************************************
