# Setting-up -----------------------------------------------
# This document was created to assist with the automation of creating the EURO database from Richard Kumapley of UNICEF's resulting analysis folder.
#
# The best way to go about this document is to run the code chunk by chunk to make sure you know what you're doing. Then check the files generated in each folder as the data we are working with is not necessarilyy consistent.
#
## Set-up of R and Python ####
source("./_scripts/R_setup.r")

# Ensure your document directory == your project directory == your current working directory.
#
# Ensure you have the following folders with, preferably, the following naming convention in your directory. These folders will follow the structure of our workflow.
# 
# * `1_dta` 
# * `2_csv`
# * `3_recoded`
# * `4_datetransformed`
# * `5_forshiny`
# * `6_shinyoutput`
# * `7_toappend`
# 
# Then ensure you have the following folders for the following uses:
#   
#   * `indata_index` for
# * `indata_JME`
# * `indata_raw`
# 
# Now set absolute paths as specified in the following two code chunks below.

#%% Your own set-up ----------------------------------------------
# Set absolute path to Excel spreadhseet with index file.
index <- read_excel("./indata_index/List_of_Datasets2019.xls")

# Set absolute path to spreadsheet with prevalence estimates from JME papers.
prev_JME_papers <- read_excel("")

# Set absolute path to spreadsheet with information on whether survey was included in JME.
dat_JME_info <- read_excel("")

# Setting-up in Python
repl_python()
from pathlib import Path
import os, pandas as pd

# Set absolute path to the same folder as where the current RCmd file is. 
who_folder = 
  
# Set relative path to where spreadsheet with index file is.
df_vars = pd.read_excel(who_folder / 'indata_index' / 'List_of_Datasets_2019.xls')
exit()

# Construct database ------------------------------------------------------------

#%% 1) Extracting relevant files ------------------------------------------------

repl_python()
from pathlib import Path
import os, io, shutil, pandas as pd, numpy as np

# Transform country names' cases so they are comparable
df_vars['uppercase_countries'] = df_vars.country.str.replace('_', ' ').str.upper()
folder_countries = tuple(map(str.upper, os.listdir(who_folder / 'indata_raw')))

# List countries both in xlsx file and in the raw folder
s1 = set(df_vars.uppercase_countries.unique())
s2 = set(folder_countries)
folders_with_datasets = list(s1 & s2)

# Select all rows where countries are selected in the previous step
df_filtered = dfvarst[df_vars.uppercase_countries.isin(folders_with_datasets)].copy()

# Add a new column with the path relative to our current working directory
# Name the column 'EURO-DB-filepath'
df_filtered['EURO-DB-filepath'] = (df_filtered['filepath'] # split lines w ()
                                   .str.replace('\\', '/') #  replace from windows to unix slashes
                                   .str.replace('D:/Country Folders', str(who_folder / 'indata_raw')))

def construct_destination_paths(source_filepath, country, survey, year, who_folder):
  dataset_path = Path(source_filepath)
dataset_folder = dataset_path.parent
dataset_filename = dataset_path.stem
new_filename = f'{country.upper()}_{survey}_{year}.dta'
destination_path = who_folder / '1_dta' / new_filename
return str(destination_path)

def copy_file(source, destination, verbose=True, skip_if_existing=True):
  if skip_if_existing:
  if os.path.isfile(destination): return  # Skip the copy
try: 
  shutil.copyfile(source, destination)
except Exception as e:
  print('Failed to move ', source, ' to ', destination)
if verbose: print(e)
if verbose: print(f'From {source.split("/")[-1]} to {destination.split("/")[-1]}')
exit

#%% 2) Converting .dta to .csv ----------------------------------------------------------

# Run the Stata do-file in scripts > convert_dta_to_csv.do. Ensure you put in the absolute path to your 1_dta folder.

#%% 3) Rename columns with reference to index file ------------------------------------------

repl_python()
from pathlib import Path
import os, io, shutil, pandas as pd, numpy as np

# Transform the columns to uppercase, to avoid case sensitivty queries problems
df_vars['country'] = df_vars.country.str.upper()
df_vars['survey'] = df_vars.survey.str.upper()

