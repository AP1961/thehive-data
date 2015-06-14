source("R/helper.R", TRUE)
source("R/main_cleaned.R", TRUE)

pkgTest("jsonlite")
library(jsonlite)
json <- toJSON(complete_data)
write(json, file = "web/facts.json",
      ncolumns = 1,
      append = FALSE, sep = " ")
