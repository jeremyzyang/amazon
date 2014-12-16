install.packages("Quandl")
library(Quandl)
install.packages("plyr")
library('plyr')


rm(toy1)


arts <- readLines("C:/Users/Jeremy/Desktop/Workspace/R/amazon/arts.txt",10)
arts[1:5]
arts <- paste("[", paste(arts,collapse=''), "]")
length(arts)
head(arts)

arts

install.packages('RJSONIO')
install.packages('rjson')
require(RJSONIO)
require(rjson)

a <- fromJSON(arts)
a[sapply(a, is.null)] <- NULL
c <- as.data.frame(do.call(rbind, a))



library(stringr)


d <- as.Date(as.POSIXct(as.numeric(as.character(c[,3])), origin="1970-01-01"))

head(d)

###################### split review/helpfulness into two columns

nrow(c)

str1 <- 1:nrow(c)
str2 <- 1:nrow(c)

for (i in 1:nrow(c)) {
str <- strsplit(as.character(d[i,1]),'/')
str <- unlist(str)
str1[i] <- str[1]
str2[i] <- str[2]
}

colnames(c)
c$review.useful <- str1
c$review.total <- str2

head(c)


c <- c[-c(5,6,10)]
colnames(c)
head(c)

############################################

as.POSIXct(val, origin="1970-01-01")

write.csv(c,'C:/Users/Jeremy/Desktop/R_example.csv')
write.table(c, "C:/Users/Jeremy/Desktop/R_example.txt", sep="\t")

f <- read.table("C:/Users/Jeremy/Desktop/arts.txt",sep='\t')

############################################
# parse category data
total <- 2441576
cat <- read.table("C:/Users/Jeremy/Desktop/Workspace/R/e.txt",sep=",",fill=T,quote="\"",comment.char="",colClasses=selection)
cat$V1
dim(cat)
tail(cat,5)

cat.book <- cat[which(cat$V2=='Books'),]
dim(cat.book)

head(cat.book)
head(cat.book$V1,50)
tail(cat$V1,200)
cat[31:33,]

selection = c(rep('character',5),c(rep('NULL',11)))


#############################################
# 

all <- 12,886,488
books.all <- readLines("C:/Users/vsingh/Desktop/amazon/books.txt",all) 

# first 2,000,000 entries
books <- readLines("C:/Users/vsingh/Desktop/amazon/books.txt",n=1000000) 

books_string <- paste("[", paste(books,collapse=""))
books_string

books_sub <- substr(books_string,1,nchar(books_string)-1)
books_sub

books_sub <- paste(books_sub,']')
books_sub

x= 'goodness'
str(x)
x

install.packages('RJSONIO')
install.packages('rjson')
require(RJSONIO)
require(rjson)

b <- fromJSON(books_sub)
class(b)
str(b)

b[sapply(b, is.null)] <- NULL


rm(time)


df <- as.data.frame(do.call(rbind, b))

dim(df)

df


# translate time 

time <- as.Date(as.POSIXct(as.numeric(as.character(df[,3])), origin="1970-01-01"))

head(df)

df[,3] <- time
df[1:5,]

colnames(df)

df <- df[c(-6,-10)]

write.csv(c,'C:/Users/Jeremy/Desktop/R_example.csv')
write.table(c, "C:/Users/Jeremy/Desktop/R_example.txt", sep="\t")

f <- read.table("C:/Users/Jeremy/Desktop/arts.txt",sep='\t')
str(f)


# read a specific line 
selection <- c('NULL','character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',7),'character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',5))
length(selection)

selection.text <- c(rep('NULL',37),'character','NULL')
length(selection.text)

e <- read.table("C:/Users/vsingh/Desktop/amazon/books.txt",nrow=12886488,colClasses=selection)
dim(e)
object_size(e)
class(e)
head(e,20)

t <- read.table("C:/Users/vsingh/Desktop/amazon/books.txt",nrow=12886488,colClasses=selection.text)
dim(t)

id <- 1:nrow(t)
t$id <- id
name <- c('text','id')
colnames(t) <- name

t <- t[c('id','text')]
t[1:5,]

