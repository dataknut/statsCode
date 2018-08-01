library(lubridate)
print("This will mess with your head")

print("Take a time...")
utc_char <- "2016-10-11 13:01:00"
utc_char
utc_dateTime <- lubridate::ymd_hms(utc_char)
utc_dateTime
lubridate::with_tz(utc_dateTime, tzone = "Pacific/Auckland")

lubridate::date(utc_dateTime)

lubridate::with_tz(date(utc_dateTime), tzone = "Pacific/Auckland")
print("That should be the day before.")

lubridate::date(with_tz(utc_dateTime, tzone = "Pacific/Auckland"))
print("Yay. Order matters")

print("Now let's turn the time into a lot of times, but only one moment in time.")
for(tz in OlsonNames()){
  nt <- lubridate::with_tz(utc_dateTime, tzone = tz)
  print(paste0(utc_dateTime, " as ", tz, " = ", nt))
}
print("Zulu time. Forever. Please")

print(paste0("Brought to you by ", R.version.string, " running on ", R.version$platform ,
             " with help from: "))
citation(package = "lubridate")
