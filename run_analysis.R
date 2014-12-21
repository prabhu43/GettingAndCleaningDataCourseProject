# Load the R package "plyr"
library(plyr)

# Read the training dataset
subjectTrain<-read.table("train/subject_train.txt",header=FALSE)
featuresTrain<-read.table("train/X_train.txt",header=FALSE)
activityTrain<-read.table("train/y_train.txt",header=FALSE)

# Read the test dataset
subjectTest<-read.table("test/subject_test.txt",header=FALSE)
featuresTest<-read.table("test/X_test.txt",header=FALSE)
activityTest<-read.table("test/y_test.txt",header=FALSE)

# Combine the traing and test dataset
subjectData<-rbind(subjectTrain,subjectTest)
featuresData<-rbind(featuresTrain,featuresTest)
activityData<-rbind(activityTrain,activityTest)

# Assign the above combined datasets the appropriate column names
names(subjectData)<-c("subject")
names(activityData)<- c("activity")
featuresNames <- read.table("features.txt",header=FALSE)
names(featuresData)<- featuresNames$V2

# Combine the activity and features and subject columnwise to a single dataset
subject_activity <- cbind(subjectData, activityData)
data <- cbind(featuresData, subject_activity)

# Filter the column names which has mean() or std() in its name
mean_stdNames<-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]

# Select only the columns having mean() or std() in thier names and subject and activity columns
data<-subset(data,select=c(as.character(mean_stdNames), "subject", "activity"))

# Read the descriptive activity labels
activityLabels <- read.table("activity_labels.txt",header = FALSE)

# Combine the dataset with activity labels
data = merge(data, activityLabels)

# Appropriately labels the dataset with descriptive variable names
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
aggData<-aggregate(. ~subject + activity, data, mean)
sortedData<-aggData[order(aggData$subject,aggData$activity),]

# Write the Tidy datset to a txt file
write.table(sortedData, file = "tidydata.txt",row.name=FALSE)

library(knitr)
knit2html("codebook.Rmd");