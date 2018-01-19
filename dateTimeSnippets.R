# add weekdays to a DT
DT$r_wday <- as.POSIXlt(DT$t_datetime)$wday # 0 = Sunday

DT$r_dow <- factor(DT$r_dow,
                   labels = c(
                     "Sunday",
                     "Monday",
                     "Tuesday",
                     "Wednesday",
                     "Thursday",
                     "Friday",
                     "Saturday"
                   )
)


# add  months
DT$r_month <- as.POSIXlt(DT$r_epstart)$mon # 0 = January

DT$r_month <- factor(DT$r_month,
                     labels = c(
                       "January", # 0
                       "February",
                       "March",
                       "April",
                       "May",
                       "June",
                       "July",
                       "August",
                       "September",
                       "October",
                       "November",
                       "December" # 11 !
                     )
)

# add seasons

DT$season <- ifelse(DT$r_month > 1 & DT$r_month < 5, # Mar,Apr,May
                    "Spring", NA
)
DT$season <- ifelse(DT$r_month > 4 & DT$r_month < 8, # Jun,Jul,Aug
                    "Summer", DT$season
)
DT$season <- ifelse(DT$r_month > 7 & DT$r_month < 11, # Sep, Oct, Nov
                    "Autumn", DT$season
)
DT$season <- ifelse(DT$r_month == 11 | # Dec, Jan, Feb
                      DT$r_month == 0 | 
                      DT$r_month == 1 ,
                    "Winter", DT$season
)