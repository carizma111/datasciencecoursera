# Coursera project


# ****************************************************************************************************************
# Load and unzip the dataset

library(reshape2)

library("downloader")

download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="dataset.zip",mode="wb")

unzip("dataset.zip")

#*******************************************************************************************************************

# reading activity data

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

activityLabels[,2] <- as.character(activityLabels[,2])

# reading features data

features <- read.table("UCI HAR Dataset/features.txt")

features[,2] <- as.character(features[,2])

str(features)


# Extract only mean and standard deviation from features data

featuresreq <- grep(".*mean.*|.*std.*", features[,2])

str(featuresreq)

head(featuresreq)

featuresreq.names <- features[featuresreq,2]

featuresreq.names = gsub('-mean', 'Mean', featuresreq.names)

featuresreq.names = gsub('-std', 'Std', featuresreq.names)

featuresreq.names <- gsub('[()-]', '', featuresreq.names)

class(featuresreq.names)

# Load the training datasets

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresreq]

trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")

trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Column binding the training data set

train <- cbind(trainSubjects, trainActivities, train)

# Load the test data sets

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresreq]

testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")

testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Column binding the test data set

test <- cbind(testSubjects, testActivities, test)

# Merge data 
consol_data <- rbind(train,test)

# Add labels
colnames(consol_data) <- c("subject", "activity", featuresreq.names)

head(consol_data)

# Create independent tidy data set

consol_data$activity <- factor(consol_data$activity, levels = activityLabels[,1], labels = activityLabels[,2])

consol_data$subject <- as.factor(consol_data$subject)

consol_data.melted <- melt(consol_data, id = c("subject", "activity"))

consol_data.mean <- dcast(consol_data.melted, subject + activity ~ variable, mean)

write.table(consol_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)