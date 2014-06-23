Getting and Cleaning Data Course Project
======================
> This repository contains the components of the Getting and Cleanning Data course project.
> Created by: Gildardo Rojas.
> Date: June 22, 2014

**Contents:**

You'll find here: 

- README.md (this file).
- CodeBook.md (A Code Book document decribing the variables, data and transformations performed.
- tidySet.csv (The full Tidy Data Set file).
- groupingSet.csv (A sample file obtained by grouping and averaging data with an specific variable - Step 5).
- run_analysis.R (The R script that performs the analysis as requested in the project instructions).
  
**Notes for peer evaluations**

* Please see the CodeBook.md.
* Look at the assumptions section, it describes some of the assumptions made, based on TA's recommendations.
* Attached is the run_analysis.R, if you wish to test it just notice the working directory must be the one generated when the zip file is uncompressed: 'UCI HAR Dataset'.
* I've included the full tidy data set ('tidySet.csv') it is in a wide format and also attached the result of a sample outcome ('averageByGroupsSet.csv') produced while getting averages by grouping by Activities and Subjects.
* The step 5. Variable average uses the plyr library so you first need to install.packages("plyr") and load library("plyr").

Thanks for reading!