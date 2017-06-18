##The zip file (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) should be downloaded and extracted in the Current Working Directory.
##The R code will perform the following steps:
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement.
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names.
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Read training and testing tables:
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

##Read feature vector:
features <- read.table('./UCI HAR Dataset/features.txt')

##Read activity labels:
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')

##Assign column names:
colnames(subject_train) <- "subjectId"
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_test) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"

colnames(activityLabels) <- c('activityId','activityType')

##Combine the data into one dataset
total_train <- cbind(y_train, subject_train, x_train)
total_test <- cbind(y_test, subject_test, x_test)
total_data <- rbind(total_train, total_test)

##Read column names
colNames <- colnames(total_data)

##Create a vector which defines ID, mean and std
meanstd <- (grepl("activityId" , colNames) | 
                grepl("subjectId" , colNames) | 
                    grepl("mean.." , colNames) |  
                        grepl("std.." , colNames) 
)

##Create a subset from total
data_meanstd <- total_data[ , meanstd == TRUE]

##Use descriptive activity names
data_meanstd_names <- merge(data_meanstd, activityLabels,
                              by='activityId',
                                all.x=TRUE)

##From data_meanstd_names, create a second independent tidy data set with the average of each variable for each activity and each subject.
average_each <- aggregate(. ~subjectId + activityId, data_meanstd_names, mean)
average_each <- average_each[order(average_each$subjectId, average_each$activityId),]
write.table(average_each, "Tidy_data.txt", row.name=FALSE)
