##################################################################
#### parse product and review text and write into json format ####
##################################################################

import gzip
import simplejson

# a modified function from http://snap.stanford.edu/data/web-Amazon.html
def parse(filename):
  f = gzip.open(filename, 'r')
  entry = {}
  for l in f:
    l = l.strip()
    colonPos = l.find(':')
    if colonPos == -1:
      yield entry
      entry = {}
      continue
    eName = l[:colonPos]
    rest = l[colonPos+2:]
    entry[eName] = rest
  yield entry

with open ("books.txt","w") as books:
    for e in parse("C:/Users/vsingh/Desktop/amazon/Books.txt.gz"):
        books.write(simplejson.dumps(e)+"\n")
books.close()

# read json format 
with open ("books.txt","rb") as cell:
    string = books.read().replace('\r\n',',')
books.close()

string = '[' + string
string = string[:-4]
string = string + ']'
string[-2000:]

# transform json string into data frame
import pandas as pd # use panda to transform json string to data frame
df = pd.read_json(string)
df.head()


################################
#### parse reviewer profile ####
################################
import urllib2 # read HTML
import re # regular expression

url = 'http://www.amazon.com/gp/pdp/profile/A392B4BSVPD5HK'
req = urllib2.Request(url, headers={'User-Agent' : "Magic Browser"}) 

# 0. name
name = re.findall(r'<title>(.*?)</title>',urllib2.urlopen(req).read())  
''.join(name)
# 1. geographic info
geo = re.findall(r'</span></div><span class="a-size-small a-color-secondary">(.*?)\n',urllib2.urlopen(req).read())  
''.join(geo)
geo
# 2. reviewer ranking
rh = re.findall(r'<span class="a-size-large a-text-bold">(.*?)</span>',urllib2.urlopen(req).read())
rh
# 3. helpfulness vote
hel = re.findall(r'<div class="a-row"><span class="a-size-small a-color-secondary">(.*?)</span>',urllib2.urlopen(req).read())
''.join(hel)[1:-1]
# 4. about me
abt = re.findall(r'<span class="a-size-base"><p>(.*?)</p>',urllib2.urlopen(req).read())
''.join(abt)
abt
# 5. interest (optional)
inter = re.findall(r'<span class="a-size-small">(.*?)\n',urllib2.urlopen(req).read())
''.join(inter)

with open ("userID.txt", "rb") as f:
    userID = f.readlines()
f.close()
len(userID)

url = 'http://www.amazon.com/gp/pdp/profile/'
url = url + userID[0][1:-3]
url

geo=['']*len(userID)
rv=['']*len(userID)
hv=['']*len(userID)
abt=['']*len(userID)
intt=['']*len(userID)

userID[1:10][1:-3]
'http://www.amazon.com/gp/pdp/profile/'+ userID[3][1:-3]

for i in range(0,len(userID)):      
    if userID[i][1:-3] != 'NA':
        try: 
            url = 'http://www.amazon.com/gp/pdp/profile/'
            url = url + userID[i][1:-3]
            req = urllib2.Request(url, headers={'User-Agent' : "Magic Browser"}) 
            s1 = re.findall(r'</span></div><span class="a-size-small a-color-secondary">(.*?)\n',urllib2.urlopen(req).read())  
            s2 = re.findall(r'<div class="a-row"><span class="a-size-small a-color-secondary">(.*?)</span>',urllib2.urlopen(req).read())
            s3 = re.findall(r'<span class="a-size-base"><p>(.*?)</p>',urllib2.urlopen(req).read())
            s4 = re.findall(r'<div class="a-row a-spacing-top-mini"><span class="a-size-small">(.*?)\n',urllib2.urlopen(req).read())            
            geo[i] = ''.join(s1)
            hv[i] = ''.join(s2)[1:-1]
            abt[i] = ''.join(s3)
            intt[i] = ''.join(s4)
            continue
        except Exception:
            geo[i] = 'NA'      
            hv[i]='NA'
            abt[i]='NA'
            intt[i]='NA'
    else: 
        geo[i] = 'NA'
        hv[i]='NA'
        abt[i]='NA'
        intt[i]='NA'
    
len(rv)

geo[0:10]
hv[0:10]
abt[0:10]
intt[0:10]


##############################
#### experiment with nltk ####
##############################

from __future__ import division
import nltk, re, pprint
from nltk import word_tokenize

file1 = open('textmining.txt','rU') # read text file
print file1.read()
for line in file1:
    print(line.strip())
txt = file1.read() # read file into a string object containing the content

type(txt)
len(txt) # how many characters
txt[:75] # first 75 characters

token = word_tokenize(txt) # tokenization: break up string into words and punctuation
type(token)
len(token)
token[:10]

