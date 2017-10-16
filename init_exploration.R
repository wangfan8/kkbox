library(archive) # handle downloaded 7z file 
library(readr)
library(tidyverse)

setwd("./data")
members <- read_csv("members.csv")
sample_submission <- read_csv("sample_submission.csv")
song_extra_info   <- read_csv("song_extra_info.csv")
songs <- read_csv("songs.csv")
train <- read_csv("train.csv")

dim(train)
length(unique(train$msno))
length(unique(train$song_id))

# we can link song information, member information and train together

train_data 

