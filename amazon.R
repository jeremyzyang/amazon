###################################
#### cleaning and manipulation ####
###################################

#### read json text and transform to data frame
install.packages('RJSONIO')
install.packages('rjson')
require(RJSONIO)
require(rjson)

cell_all <- readLines("C:/Users/vsingh/Desktop/amazon/cell_phone.txt") # specify the path  
cell_string <- paste("[", paste(cell_all,collapse=",")) # modify the format
cell_sub <- substr(cell_string,1,nchar(cell_string)-3)
cell_sub <- paste(cell_sub,']')

x <- substr(cell_sub,1,2000);x # check the head of json string
y <- substr(cell_sub,nchar(cell_sub)-2000,nchar(cell_sub));y # check the tail of json string

cell <- fromJSON(cell_sub) # json string to data frame
cell[sapply(cell, is.null)] <- NULL
cell.df <- as.data.frame(do.call(rbind, cell))

dim(cell.df) # check the dimension and the head
head(cell.df)

cell.df[,3] <- as.Date(as.POSIXct(as.numeric(as.character(cell.df[,3])), origin="1970-01-01")) # translate unix time to real time
cell.df[1:5,] 
colnames(cell.df) # check variable names

write.csv(c,'C:/Users/Jeremy/Desktop/R_example.csv') # write data frame into csv

#### read only specified columns (separate review text from other variables) to avoid buffer overflow
selection <- c('NULL','character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',7),'character',rep('NULL',3),'character',rep('NULL',3),'character',rep('NULL',5))
length(selection)
selection.text <- c(rep('NULL',37),'character','NULL')
length(selection.text)

e <- read.table("C:/Users/vsingh/Desktop/amazon/books.txt",nrow=12886488,colClasses=selection); dim(e)
object_size(e); class(e)
head(e,20)

t <- read.table("C:/Users/vsingh/Desktop/amazon/books.txt",nrow=12886488,colClasses=selection.text); dim(t)

#### cleaning and reformatting the data frame 
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

##### process category info and merge with review data
selection = c(rep('character',8),c(rep('NULL',8)))
cat <- read.table("C:/Users/vsingh/Desktop/amazon/cat.txt",sep=",",fill=T,quote="\"",comment.char="",colClasses=selection)

cell.cat <- cat[which(cat$V2=="Books"),]
dim(cell.cat)
table(cell.cat$V6)

name <- c('productID','Main_Cat','Sub_Cat1','Sub_Cat2','Sub_Cat3','Sub_Cat4','Sub_Cat5','Sub_Cat6')
colnames(book.cat) <- name

book.review.cat <- merge(book.review,book.cat,by='productID')
head(book.review.cat,50)
tail(book.review.cat)

write.csv(book.review.cat,"C:/Users/vsingh/Desktop/amazon/books_reviews_with_cat.csv")

#### add a new variable as #review count for each productID
install.packages('dplyr')
require(dplyr)

book.reviews.cat <- read.csv("C:/Users/vsingh/Desktop/amazon/books_reviews_with_cat.csv")
books.group <- group_by(book.reviews.cat,productID)
dim(book.reviews.cat)

books.group <- mutate(books.group, numReviews=n())
head(books.group)

select(books.group,productID,numReviews)
head(books.group)
book.cat.num <- as.data.frame(books.group)
dim(book.cat.num)

write.csv(book.reviews.cat.new,"C:/Users/vsingh/Desktop/amazon/books_reviews_with_cat_new.csv")

head(book.reviews.cat)
book.reviews.cat.new <- book.reviews.cat[,-c(1,4,7)]
head(book.reviews.cat.new)

save <- book.reviews.cat.new[which(book.reviews.cat.new$price!='unknown'),]
head(save)
head(book.reviews.cat.new)

write.csv(book.reviews.cat.new,"C:/Users/vsingh/Desktop/amazon/books_with_price.csv")

check <- read.csv("C:/Users/vsingh/Desktop/amazon/books_with_price.csv"); dim(check)
check2 <- check[which(check$price!='unknown'),]

#### add a kindle version dummy for each productID 
table(books$Sub_Cat1) # Politics & Social Sciences
table(books$Sub_Cat2)
table(books$Sub_Cat3) # Kindle eBooks
table(books$Sub_Cat4) # Kindle Store
table(books$Sub_Cat5) 
table(books$Sub_Cat6) 

politics.kindle <- politics[which(politics$Sub_Cat3=="Kindle Store"|politics$Sub_Cat3=="Kindle eBooks"|politics$Sub_Cat4=="Kindle Store"|politics$Sub_Cat4=="Kindle eBooks"|politics$Sub_Cat5=="Kindle Store"|politics$Sub_Cat5=="Kindle eBooks"|politics$Sub_Cat6=="Kindle Store"|politics$Sub_Cat6=="Kindle eBooks"),]
head(politics.kindle)
dim(politics.kindle)

