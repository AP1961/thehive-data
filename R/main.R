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
################################################################################
#read abs data
autisum_2012_file <- read.xlsx("data/absdata_autisum_2012.xls",6)
assistance_2012_file <- read.xlsx("data/absdata_needforassistance_2012.xls",1)
assistance_2012_headers <- assistance_2012_file[,6]
assistance_2012_headers
x <- read.xlsx('data/absdata_needforassistance_2012.xls',2,header=FALSE)
,skip=4) 

#read Liam's data
#fix this function later
# read_files <- function(x,y) {
#                                 x <- read.csv(y,header=TRUE)                               
#                              }
# x = 
# y = 'location_quotient_by_pbc_2013.csv'
# read_files(x,y)


insolvency <- read.csv('data/aus_personal_insolvency_activity.csv',header=TRUE)
demographic <- read.csv('data/demographic_variables_by_pbc_2013.csv',header=FALSE)
education <- read.csv('data/early_childhood_education_and_care.csv',header=TRUE)
mesh_block_census <- read.csv('data/mb_mesh_block_2011_census.csv',header=TRUE)
railway_lines <- read.csv('data/psma_railway_lines.csv',header=TRUE)
railway_stations <- read.csv('data/psma_railway_stations.csv',header=TRUE)
public_toilets <- read.csv('data/public_toilets_2004_2014.csv',header=FALSE)
socioeconomic <-read.csv('data/socioeconomic_variables_by_pbc.csv',header=FALSE)
str(demographic)

## to create a gigantic table by area (lethbridge park, mt. druitt, .....) to 
## include education, demographics, train services, public toilets, nearest train stations
## in future, we can roll this out to all areas of the country. (potential features of the model to predict the success of the business)
View(insolvency)
#insolvency by postcode
#link key: post code

View(education)
# education provider of the suburbs
# link key: suburb names

View(demographic) 
#population: gender proportion, age groups, suburb names, latitute and longitute
#link key: suburb names

View(mesh_block_census)  
#SA1,2,3,4 data  total dwellings of  the area, area names
#link key: area names


##cross join these two tables
View(railway_lines) 
#railline
View(railway_stations)
#rail way stations

View(public_toilets)
#public toilet info in the area
# link key: suburb names (the column name is town)
## dplyr to group by suburb names 

##########################CLEAN AND MERGE DATASETS######################################

#View(education),View(demographic),View(mesh_block_census) 
#summarise by suburb names
head(demographic,2)
#rename the dataset
rename_1<-c("suburb names","age75_","poll_id","state","male_proportion",
          "age35_44","age45_59","long_1","lat_1","long_2","lat_2",
          "age0_17","age18_22","age23_34","age60_74")
        
demographic <-demographic[-1,]
names(demographic)<-rename_1
remove_function <- function(x) {
                                  gsub("[[:punct:]]", "", x)
                                }  #change to regex code later






