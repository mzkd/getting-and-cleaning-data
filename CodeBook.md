---
title: "CodeBook"
output: html_document
---

# Transformations and expected output

The R code in this repo does the following (specified from assignment):
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

See the features_info.txt file for background on the original data.

# Inputs
The transformation process depends on:
* The test and training observation data sets under test and train directories respectively.
* The test and training subject id data sets under test and train directories respectively.
* The test and training activty id  data sets under test and train directories respectively.
* The master feature (features.txt) and activity label (activity_label.txt) data sets.

# Outputs

The transformation process aggregates the source data per the above specification, and results in a data set with the following fields:
* subject_id - the id of the subject for relevant aggregate variables.
* activity - the descriptive label for the activity performed during the measurements. Looked up from activity_labels.txt.
* Multiple variables, representing the mean of the relevant source variable for observations for the given subject and activity grouping. 
** The variable name is transformed from the original description in features.txt using the R gsub function and Perl compatible regex 's/[-(),]/_/g' (as appropriate for R) to support usage in R column names.
** Units for these aggregate measures are unchanged from source units.

By default the file is written to "mean_by_subject_activity.txt" in the current working directory.