index <- rep(0,nrow(politics))
for (i in 1:nrow(politics)) {
  index[i] <- isTRUE(politics$Sub_Cat3[i]=="Kindle Store"|politics$Sub_Cat3[i]=="Kindle eBooks"|politics$Sub_Cat4[i]=="Kindle Store"|politics$Sub_Cat4[i]=="Kindle eBooks"|politics$Sub_Cat5[i]=="Kindle Store"|politics$Sub_Cat5[i]=="Kindle eBooks"|politics$Sub_Cat6[i]=="Kindle Store"|politics$Sub_Cat6[i]=="Kindle eBooks")
}

w <- which(politics$Sub_Cat3=="Kindle Store"|politics$Sub_Cat3=="Kindle eBooks"|politics$Sub_Cat4=="Kindle Store"|politics$Sub_Cat4=="Kindle eBooks"|politics$Sub_Cat5=="Kindle Store"|politics$Sub_Cat5=="Kindle eBooks"|politics$Sub_Cat6=="Kindle Store"|politics$Sub_Cat6=="Kindle eBooks")
politics[which(politics$productID=='B000FBFDY2'),]
p <- politics[which(politics$price!='unknown'),]

for (i in 1:nrow(politics)) {
  index[i] <- is.element(politics$productID[i],politics.kindle$productID)
}

#### add the review text back 
politics.reviews <- merge(politics,review.text,by='X')
dim(politics.reviews)
head(politics.reviews)

politics.reviews <- politics.reviews[,-18]
write.csv(politics.reviews,'C:/Users/vsingh/Desktop/amazon/books_politics.csv')

###########################
#### sentiment analysis ###
###########################

#### work with review text
review.text <- read.csv('C:/Users/vsingh/Desktop/amazon/books_reviews_text.csv')
dim(review.text)
text <- as.character(review.text[,3])

corpus <- Corpus(VectorSource(text))
dtm <- DocumentTermMatrix(corpus)

#### use tm.plugin.sentiment for sentiment analysis
install.packages('quantmod')
install.packages('tm')
library(tm) 
install.packages('C:/Users/vsingh/Desktop/amazon/tm.plugin.sentiment_0.0.1.zip', repos = NULL, type="source")
library(tm.plugin.sentiment)

#### sample code 
install.packages("tm.lexicon.GeneralInquirer", repos="http://datacube.wu.ac.at", type="source")
require("tm.lexicon.GeneralInquirer")
tm_term_score(TermDocumentMatrix(corpus,
                                 control = list(removePunctuation = TRUE)),
              terms_in_General_Inquirer_categories("Positiv"))

positive <- as.numeric(tm_term_score(dtm,terms_in_General_Inquirer_categories("Positiv"))) 
negative <- as.numeric(tm_term_score(dtm,terms_in_General_Inquirer_categories("Negativ"))) 

#### a different method from https://github.com/mjhea0/twitter-sentiment-analysis
# define sentiment score function
score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  
  # we got a vector of sentences. plyr will handle a list or a vector as an "l" for us
  # we want a simple array of scores back, so we use "l" + "a" + "ply" = laply:
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
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
    # check <- match(words,exc.words)
    # exc.list <-!is.na(check)
    # words <-words[!exc.list] 
    
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

# read word lists
positive <- scan('C:/Users/vsingh/Desktop/amazon/positive-words.txt',what='character',comment.char=';')
negative <- scan('C:/Users/vsingh/Desktop/amazon/negative-words.txt',what='character',comment.char=';')

score <- score.sentiment(text,positive,negative)
class(score)
dim(score)
score 

############################
#### reviewer's profile ####
############################

politics <- books[which(books$Sub_Cat1==" Politics & Social Sciences"),]
userID <- politics[,6]
head(userID)
userID[userID=='unknown '] <- NA
write.table(unique(userID),'C:/Users/vsingh/Desktop/amazon/userID.txt',row.names=F,col.names=F)
length(userID[userID!='NA'])
length(unique(userID))

require(dplyr)
politics.group <- group_by(politics,userID)
politics.group <- mutate(politics.group,numReviews_user=n())
head(politics.group,10)

length(books$userID[which(books$userID=='A3H6RDFFMA9MM2')])
books[which(books$userID=='A3H6RDFFMA9MM2'),]
books$userID[books$userID=='unknown'] <- 'NA'
books.group <- group_by(books,userID)
books.group <- mutate(books.group,numReviews_user=n())
bg <- as.data.frame(books.group)
max(bg$numReviews_user)
head(bg,20)
bg$userID[bg$userID=='unknown'] <- 'NA'
bg$userID[8]

length(unique(bg$userID))
length(unique(bg$userID[bg$numReviews_user>=27]))
userID <- unique(bg$userID[bg$numReviews_user>=27])
userID <- as.data.frame(userID)
dim(politics)
length(unique(userID$userID))
