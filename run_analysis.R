## R script file for the Getting and Cleaning Data Course Project

library(dplyr)    # for grouping and summarizing data.frames
library(tidyr)    # for "gather" function

# Set working directory, it should point to folder with the raw data
# files. Change this if the script is located in different folder.

#setwd("/home/remco/Desktop/data/Getting-and-Cleaning-Data-Course-Project/")
 
# Reading the tables to be merged.
# - subject      : list with numbers of subjects for each observation
# - activity     : list of activities performed for each observation
# - measurements : the actual measurements for each observation
# - features     : list with titles of all measurements, used to create
#                  meaningful column names

cat("\n\nReading train dataset....please wait....\n")

subject      <- read.table("./train/subject_train.txt")
activity     <- read.table("./train/y_train.txt")
measurements <- read.table("./train/X_train.txt", sep="")
features     <- read.table("./features.txt")

# The "features" table needs a bit of processing. The first colum
# contains a numeric reference of the measurement, this can be
# ignored. The second column, with the names of the measurements,
# contains many unwanted characters, these will be removed before
# using the values as column names of the dataset.

features <- features[,2]   
features <- gsub("[)(,\\-]","", features)

# Adding column names to the above data.frames. This will ensure the
# final table is understandable and ensures a smooth merge with the
# test-set data 

names(subject)      <- "subject"
names(activity)     <- "activity"
names(measurements) <- features    

# Now merge the three dataframes by binding the columns ("left-to-right")

train_frame <- cbind(subject, activity, measurements)

# Repeat the same steps for the tables in ./test/ directory

cat("Reading test dataset....please wait....\n")

subject             <- read.table("./test/subject_test.txt")
activity            <- read.table("./test/y_test.txt")
measurements        <- read.table("./test/X_test.txt", sep="")
names(subject)      <- "subject"
names(activity)     <- "activity"
names(measurements) <- features
test_frame          <- cbind(subject, activity, measurements)

# Now merge to train and test data.frames by binding the rows 
# ("top-to-bottom") the resulting data.frame with all observations over 
# all subjects is stored in "data"

data <- rbind(train_frame, test_frame)

# The activity column in the data.frame contains numeric values
# corresponding to the six observed activities. This needs to be
# replaced with more meaningful labels. These labels can be found
# in the "activity_labels.txt" file where they are stored in 2nd column.

act_labels     <- read.table("./activity_labels.txt")
act_labels$V2  <- tolower(act_labels$V2)
data$activity  <- factor(data$activity, labels=act_labels[,2])

# Using again the "features" list with all measurements, select those
# representing 'mean' and 'standard deviations' values. 
# The 'grep' function will return a list with column numbers we need
# to keep in our data.frame. In order to take the first two columns
# into account (subject and activity) the discovered column numbers
# are all increased with 2, and the numbers 1 and 2 are added to list
# of columns we need to keep.

columns <- grep("[[Mm]ean|std]", features) 
columns <- columns +2       
columns <- c(1,2,columns)   

# With that we can reduce are "data" data.frame, only keeping 
# the columns as described above.

cat("\n New tidy data.frame available: ***data***. Dimensions 10299 x 55\n")

data <- data[,columns]

# As a final step we will further reduce the data.frame by grouping
# over subjects and activities. For each subject-activity combination
# the mean value for each measurements is calculated. This will result
# in 180 observations (6 activities * 30 subjects).
#
# The function "summarise_each" is used to summarize over all columns
# other than those grouped by.

cat("\nNew tidy data.frame available: ***new_data_set_wide***. Dimensions = 180 x 55\n")

new_data_set_wide     <- group_by(data, subject, activity) %>% summarise_each(funs(mean))

# For plotting measurements of multiple features, it is sometimes convenient
# to transform the wide table into a narrow one. This can be achieved by gathering
# over the columns with measurements (so excluding subject and activity columns).

cat("New tidy data.fram available: ***new_data_set_narrow***. Dimensions = 9540 x 4\n\n")

new_data_set_narrow  <- gather(new_data_set_wide, feature, measurement, -subject, -activity)

# Now removing objects no longer needed, this to not clutter R with all sort of
# temporary data.

rm(activity)
rm(act_labels)
rm(columns)
rm(features)
rm(measurements)
rm(subject)
rm(test_frame)
rm(train_frame)

cat("FINISHED PROCESSING.\n\n\n")

# Some suggetions to inspect data visually:
# library(lattice)
# library(ggplot2)
# with(new_data_set_wide, xyplot(tBodyAccmeanX ~  activity | subject ))
# with(new_data_set_wide, xyplot(tBodyAccmeanX ~  subject | activity ))
# with(new_data_set_narrow, xyplot(measurement ~ subject| activity, groups=feature))
# qplot(measurement, feature,  data=new_data_set_narrow, facets = subject~activity)
# str(new_data_set_wide)
# summary(new_data_set_wide)
# str(new_data_set_narrow)
# summary(new_data_set_narrow)
