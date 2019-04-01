sh_prev <- fread("./shinyoutput/case_age_greater5yr_prevalence.csv")
sh_zsum <- fread("./shinyoutput/case_age_greater5yr_zscore_summary.csv")

setnames(sh_prev, "rowname", "group")
setnames(sh_zsum, "Group", "group")
setkey(sh_prev, group)
setkey(sh_zsum, group)

sh_all <- merge(sh_prev, sh_zsum,
                by = "group",
                all.x = T)

setnames(sh_all, c("Mean (zlen)", "Standard deviation (zlen)",
                   "Mean (zwei)", "Standard deviation (zwei)",
                   "Mean (zbmi)", "Standard deviation (zbmi)",
                   "Mean (zwfl)", "Standard deviation (zwfl)"),
         c("mean_zlen", "sd_zlen",
           "mean_zwei", "sd_zwei",
           "mean_zbmi", "sd_zbmi",
           "mean_zwfl", "sd_zwfl"))

# Rename variables #####
names(sh_all)
sh_all <- sh_all[, .(group, # Weight-for-height
  N_WH_UNWGT = WHZ_unwpop,
  N_WH_WGT = WHZ_pop,
  WH_3 = WH_3_r,
  WH_3_SE = WH_3_se,
  WH_3_LOW = WH_3_ll,
  WH_3_UP = WH_3_ul,
  WH_2 = WH_2_r,
  WH_2_SE = WH_2_se,
  WH_2_LOW = WH_2_ll,
  WH_2_UP = WH_2_ul,
  WH_1 = WH_1_r,
  WH_1_SE = WH_1_se,
  WH_1_LOW = WH_1_ll,
  WH_1_UP = WH_1_ul,
  WH1 = WH1_r,
  WH1_SE = WH1_se,
  WH1_LOW = WH1_ll,
  WH1_UP = WH1_ul,
  WH2 = WH2_r,
  WH2_SE = WH2_se,
  WH2_LOW = WH2_ll,
  WH2_UP = WH2_ul,
  WH3 = WH3_r,
  WH3_SE = WH3_se,
  WH3_LOW = WH3_ll,
  WH3_UP = WH3_ul,
  WHZ_MEAN = mean_zwfl,
  WHZ_MEAN_SE = WH_se,
  WHZ_MEAN_LOW = WH_ll,
  WHZ_MEAN_UP = WH_ul,
  WHZ_SD = sd_zwfl,
  
  # Height-for-age
  N_HA_UNWGT = HAZ_unwpop,
  N_HA_WGT = HAZ_pop,
  HA_3 = HA_3_r,
  HA_3_SE = HA_3_se,
  HA_3_LOW = HA_3_ll,
  HA_3_UP = HA_3_ul,
  HA_2 = HA_2_r,
  HA_2_SE = HA_2_se,
  HA_2_LOW = HA_2_ll,
  HA_2_UP = HA_2_ul,
  HA_1 = HA_1_r,
  HA_1_SE = HA_1_se,
  HA_1_LOW = HA_1_ll,
  HA_1_UP = HA_1_ul,
  HA1 = HA1_r,
  HA1_SE = HA1_se,
  HA1_LOW = HA1_ll,
  HA1_UP = HA1_ul,
  HA2 = HA2_r,
  HA2_SE = HA2_se,
  HA2_LOW = HA2_ll,
  HA2_UP = HA2_ul,
  HA3 = HA3_r,
  HA3_SE = HA3_se,
  HA3_LOW = HA3_ll,
  HA3_UP = HA3_ul,
  HAZ_MEAN = mean_zlen,
  HAZ_MEAN_SE = HA_se,
  HAZ_MEAN_LOW = HA_ll,
  HAZ_MEAN_UP = HA_ul,
  HAZ_SD = sd_zlen,
  
  # Height-for-age and weight-for-height combined
  N_HA_WH_UNWGT = HA_2_WH_2_unwpop,
  N_HA_WH_WGT = HA_2_WH_2_pop,
  HA_2_WH_2 = HA_2_WH_2_r,
  HA_2_WH_2_SE = HA_2_WH_2_se,
  HA_2_WH_2_LOW = HA_2_WH_2_ll,
  HA_2_WH_2_UP = HA_2_WH_2_ul,
  # HA_2_WH2 shouldn't this be different from HA_2_WH2
  HA_2_WH2_SE = HA_2_WH2_se,
  HA_2_WH2_LOW = HA_2_WH2_ll,
  HA_2_WH2_UP = HA_2_WH2_ul,
  
  # Weight-for-age
  N_WA_UNWGT = WAZ_unwpop,
  N_WA_WGT = WAZ_pop,
  WA_3 = WA_3_r,
  WA_3_SE = WA_3_se,
  WA_3_LOW = WA_3_ll,
  WA_3_UP = WA_3_ul,
  WA_2 = WA_2_r,
  WA_2_SE = WA_2_se,
  WA_2_LOW = WA_2_ll,
  WA_2_UP = WA_2_ul,
  WA_1 = WA_1_r,
  WA_1_SE = WA_1_se,
  WA_1_LOW = WA_1_ll,
  WA_1_UP = WA_1_ul,
  WA1 = WA1_r,
  WA1_SE = WA1_se,
  WA1_LOW = WA1_ll,
  WA1_UP = WA1_ul,
  WA2 = WA2_r,
  WA2_SE = WA2_se,
  WA2_LOW = WA2_ll,
  WA2_UP = WA2_ul,
  WA3 = WA3_r,
  WA3_SE = WA3_se,
  WA3_LOW = WA3_ll,
  WA3_UP = WA3_ul,
  WAZ_MEAN = mean_zwei,
  WAZ_MEAN_SE = WA_se,
  WAZ_MEAN_LOW = WA_ll,
  WAZ_MEAN_UP = WA_ul,
  WAZ_SD = sd_zwei,
  
  # BMI-for-age
  N_BA_UNWGT = BMIZ_unwpop,
  N_BA_WGT = BMIZ_pop,
  BA_3 = BMI_3_r,
  BA_3_SE = BMI_3_se,
  BA_3_LOW = BMI_3_ll,
  BA_3_UP = BMI_3_ul,
  BA_2 = BMI_2_r,
  BA_2_SE = BMI_2_se,
  BA_2_LOW = BMI_2_ll,
  BA_2_UP = BMI_2_ul,
  BA_1 = BMI_1_r,
  BA_1_SE = BMI_1_se,
  BA_1_LOW = BMI_1_ll,
  BA_1_UP = BMI_1_ul,
  BA1 = BMI1_r,
  BA1_SE = BMI1_se,
  BA1_LOW = BMI1_ll,
  BA1_UP = BMI1_ul,
  BA2 = BMI2_r,
  BA2_SE = BMI2_se,
  BA2_LOW = BMI2_ll,
  BA2_UP = BMI2_ul,
  BA3 = BMI3_r,
  BA3_SE = BMI3_se,
  BA3_LOW = BMI3_ll,
  BA3_UP = BMI3_ul,
  BAZ_MEAN = mean_zbmi,
  BAZ_MEAN_SE = BMI_se,
  BAZ_MEAN_LOW = BMI_ll,
  BAZ_MEAN_UP = BMI_ul,
  BAZ_SD = sd_zbmi)]
