# Per assignment description:
# You should create one R script called run_analysis.R that does the following.

# Merges the training and the test sets to create one data set.
## data from X_train.txt and X_test.txt respectively
## preserve subject id from subject_train.txt and subject_test.txt respectively
## preserve activity from y_train.txt and y_test.txt respectively with labels in activity_labels.txt
# Extracts only the measurements on the mean and standard deviation for each measurement.
## variables with "mean" or "std" in name, except the angle() vars
# Uses descriptive activity names to name the activities in the data set
## from activity_labels.txt
# Appropriately labels the data set with descriptive variable names.

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# code below assumes following relative to current working dir:
# train data in train dir
# test data in test dir
# activity labels in current working dir

library(data.table)
library(reshape2)
# activity labels
activities <- read.table(file ="activity_labels.txt")
# feature labels (columns)
features <- read.table(file = "features.txt")
# cleanup names to be usable as column names
features$clean <- gsub("[-(),]", "_", features$V2, perl = T)

# measurements on mean / std are relevant columns
rel_cols <- grepl("^[^angle].*(mean|std).*", features$clean, perl = T)


# test data
# sep is whitespace - use read.table, fread seems to not support repeated whitespace??
har_test_df <- as.data.table(read.table(file = "test/X_test.txt"))
setnames(har_test_df, features$clean)
# filter each set before merge
# limit to relevant columns (correct subsetting for data.table)
har_test_df <- har_test_df[, features[rel_cols, "clean"], with=F]

# append subject
subject_test_df <- fread(input="test/subject_test.txt")
har_test_df$subject_id <- subject_test_df$V1
# append activity, converted to factors
activity_test_df <- fread(input="test/y_test.txt")
har_test_df$activity <- factor(activity_test_df$V1, activities$V1, activities$V2)

# training data
# sep is whitespace - use read.table, fread seems to not support repeated whitespace??
har_train_df <- as.data.table(read.table(file = "train/X_train.txt"))
setnames(har_train_df, features$clean)
# filter each set before merge
# limit to relevant columns (correct subsetting for data.table)
har_train_df <- har_train_df[, features[rel_cols, "clean"], with=F]

# append subject
subject_train_df <- fread(input="train/subject_train.txt")
har_train_df$subject_id <- subject_train_df$V1
# append activity, converted to factors
activity_train_df <- fread(input="train/y_train.txt")
har_train_df$activity <- factor(activity_train_df$V1, activities$V1, activities$V2)

# merge the data
union_har_df <- rbindlist(list(har_test_df, har_train_df))

# compute average of each var for each activity / subject
# unpivot cols into EAV format
melted <- melt(union_har_df, id=c("subject_id", "activity"), measure.vars=features[rel_cols, "clean"])
# and reaggregate
final <- dcast(melted, subject_id + activity ~ variable, mean)
write.table(final, file="mean_by_subject_activity.txt", col.names=T, row.names=F, sep="\t", quote=F)