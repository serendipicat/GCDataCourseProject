# GCDataCourseProject
Files created for the *Getting and Cleaning Data* course project.

## Overview
The [course project](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project) involves writing a script that converts a set of raw data files into a processed dataset.

The source of the raw data is the [*Human Activity Recognition Using Smartphones Data Set*](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), which contains measurements obtained while subjects performed six different activities. 

The resulting tidy dataset (averages_dataset.txt) contains the average of each measurement derived from the mean and standard deviation, for each activity and each subject. 
* The tidy dataset was laid out following the principles described by Hadley Wickham in his paper [*Tidy Data*](http://vita.had.co.nz/papers/tidy-data.pdf), along with added insight provided by David Hood in his [*Getting and Cleaning Assignment*](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/) blog post.
* I used a long/tall form (as opposed to a wide form) during the intermediate stages of reshaping the data, as the long form is often considered preferable for processing (see [*Wide & Long Data*](https://sejdemyr.github.io/r-tutorials/basics/wide-and-long/)).

## Contents
| File                 | Description                                                        |
|----------------------|--------------------------------------------------------------------|
| Codebook.docx        | A Word document that describes the study design and data           |
| run_analysis.R       | A script that generates averages_dataset.txt from the source data  |
| averages_dataset.txt | A tidy dataset with average measurements per subject and activity  |
| 
## Environment
To run the script, you must have R Studio installed. The script uses the plyr, dplyr, and reshape2 packages. 

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
	 
