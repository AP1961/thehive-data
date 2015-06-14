#Project: data research on mt druitt data
#Author: Rachel Huang
#Date:20150613
###############################STEP0:INSTALL PACKAGES###########################################
#checking files
wd<-getwd()
list.files(wd)

#install packages:
source("R/helper.R", TRUE)
source("R/dbpedia.R", TRUE)

pkgTest("xlsx")
################################STEP1: FUNCTIONS###################################################
rm_specialchar_1 <- function(x) {
  substring(x,2,nchar(x))
}  

rm_specialchar_2 <- function(x) {
  substring(x,1,nchar(x)-1)
}  
##########################STEP2:DATA EXPLORATION######################################################

## to create a gigantic table by area (lethbridge park, mt. druitt, .....) to 
## include education, demographics, train services, public toilets, nearest train stations
## in future, we can roll this out to all areas of the country. (potential features of the model to predict the success of the business)
##View(insolvency)
#insolvency by postcode
#link key: post code

##View(education)
# education provider of the suburbs
# link key: suburb names

##View(demographic) 
#population: gender proportion, age groups, suburb names, latitute and longitute
#link key: suburb names

##View(mesh_block_census)  
#SA1,2,3,4 data  total dwellings of  the area, area names
#link key: area names


##cross join these two tables
##View(railway_lines) 
#railline
##View(railway_stations)
#rail way stations

##View(public_toilets)
#public toilet info in the area
# link key: suburb names (the column name is town)
## dplyr to group by suburb names 

##########################STEP3 CLEAN AND MERGE DATASETS######################################
#3.1: DEMOGRAPHIC DATASET
#read data
demographic <- read.csv('data/demographic_variables_by_pbc_2013.csv',header=FALSE)

#rename the dataset
names(demographic)<-c("suburb_name","age75_","poll_id","state","male_proportion",
          "age35_44","age45_59","long_1","lat_1","long_2","lat_2",
          "age0_17","age18_22","age23_34","age60_74")

#drop first row
demographic <-demographic[-1,]

#drop special characters
long_1 <- as.data.frame(apply(as.data.frame(demographic$long_1),1, rm_specialchar_1))
names(long_1)<-"long_1"
lat_2 <- as.data.frame(apply(as.data.frame(demographic$lat_2),1, rm_specialchar_2))
names(lat_2)<-"lat_2"
drops <- c("long_1","lat_2")
demographic <-demographic[,!(names(demographic) %in% drops)]
demographic <-cbind(demographic,long_1,lat_2)


#3.2: EDUCATION DATASET
education <- read.csv('data/early_childhood_education_and_care.csv',header=TRUE)
education <- apply(education,2,function(x)tolower(x))
education <- as.data.frame(education,header=TRUE)   

 require(plyr)
 require(stringr)
education[,c(1:23)] <- colwise(str_trim)(education[, c(1:23)])                  #education raw data for maps

education_summary <- education %>%
  group_by(suburb) %>%
  dplyr::summarize(child_education_provider = n())

education_summary <-as.data.frame(education_summary)

#3.3: MESH BLOCK (# not sure how to use this one yet)
# head(mesh_block_census,2)
# unique(mesh_block_census$sa2_name11)
# str(mesh_block_census)

##3.4: PUBLIC TOILETS 
public_toilets <- read.csv('data/public_toilets_2004_2014.csv',header=FALSE)
names(public_toilets) <-c("parking","state","address","faility_type",
                          "icon_alt_text","sanitary_disposal",
                          "accessible_unisex","last_update_date","location_name",
                          "baby_change","parking_accessible","showers","toilet_type",
                          "is_open","sharps_disposal","accessible_female","status","opening_hours_note",
                          "accessible_note","male","payment_required","parking_note"
                          ,"accessible_parking_note","post_code","key_required","accessible_female",
                          "mlak","access_note","long_1","lat_1","long_2","lat_2",
                          "female","address_note","access_limited","opening_hours_scheduale",
                          "unisex","drinking_water","suburb_name","notes")

public_toilets <-public_toilets[-1,]