# ISOCODE:ADMLEVEL2 to be filled in later
# YEAR:AGE_END, OEDEMA to be filled in later
# NOTES:Short_source_code

# Recode levels #####

dat$ADMLEVEL <- ""
dat$ADMLEVEL1 <- substring(dat$rowname, regexpr(" region:", dat$rowname) + 2)

#%% Area #####
dat$AREA <- "BOTH"
dat$AREA[dat$rowname %like% "Area: 1"] <- "NUTRITION_RUR"
dat$AREA[dat$rowname %like% "Area: 2"] <- "NUTRITION_URB"

#%% Mothers' Education ####
dat$MEDUC <- ""
dat$MEDUC[dat$melevel %like% "Maternal education: 1",] <- "MEDUC_1"
# Check this again as we're not sure what the melevel is? Check back to .dta file

dat$WEALTHQ <- ""
dat$WEALTHQ[dat$rowname %like% "Poorest",] <- "WQ1"
dat$WEALTHQ[dat$rowname %like% "Poorer",]  <- "WQ2"
dat$WEALTHQ[dat$rowname %like% "Middle",]  <- "WQ3"
dat$WEALTHQ[dat$rowname %like% "Richer",]  <- "WQ4"
dat$WEALTHQ[dat$rowname %like% "Richest",] <- "WQ5"

#%% Sex #####
dat$SEX <- "BTSX"
dat$SEX[(dat$rowname %like% ".M") | (dat$rowname %like% " M")] <- "MLE"
dat$SEX[(dat$rowname %like% ".F") | (dat$rowname %like% " F")] <- "FMLE"

#%% Age group ######
dat$AGEGROUP[!(dat$rowname %like% " mo"),]    <- "0.   - 5.00"
dat$AGEGROUP[dat$rowname %like% " 00-05 mo",] <- "0.   - 0.49"
dat$AGEGROUP[dat$rowname %like% " 06-11 mo",] <- "0.50 - 0.99"
dat$AGEGROUP[dat$rowname %like% " 12-23 mo",] <- "1.   - 1.99"
dat$AGEGROUP[dat$rowname %like% " 24-35 mo",] <- "2.   - 2.99"
dat$AGEGROUP[dat$rowname %like% " 36-47 mo",] <- "3.   - 3.99"
dat$AGEGROUP[dat$rowname %like% " 48-59 mo",] <- "4.   - 5.00"

dat$AGE_START[dat$AGEGROUP %like% "0.  "] <- 0
dat$AGE_START[dat$AGEGROUP %like% "0.50"] <- 6
dat$AGE_START[dat$AGEGROUP %like% "1.  "] <- 12
dat$AGE_START[dat$AGEGROUP %like% "2.  "] <- 24
dat$AGE_START[dat$AGEGROUP %like% "3.  "] <- 36
dat$AGE_START[dat$AGEGROUP %like% "4.  "] <- 48

dat$AGE_END[dat$AGEGROUP %like% "- 0.49"] <- 5
dat$AGE_END[dat$AGEGROUP %like% "- 0.99"] <- 11
dat$AGE_END[dat$AGEGROUP %like% "- 1.99"] <- 23
dat$AGE_END[dat$AGEGROUP %like% "- 2.99"] <- 35
dat$AGE_END[dat$AGEGROUP %like% "- 3.99"] <- 47
dat$AGE_END[dat$AGEGROUP %like% "- 5.00"] <- 60

# Write file #####

write_csv(sh_all, "./output/XMart_convert.csv")
