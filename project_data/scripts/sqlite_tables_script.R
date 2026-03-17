library(readr)
library(DBI)
library(RSQLite)
library(tidyverse)

##### NRES 701B
##### Invertebrate Relational Database (single data file)

#Load cleaned data
data <- read_csv("bug_clean")
#-------------------------------------------------------------------------------
#SQLITE specific cleaning 
#Convert all character columns to character 
char_cols <- c("site", "lab_id", "field_id", "source_of_production", "method",
               "life_stage", "order", "family", "genus", "common_name",
               "functional_group", "processor", "qa_qc", "notes")
data <- data %>%
  mutate(across(all_of(char_cols), as.character))

#get those spaces outta here
data <- data %>%
  mutate(across(all_of(char_cols), ~trimws(.)))

#convert date columns to character for our little SQLite gremlin
date_cols <- c("field_date", "id_date")
data <- data %>%
  mutate(across(all_of(date_cols), as.character))
#-------------------------------------------------------------------------------

#Connect to database
invert_db <- dbConnect(RSQLite::SQLite(), "invertebrate_db.sqlite")

################SITES TABLE#################
sites <- data %>%
  select(site) %>%
  distinct() %>%
  rename(site_id = site)

dbExecute(invert_db, "CREATE TABLE IF NOT EXISTS sites (
  site_id TEXT NOT NULL,
  PRIMARY KEY (site_id)
);")

dbWriteTable(invert_db, "sites", sites, append = TRUE)
dbGetQuery(invert_db, "SELECT * FROM sites LIMIT 10;")

################EVENTS TABLE#################
events <- data %>%
  select(site, field_date, reach, transect, method) %>%
  distinct() %>%
  rename(site_id = site,
         sample_date = field_date)

dbExecute(invert_db, "CREATE TABLE IF NOT EXISTS events (
  event_id INTEGER PRIMARY KEY AUTOINCREMENT,
  site_id TEXT,
  sample_date TEXT,
  reach REAL,
  transect REAL,
  method TEXT,
  FOREIGN KEY(site_id) REFERENCES sites(site_id)
);")

dbWriteTable(invert_db, "events", events, append = TRUE)
dbGetQuery(invert_db, "SELECT * FROM events LIMIT 10;")

################SAMPLES TABLE#################
# Read events table from database and convert dates to character
events_db <- dbReadTable(invert_db, "events") %>%
  mutate(sample_date = as.character(sample_date))  # ensure type matches data$field_date

# Prepare samples table by joining master data with events
samples <- data %>%
  select(lab_id, field_id, source_of_production, id_date, processor, qa_qc, notes,
         site, field_date, reach, transect, method) %>%
  left_join(events_db, by = c(
    "site" = "site_id",
    "field_date" = "sample_date",
    "reach", "transect", "method"
  )) %>%
  rename(sample_id = lab_id,
         source = source_of_production)

# Create SQLite samples table
dbExecute(invert_db, "CREATE TABLE IF NOT EXISTS samples (
  sample_id TEXT PRIMARY KEY,
  event_id INTEGER,
  field_id TEXT,
  source TEXT,
  id_date TEXT,
  processor TEXT,
  qa_qc TEXT,
  notes TEXT,
  FOREIGN KEY(event_id) REFERENCES events(event_id)
);")

# Select columns in the correct order for writing
samples_db <- samples %>%
  select(sample_id, event_id, field_id, source, id_date, processor, qa_qc, notes)

# Write samples table to database
dbWriteTable(invert_db, "samples", samples_db, append = TRUE)

# Quick verification
dbGetQuery(invert_db, "SELECT * FROM samples LIMIT 10;")

################TAXONOMY TABLE#################
taxonomy <- data %>%
  select(order, family, genus, common_name, functional_group) %>%
  distinct() %>%
  mutate(taxon_id = 1:n()) %>%
  rename(order_name = order)

dbExecute(invert_db, "CREATE TABLE IF NOT EXISTS taxonomy (
  taxon_id INTEGER PRIMARY KEY,
  order_name TEXT,
  family TEXT,
  genus TEXT,
  common_name TEXT,
  functional_group TEXT
);")

dbWriteTable(invert_db, "taxonomy", taxonomy, append = TRUE)
dbGetQuery(invert_db, "SELECT * FROM taxonomy LIMIT 10;")

################OBSERVATIONS TABLE#################
observations <- data %>%
  select(lab_id, order, family, genus, common_name, functional_group, life_stage,
         length, weight, a, b) %>%
  left_join(taxonomy, by = c("order" = "order_name",
                             "family", "genus",
                             "common_name", "functional_group")) %>%
  mutate(observation_id = 1:n()) %>%
  rename(sample_id = lab_id,
         length_mm = length,
         weight_mg = weight)

dbExecute(invert_db, "CREATE TABLE IF NOT EXISTS observations (
  observation_id INTEGER PRIMARY KEY,
  sample_id TEXT,
  taxon_id INTEGER,
  life_stage TEXT,
  length_mm REAL,
  weight_mg REAL,
  a REAL,
  b REAL,
  FOREIGN KEY(sample_id) REFERENCES samples(sample_id),
  FOREIGN KEY(taxon_id) REFERENCES taxonomy(taxon_id)
);")

observations_db <- observations %>%
  select(observation_id, sample_id, taxon_id, life_stage, length_mm, weight_mg, a, b)

dbWriteTable(invert_db, "observations", observations_db, append = TRUE)
dbGetQuery(invert_db, "SELECT * FROM observations LIMIT 10;")


################QUERIES#################

#What is the most common taxon for the whole system that was sampled?
most_common_taxon <- dbGetQuery(invert_db, "
  SELECT t.common_name, COUNT(*) AS n_observations
  FROM observations o
  LEFT JOIN taxonomy t
    ON o.taxon_id = t.taxon_id
  GROUP BY t.common_name
  ORDER BY n_observations DESC
  LIMIT 1;
")

###ANSWER: Riffle beetle

#What is the most common function feeding group? 
functional_group_summary <- dbGetQuery(invert_db, "
  SELECT functional_group, COUNT(*) AS n_observations
  FROM observations o
  LEFT JOIN taxonomy t
    ON o.taxon_id = t.taxon_id
  GROUP BY functional_group
  ORDER BY n_observations DESC;
")

###Answer: Collector-Gatherer

#What life stage is the most abundant?

life_stage_summary <- dbGetQuery(invert_db, "
  SELECT life_stage, COUNT(*) AS n_observations
  FROM observations
  GROUP BY life_stage
  ORDER BY n_observations DESC;
")

###Answer: Larvae

#All tables listed 
dbListTables(invert_db)

#And we out
dbDisconnect(invert_db)
