# Set-up #####
require(tidyverse) | require(stringr) | require(data.table)
jme <- fread("indata/JME_comparison.csv")
prev <- fread("output/prev_all_0213.csv")

# Cleaning

# survey.year is the range of years the survey is conducted (chr string). Year is an integer
prev$country <- str_to_upper(prev$country)
prev$survey.period <- prev$year
prev$year <- as.integer(substr(prev$year, 1, 4))
setnames(jme,  c("Country and areas", "Year*"), c("country", "year"))
setnames(jme, c("source"), c("source.type"))
setkey(prev, country, year)
setkey(jme, country, year)

# Analysis #####

# Extract unique from prev
dat.prev <- prev[, .(country, year)]
dat.prev <- unique(dat.prev[, c("country", "year")])
dat.jme <- jme[, .(country, year)]
setkey(dat.prev, country, year)
setkey(dat.jme, country, year)

# Data.table joins
ref.jme <- merge(dat.prev, dat.jme, all.x = T)
ref.jme$jme.inc <- "JME included"
setkey(ref.jme, country, year)
# I want an inner join, not a left full join..

dat <- merge(prev, ref.jme, all.x = T)
dat$jme.inc[is.na(dat$jme.inc)] <- "Not included in JME"
table(dat$jme.inc, useNA="always")

# tidyverse joins
ref.jme <- intersect(dat.prev, dat.jme)
ref.jme$jme.inc <- "JME included"
setkey(ref.jme, country, year)

dat <- left_join(prev, ref.jme, by = c("country", "year"), copy = FALSE, suffix = c("", ".JME"))
dat$jme.inc[is.na(dat$jme.inc)] <- "Not included in JME"
table(dat$jme.inc, useNA="always")

write_csv(dat, "output/prev_all_0220.csv")

# Input all JME that doesn't exist in EURO
jme <- fread("indata/JME_comparison.csv")
prev <- fread("output/prev_all_0225.csv")

setnames(jme,  c("Country and areas", "Survey year", "Year*",
                 "Survey sample size (N)", "Severe Wasting", "Wasting",
                 "Overweight", "Stunting", "Underweight",
                 "Notes", "Report Author"),
               c("country", "survey.period", "year",
                 "WHZ_unwpop", "WH_3_r", "WH_2_r",
                 "WH2_r", "HA_2_r", "WA_2_r",
                 "Notes", "Reference"))
setnames(prev, c("Cutoff / Notes"), c("Notes"))
prev$WHZ_unwpop <- as.numeric(gsub(",", "", prev$WHZ_unwpop))
setkey(prev, country, year)

dat.prev <- prev[, .(country, year)]
dat.prev <- unique(dat.prev[, c("country", "year")])
setkey(dat.prev, country, year)
setkey(dat.jme, country, year)

dat.jme.noteuro <- anti_join(dat.jme, dat.prev)
dat1 <- left_join(dat.jme.noteuro, jme)
dat1 <- select(dat1, country, year, survey.year, WHZ_unwpop:Reference)
dat1$WHZ_unwpop <- as.numeric(gsub(",", "", dat1$WHZ_unwpop))

# Join with prevalence

prev$WH3_r <- as.numeric(gsub(",", "", prev$WH3_r))
prev$WH2_r <- as.numeric(gsub(",", "", prev$WH2_r))

dat2 <- bind_rows(prev, dat1)
write_csv(dat2, "output/dat0225_01.csv")

# Get JME references

dat.jme <- jme[, .(country, year, Reference)]
dat <- fread("./output/dat0225_02.csv")
setkey(dat, country, year)
setkey(dat.jme, country, year)

dat2 <- left_join(dat, dat.jme, by = c("country", "year"))
setDT(dat2)

