# Course Project for "Getting and Cleaning Data"

This is my solution to the Getting and Cleaning Data course project.

## Files

- run_analysis.R - Script for getting and cleaning the Samsung
  dataset.
- tidy.txt - A CSV file containing the results of cleaning the data
  before aggregation.
- tidy_averaged.txt - A CSV file with values averaged for each subject
  and activity.
- README.md - This readme.

## Running the analysis

You can run the analysis using the RStudio, R REPL or R batching
directly from the command line. If you are running the script from the
REPL or RStudio, make sure you have the right working directory (if
you don't want the script to download the dataset, the working
directory must contain it already).

To run the script from the REPL do the following, where
path/containing/dataset is the path to the directory containing the
UCI HAR Dataset.zip file or containing the UCI HAR Dataset directory
(DO NOT cd into the UCI HAR Dataset directory) and path is the path to
the directory containing the run_analysis.R script:

    $ cd path/containing/dataset
    $ R
    > source("path/run_analysis.R")

Optionally you can set the working directory from inside the REPL,
this will also work well in RStudio, where the source command can be
run by opening the script, and then clicking the source button:

    > setwd("path/containing/dataset")
    > source("path/run_analysis.R")

To run the script from the command line, use one of the following
where path is the path to the script from the current directory or an
absolute path (note the path/containing/dataset like above):

    $ cd path/containing/dataset
    $ R CMD BATCH path/run_analysis.R
    $ R -f path/run_analysis.R

The first will not show you what is going on, but will output progress
information to the file run_analysis.Rout.

The second option will echo every command read from the script, as
well as outputting the print statements indicating progression.

After running the script, the UCI HAR Dataset directory should
contain two new files: tidy.txt and tidy_averaged.txt, which contain
the cleaned data.

### Dependencies

The script requires that the reshape2 library is available. I've
chosen not to install the library automatically in the
script.

### What the script does

First, the script checks if the working directory contains a directory
called "UCI HAR Dataset". If it does, it goes directly to work on the
dataset. If it doesn't, it checks if the ZIP archive "UCI HAR
Dataset.zip" is in the working directory. If not, it downloads the
archive. When it has ensured the archive is available, it will extract
the dataset.

The analysis runs in a slightly different order than the one
prescribed in the assignment.

First it loads the variable names and cleans them up according to the
naming scheme described in the [code book](CodeBook.md) (this is
almost entirely based on regular expressions, and could be difficult
to read if you are not at least somewhat familiar with regex). It
employs a helper function to move function names (like mean, std,
etc.) in front of the sensor names (Gyro, Acc, etc.). This is also
done entirely with regex, but as it was a common pattern in my naming
scheme, it simplified the work a bit (although it changes the order of
backreferences).

Then it loads activity labels, and the activities associated with the
measurements in both the training and testing sets (which whenever
data from these two sets are loaded, they are attached one below the
other using rbind), converting the activity numbers to activity
labels. Then it loads subject IDs for each measurement in the two
sets. Then it reads the measurements for both sets and attaches the
subject IDs and the labelled activities as the first two columns
(using cbind).

At this point, there are two lines of code commented out, that would
allow outputting all measurements as a tidy dataset. The full dataset
is quite large, and it is recommended to keep the lines commented
out. Should you be interested in working with the whole dataset, in a
cleaned up manner, feel free to put them back in.

Then it removes all measurement variables that are not means or
standard deviations as per the requirements. Note that, although the
word mean is in the angle variables, they aren't actually averaged
data (but angles between averaged vectors), and as such are not kept;
and although the mean frequencies do not have standard deviations,
they are kept. Then it stores the now cleaned up dataset in
"UCI&nbsp;HAR&nbsp;Dataset/tidy.txt" as CSV, with all the measurements
for the mean and standard deviation variables.

Lastly it reshapes the data, by averaging all values for each variable
where the subject and activity are the same (i.e. averaging grouped by
subject and activity). These means are then stored in
"UCI&nbsp;HAR&nbsp;Dataset/tidy_averaged.txt" as CSV.

Along the way it will print out messages to indicate which stage of
it is currently executing.

## Links

- [The study the raw data comes
  from](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- [The dataset link from the
  assignment](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
