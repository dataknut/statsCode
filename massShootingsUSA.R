# USA mass shootings
# 'mass' = > 3 fatalities
# Source: https://www.motherjones.com/politics/2012/12/mass-shootings-mother-jones-full-data/

url_csv <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vQBEbQoWMn_P81DuwmlQC0_jr2sJDzkkC0mvF6WLcM53ZYXi8RMfUlunvP1B5W0jRrJvH-wc-WGjDB1/pub?gid=0&single=true&output=csv"
url_gs <- "https://docs.google.com/spreadsheets/d/1b9o6uDO18sLxBqPwl_Gh9bnhW-ev_dABH83M5Vb5L8o/"

local_xlsx <- "~/Dropbox/data/Mother Jones - Mass Shootings Database, 1982 - 2022.xlsx"
  
library(data.table)
library(ggplot2)
library(googlesheets4)
library(lubridate)
library(readxl)

df <- googlesheets4::read_sheet(url_gs)
df_csv <- read.csv(url_csv)
df_xlsx <- readxl::read_xlsx(local_xlsx) # had to manually reformat dates in most recent data :-(

head(df_xlsx$date)

dt <- data.table::as.data.table(df_xlsx)
dt[, dv_date := lubridate::date(date)] 
dt[, dv_year := lubridate::year(dv_date)]
# check
table(dt$dv_year, useNA = "always")

annual <- dt[, .(nMassShootings = .N,
                 nFatalities = sum(as.numeric(fatalities), na.rm = TRUE),
                 nInjured = sum(as.numeric(injured), na.rm = TRUE),
                 total_victims = sum(as.numeric(total_victims), na.rm = TRUE)),
             keyby = .(dv_year)]

ggplot2::ggplot(annual, aes(x = dv_year, y = nMassShootings)) +
  geom_smooth() +
  geom_point(aes(size = total_victims, 
                 colour = nFatalities)) +
  scale_color_continuous(low = "green", high = "red") +
  labs(caption = paste0("Data source: https://www.motherjones.com/politics/2012/12/mass-shootings-mother-jones-full-data/",
                        "\nBeware changes to counting methods & definitions")
       )

