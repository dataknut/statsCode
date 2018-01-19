# to fix fuel variable labels in ggplot2's mpg datset
mpgDT <- mpgDT[, fln := ifelse(fl == "p", "premium", NA)]
mpgDT <- mpgDT[, fln := ifelse(fl == "d", "diesel", fln)]
mpgDT <- mpgDT[, fln := ifelse(fl == "r", "regular", fln)]
mpgDT <- mpgDT[, fln := ifelse(fl == "e", "ethanol", fln)]
mpgDT <- mpgDT[, fln := ifelse(fl == "c", "natural_gas", fln)]
