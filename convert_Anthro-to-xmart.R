survprev_cleaning <- function(dat){
  # Rename variables #####
  dat <- dat[, .(country, year, survey, strat_cat, strat_label, # Weight-for-height
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
  
  # Create variables ####
  
  #%% YEAR_START
  dat[, YEAR_START := ""]
  
  #%% YEAR_END
  dat[, YEAR_END := ""]
  
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

