#####################################################################
#Project name: Wizard Turtle
#Package chosen: ggmap and ggplot2
#Author: Rachel Huang
#Date: 20150411

#####################################################################

#######################################################functions##########################################################################################

####Function1:  install and load multiple packages####

multi_instalation <- function(pkg){
  
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]   # check what packages have been installed and then compared with the input packages to see if they have been installed
  
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)  #only install new packages
}


####Function2:  ggmap####


#######################################################Initiate functions#################################################################################
# packages<- c("munsell")
# multi_instalation(packages)  #run line 27, 28 first if the below 30 and 31 are not working

packages <- c("ggplot2", "dplyr", "reshape2", "RColorBrewer", "scales", "grid","ggmap")
multi_instalation(packages)  #install and load packages


############## ABS data plot######################################
##read dataset (state is a temporary variable, added by Rachel Huang for testing purpose)
ABS<-read.csv("02.ABSData_master.csv",header=TRUE)

##Find an area map
#method 1: use area name to locate map
myLocation<-"SYDNEY"
sources<-c("stamen","google","osm","cloudmade")
stamenmaps = c("terrain", "toner", "watercolor")
googlemaps = c("roadmap", "terrain", "satellite", "hybrid")
i=2   #as an example 
k=1
myMap <- get_map(location=myLocation,
                 source=sources[[i]], maptype=googlemaps[[k]], crop=FALSE,zoom=7)
map<-ggmap(myMap) 

#Method2: Locate maps based specific long and lat  (to be converted to lon and lat range) 
# lat_1=-37.10475  
# lon_1=149.8790
# map<-get_map(location = c(lon =lon_1 , lat =lat_1 ),
#              zoom = 12, scale = "auto",
#              maptype = "roadmap",
#              messaging = FALSE, urlonly = FALSE,
#              filename = "NSW", crop = TRUE,
#              color = c("color"),
#              source = "google")
# map<-ggmap(map)


##subset data from ABS dataset
data <- subset(ABS,state=="NSW")

## to show the map
areamap <- map

## to add the mediuan mortgage repayment monthly on the map
output1<-
  
areamap +
geom_point(aes(x = longtitude, y = latitude
,fill = Median_Tot_fam_inc_weekly        
,size = Median_Tot_fam_inc_weekly

),data = data)

output2<-output1 + ggtitle("Weekly income") + 
  theme(plot.title = element_text(lineheight=.5, face="bold"))

#output2 + scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9","#E69F00", "#56B4E9"),name="Experiment"))

########### to do
#locate lat and long range instead of points (after knowing specific project requirements)
#add more fancy color and styles 
#






