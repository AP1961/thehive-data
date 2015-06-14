##############################
##ggmap public toilet data
############################

##############################STEP0: PACKAGES####################################################
pkgTest("xlsx")
pkgTest("dplyr")
pkgTest("plyr")
pkgTest("reshape2")
pkgTest("data.table")
pkgTest("ggplot2")
pkgTest("stringr")
################################STEP1: FUNCTIONS###################################################
rm_specialchar_1 <- function(x) {
  substring(x,2,nchar(x))
}  

rm_specialchar_2 <- function(x) {
  substring(x,1,nchar(x)-1)
}  
#######################STEP1: GETTING DATASET########################################################
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

###################################STEP2: GGMAP##############################################