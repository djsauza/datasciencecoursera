##Samsung phone analysis project
## Coursera Data Science Week 4 Assignment

#load the required libraries
library(stringr)
library(dplyr)


#Note - this script should be placed in the "UCI HAR Dataset" folder,
#with the assumption that none of the files have been moved.


#The following steps load all of the data into tables
data_x_train <- read.table("train/X_train.txt")
data_x_test <- read.table("test/X_test.txt")
data_y_test <- read.table("test/y_test.txt")
data_y_train <- read.table("train/y_train.txt")
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
features <- read.table("features.txt", stringsAsFactors = FALSE)
activity_labels <- read.table("activity_labels.txt")

#Changing the column of the y data to correspond with "activity type" and x data to correspond
#with the appropriate variable name, as given by the list in features.txt. 
#Also giving the column name "subject" to the data corresponding to the test subject.
colnames(data_y_test) <- "activity_type"
colnames(data_y_train) <- "activity_type"
colnames(data_x_test) <- features$V2
colnames(data_x_train) <- features$V2
colnames(subject_test) <- "subject"
colnames(subject_train) <- "subject"

#The grepl function is used to only include variables for the mean and the standard deviation in both datasets
data_x_test <- data_x_test[,grepl("-mean\\b()|std()", colnames(data_x_test))]
data_x_train <- data_x_train[,grepl("-mean\\b()|std()", colnames(data_x_train))]

#cbind is used to combine the subject, activity type, and variables for the test and training data sets
test_data <- cbind(subject_test, data_y_test, data_x_test)
train_data <- cbind(subject_train, data_y_train, data_x_train)

#The training and test datasets are combined with rbind
full_data <- rbind(test_data, train_data)

#the numeric activity type (data_y) is converted to a factor with the description of that activity 
full_data$activity_type <- activity_labels$V2[full_data$activity_type]


##Now to create the tidy data set

#dplyr groups by subject and activity type, and then summarizes to get the mean values for each group across
#all of the variables. 
tidy_data <- full_data %>% group_by(subject, activity_type) %>% summarize_all(funs(mean))

#The column names of the variables are changed to "avg_variable" to reflect that this is an average of the data collected
colnames(tidy_data)[-(1:2)] <- paste("avg_", colnames(tidy_data[-(1:2)]), sep = "")




#export the tidy dataset to a .csv file
write.table(tidy_data, "coursera_course3_week4_tidydata.txt", row.name = FALSE)


