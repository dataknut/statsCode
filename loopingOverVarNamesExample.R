vars <- c("sleep", "personal","food")
for(i in vars)
{
  print(paste0("Processing: ", i))
  DT[[paste0("anyDA_",i,"_m")]] <- ifelse(DT[[paste0("da_",i,"_m")]] > 0,
                                          1, # at least 1 episode
                                          0)
  
  DT[[paste0("anyDA_",i,"_s")]] <- ifelse(DT[[paste0("da_",i,"_s")]] > 0,
                                          1, # at least 1 episode
                                          0)
}

files = c(Clamp = "wmgClampDT", SmartPlug = "wmgSmartPlugDT")

for(i in names(files))
{
  ofile <- paste0(odpath, "all", i ,"sProcessed_updated_",
                  Sys.Date(),
                  ".csv")
  print(paste0("Saving processed DT to: ", ofile, ".")
  )
  print("Variables saved:")
  print(
    names(
      eval(
        parse(text = files[[i]]) # surely has to be an easier way than this?!
      )
    )
  )
  
  write.csv(eval(parse(text = files[[i]])), # condensed version of the above
            file = ofile, row.names = FALSE
  )
  print("Now gzip that file")
  cmd <- paste0("gzip -f ", ofile," &")
  system(cmd) # gzip & force over-write, shame can't do this directly as part of write
}