#Project: data research on disability data
#Author: Rachel Huang
#Date:20150613
################################################################################
#checking files
wd<-getwd()
list.files(wd)

#install packages:
pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

pkgTest("xlsx")

#create an empty folder to hold all data
folder <- function(folder.name){  
  FN <- substitute(folder.name)
  FN <- as.character(FN)
  x <- paste(getwd(),"/", FN, sep="")
  dir.create(x)
}

folder(data)

#files in the data folder
list.files(paste0(wd,"/data"))

#read data
autisum_2012_file <- read.xlsx("data/absdata_autisum_2012.xls",6)
assistance_2012_file <- read.xlsx("data/absdata_needforassistance_2012.xls",1)
assistance_2012_headers <- assistance_2012_file[,6]
assistance_2012_headers
x <- read.xlsx('data/absdata_needforassistance_2012.xls',2,header=FALSE)
,skip=4) 

# Trivial change





