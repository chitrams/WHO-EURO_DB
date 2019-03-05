# WHO: EURO Database
This document was created to assist with the automation of creating the EURO database from Richard Kumapley of UNICEF's resulting analysis folder.

## Setting up for automation

1. Set the directory. Ensure you have the following folders with, preferably, the following naming convention in your directory. This makes it easier for troubleshooting as the data we are working with is not necessarily consistent. Each folder also represents the 
2. Edit the set-up scripts. These include:
  * Set the working directory
  * Set the 'Index' document.

### Folders representing steps

My programming language of choice is R and my code reflects that. The language used for each process is put in brackets below so run them with whatever program you see fit. Feel free to adapt each step as you see fit as well.

Each folder represents a step run in this process to automate the creation of the EURO database.

* `1_dta` (Python) where all the .dta files will be saved
* `2_csv` (Stata) where all the converted .dta files from step 1 will be saved
  * Richard sometimes does this process for you; he would save the files as a .csv file already which means you can skip step 1.
* `3_recoded` (Python)
* `4_datetransformed` (R)
* `5_shinyoutput` (R - Anthro Survey Analyser)
* `6_toappend` (R)

### Folders for data

* `indata_raw` for all the files as given from UNICEF. These will be within subfolders.
* `indata_index` for the 

## Steps after

These steps are unfortunately non-automatable as it requires quite a bit of thinking. Ask your supervisor if at any point you're unsure about what you're looking for; this is quite a tedious task.

* Appending your JME-given prevalence estimates obtained from scientific papers
* Ensuring that all the country names are the same standard as that in WHO
* Adding in a column for country ISO code
* Converting this database to XMart.