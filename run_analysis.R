## R script file for the Getting and Cleaning Data Course Project

library(dplyr)    # for grouping and summarizing data.frames
library(tidyr)    # for "gather" function

# Reading the tables to be merged.
# - subject      : list with numbers of subjects for each observation
# - activity     : list of activities performed for each observation
# - measurements : the actual measurements for each observation
# - features     : list with titles of all measurements, used to create
#                  meaningful column names

cat("\n\nReading train dataset.....please wait....\n")

subject      <- read.table("./train/subject_train.txt")
activity     <- read.table("./train/y_train.txt")
measurements <- read.table("./train/X_train.txt", sep="")
features     <- read.table("./features.txt")

# The "features" table needs a bit of processing. The first colum
# contains a numeric reference of the measurement, this can be
# ignored. The second column, with the names of the measurements,
# contains many unwanted characters, these will be removed before
# using the values as column names of the dataset.
# A lot of processing needs to be done to whip them all in the same form.
# Probably it can be achieved with more elegant, simple regular expressions
# but since it only works on 561 or so values, it is not critical and
# I do not have the time now to tidy up....

features <- features[,2]   
features <- gsub("angle\\(tBodyAccMean,gravity\\)","drop_this_column", features)
features <- gsub("angle\\((.*),(.*)gravityMean\\)", "angleWithGravity\\1Total_mean" , features)
features <- gsub("[)(,]","", features)
features <- gsub("^t","time", features)
features <- gsub("^f","fft", features)
features <- gsub("Mag","_mag", features)
features <- gsub("\\-","_", features)
features <- gsub("_mag_(mean|std)","Total_\\1", features)
features <- gsub("_(mean|std)_(.*)$","\\2_\\1", features)
features <- gsub("angle([XYZ])gravityMean","angle_gravity\\1_mean", features)
features <- gsub("_meanFreq_(X|Y|Z)$","\\1Freq_mean", features)
features <- gsub("_meanFreq$","\\1Freq_mean", features)

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

columns <- grep("std|[Mm]ean", features) 
columns <- columns +2       
columns <- c(1,2,columns)   

# With that we can reduce are "data" data.frame, only keeping 
# the columns as described above.

data <- data[,columns]

# We can further reduce the data.frame by grouping over subjects 
# and activities. For each subject-activity combination the mean value 
# for each measurements is calculated. This will result
# in 180 observations (6 activities * 30 subjects).
#
# The function "summarise_each" is used to summarize over all columns
# other than those grouped by.

tdw  <- group_by(data, subject, activity) %>% summarise_each(funs(mean))

# As a final step the dataset can be narrowed done by taking out the 
# _mean and_std parts from the columns names, and instead have this information
# stored in a new column called "calculation_type". This will lead to a small portion
# of NA values, because not for each feature the mean and std values are known.
#
# I have experimented also with further splitting the features, and created tables
# with columns with:
#   * _time_ and _fft_ values  (mathmatical processing type)
#   * X / Y / Z / total values      (component of measurement
#
# The physics behind the experiment justify such a further splitting, as they do not
# relate to new observed features, but calculations upon the measurement on the
# features. However, because this resulted in tables with a very large number of
# missing values NA (up to 50%), I decided against this.


tdn<- tdw %>%
	    		gather(temp_column, value, -subject, -activity) %>%
	    		separate(temp_column, into=c("feature","calculation_type")  , sep="_") %>%
	    		spread(feature, value)	

				
# End of processing!
				
cat("\n\nFINISHED PROCESSING.\n\n")

cat("Created dataframes: \n ")
cat("\t data: full dataset\n")
cat("\t tdw: dataset with variables averaged over subject and activity\n")
cat("\t tdn: dataset with variables averaged as above, and _mean and _std moved into column\n\n")



rm(activity); rm(act_labels); rm(columns);
rm(features); rm(measurements); rm(subject);
rm(test_frame); rm(train_frame);

# with(new_data_set_wide, xyplot(tBodyAccmeanX ~  activity | subject ))
# with(new_data_set_wide, xyplot(tBodyAccmeanX ~  subject | activity ))
# with(new_data_set_narrow, xyplot(measurement ~ subject| activity, groups=feature))
# qplot(measurement, feature,  data=new_data_set_narrow, facets = subject~activity)
# str(new_data_set_wide)
# summary(new_data_set_wide)
# str(new_data_set_narrow)
# summary(new_data_set_narrow)
