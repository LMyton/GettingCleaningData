
# read in all the data sets
subject_test <- read.table("test/subject_test.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

subject_train <- read.table("train/subject_train.txt")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")


#
# Combine test and training sets together
#
test_train <- rbind(x_test,x_train)

------------------------------------------------------------------------
#Extract any columns containing mean or std measurements

# extract any columns with mean() or std() in them from the features data set. we need these.
features_cols <- filter(features, grepl('mean\\()|std\\()', V2))

# save them to a list
list_of_features_cols <- features_cols$V1 # 66 of them

# use that list to create new data frame with only those columns in
test_train_mean_std <- test_train[,list_of_features_cols]

------------------------------------------------------------------------
#Uses descriptive activity names to name the activities in the data set

# combine the labels from test and train (to match the combined test/training set)        
all_labels <- rbind(y_test, y_train)       

#rename labels column from V1 to label
colnames(all_labels) <- "labels"
        
# combine the test_train data set with the labels
activity_data <- cbind(test_train_mean_std, all_labels)

# match the q3 labels col to the lookup tables V1 col to add the text in
activity_data$activity_text <- activity_labels[match(activity_data$labels, activity_labels$V1),2]

------------------------------------------------------------------------
#Appropriately labels the data set with descriptive variable names. 
        
## using the list of chosen mean/std cols from before 
# take the text this time (column V2)
# add on the labels and activity text needed for the extra columns added previously
        
features_text <- c(as.character(features_cols$V2), "labels", "activity_text")

# uses that to reassign column names
colnames(activity_data) <- features_text        

-------------------------------------------------------------------------
#create a second, independent tidy data set with 
#the average of each variable for each activity and each subject.
        
#combine test and train subjects        
all_subjects <- rbind(subject_test, subject_train)        
        
#rename V1 column in all_subjects
colnames(all_subjects) <- "subject"

# combine activity data and subject data
sub_activity_data <- cbind(all_subjects, activity_data)

#melt it (by subject and activity_text)
sub_activity_data_m <- melt (sub_activity_data, id= c("subject", "activity_text"))

#cast it getting the mean for all values, grouped by subject and activity_text
summary_data <- dcast(sub_activity_data_m, subject + activity_text ~  variable, fun.aggregate = mean)


-------------------------------------------------------------------------
# output the data to file tidydata.txt
write.table(summary_data, "tidydata.txt", row.name = FALSE)