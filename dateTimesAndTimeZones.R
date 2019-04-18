library(lubridate)
message("# Warning: this will mess with your head")

message("Take a time...")
utc_char <- "2016-10-11 13:01:00"

message("Convert", utc_char ," to an R dateTime")
utc_dateTime <- lubridate::ymd_hms(utc_char)
message("Proof:")
utc_dateTime
message("Set tzone to something else - this is very useful when your data is stored in UTC but only makes sense in local time")
lubridate::with_tz(utc_dateTime, tzone = "Pacific/Auckland")

message("You can also force a timezone but be sure you know what you are doing!")
lubridate::force_tz(utc_dateTime, tzone = "Pacific/Auckland")
message("As you can see it took the UTC time and forced it to be the same clock time but in NZ.")
message("This is a different moment in time and is often not what you intended to do...")
message("Got that?")
  
message("Now let's turn the time into a lot of times, but only one moment in time.")
for(tz in OlsonNames()){
  nt <- lubridate::with_tz(utc_dateTime, tzone = tz)
  message(utc_dateTime, " as ", tz, " = ", nt)
}
message(" => Zulu time. Forever. Please")

message(paste0("Brought to you by ", R.version.string, " running on ", R.version$platform ,
             " with help from: "))

citation(package = "lubridate")
