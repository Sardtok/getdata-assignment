library(reshape2)

if (!file.exists("UCI HAR Dataset")) {
  if (!file.exists("UCI HAR Dataset.zip")) {
    print("Downloading dataset.")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  "UCI HAR Dataset.zip", method="curl")
  }
  
  print("Extracting dataset.")
  unzip("UCI HAR Dataset.zip")
}

# Helper function to replace a pattern and move it in front of common measurements
moveInFrontAndReplace <- function(pattern, replacement, x) {
  sub(paste("(Acc|Gyro|AccJerk|GyroJerk|gravity)", pattern, sep=""), paste(replacement, "\\1", sep=""), x)
}

# Clean up names
print("Cleaning names")
names <- read.table("UCI HAR Dataset/features.txt", colClasses="character")[,2]
names <- sub("^t", "TimeDomain", names) # Expand time abbreviation
names <- sub("^f", "FrequencyDomain", names) # Expand frequency abbreviation
names <- moveInFrontAndReplace("-bandsEnergy\\(\\)-([0-9]*),([0-9]*)",
                               "EnergyBands\\2Through\\3Of", names) # Place bandsEnergy appropriately
names <- sub("^angle\\(([[:alpha:]]*)\\)?,([[:alpha:]]*)", "AngleBetween\\1And\\2", names)
names <- gsub("[[:punct:]]", "", names) # Remove punctuation characters
names <- sub("^AngleBetweent", "AngleBetweenTimeDomain", names) # Fix angle prefix for time domain
names <- sub("BodyBody", "Body", names) # Remove repeated Body

names <- moveInFrontAndReplace("(M|m)ag", "MagnitudeOf", names) # Place Mag appropriately
names <- moveInFrontAndReplace("(m|M)ean", "MeanOf", names) # Place mean appropriately
names <- moveInFrontAndReplace("std", "StandardDeviationOf", names) # Place std appropriately
names <- moveInFrontAndReplace("mad", "MedianAbsoluteDeviationOf", names) # Place mad appropriately
names <- moveInFrontAndReplace("maxInds", "StrongestFrequencyIndexOf", names) # Place maxInds appropriately
names <- moveInFrontAndReplace("max", "Max", names) # Place max appropriately
names <- moveInFrontAndReplace("min", "Min", names) # Place min appropriately
names <- moveInFrontAndReplace("sma", "SignalMagnitudeArea", names) # Place sma appropriately
names <- moveInFrontAndReplace("energy", "EnergyOf", names) # Place energy appropriately
names <- moveInFrontAndReplace("iqr", "InterquartileRangeOf", names) # Place iqr appropriately
names <- moveInFrontAndReplace("arCoeff", "AutoRegressionCoefficientOf", names) # Place arCoeff appropriately
names <- moveInFrontAndReplace("corr", "CorrelationOf", names) # Place corr appropriately
names <- moveInFrontAndReplace("Freq", "FrequencyOf", names) # Place Freq appropriately
names <- moveInFrontAndReplace("skewness", "SkewnessOf", names) # Place skewness appropriately
names <- moveInFrontAndReplace("kurtosis", "KurtosisOf", names) # Place kurtosis appropriately

names <- sub("Acc", "Acceleration", names) # Expand acceleration abbreviation
names <- sub("gravity", "Gravity", names) # Fix lower-case g in gravity
names <- sub("([XYZ]+[0-9]?)$", "In\\1", names) # Add preposition to axis
names <- sub("([0-9])$",".WithBurgOrder\\1", names) # Add Burg order

names <- gsub("([[:alnum:]])([[:upper:]])", "\\1.\\2", names) # Add dots between words, done twice to cover
names <- gsub("([[:alnum:]])([[:upper:]])", "\\1.\\2", names) # three or more uppercase characters in a row
names <- gsub("([[:alpha:]])([[:digit:]])", "\\1.\\2", names) # Add dots between words and numbers

# Read activity labels
print("Getting activities")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", colClasses=c("numeric", "factor"))

# Read activities
activities <- sapply(rbind(read.table("UCI HAR Dataset/train/y_train.txt"),
                           read.table("UCI HAR Dataset/test/y_test.txt")),
                     function(x) activity_labels[x,2])
colnames(activities) <- "Activity"

# Read subject IDs
print("Getting subjects")
subjects <- rbind(read.table("UCI HAR Dataset/train/subject_train.txt", col.names="Subject"),
                  read.table("UCI HAR Dataset/test/subject_test.txt", col.names="Subject"))

# Read datasets
print("Reading and merging datasets")
UciHar <- rbind(read.table("UCI HAR Dataset/train/X_train.txt", colClasses="double",
                           col.names=names, comment.char="", quote=""),
                read.table("UCI HAR Dataset/test/X_test.txt", colClasses="double",
                           col.names=names, comment.char="", quote=""))
UciHar <- cbind(subjects, activities, UciHar)

# If wanted, the data set can be saved as is by uncommenting the following lines
#print("Storing cleaned up dataset")
#write.table(UciHar, "UCI HAR Dataset/full_tidy.txt", quote=FALSE, sep=",")

# Remove columns that aren't means or standard deviations
print("Removing non-mean and non-standard deviation columns")
UciHar <- UciHar[, append(c(TRUE, TRUE), grepl("^(Time|Frequency).*(Mean|Standard)", names))]

# Store first tidy data set, comment these out if you don't want it
print("Storing tidy data set without aggregation")
write.table(UciHar, "UCI HAR Dataset/tidy.txt", quote=FALSE, sep=",")

# Split and average values
print("Splitting and averaging values")
UciHar <- dcast(melt(UciHar,id.vars=c("Subject", "Activity"), measure.vars=3:dim(UciHar)[2]),
                Subject + Activity ~ variable, mean)
write.table(UciHar, "UCI HAR Dataset/tidy_avg.txt", quote=FALSE, sep=",")
