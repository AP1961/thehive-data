source("R/helper.R", TRUE)

pkgTest("jsonlite")
library(jsonlite)
c <- c(1, 2, 3)
toJSON(c)
