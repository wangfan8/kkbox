library(readr)
library(tidyverse)
library(lubridate)

setwd("~/Dropbox/kkbox/data")
members <- read_csv("members.csv")
sample_submission <- read_csv("sample_submission.csv")
song_extra_info   <- read_csv("song_extra_info.csv")
songs <- read_csv("songs.csv")
train <- read_csv("train.csv")
test  <- read_csv("test.csv") 

dim(train)
length(unique(train$msno))
length(unique(train$song_id))

# we can link song information, member information and train together
train_data <- songs %>% 
              left_join(song_extra_info, by = "song_id") %>%
              right_join(train, by = "song_id") %>%
              left_join(members, by = "msno")

# clean up data with wrong data type and obvious outliers
train_data <- train_data %>%
              mutate(city = as.character(city)
                     , language = as.character(language)
                     , registered_via = as.character(registered_via)) %>%
              mutate(bd = ifelse(bd<=0 | bd > 100, NA, bd)) %>%
              mutate(song_length = ifelse(song_length/6000 > 1440
                                          , 1440
                                          , song_length/6000)) %>%
              mutate(registration_init_time 
                     = ymd(as.character(registration_init_time))) %>%
              mutate(expiration_date
                     = ymd(as.character(expiration_date)))

# use same linking/cleaning methods on test data
test_data <- songs %>% 
  left_join(song_extra_info, by = "song_id") %>%
  right_join(test, by = "song_id") %>%
  left_join(members, by = "msno")

# clean up data with wrong data type and obvious outliers
test_data <- test_data %>%
  mutate(city = as.character(city)
         , language = as.character(language)
         , registered_via = as.character(registered_via)) %>%
  mutate(bd = ifelse(bd<=0 | bd > 100, NA, bd)) %>%
  mutate(song_length = ifelse(song_length/6000 > 1440
                              , 1440
                              , song_length/6000)) %>%
  mutate(registration_init_time 
         = ymd(as.character(registration_init_time))) %>%
  mutate(expiration_date
         = ymd(as.character(expiration_date)))

# initial exploration on one customer

c1 <- train_data %>% 
      filter(msno == 
               "//4hBneqk/4/TtgL1XXQ+eKx7fJTeSvSNt0ktxjSIYE=") %>%
      select(name, target)

# explore different customers and how many songs they listened/re-listened

unique_and_total_songs <- train_data %>% 
                          group_by(msno) %>%
                          summarise(total_songs    = n()
                                    , repeat_songs = sum(target)) %>%
                          mutate(repeat_ratio      = repeat_songs / total_songs)

saveRDS(train_data, "~/Dropbox/kkbox/data/merged_train.rds") 
saveRDS(test_data, "~/Dropbox/kkbox/data/merged_test.rds")

             





             
        

