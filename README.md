# GCDataCourseProject
Analysis files created for the *Getting and Cleaning Data* course project

## Overview
The [course project](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project) involves writing a script that converts a set of raw data files into a processed dataset.

The source of the raw data is the [*Human Activity Recognition Using Smartphones Data Set*](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), which contains measurements obtained while subjects performed six different activities. 

The resulting tidy dataset (averages_dataset.txt) contains the average of each measurment for each activity and each subject.

## Contents
| File                 | Description                                                       |
|----------------------|-------------------------------------------------------------------|
| Codebook.md          | Project codebook                                                  |
| run_analysis.R       | Script that generates averages_dataset.txt from the source data   |
| averages_dataset.txt | A tidy dataset with average measurements per subject and activity |
| 
## Environment
To run the script, you must have R Studio installed, along with the following R packages: 

## Setup
* Download the run_analysis.R script.
* Open R Studio.
* Set the working directory to the directory containing the run_analysis.R script.
* Run the script using the following command: 
```
source("run.analysis.R")
```

You can use the following code to read the resulting datasets:
```
avg_ds <- read.table("averages_dataset.txt", header = TRUE, stringsAsFactors = FALSE)
```

Use the following code to view the tidy dataset from which the averages were extracted:
```
tds <- read.table("tidy_dataset.txt", header = TRUE, stringsAsFactors = FALSE)
```
	 
