********************************
*** Convert dta to csv files ***
********************************
*
* A stata-based script that converts your .dta files to .csv whilst
* preserving the variable labels.
*
* This script requires you to input the working directory.
* 
clear all

***
*** Insert your working directory for folder 1_dta here
cd 

local filelist : dir "`c(pwd)'" files "*.dta", respectcase

foreach file of local filelist {
    use "`file'", clear
    export delimited using "../2_csv/`file'.csv", delimiter(",")
}

exit, STATA clear
