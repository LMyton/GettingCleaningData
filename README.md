
## 1. Data

Source of data : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Data file to be downloaded and extracted.

Working directory to be set to the head directory for the zip file (UCI HAR Dataset)

###Data files : 

**UCI HAR Dataset**

+ activity_labels.txt  
+ features.txt

**UCI HAR Dataset/test**

+ subject_test.txt  
+ X_test.txt  
+ y_test.txt

**UCI HAR Dataset/train**

+ subject_train.txt  
+ X_train.txt  
+ y_train.txt  

##2. run_analysis.R


The script run_analysis.R requires working directory to be set to the head directory for the zip file (UCI HAR Dataset).

The file is divided into sections : 

###Reading in the data sets
creates the following data frames

```{r tidy=FALSE, eval=FALSE}
activity_labels  
features  
subject_test  
x_test  
y_test  
subject_train  
x_train  
y_train  
```



###Combining the test and training data sets together
This creates one data frame `test_train ` with both the x_test data and x_train data


###Extract any columns containing mean or std measurements

String matching mean() and std() in the ` features` dataframe gives dataframe `features_cols`

a list of columns required (`list_of_features_cols`) is then determined.

data frame `test_train_mean_std` is created by subsetting `test_train` with the extracted list of columns above


###Use descriptive activity names to name the activities in the data set

combines the labels for test and train data sets into data frame `all_labels`

Renames column `v1` to `labels` to avoid confusion with duplicate names

Combines label and measurement data frames (`all_labels` and `test_train_mean_std`) into `activity_data` to assign an activity label to each row

Adds column `activity_text` to data frame `activity_data` by matching the labels in `activity_data` and `activity_labels` dataframe to get a descriptive label for each row



###Appropriately labels the data set with descriptive variable names. 
      
Uses the previously determined `features_cols` dataframe. Extracted names (column `V2`)  for each activity are stored in list `features_text`


This is to be used to reassign column names in the `activity_data` dataframe. However, this dataframe currently 
also includes the `labels` column and the lookup `activity_text` column. Therefore these labels need to be added to `features_text` list

The complete `features_text` list is then used to reassign all column names in the `activity_data` data frame




###Summarises the data to give an average for each variable for each activity

Combines the subjects for test and train data sets into data frame `all_subjects`

Renames column `v1` to `subject` to avoid confusion with duplicate names

Combines subject and measurement data frames (`all_subjects` and `activity_data`) into `sub_activity_data` to assign an subject label to each row

Transforms the data (`melt`), to be grouped by subject and activity_test, stored in dataframe `sub_activity_data_m`

summarises the data (`cast`) into `summary_data` dataframe, calculating the mean for each measurement, for each subject and activity 


###Outputs the dataset to file "tidydata.txt"

creates a file called tidydata.txt in working directory containing the `summary_data` data



