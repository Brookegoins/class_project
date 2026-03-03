#Load in your packages 
library(readr)
library(janitor)
library(dplyr)

data_raw <- read_csv("project_data/data_raw/invertebrate_field_sample_data(Master sheet).csv")

#Let's start with adjusting the column names 
data_raw <- janitor::clean_names(data_raw)

#Look at the data structure and types 
str(data_raw)

#We need to convert the dates to the correct data type
#For Field_date
data_raw <- data_raw %>%
  mutate(field_date = as.Date(field_date, format = "%m.%d.%Y"))
#For id_date 
data_raw <- data_raw %>%
  mutate(id_date = as.Date(id_date, format = "%m.%d.%Y"))

#Need to remove trailing spaces from all columns using dplyr
#I remember being in lab and typing extra spaces after certain entries
data_raw <- data_raw%>%
  mutate(across(where(is.character), trimws))

#Remove uncessary columns like QAQC, Processor, ID_date and Notes
data_raw <- data_raw[, -c(19:22)]
