# https://arrow-user2022.netlify.app/hello-arrow.html

# Time flies like an arrow, fruit flies like a banana
# do we really need all these loaded?
libs <- c("arrow",
          "dplyr",
          "lubridate",
          "duckdb",
          "stringr",
          "palmerpenguins",
          "tictoc",
          "scales",
          "janitor",
          "fs",
          "ggplot2",
          "ggrepel",
          "sf")

dkUtils::loadLibraries(libs)

# Test on SAVE electricity use data (large dataset)
# https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=8676
path <- "~/Dropbox/data/SAVE/UKDA-SN-8676-1/save_consumption_data/"

save_Wh <- arrow::open_dataset(path, format = "csv")

save_Wh %>%
  head() %>%
  collect()

# Energy = cumulative Wh within bmg_id - you'd forgotten, right? lol
dkUtils::tidyNum(nrow(save_Wh), round = 1)

tic()
# create an arrow table object with just 2018 data
save_2018_Wh <- save_Wh %>%
  mutate( dateTime = cast(recorded_timestamp, timestamp()),
          year = year(dateTime)) %>%
  filter(year == 2018) %>%
  compute()
toc()

dkUtils::tidyNum(nrow(save_2018_Wh), round = 1)

tic()
save_2018_Wh <- save_2018_Wh %>%
  group_by(bmg_id) %>% # do we need to 'arrange' by dateTime here to be sure?
  arrange(bmg_id, dateTime) %>%
  mutate(wh = energy - lag(energy)) %>% # pulls into R so subsequent memory issues
  compute()
toc()

save_2018_Wh %>%
  head() %>%
  collect()

summary(save_2018_Wh)

t <- save_2018_Wh %>%
  mutate(date = date(dateTime)) %>%
  group_by(date) %>%
  summarise(meanEnergy = mean(wh/1000, na.rm = TRUE),
            medianEnergy = median(wh/1000)) %>%
  collect()

ggplot2::ggplot(t, aes(x = date, y = medianEnergy)) +
  geom_point()