csv_folder = who_folder / '2_csv'
csv_files = list(csv_folder.glob('*.csv'))
destination_path = who_folder / '3_recoded'

# The function used:

for csv_file in csv_files:
  try:
  (country, survey, year) = csv_file.stem.rsplit('_', 2)
except:
  print('Error in rsplitting: ', csv_file)

row = df_vars.query(f"country == '{country.upper()}' & survey == '{survey.upper()}' & year == {year}")
to_dict = row.to_dict(orient='records')[0]
dict_vars = {v: k for k, v in to_dict.items()}

df_csv = pd.read_csv(csv_file)

# find the common columns between the csv_file and the list_var files
columns_csv = set(df_csv.columns)
common_columns = set(dict_vars.keys()) & columns_csv
excluded_columns = columns_csv - common_columns

# common columns is a set of variables that should be renamed
# we want to keep only the common columns and discard all the others
# so we delete all the other columns
df_csv = df_csv.drop(excluded_columns, axis=1)

df_csv = df_csv.rename(columns=dict_vars)
# Generate the name for the files
csv_filename = csv_file.stem
new_csv_filename = csv_filename + '_rc.csv'

try:
  df_csv.to_csv(destination_path / new_csv_filename)
print('SAVED: ', destination_path / new_csv_filename)
except Exception as e: # capture the stacktrace of the error in the variable 'e'
  print('Could not save ', new_csv_filename)
print(e)
exit

#%% 4) Date transformation ---------------------------------------------------

gen_dates <- function(data){
  
  df <- read_csv(paste0("./3_recoded/", data, ".csv"))
  
  # Replace NA values of date with "15", if any
  df$BR3D.new <- df$BR3D
  df$BR3D.new[is.na(df$BR3D.new)] <- paste("15")
  df$HI3D.new <- df$HI3D
  df$HI3D.new[is.na(df$HI3D.new)] <- paste("15")
  
  df <- transform(df, dob.posix = paste0(df$BR3D.new, "/", df$BR3M, "/", df$BR3Y))
  df <- transform(df, dov.posix = paste0(df$HI3D.new, "/", df$HI3M, "/", df$HI3Y))
  
  # Remove NA values in date if it exists
  df$dob.posix <- dmy(df$dob.posix)
  df$dov.posix <- dmy(df$dov.posix)
  
  # Calculate age in days for Shiny just in case of computer formatting
  df$agedays <- as.integer(df$dov.posix - df$dob.posix)
  
  # Preserve date format in DMY string for export rather than POSIX to be read into R Shiny
  df <- transform(df, dob = paste0(df$BR3D.new, "/", df$BR3M, "/", df$BR3Y))
  df <- transform(df, dov = paste0(df$HI3D.new, "/", df$HI3M, "/", df$HI3Y))
  
  write.csv(df, paste0("./4_datetransformed/", gsub("_rc", "", data), ".csv"))
  
}

dat.list <-  list.files("./3_recoded", "csv")
dat.list <- str_replace_all(dat.list, ".csv", "") 
lapply(dat.list, gen_dates)

#%% 5) Extracting relevant columns ------------------------------------------------------

# This step is necessary so the Anthro Tool won't be overloaded as our current file size limitation is 50MB; some of the datasets have 200+ columns with variables we do not need.

extract <- function(data){
  df <- read_csv(paste0("./4_datetransformed/", data, ".csv"))
  df.new <- df[,colnames(df) %in% index]
  write_csv(df.new, paste0("./5_forshiny/", data, ".csv"))
}

dat.list <-  list.files("./4_datetransformed", "csv")
dat.list <- str_replace_all(dat.list, ".csv", "") 
lapply(dat.list, gen_dates)

# You can now run the Anthro Survey Analyser using datasets saved in `5_forshiny` and save the output in the `6_shinyoutput` folder.

#%% 6) Clean prevalence estimates -----------------------------------------------------------

# We now clean the prevalence files obtained from the Anthro tool. Run the code chunks below.

