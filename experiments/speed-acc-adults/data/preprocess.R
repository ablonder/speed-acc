################################################################################
## PREPROCESSING SCRIPT FOR GAZE-XSIT
## read in data files and consolidate them
##
## mcf ad 7/15
################################################################################

## PRELIMINARIES
rm(list = ls())
library(dplyr)
library(readr)
library(magrittr)
source("et_helper.R")

raw.data.path <- "data_adult/"
processed.data.path <- "../processed_data/"

## LOOP TO READ IN FILES
all.data <- data.frame()
files <- dir(raw.data.path,pattern="*.txt")

for (file.name in files) {
  print(file.name)
  
  ## these are the two functions that are most meaningful
  d <- read.smi.idf(paste(raw.data.path,file.name,sep=""), header.rows=32)
  d <- preprocess.data(d) 
  d$subid <- file.name
  
  ## now here's where data get bound together
  all.data <- bind_rows(all.data, d)
}

## WRITE DATA OUT TO CSV FOR EASY ACCESS
write_csv(all.data, paste0(processed.data.path, "processed_adult_data.csv")) 

