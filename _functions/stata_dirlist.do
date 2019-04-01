***********************
** Function: dirlist **
***********************
*
* This function lists all files in current directory,
* with pattern matching if needed.
* 
* Examples:
* ** First, start from the current directory:
* > local cdir = "`c(pwd)'"
* ** Then list all files, or list only excel files:
* > dirlist, fromdir("`cdir'") save("allfiles.dta") replace
* > dirlist, fromdir("`cdir'") save("allfiles.dta") ///
*   pattern("*.xls") replace

cap program drop dirlist
program define dirlist

    syntax, fromdir(string) save(string) /// 
    [pattern(string) replace append]

    // get files in `fromdir' using pattern
    if "`pattern'" == "" local pattern "*"
    local flist: dir "`fromdir'" files "`pattern'"

    qui {
        
        // initialise dataset to be used
        if "`append'" != "" use "`save'", clear
        else {
            clear
            gen fname = ""
        }

        // add files to the dataset
        local i = _N
        foreach f of local flist {
            set obs `++i'
            replace fname = "`fromdir'/`f'" in `i'
        }
        save "`save'", `replace'
    }

    // recursively list directories in "`fromdir'"
    local dlist: dir "`fromdir'" dirs "*"
    foreach d of local dlist {
        dirlist , fromdir("`fromdir'/`d'") save (`save') ///
        pattern("`pattern'") append replace
    }

end