#%%% 6.1 Insert country, survey, and year name based on title --------------------------------
survprev_ins_titleinfo <- function(dat){
  df  <- read_csv(paste0("./6_toappend/", dat, ".csv"))
  dat <- gsub("_prevalence", "", dat)
  
  # Extracting from title string
  df.split <- str_split_fixed(dat, "_", n=3) # Need to do this better for countries that hav more than one word for their name. R equivalent of python's rsplit?
  # ! WARNING !
  df.split <- strsplit(stri_reverse(dat), "_", n=3) # see if this works
  df.country <- str_to_title(df.split[,1])
  df.survey <- df.split[,2]
  df.year <- df.split[,3]
  
  df$country <- df.country
  df$survey  <- df.survey
  df$year    <- df.year
  
  write_csv(df, paste0("./6_toappend/", dat, ".csv"))
  }

dat.list <-  list.files("./6_toappend", "csv")
dat.list <- str_replace_all(dat.list, ".csv", "") 
lapply(dat.list, survprev_ins_titleinfo)

#%%% 6.2 Tidy the data to Xmart format --------------------------------------------------------------------------

# This also makes it easier to format to XMart file further on.
survprev_cleaning <- function(dat){
  
  df <- read_csv(paste0("./6_toappend/", dat, ".csv"))
  
  # Rename variables #####
  df <- df[, .(country, year, survey, Group, # Weight-for-height
               N_WH_UNWGT = whz_unweighted_N,
               N_WH_WGT = whz_weighted_N,
               WH_3 = whzA_r,
               WH_3_SE = whzA_se,
               WH_3_LOW = whzA_ll,
               WH_3_UP = whzA_ul,
               WH_2 = whzB_r,
               WH_2_SE = whzB_se,
               WH_2_LOW = whzB_ll,
               WH_2_UP = whzB_ul,
               WH_1 = whzC_r,
               WH_1_SE = whzC_se,
               WH_1_LOW = whzC_ll,
               WH_1_UP = whzC_ul,
               WH1 = whzD_r,
               WH1_SE = whzD_se,
               WH1_LOW = whzD_ll,
               WH1_UP = whzD_ul,
               WH2 = whzE_r,
               WH2_SE = whzE_se,
               WH2_LOW = whzE_ll,
               WH2_UP = whzE_ul,
               WH3 = whzF_r,
               WH3_SE = whzF_se,
               WH3_LOW = whzF_ll,
               WH3_UP = whzF_ul,
               WHZ_MEAN = whz_r,
               WHZ_MEAN_SE = whz_se,
               WHZ_MEAN_LOW = whz_ll,
               WHZ_MEAN_UP = whz_ul,
               WHZ_SD = whz_sd,
               
               # Height-for-age
               N_HA_UNWGT = haz_unweighted_N,
               N_HA_WGT = haz_weighted_N,
               HA_3 = hazA_r,
               HA_3_SE = hazA_se,
               HA_3_LOW = hazA_ll,
               HA_3_UP = hazA_ul,
               HA_2 = hazB_r,
               HA_2_SE = hazB_se,
               HA_2_LOW = hazB_ll,
               HA_2_UP = hazB_ul,
               HA_1 = hazC_r,
               HA_1_SE = hazC_se,
               HA_1_LOW = hazC_ll,
               HA_1_UP = hazC_ul,
               HA1 = hazD_r,
               HA1_SE = hazD_se,
               HA1_LOW = hazD_ll,
               HA1_UP = hazD_ul,
               HA2 = hazE_r,
               HA2_SE = hazE_se,
               HA2_LOW = hazE_ll,
               HA2_UP = hazE_ul,
               HA3 = hazF_r,
               HA3_SE = hazF_se,
               HA3_LOW = hazF_ll,
               HA3_UP = hazF_ul,
               HAZ_MEAN = haz_r,
               HAZ_MEAN_SE = haz_se,
               HAZ_MEAN_LOW = haz_ll,
               HAZ_MEAN_UP = haz_ul,
               HAZ_SD = haz_sd,
               
               # Height-for-age and weight-for-height combined
               N_HA_WH_UNWGT = hazB_whzB_unweighted_N,
               N_HA_WH_WGT = hazB_whzB_weighted_N,
               HA_2_WH_2 = hazB_whzB_r,
               HA_2_WH_2_SE = hazB_whzB_se,
               HA_2_WH_2_LOW = hazB_whzB_ll,
               HA_2_WH_2_UP = hazB_whzB_ul,
               HA_2_WH2 = hazB_whzE_r,
               HA_2_WH2_SE = hazB_whzB_se,
               HA_2_WH2_LOW = hazB_whzB_ll,
               HA_2_WH2_UP = hazB_whzB_ul,
               
               # Weight-for-age
               N_WA_UNWGT = waz_unweighted_N,
               N_WA_WGT = waz_weighted_N,
               WA_3 = wazA_r,
               WA_3_SE = wazA_se,
               WA_3_LOW = wazA_ll,
               WA_3_UP = wazA_ul,
               WA_2 = wazB_r,
               WA_2_SE = wazB_se,
               WA_2_LOW = wazB_ll,
               WA_2_UP = wazB_ul,
               WA_1 = wazC_r,
               WA_1_SE = wazC_se,
               WA_1_LOW = wazC_ll,
               WA_1_UP = wazC_ul,
               WA1 = wazD_r,
               WA1_SE = wazD_se,
               WA1_LOW = wazD_ll,
               WA1_UP = wazD_ul,
               WA2 = wazE_r,
               WA2_SE = wazE_se,
               WA2_LOW = wazE_ll,
               WA2_UP = wazE_ul,
               WA3 = wazF_r,
               WA3_SE = wazF_se,
               WA3_LOW = wazF_ll,
               WA3_UP = wazF_ul,
               WAZ_MEAN = waz_r,
               WAZ_MEAN_SE =waz_se,
               WAZ_MEAN_LOW =waz_ll,
               WAZ_MEAN_UP =waz_ul,
               WAZ_SD = waz_sd,
               
               # BMI-for-age
               N_BA_UNWGT = baz_unweighted_N,
               N_BA_WGT = baz_weighted_N,
               BA_3 = bazA_r,
               BA_3_SE = bazA_se,
               BA_3_LOW = bazA_ll,
               BA_3_UP = bazA_ul,
               BA_2 = bazB_r,
               BA_2_SE = bazB_se,
               BA_2_LOW = bazB_ll,
               BA_2_UP = bazB_ul,
               BA_1 = bazC_r,
               BA_1_SE = bazC_se,
               BA_1_LOW = bazC_ll,
               BA_1_UP = bazC_ul,
               BA1 = bazD_r,
               BA1_SE = bazD_se,
               BA1_LOW = bazD_ll,
               BA1_UP = bazD_ul,
               BA2 = bazE_r,
               BA2_SE = bazE_se,
               BA2_LOW = bazE_ll,
               BA2_UP = bazE_ul,
               BA3 = bazF_r,
               BA3_SE = bazF_se,
               BA3_LOW = bazF_ll,
               BA3_UP = bazF_ul,
               BAZ_MEAN = baz_r,
               BAZ_MEAN_SE = baz_se,
               BAZ_MEAN_LOW = baz_ll,
               BAZ_MEAN_UP = baz_ul,
               BAZ_SD = baz_sd)]
  
  # Recode group levels ####
  
  #%% YEAR_START
  df[, YEAR_START := ""]
  
  #%% YEAR_END
  df[, YEAR_END := ""]
  
  #%% ADMLEVEL - Representation level, if national "NA"
  df[, ADMLEVEL := ""]
  
  #%% Geog region ADMLEVEL1
  df[Group %like% regex("^Geographical Region\\:\\>"), ADMLEVEL1 := sub(".*\\:\\s", "", Group)]
  
  #%% MEDUC
  df[Group %like% regex("^Maternal education\\:\\>"), MEDUC := sub(".*\\:\\s", "", Group)]
  
  #%% AREA (Urban / Rural)
  df$AREA <- "BOTH"
  df[Group %like% regex("^Area\\:\\>") & Group %like% regex("[Rr]ural$"), AREA := "NUTRITION_RUR"]
  df[Group %like% regex("^Area\\:\\>") & Group %like% regex("[Uu]rban$"), AREA := "NUTRITION_URB"]
  
  #%% WEALTHQ
  df$WEALTHQ <- ""
  df[Group %like% regex("^Wealth Quintile\\:\\>"), wealth := sub(".*\\:\\s", "", Group)]
  
  #%% Sex
  
  df[, SEX := "BOTH"]
  
  df[(Group %like% regex("[Ff]emale$") |
        Group %like% regex("^[Ff]$")
  ),
  SEX := "FMLE"]
  
  df[(Group %like% regex("^[Mm]ale$") |
        Group %like% regex("^[Mm]$")
  ),
  SEX := "MLE"]
  
  #%% Age group
  df$AGEGROUP <-  "0.   - 5.00"
  df[Group %like% regex("^Age group:\\>") & Group %like% regex("\\<00-05 mo"), AGEGROUP := "0.   - 0.49"]
  df[Group %like% regex("^Age group:\\>") & Group %like% regex("\\<06-11 mo"), AGEGROUP := "0.50 - 0.99"]
  df[Group %like% regex("^Age group:\\>") & Group %like% regex("\\<12-23 mo"), AGEGROUP := "1.   - 1.99"]
  df[Group %like% regex("^Age group:\\>") & Group %like% regex("\\<24-35 mo"), AGEGROUP := "2.   - 2.99"]
  df[Group %like% regex("^Age group:\\>") & Group %like% regex("\\<36-47 mo"), AGEGROUP := "3.   - 3.99"]
  df[Group %like% regex("^Age group:\\>") & Group %like% regex("\\<48-59 mo"), AGEGROUP := "4.   - 5.00"]
  
  df[AGEGROUP %like% "0.  ", AGE_START := 0]
  df[AGEGROUP %like% "0.50", AGE_START := 6]
  df[AGEGROUP %like% "1.  ", AGE_START := 12]
  df[AGEGROUP %like% "2.  ", AGE_START := 24]
  df[AGEGROUP %like% "3.  ", AGE_START := 36]
  df[AGEGROUP %like% "4.  ", AGE_START := 48]
  
  df[AGEGROUP %like% "- 0.49", AGE_END := 5]
  df[AGEGROUP %like% "- 0.99", AGE_END := 11]
  df[AGEGROUP %like% "- 1.99", AGE_END := 23]
  df[AGEGROUP %like% "- 2.99", AGE_END := 35]
  df[AGEGROUP %like% "- 3.99", AGE_END := 47]
  df[AGEGROUP %like% "- 5.00", AGE_END := 60]
  
  #%% Notes etc
  
  df[, NOTES := ""]
  df[, R_SCORE_E := ""]
  df[, ENTRYD := ""]
  df[, LASTUPD := ""]
  df[, LOCATIONTYPE := ""]
  
  # Rearrange levels #####
  df <- select(df, ISOCODE:AGE_END, everything(), NOTES:LOCATIONTYPE, Short_Source_Code)
  
}

dat.list <-  list.files("./6_toappend", "csv")
dat.list <- str_replace_all(dat.list, ".csv", "") 
lapply(dat.list, survprev_cleaning)

#%% 7) Append all into one master file ----------------------------------------------------

# Run the code chunk below. Don't forget to add in the file containing prevalence estimates obtained from scientific papers given by the JME.

dat.list <-  list.files("./6_toappend", "csv")

DF <- read_csv(paste0("./6_toappend/", dat.list[1]))
for (f in dat.list[-1]){
  df <- read.csv(paste0("./6_toappend/", f))
  DF <- rbind(DF, df)
}

write_csv(DF, "all_append.csv")

# Congratulations! The resulting file can now be found in all_append.csv.

# Further steps -------------------------------------------------------------------
#
# * For Anthro csv to Xmart conversion run the convert_Anthro-to-xmart.R script.

# Notes and questions -----------------------------------------------------------------

# * At each step of the process, check that the files are being transformed as necessary. The issue is that there are unconventional filenames and small discrepancies between each file that could lead to massive differences in output.