long_1 <- as.data.frame(apply(as.data.frame(public_toilets$long_1),1, rm_specialchar_1))
names(long_1)<-"long_1"
lat_2 <- as.data.frame(apply(as.data.frame(public_toilets$lat_2),1, rm_specialchar_2))
names(lat_2)<-"lat_2"

drops <- c("long_1","lat_2")
public_toilets <-public_toilets[,!(names(public_toilets) %in% drops)]
public_toilets <-cbind(public_toilets,long_1,lat_2)

public_toilets_summary <- public_toilets %>%
  group_by(suburb_name) %>%
  dplyr::summarize(total_public_toilet = n())


#3.5 SOCIOECONOMIC DATASET
socioeconomic <-read.csv('data/socioeconomic_variables_by_pbc.csv',header=FALSE)
names(socioeconomic) <-c("buy_house","dis_ser_","ot_ch_","islamic","lone_p_h","la_for_",
                         "man_proportion","pentec_","uk","h_degree","trans_in","own_house","unemployment","catholic","overseas","add_ss_",
                         "c_no_c_h","suburb_name","c_diploma","no_religion","rent_house","soc_ser_","rou_pro_w_","se_eu","ex_in_","addre_5","o_n_c_r"
                         ,"d599_","per_ser","cwch","indigenous","state","poll_id","opfh","long_1","lat_1","long_2","lat_2","d600_2499","public_housing",
                         "m_east","anglican","internet","d2500","bus_fin","asia","inpsw")

socioeconomic<-socioeconomic[-1,]
long_1 <- as.data.frame(apply(as.data.frame(socioeconomic$long_1),1, rm_specialchar_1))
names(long_1)<-"long_1"
lat_2 <- as.data.frame(apply(as.data.frame(socioeconomic$lat_2),1, rm_specialchar_2))
names(lat_2)<-"lat_2"


drops <- c("long_1","lat_2")
socioeconomic <-socioeconomic[,!(names(socioeconomic) %in% drops)]
socioeconomic <-cbind(socioeconomic,long_1,lat_2)



##################################STEP4: COMBINE CLEANED DATA##################################
#4.1 TRIM ALL DATASETS
socioeconomic[,c(1:ncol(socioeconomic))] <- colwise(str_trim)(socioeconomic[, c(1:ncol(socioeconomic))])   
public_toilets[,c(1:ncol(public_toilets))] <- colwise(str_trim)(public_toilets[, c(1:ncol(public_toilets))])
demographic[,c(1:ncol(demographic))] <- colwise(str_trim)(demographic[, c(1:ncol(demographic))])
public_toilets_summary[,c(1:ncol(public_toilets_summary))] <- colwise(str_trim)(public_toilets_summary[, c(1:ncol(public_toilets_summary))])

#4.2 MELT ALL DATASETS
melt_socioeconomic <- melt(socioeconomic,id=c("state","poll_id","suburb_name"))
melt_education_summary <- melt(education_summary,id=c("suburb"))
melt_demographic <- melt(demographic,id=c("state","poll_id","suburb_name"))
melt_public_toilets_summary <- melt(public_toilets_summary,id=c("suburb_name"))

#4.3 REMOVE EXTRA COLUMNS
melt_socioeconomic <-melt_socioeconomic[,-c(1,2)]
melt_demographic <-melt_demographic[,-c(1,2)]

#4.4 RENAME COLUMN NAMES BEFORE RBINDING THEM
names(melt_socioeconomic) <-c("location","key","value")
names(melt_education_summary) <-c("location","key","value") 
names(melt_demographic) <-c("location","key","value")  
names(melt_public_toilets_summary) <-c("location","key","value") 

#4.5 BIND ALL THE DATASETS 
all_data <- rbind(melt_socioeconomic,melt_education_summary,melt_demographic,melt_public_toilets_summary)
#View(all_data)
#write.csv(all_data,file="rachelsdata.csv")


#################################STEP FINAL: CONSOLIDATE DATASETS###################
# Liam's data
dbpediaResults <- generateResults()
#colnames(dbpediaResults)

dbpediaResults <- select(dbpediaResults,location,p,o)
names(dbpediaResults) <-c("location","key","value")

complete_data <- rbind(all_data,dbpediaResults)
#write.csv(complete_data,file="complete_data.csv")