name <- c('profileName','price','time','productID','helpfulness','userID','title','score')
colnames(e) <- name

time <- as.Date(as.POSIXct(as.numeric(as.character(e[,3])), origin="1970-01-01"))
e[,3] <- time

t <- time[time>='2000-01-01']
head(t)
length(t)

e[1:10,5]

nrow(e)
str1 <- 1:nrow(e)
str2 <- 1:nrow(e)

for (i in 1:nrow(e)){
  str <- strsplit(as.character(e[i,5]),'/')
  str <- unlist(str)
  str1[i] <- str[1]
  str2[i] <- str[2]
}

e$helpfulness_useful <- str1
e$helpfulness_total <- str2

head(e,10)
e <- e[-5]

write.csv(e,'C:/Users/vsingh/Desktop/amazon/books.csv')
write.csv(t,'C:/Users/vsingh/Desktop/amazon/books_text.csv')

review <- read.csv("C:/Users/vsingh/Desktop/amazon/books_reviews.csv")
book.review <- review
head(book.review)
dim(book.review)

book.review.t <- book.review[1:5000,]
head(book.review.t)

###### category
selection = c(rep('character',8),c(rep('NULL',8)))
cat <- read.table("C:/Users/vsingh/Desktop/amazon/e.txt",sep=",",fill=T,quote="\"",comment.char="",colClasses=selection)
dim(cat)
head(cat,50)

book.cat <- cat[which(cat$V2=='Books'),]
dim(book.cat)

name <- c('productID','Main_Cat','Sub_Cat1','Sub_Cat2','Sub_Cat3','Sub_Cat4','Sub_Cat5','Sub_Cat6')
colnames(book.cat) <- name
head(book.cat)

book.cat.t <- book.cat[1:2000,]
head(book.cat.t)

book.review.cat <- merge(book.review,book.cat,by='productID')
head(book.review.cat,50)
tail(book.review.cat)

write.csv(book.review.cat,"C:/Users/vsingh/Desktop/amazon/books_reviews_with_cat.csv")

install.packages('dplyr')
require(dplyr)

books.group <- group_by(book.review.cat,productID)

books.group <- mutate(books.group, numReviews=n())
head(books.group)

select(books.group,productID,numReviews)
head(books.group)
book.cat.num <- as.data.frame(books.group)
dim()

write.csv(books.group,"C:/Users/vsingh/Desktop/amazon/books_reviews_with_cat.csv")


s <- "how are you doing"
length(s)

sapply(gregexpr("\\W+", s), length)

###################
## sentiment analysis

###################
## twitter example
install.packages('twitteR',dependencies=T)
library(twitteR)

tweets <- searchTwitter('#abortion',n=1500)

# oauth authentication, find consumerKey and Secret
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"
consumerKey <- "12345pqrst6789ABCD"
consumerSecret <- "abcd1234EFGH5678ijkl0987MNOP6543qrst21"
twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=reqURL,
                             accessURL=accessURL,
                             authURL=authURL)
twitCred$handshake()
registerTwitterOAuth(twitCred)

# define sentiment score function

score.sentiment <- function(sentences, pos.words, neg.words, exc.words, .progress='none')
{
  require(plyr)
  require(stringr)
  
  # we got a vector of sentences. plyr will handle a list or a vector as an "l" for us
  # we want a simple array of scores back, so we use "l" + "a" + "ply" = laply:
  scores = laply(sentences, function(sentence, pos.words, neg.words, exc.words) {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # and convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # exclude stop words
    check <- match(words,exc.words)
    exc.list <-!is.na(check)
    words <-words[!exc.list]
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

positive <- scan('C:/Users/Jeremy/Desktop/Workspace/R/amazon/positive-words.txt',what='character',comment.char=';')
negative <- scan('C:/Users/Jeremy/Desktop/Workspace/R/amazon/negative-words.txt',what='character',comment.char=';')


install.packages('C:/Users/Jeremy/Desktop/Workspace/R/sentiment_0.1.tar.gz', repos = NULL, type="source")
library(tm.plugin.sentiment)
install.packages("quantmod")