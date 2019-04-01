# Test file

dat <- fread("./shinyoutput/AZERBAIJAN_NNS_2013_prevalence.csv")

dat$agegroup[!(dat$rowname %like% " mo")]    <- "00-60"
dat$agegroup[dat$rowname %like% " 06-11 mo"] <- "06-11"
dat$agegroup[dat$rowname %like% " 12-23 mo"] <- "12-23"
dat$agegroup[dat$rowname %like% " 24-35 mo"] <- "24-35"
dat$agegroup[dat$rowname %like% " 36-47 mo"] <- "36-47"
dat$agegroup[dat$rowname %like% " 48-59 mo"] <- "48-59"

# Sex ##### 

dat$sex <- "all"
dat$sex[(dat$rowname %like% "Sex") & (dat$rowname %like% "F" | dat$rowname %like% ".2")] <- "FEMALE"
dat$sex[(dat$rowname %like% "Sex") & (dat$rowname %like% "M" | dat$rowname %like% ".1")] <- "MALE"

# Area #####

dat$area[dat$rowname=="Area: 1"] <- 1
dat$area[dat$rowname=="Area: 2"] <- 2