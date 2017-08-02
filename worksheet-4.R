## Tidy data concept

response <- data.frame(
  trial = 1:3,
  treatment = c(0.22, 0.58, 0.31),
  control = c(0.42, 0.19, 0.40)
)

## Reshaping multiple columns in category/value pairs

library(tidyr)

df <- gather(response, key="factor",value="response", -trial)

counts <- data.frame(
  site = rep(1:3, each = 2),
  species = rep(c("lynx", "hare"), 3),
  n = c(2, 341, 7, 42, 0, 289)
)

counts_spread <- spread(counts,
			key=species,
			value=n)

## Exercise 1
df2<-counts[-5,]
#with brackets, everything is row,column. So leaving column blank means 
#take away everything that is in that row
spread(df2, key=species, value=n)
#turns your zero into NA
spread(df2, key=species, value=n, fill=0)
#default value for missing data is NA, fill tells you what to fill all teh blanks in as 
# so we say fill with zero and get the zero value back 

## Read comma-separated-value (CSV) files

animals <- read.csv('data/animals.csv')
#someting didnt read in right about this data - the factor for species ID has an empty string 
#in the first value. There is a blank in the data, and it's reading it as blank 
# but we want to read it in as an NA

animals <- read.csv('data/animals.csv', na.strings='')
#na.strings is the command to treat whatever is after the equal sign as a NA
#we have empty quotations to indicate it's the blank
#check the structure and you see that the blank is gone
#the na.strings is flexible, can put in a vector of arguments (things) to treat as NA

# now looking at Key Data Wrianging Funcions
#dplyr is the R library for data wrangling
#filter is probabl the most important one - filters out rows that we don't want (like filter out
#everything of one species that wedont want to look at)
#select can keeeep the columns you want

#arrange sorts data
#mutate creates a new column that's a function of other columns in the data frame
#ex have column that's weight in grams, use mutate to create column that is weight
#in kg, so divides grams column by 1000
#on lesson variable is surrounded by %- that just means type in a name for the variable
#group - chunk data into groups and idividually process by grouns
#ex. take data fram with all the species, can group by species ID so when you 
#summarize the data, it runs a summary gorup by group - summarizes (ex with mean)
#by species instead of a mean of the whole data frame together

library(dplyr)
#red is not always an error - so the masking is ok
#if red is an error, it will actually say error
#skip down to line 76

con <- ...(..., host = 'localhost', dbname = 'portal')
animals_db <- ...
animals <- ...
dbDisconnect(...)

## Subsetting and sorting

library(dplyr)
#lets use filter function on the animals data frame to just look at 1990 data
animals_1990_winter <- filter(animals,
                              year == 1990,
                              month%in%1:3)
#year is a logical test- double equal sign means "has to be equal to"
#want all winter months, and in this data set, month is indicated by a number, 
#so we ask for month "in" the range of 1:3
#look over at enviroment and we can see that new animals_1990_winter has 491 obs
#while animals has 35549, so we know our filter worked

#ok now we don't need the year column because they're all 1990
#so use select to pick the columns we want.
#except that a lot to tyoe
#so
animals_1990_winter <- select(animals_1990_winter, -year
                              )
str(animals_1990_winter)
#our variable dropped from 9 variables to 8. yay!
#but if you might want to go back to the 9 variable value, make sure
#you define the select as a new variable, not the same name

#now lets rearrange the data frame so it's sorted by columns
#sort first by species ID, then by weight

sorted <- arrange(animals_1990_winter,
              desc(species_id), weight)
#desc is helper function to sort by descending order (z to A instead of A to z,
#which would be ascend (idk what the command is but maybe fill in the blank?))
#wantto see the beginning of the data frame but not the whole thing, use head
head(sorted)

#view will pop out the whole data table as a new tab here MUST BE CAPITAL V
View(sorted)
## Exercise 2
#Write code that returns the id, sex and weight of all surveyed
#individuals of Reithrodontomys montanus (RO).

RO <- filter(animals, species_id == 'RO')
RO2<-select (RO, id, sex, weight)

## Chainning with pipes

sorted_pipe <- animals %>%
    ... # filter to the first 3 months of 1990
    ... # select all columns but year
    ... # sort with descening species_id and weight

## Grouping and aggregation

counts_1990_winter <- animals_1990_winter %>%
    group_by(...) %>%
    ...

weight_1990_winter <- animals_1990_winter %>%
    ...
    summarize(avg_weight = mean(...))

## Exercise 3

...

## Transformation of variables

prop_1990_winter <- counts_1990_winter %>%
    mutate(...)

## Exercise 4

...

## Database Connection

library(...)

con <- ...(PostgreSQL(), host = 'localhost', dbname = 'portal')
animals_db <- ...

species_month_prop <- ...
    group_by(species_id, month) %>%
    summarize(count = n()) %>%
    mutate(prop = count / sum(count)) %>%
    select(-count)

pivot <- ...
  spread(month, prop, fill = 0)

dbDisconnect(con)



library(tidyr)
df3<-gather(response, "factor", "repsonse", -trial)
df3


dss3<-gather(dss2,"factor", "response",-)