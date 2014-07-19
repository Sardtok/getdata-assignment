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
(DO NOT cd into the UCI HAR Dataset directory):

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
absolute path:

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
