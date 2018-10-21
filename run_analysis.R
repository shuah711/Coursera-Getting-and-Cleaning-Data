# Getting and Cleaning Data Course Projectless 
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


library(plyr)


# Download and unzip the file:
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "dataset.zip", method="curl")

if(!file.exists("./UCI HAR Dataset")) {
  unzip("dataset.zip")
}

# Read Features/Activity/Subject/Labels/features Files:
x_Train    <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_Train    <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_Train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


x_Test     <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_Test      <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_Test  <- read.table("./UCI HAR Dataset/test/subject_test.txt")


activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features  <- read.table("./UCI HAR Dataset/features.txt")


# Merges the training and the test sets to create one data set
x <- rbind(x_Train, x_Test)
y <- rbind(y_Train, y_Test)
subject <- rbind(subject_Train, subject_Test)


# Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]


# Uses descriptive activity names to name the activities in the data set
names(x) <- features$V2
names(y) <- "activity"
names(subject)   <- "subject"
all <- cbind(x, y, subject)


# subset columns
subsetColumns <- c(as.character(mean_std), "subject", "activity" )
all <- subset(all, select=subsetColumns)


# Use descriptive activity names to name the activities in the data set
all$activity <- activity_labels[all$activity, 2]


# Appropriately label the data set with descriptive variable names
names(all) <-gsub("Acc", "Accelerometer", names(all))
names(all) <-gsub("Gyro", "Gyroscope", names(all))


# creates a second, independent tidy data set
finalData <- ddply(all, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(finalData, "./UCI HAR Dataset/tidy.txt", row.name=FALSE)
