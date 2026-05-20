#The purpose of this script is to compile proteomic data into an R object that is faster to load capable of being stored on GitHub.

## CHANGE THESE PARAMETERS
setwd("~/Downloads/Ulithi_2023_Coral_Multi-Omic_Dataset_Workflows") #set working directory
filepath <- "~/Downloads/3_Raw_proteomic_data_all_genera/1_Montipora" #Path to intensity matrix. This is saved into multiple chunked gzipped files that will have to be combined below.
rdat <- read_delim("2-Proteomic_workflows/1-Montipora/1-Input/Montipora_proteomic_run_metadata.csv", delim = ",") #Load run metadata, matrix containing run IDs and associated sample IDs
sdat <- read_delim("2-Proteomic_workflows/1-Montipora/1-Input/Montipora_sample_metadata.csv", delim = ",") #Load sample metadata


#Load libraries
library(dplyr)
library(tidyverse)
library(janitor)

files_to_read <- paste(filepath, list.files(filepath), sep = "/")

all_files <- lapply(files_to_read,function(x) {
  read.table(file = x, 
             sep = '\t', 
             header = FALSE, 
             as.is = TRUE,
             fill = TRUE,
             colClasses = "character"
  )
})

pdat <- bind_rows(all_files)

names(pdat) <- as.character(
  as.vector(pdat[1,])
)
pdat <- pdat[-1,]

pdat <- type_convert(pdat)


#Prune the protein data matrix... it has a lot of extra rows and columns we don't need.
pdat <- pdat %>% 
  remove_empty("cols") %>% #remove any empty columns
  select(!File.Name) %>% 
  filter(Run%in%rdat$run) #keep only samples in sample metadata sheet

#Add run metadata to the abundance data
rpdat <- left_join(rdat, pdat, by = c("run" = "Run"))
n_distinct(rpdat$sample_id)

#How many in treatmentinfo missing from run?
setdiff(sdat$sample_id, rdat$sample_id); setdiff(rdat$sample_id, sdat$sample_id)

dat <- left_join(rpdat, sdat, by="sample_id")

dat.host <- dat %>% filter(grepl("Montipora_", Protein.Group))
n_distinct(dat.host$Protein.Group)
n_distinct(dat.host$sample_id)

save(dat.host, file = "2-Proteomic_workflows/1-Montipora/3-Output/Ulithi23_Montipora_host_proteomic_raw_dataset")
