install.packages('gender')
library(gender)

getwd()
setwd('/Users/jeremyyang/Documents/R/data')

# get top reviewers based on our data set
#data = read.csv('book_final.csv')
#data = read.csv('app_final.csv')
data = read.csv('clothing_final.csv')


head(data)

data <- data[,c('name','userID','total_reviews_user')]
data <- data[order(-data$total_reviews_user),] 
data <- unique(data)
data <- data[!duplicated(data[,'userID']),]

head(data)
dim(data)

library(stringr)
name <- strsplit(as.character(data$name),' ')
name <- sapply(name, function(l) l[1])
name <- str_replace_all(name, "[^a-zA-Z]", "")
name <- str_to_lower(name)

name[1:20]


# gen <- function(name){
#         df <- as.data.frame(gender(name)[2:4])
#         if (dim(df)[1]==0){
#                 df[1,1]<-NA
#                 df[1,2]<-NA
#                 df[1,3]<-NA
#                 return(df)
#         } else {
#                 return(df)
#         }
# }

# test <- do.call("rbind", test)

gen <- as.data.frame(gender(name))
gen <- gen[!duplicated(gen[,'name']),]

dim(gen)
head(gen)

data$firstname <- name

head(data)
head(gen)

final <- merge(data,gen,by.x='firstname',by.y='name',all.x=T)
final <- final[order(-final$total_reviews_user),]

head(final)
tail(final)

dim(final)
final <- final[,-c(8:9)]

write.csv(final,'gender_clothing.csv',row.names=F)

do.call('rbind',df)
