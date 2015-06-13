library(ggmap)
sfMap=map=get_map(location="Australia",zoom=4)
ggmap(sfMap)


library(rgdal)
library(ggplot2)
getwd()
setwd()
sfn=readOGR("C:/Users/rachel/Documents/On the house/Maps/1270055001_sa1_2011_aust_shape","SA1_2011_AUST") %>% spTransform(CRS("+proj=longlat +datum=WGS84"))
ggplot(data = sfn, aes(x = long, y = lat, group = group)) + geom_path()

class(sfn)
names(sfn)


###Create values (fake value in this example) to plot on the map later
#so in the real example, we can fit in any value, such as income of the Long and Lat
sfn.f = sfn %>% fortify(region = 'SA1_MAIN11')
AU = merge(sfn.f,sfn@data,by.x='id',by.y='SA1_MAIN11')

library(dplyr)

postcodes = AU %>% select(id) %>% distinct()
values = data.frame(id = c(postcodes),
                    value = c(runif(postcodes %>% count() %>% unlist(),5.0, 25.0)))
sf = merge(AU, values, by.x='id')
sf %>% group_by(id) %>% do(head(., 1)) %>% head(10)

###plot 

ggplot(sf, aes(long, lat, group = group)) + geom_polygon(aes(fill = value))
