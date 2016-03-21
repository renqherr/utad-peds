##########################################################################
## PEDS 2015 (Segunda edicion)
## Trabajo fin de Experto: Kaggle - Telstra Network Disruptions
## Rafael Enriquez-Herrador
##    rafael.enriquez@live.u-tad.com
##    rafenher07@gmail.com
##########################################################################

##########################################################################
## Attempt 00
##########################################################################

library(plyr)
require(reshape2)
library(data.table)
library(dplyr)
require(stringr)

## Descomprimir todo los archivos del dataset (formato ZIP)

zipFiles <- dir(path = "data", pattern = "\\.zip")
zipFiles

unzipDataFiles <- function(zipFiles) {
  for (file in zipFiles) {
    unzip(paste(c("data/"), file, sep = ""), exdir = "data")
  }
}

unzipDataFiles(zipFiles)

## Prepare data
eventTypeData <- read.table(
  file = "data/event_type.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)

logFeatureData <- read.table(
  file = "data/log_feature.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)

resourceTypeData <- read.table(
  file = "data/resource_type.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)

severityTypeData <- read.table(
  file = "data/severity_type.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)

testData <- read.table(
  file = "data/test.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)

trainData <- read.table(
  file = "data/train.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)

sampleSubmissionData <- read.table(
  file = "data/sample_submission.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)

stringToBinary <- function(x) {
  for (i in 1:length(x)) {
    if (is.na(x[i]))
      x[i] <- 0
    else
      x[i] <- 1
  }
    
  return(x)
}

stringToValue <- function(x) {
  for (i in 1:length(x)) {
    if (is.na(x[i]))
      x[i] <- 0
  }
  
  return(x)
}

## event_types
castEventTypeData <- dcast(
  data = eventTypeData,
  formula = id ~ event_type,
  value.var = "event_type")

castEventTypeData[, 2:ncol(castEventTypeData)] <- as.numeric(
  apply(castEventTypeData[, 2:ncol(castEventTypeData)], 2, stringToBinary))

save(castEventTypeData, file = "data/cast_event_type.Rdata")
load(file = "data/cast_event_type.Rdata")

## log_features (keep volume)
castLogFeatureData <- dcast(
  data = logFeatureData,
  formula = id ~ log_feature,
  value.var = "volume")

castLogFeatureData[, 2:ncol(castLogFeatureData)] <- as.numeric(
  apply(
    castLogFeatureData[, 2:ncol(castLogFeatureData)],
    2,
    stringToValue))

save(castLogFeatureData, file = "data/cast_log_feature.Rdata")
load(file = "data/cast_log_feature.Rdata")

## resource_types
castResourceTypeData <- dcast(
  data = resourceTypeData,
  formula = id ~ resource_type,
  value.var = "resource_type")

castResourceTypeData[, 2:ncol(castResourceTypeData)] <- as.numeric(
  apply(
    castResourceTypeData[, 2:ncol(castResourceTypeData)],
    2,
    stringToBinary))

save(castResourceTypeData, file = "data/cast_resource_type.Rdata")
load(file = "data/cast_resource_type.Rdata")

## severity_type
castSeverityTypeData <- dcast(
  data = severityTypeData,
  formula = id ~ severity_type,
  value.var = "severity_type")

castSeverityTypeData[, 2:ncol(castSeverityTypeData)] <- as.numeric(
  apply(
    castSeverityTypeData[, 2:ncol(castSeverityTypeData)],
    2,
    stringToBinary))

save(castSeverityTypeData, file = "data/cast_severity_type.Rdata")
load(file = "data/cast_severity_type.Rdata")

## train dataset
castTrainData <- dcast(
  data = trainData,
  formula = id ~ location,
  value.var = "fault_severity")

castTrainData[, 2:ncol(castTrainData)] <- as.numeric(
  apply(
    castTrainData[, 2:ncol(castTrainData)],
    2,
    stringToValue))

## Save casting datasets into CSV
castDatasets <- c(
  "castEventTypeData",
  "castLogFeatureData",
  "castResourceTypeData",
  "castSeverityTypeData")

## Creacion de variables
foo <- castLogFeatureData
foo <- mutate(foo, sum_log_feat_num = apply(foo[2:387], 1, sum))
foo <- mutate(foo, mean_log_feat_num = apply(foo[2:387], 1, mean))
foo <- mutate(foo, sd_log_feat_num = apply(foo[2:387], 1, sd))
foo <- mutate(foo, median_log_feat_num = apply(foo[2:387], 1, median))

