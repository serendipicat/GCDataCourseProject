###############################################################################
## Script: run_analysis.R
## This script downloads data files used to train and test human activity recognition
## using smartphones. It converts the data into a tidy dataset, extracts the 
## mean and standard deviation variables, and writes it to a file in the working
## directory called "tidy_dataset.txt.
## It also creates a new tidy dataset, saved as "averages_dataset.txt", with the 
## averages of each variable for each activity and each subject.

library(plyr)  # Needed for call to ldply
library(dplyr) # Needed for call to sample
library(reshape2) #Needed for 

###############################################################################
#### Step 0. Download and unzip the data files

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name <-"UCI HAR Dataset.zip"
data_dir <- "UCI HAR Dataset"

if (!file.exists(file_name)) {
    message("Downloading data file...")
    download.file(file_url, destfile = file_name, method = "curl")
}
if (!dir.exists(data_dir)) {
    message("Unzipping data file...")
    unzip(file_name)
}

###############################################################################
#### Step 1. Merge the training and the test sets to create one data set.
## Each of the two sets is spread across multiple files (subject, X, and Y).  
## After reading in all the files, the data is split by source file, to extract 
## the relevant columns, and the rows are then combined. The dataset is then melted 
## to convert from a wide to a tall format.

## Read all the data files 
message("Reading observation files from test and train directories...")
paths = dir(file.path(data_dir), pattern = "^(subject|X|y)_(train|test)\\.txt$",
            full.names = TRUE, recursive = TRUE)
names(paths) <- basename(paths)
data <- ldply(paths, read.table, header = FALSE, stringsAsFactors = FALSE)

## Reshape and tidy data
message("Reshaping data...")

## Split the files based on source file (.id)
split_data <- split(data, data$.id)

## Extract the column values for each set and then bind all the rows together
## Construct the dataset starting with the fixed variable columns and 
## create new column to indicate set
df = as_tibble(rbind(cbind(subject_id  = split_data$subject_test.txt$V1, 
                           set = "Test", 
                           activity_id = split_data$y_test.txt$V1, 
                           split_data$X_test.txt[,2:ncol(split_data$X_test.txt)]),
                     cbind(subject_id = split_data$subject_train.txt$V1, 
                           set = "Train",
                           activity_id = split_data$y_train.txt$V1, 
                           split_data$X_train.txt[,2:ncol(split_data$X_train.txt)])))

## Column headers are variables, instead of variable names.
# Melt the dataset (change from wide to long format)
molten_df <- melt(df, id.vars = c("subject_id", "set", "activity_id"))   

###############################################################################
#### Step 2. Extract only the measurements on the mean and standard deviation 
#### for each measurement.
## Variable names are obtained from the features.txt file. 
## Only variables that include "mean()" or "std()" in their namesare extracted. 

## Read features recorded in columns V1-V561
message("Reading features file...")
features <- read.table(file.path(data_dir, "features.txt"), header = FALSE, 
                       col.names = c("feature_id", "feature_label"), stringsAsFactors = FALSE)

# Determine which features are based on the mean or standard deviation of a measuremet
# by searching for labels that contain either "mean()" or "std()"
fns <- features[grep("(mean|std)\\(", features$feature_label),]

# Extract measurements associated with mean/std functions
message("Extracting measurements on the mean and standard deviation...")
molten_df <- filter(molten_df, sub("V", "", variable) %in% fns$feature_id)

#### Step 3: Use descriptive activity names to name the activities in the data set
# Read activity labels from file and replace corresponding activity id values
message("Reading activity file...")
activities <- read.table(file.path(data_dir, "activity_labels.txt"), 
                         col.names = c("activity_id", "activity_label"))
molten_df <- molten_df %>%
    mutate(activity_id = activities$activity_label[activity_id]) %>%
    rename("activity" = "activity_id")

###############################################################################
#### Step 4. Appropriately label the data set with descriptive variable names
## Read names from features files; remove parenthesis and replace hyphen with 
## underscore to comply with naming convention
tidy_df <- mutate(molten_df, 
                  variable = gsub("-", "_",    # Replace hyphens with underscores
                                  gsub("\\(\\)","",  # Remove parenthesis
                                        features$feature_label[ # Look up variable name
                                            as.integer(sub("V", "", variable))])))
               

#### Write tidy dataset to "tidy_observations.txt
message("Writing tidy dataset to \"tidy_dataset.txt\" in the working directory")
write.table(tidy_df, "tidy_dataset.txt", row.names = FALSE)

###############################################################################
#### Step. 5 create a second, independent tidy data set with the average of each
#### variable for each activity and each subject.

## Cast the tidy dataset using fixed variables subject_id and activity,
## and calculating the averages of each measurment (stored as variable/value pairs in 
## the dataset) for each subject and each activity.
averages_df <- dcast(tidy_df, subject_id + set + activity ~ variable, fun.aggregate = mean)

#### Write averages dataset to "averages_observations.txt
message("Writing averages dataset to \"averages_dataset.txt\" in the working directory")
write.table(averages_df, "averages_dataset.txt", row.names = FALSE)

message("Use the following code to read the resulting datasets:")
message("tds <- read.table(\"tidy_dataset.txt\", header = TRUE, stringsAsFactors = FALSE)")
message("avg_ds <- read.table(\"averages_dataset.txt\", header = TRUE, stringsAsFactors = FALSE)")
