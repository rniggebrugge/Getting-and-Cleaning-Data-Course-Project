# Getting-and-Cleaning-Data-Course-Project

#### Files to be evaluated

* run_analysis.R : script processing raw data into a tidy dataset
* CodeBook.????  : description of the variables in the tidy dataset
* README.md      : this file, explaining the run_analysis.R script 
 
#### Prerequisites

For the **analysis.R** script to function properly, the following conditions
are assumed:

* **dplyr** package is installed;
* **tidyr** package is installed;
* the script is saved and called from directory containing the experimental data.

To be clear: the last point means the *run_analysis.R* file is in same directory as (for example)
the *features_info.txt* and *features.txt* files and */test* and */train* sub-folders.


#### Script explanation

Both the *train* and *test* data are spread over three files, these are:

* subject_train.txt / subject_test.txt : reference to subject associated with an observation;
* y_train.txt / y_test.txt : reference to the activity associated with an observation;
* X_train.txt / X_test.txt : reference to the measured features associated with an observation.

In each of these files a row describes one observation. 

In order to create meaningful column names for the measures, the **features.txt** file is read, this 
file contains the names of all the measures features.

First the above mentioned files are read and stored in the following objects:

* subject
* activity
* measurements
* features
 
Secondly the **features** object is stripped from its first column, after which it only contains the list of features. Additionally the contents of this object are stripped from **)**, **)**, **-** and **,** characters. This to avoid problems
with inappropriate column headers.

As a third step the data.frames *subject*, *activity* and *measurements* are given meaningful column names.

After that these three data.frames are cbind-ed, they are merged together from "left-to-right" to form one data.frame with a number of rows equal to that of the original frames and a number of columns being the sum of columns of the original frames.
The resulting data.frame is stored in object **train_frame**.

After doing this for the **train** dataset, the process is repeated for the **test** data.  
The resulting data.frame is stored in object **test_frame**.

Now the **test_frame** and **train_frame** are pasted together using rbind. This pastes one frame on top of the other, leading to a new frame with the same number of columns as the originals, and a number of rows the sum of originals.
The resulting data.frame is stored in object **data**. This thus combines all observations, from *test* and *train* gropup.

At this point the *activity* column contains numeric references. For readability these are replaced with the actual activity labels. These labels are stored in file **activity_labels.txt** and stored in object **act_labels**. As with the **features** object above we are only interested in the 2nd column containing the labels. These labels in second column are turned 
into lowercase, purely for aestethic reaons.

Now the list of labels (2nd column **act_labels** object) is used to turn the numeric column **activity** of the data.frame into a factor column.

We now have a tidy dataset **data** containing all observation to all subject, for all activities and for all measured features. As part of the Course Project we have to reduce this set to only contains **mean values** and **standard deviations** of the measurements. For this the **grep** function is used on the **features** object, looking for all entries containing either *Mean*, *mean* or *std*. The results of *grep* are stored in object called **columns**.
Because **features** is used to name the columns in the dataset, with the **columns** object we now know which columns contain the measurements of interest. A small correction (+2) needs to be made because two columns (*subject* and *activity*) precede the measurements columns.

The **data** data.frame is now reduced, only columns 1 and 2 and those matching **mean** and **std** measurements are kept.

From the **dplyr** library the **group_by** is used the make groups for each *subject-activity* combination. This enables us to calculate values (mean, max, min, etc.) for each such group. 

The results of the **group_by** operation is *piped* to the **dplyr::summarise_each** function. With this function we can make calculations for each column of the data.frame (except obviously those used for the grouping). The argument **mean** (function) is used as we need to calculate average values for each subject and each activity. 

The resulting data.frame is stored in **new_data_set_wide**.  
It contains mean measurements for 180 rows (30 subject * 6 activities = 180 groups), and 88 columns (86 measurements + activity + subject).

As a final processing step this **new_data_set_wide** is transformed to a narrow table, by gathering over all the measurement columns. Using the **gather** function of **tidyr** this is achieved, the *subject* and *activity* columns are excluded from gathering and the mesaured features (column names in **new_data_set_wide**) are listed in column **feature** with the column **measurement** containing the actual values. 

The resulting data.frame is stored in **new_data_set_narrow**.  
It contains 15480 rows (86 measurements * 180 groups) and 4 columns (subject + activity + feature + measurment).

The creation of **new_data_set_narrow** is not required, but I found it very useful to create plots with multiple lines. Example: *qplot(measurement, feature,  data=new_data_set_narrow, facets = .~activity)*

In the final step of the script we remove the objects no longer needed, using **rm(....)**.

After completion of the code the environment should now contain three new objects:

* data
* new_data_set_narrow
* new_data_set_wide.








