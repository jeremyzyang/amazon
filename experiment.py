############################################################################
#get text from webpage

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

#############################################
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

# back to basic python

## equality
python =['python']
list1 = python * 2
    
list1[0] == list1[1] # '==' requires the value be the same
list1[0] is list1[1] # 'is' requires identical objects

id(list1[0])
id(list1[1])

## conditionals

mixed = ['cat', '', ['dog'], []]
for element in mixed:
    if element:
        print(element)
        
animals = ['cat', 'dog']
if 'cat' in animals:
    print(1)
elif 'dog' in animals: # skip the 'elif' part if the condition of 'if' is satisfied
    print(2)
        
all(len(w)>2 for w in animals)
any(len(w)>3 for w in animals)

## sequence
t = 'walk','fem',3 # tuple
t[0]
len(t)

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

## function
import re 
def get_text(file):
    """Read text from a file, normalizing whitespace and stripping HTML markup."""
    text = open(file).read()
    text = re.sub(r'<.*?>', ' ', text)
    text = re.sub('\s+', ' ', text)
    return text

## python graphing
import matplotlib


## extracting text from Craigslist

import urllib2
response = urllib2.urlopen("http://www.presidency.ucsb.edu/ws/index.php?pid=101962")

html = response.read()
cl = urllib2.urlopen('http://newyork.craigslist.org/brk/mob/4723679834.html')
cl.html = cl.read()

print (cl.html)
