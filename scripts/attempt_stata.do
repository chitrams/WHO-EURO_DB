local cdir = "`c(pwd)'"

foreach file in `files' {;
    insheet using `file', clear;
    }

outsheet using "country", delimiter(",")