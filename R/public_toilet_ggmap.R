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
multi_instalation <- function(pkg){
  
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]   # check what packages have been installed and then compared with the input packages to see if they have been installed
  
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)  #only install new packages
}


rm_specialchar_1 <- function(x) {
  substring(x,2,nchar(x))
}  

rm_specialchar_2 <- function(x) {
  substring(x,1,nchar(x)-1)
}  
packages <- c("ggplot2", "dplyr", "reshape2", "RColorBrewer", "scales", "grid","ggmap")
multi_instalation(packages) 
#######################STEP1: GETTING DATASET########################################################
public_toilets <- read.csv('data/public_toilets_2004_2014.csv',header=FALSE,stringsAsFactors=FALSE)
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


View(public_toilets)
###################################STEP2: GGMAP##############################################
myLocation<-"Mt Druitt"
sources<-c("stamen","google","osm","cloudmade")
stamenmaps = c("terrain", "toner", "watercolor")
googlemaps = c("roadmap", "terrain", "satellite", "hybrid")
i=2   #as an example 
k=1
myMap <- get_map(location=myLocation,
                 source=sources[[i]], maptype=googlemaps[[k]], crop=FALSE,zoom=14)
map<-ggmap(myMap) 
map

#############################STEP3: GGPLOT2 TO ADD VALUES##################################
areamap <- map

#View(public_toilets)

lon <- as.data.frame(as.numeric(as.character(public_toilets$long_1)))
names(lon)<-"lon"
lat <- as.data.frame(as.numeric(as.character(public_toilets$lat_2)))
names(lat)<-"lat"
finaldata <- cbind(public_toilets,lon,lat)

View(finaldata)

output1<-  
  areamap +
  geom_point(aes(x = lon, y = lat
                 ,fill = female        
                 ,size = is_open
                 ,color="red"
                 ),data = finaldata)

output2<-output1 + ggtitle("Mt.Druitt public toilets - locations and openning hours") + 
  theme(plot.title = element_text(lineheight=.5, face="bold"))


areamap + geom_point(data=finaldata, aes(x=lon, y=lat), color="blue", size=12, alpha=0.5)






lon <- as.data.frame(as.numeric(as.character(public_toilets$long_1)))
names(lon)<-"lon"
lat <- as.data.frame(as.numeric(as.character(public_toilets$lat_2)))
names(lat)<-"lat"
finaldata <- cbind(public_toilets,lon,lat)


names()
qmplot(lon, lat, data = finaldata,
       colour = I('red'), size = I(3), darken = .3)


class(public_toilets$long_1)
as.numeric(public_toilets$long_1)