text = nltk.Text(token)
type(text)
text[100:120]

# read HTML
import urllib2
response = urllib2.urlopen("http://www.presidency.ucsb.edu/ws/index.php?pid=101962")
html = response.read()

import os
os.listdir('.')

#sum up
import urllib2
response = urllib2.urlopen("http://www.presidency.ucsb.edu/ws/index.php?pid=101962")
html = response.read()

from bs4 import BeautifulSoup as bs
raw = bs(cl.html).get_text()
print(raw)

token = nltk.wordpunct_tokenize(raw)
text = nltk.Text(tokens) # creat a NLTK text

words = [w.lower() for w in text]
vocab = sorted(set(words))

#strings operations
couplet = """Shall I compare thee to a Summer's day?
Thou are more lovely and more temperate:""" # printout on different lines
print couplet

string1 = "How are "\
         "you"
string2 = " doing!"
string2*3; string1 + string2
string1[0]
string1[-1]

string1.find("are")
string1.replace('H','h')

print ("monty" + " " + "python")
print ('monty ' + 'and' + ' python')

## count freq of letters
from nltk.corpus import gutenberg
raw = gutenberg.raw('melville-moby_dick.txt')
fdist = nltk.FreqDist(ch.lower() for ch in raw if ch.isalpha())
fdist.most_common(5)

##list (string is immutable,list is mutable)
beatles = ['John', 'Paul', 'George', 'Ringo']
beatles[0]
beatles + ['Brian']

del beatles[-1]

##regular expression
import re
wordlist = [w for w in nltk.corpus.words.words('en') if w.islower()]

### '^' matches the start and '$' matches the end
### '\' the following character will be interpreted literally (not special symbol anymore)
### '|' means or
### '?' zero or one previous iterm, means the previous character is optional
### '*' zero or more of previous item
### '+' one or more previoius item
### '{m,n}' the previous item repeat at least m times and at most n times
###'[]' a range of charactors e.g. [aeiou]
### '()' the scope of operators e.g. a(b|c)+ 

[w for w in wordlist if re.search('ed$',w)] # re.research(p,s) find pattern p in string s
[w for w in wordlist if re.search('^..j..t..$',w)] # 8 letter word with 'j' the 3rd and 't' the 6th

sum( 1 for w in wordlist if re.search('^e-?mail$',w)) # find # of 'email' or 'e-mail'

wsj = sorted(set(nltk.corpus.treebank.words()))

regexp = r'^[AEIOUaeiou]+|[AEIOUaeiou]+$|[^AEIOUaeiou]'

def compress(word):
    pieces = re.findall(regexp,word)
    return (''.join(pieces))

english_udhr = nltk.corpus.udhr.words('English-Latin1')
print (nltk.tokenwrap(compress(w) for w in english_udhr[:75]))

rotokas_words = nltk.corpus.toolbox.words('rotokas.dic')
cvs = [cv for w in rotokas_words for cv in re.findall(r'[ptksvr][aeiou]', w)] # put two for loop together
cdf = nltk.ConditionalFreqDist(cvs)
cdf.tabulate()
cdf.plot()

## normalization
def stem(word): # stems
    for suffix in ['ing', 'ly', 'ed', 'ious', 'ies', 'ive', 'es', 's', 'ment']:
        if word.endswith(suffix):
            return word[:-len(suffix)]
    return (word)

## from list to string
silly = ['We', 'called', 'him', 'Tortoise', 'because', 'he', 'taught', 'us', '.']
' '.join(silly)
','.join(silly)

## open and write to a txt file
file1 = open('textmining.txt','rU')
txt = file1.read()
txt

file2 = open('textmining.txt','w')
words = set(nltk.corpus.genesis.words('english-kjv.txt'))
for word in sorted(words):
    file1.write(word + "\n")

raw = 'Red lorry, yellow lorry, red lorry, yellow lorry.'
text = word_tokenize(raw)
fdist = nltk.FreqDist(text)
sorted(fdist)
fdist['Red']

text = nltk.corpus.nps_chat.words() # split data into training dataset and test dataset
cut = int (0.9 * len(text))
training_data,test_data = text[:cut],text[cut:]
text == training_data + test_data
len(training_data)/len(test_data)

words = 'I turned off the spectroroute'.split() # split into words, tokenization splits into symbols
print (words) 
wordlens = [(len(word), word) for word in words] # a list of 2-tuples
print (wordlens)
wordlens.sort()
' '.join(w for (_, w) in wordlens) # join seperate words into one string

import re 
def get_text(file):
    """Read text from a file, normalizing whitespace and stripping HTML markup."""
    text = open(file).read()
    text = re.sub(r'<.*?>', ' ', text)
    text = re.sub('\s+', ' ', text)
    return text
