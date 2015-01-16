Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

Variables
=========

The tidy data set **tdn** has 55 columns, corresponding with 52 measured features and 3 columns related to subject, activity and calculation type.

* Subject: 1 to 30, subjects participating in the research
* Activity: 6 different observed activities, Walking, Walking Upwards, Walking Downwards, Sitting, Standing and Laying
* Calculation_type: indicates whether the row has **mean** or **std** values
* angleWithGravitytBodyAccJerkMeanTotal : angle between Gravity and mean Body Accelaration Jerk
* angleWithGravitytBodyGyroJerkMeanTotal : angle between Gravity and Body Gyro Jerk Mean
* angleWithGravitytBodyGyroMeanTotal : angle between Gravity and Body Gyri Mean
* angleWithGravityXTotal : angle Gravity with X axis
* angleWithGravityYTotal : angle Gravity with Y axis
* angleWithGravityZTotal : angle Gravity with Z axis
* fftBodyAccJerkX : FFT of Body Accelaratiok Jerk, X component
* fftBodyAccJerkXFreq : FFT of Frequency of Body Accelaration Jerk, X compomenent
* fftBodyAccJerkY : FFT of Body Accelaratiok Jerk, Y component
* fftBodyAccJerkYFreq : FFT of Frequency of Body Accelaration Jerk, Y compomenent
* fftBodyAccJerkZ : FFT of Body Accelaratiok Jerk, Z component
* fftBodyAccJerkZFreq : FFT of Frequency of Body Accelaration Jerk, Z compomenent
* fftBodyAccTotal : FFT of Body Accelatation (total)
* fftBodyAccTotalFreq: FFT of Body Accelaration Frequency (total)
* fftBodyAccX: FFT of Body Accelaration, X component
* fftBodyAccXFreq : FFT of Body Accelaration Frequency, X component
* fftBodyAccY: FFT of Body Accelaration, Y component
* fftBodyAccYFreq : FFT of Body Accelaration Frequency, Y component
* fftBodyAccZ: FFT of Body Accelaration, Z component
* fftBodyAccZFreq: FFT of Body Accelaration Frequency,  Z component
* fftBodyBodyAccJerkTotal: FFT of Body Accelaration Jerk,  total
* fftBodyBodyAccJerkTotalFreq: FFT of Body Accelaration Jerk Frequency,  total
* fftBodyBodyGyroJerkTotal: FFT of Body Gyro Jerk,  total
* fftBodyBodyGyroJerkTotalFreq: FFT of Body Gyro Jerk Frequency, total
* fftBodyBodyGyroTotal: FFT of Body Gyro Jerk, total
* fftBodyBodyGyroTotalFreq: FFT of Body Gyro Freq, total
* fftBodyGyroX : FFT ot Body Gyro, X component
* fftBodyGyroXFreq : FFT ot Body Gyro Frequency, X component
* fftBodyGyroY : FFT ot Body Gyro, Y component
* fftBodyGyroYFreq : FFT ot Body Gyro Frequency, Y component
* fftBodyGyroZ : FFT ot Body Gyro, Z component
* fftBodyGyroZFreq : FFT ot Body Gyro Frequency, Z component
* timeBodyAccJerkTotal: time domain signal of Body Accelaration Jerk, total
* timeBodyAccJerkX : time domain signal of Body Accelaration Jerk X component
* timeBodyAccJerkY : time domain signal of Body Accelaration Jerk Y component
* timeBodyAccJerkZ : time domain signal of Body Accelaration Jerk Z component
* timeBodyAccTotal : time domain signal of Body Accelaration total
* timeBodyAccX : time domain signal of Body Accelaration X component
* timeBodyAccY : time domain signal of Body Accelaration Y component
* timeBodyAccZ : time domain signal of Body Accelaration Z component
* timeBodyGyroJerkTotal : time domain signal of Body Gyro Jerk Total
* timeBodyGyroJerkX : time domain signal of  Body Gyro Jerk X component
* timeBodyGyroJerkY : time domain signal of  Body Gyro Jerk Y component
* timeBodyGyroJerkZ : time domain signal of  Body Gyro Jerk Z component
* timeBodyGyroTotal : time domain signal of  Body Gyro Total
* timeBodyGyroX : time domain signal of Body Gyro X component
* timeBodyGyroY : time domain signal of Body Gyro Y component
* timeBodyGyroZ : time domain signal of Body Gyro Z component
* timeGravityAccTotal : time domain signal of Gravitational Accelation total
* timeGravityAccX : time domain signal of Gravitational Accelation X Component
* timeGravityAccY : time domain signal of Gravitational Accelation Y Component
* timeGravityAccZ : time domain signal of Gravitational Accelation Z component    

All data is derived from the provided research data. These data was normalized to have values [-1, 1] and as such do not have units.

Processing
==========

* For both the data in *train* and *test* folder the the Subject_<test/train>, X_<test/train> and y_<test/train> tables were read in R and cbinded to form one single dataset;
* The two resulting datasets (one for train, one for test) are rbinded to form one united dataset, with all subjects
* From all the available features, only those representing mean values and standard deviations of measurements are kept, all other variables are taken out of the dataset
* Hence apart from merging available data and removing unneeded data, no processing is done at this point. No calculations or data-summaries have been carried out. The clean, tidy data set produces is called **data**;
* Now the data are grouped over subjects and activities to generate mean values of all measured features over each activity-subject combination, these summarized data are stored in the **tdw** dataset;
* In order to further tidy the data, the two columns present for almost each feature (<feature>_mean and <feature>_std) are gathered into one, with a new column **calculation_type**. Example:
<pre>      
case   |  A_mean |  A_std            case | calculation_type |  A
---------------------------          ------------------------------
case 1 |      45 |      8               1 |            mean  | 45
case 2 |      10 |      2    ===>       1 |             std  |  8
                                            2 |            mean  | 10
                                            2 |             std  |  2

</pre>
* The such created dataset is stored as **tdn**





