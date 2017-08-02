## Getting started

library(dplyr)
library(ggplot2)
animals <- read.csv('data/animals.csv', na.strings = '') %>%
  filter(!is.na(species_id), !is.na(sex), !is.na(weight))
#%>% = take the result of the read.csv command and sends it immediately into the filter command


## Constructing layered graphics in ggplot

ggplot(data=animals, aes(x=species_id, y=weight))+ geom_point()
  ...
#constructs a scatter plot
  
ggplot(data = animals,
       aes(x = species_id, y = weight)) +geom_boxplot()
  ...
# construct a box plot
  
ggplot(data = animals,
       aes(x = species_id, y = weight)) +
  geom_boxplot() +
  geom_point(stat='summary',fun.y='mean',color='red')

ggplot(data = animals,
       aes(x = species_id, y = weight, color=species_id)) +
  geom_boxplot() +
  geom_point(stat = 'summary',
             fun.y = 'mean')

## Exercise 1
#Using dplyr and ggplot show how the mean weight of individuals of the 
#species DM changes over time, with males and females shown in different colors.

animals_dm<-filter(animals,species_id=="DM")
ggplot(data=animals, aes(x=weight, y=year, color=sex))+geom_line(stat='summary',fun.y='mean')

## Adding a regression line
ggplot(data=animals, aes(x=weight, y=year, color=sex))+geom_point(stat='summary',fun.y='mean')

levels(animals$sex) <- c('Female', 'Male')

ggplot(data=animals_dm,
       aes(x = year, y = weight)) +
  geom_point(aes(shape=sex),
             size = 3,
             stat = 'summary',
             fun.y = 'mean') + geom_smooth(method='lm')
  ...

ggplot(data = animals_dm,
       aes(x = year, y = weight)) + 
  geom_point(aes(shape = sex),
             size = 3,
             stat = 'summary',
             fun.y = 'mean') +
  geom_smooth(aes(group=sex), method="lm")

ggplot(data = animals_dm,
       aes(x=year, y=weight, color=sex)) + 
  geom_point(aes(shape = sex),
             size = 3,
	           stat = 'summary',
	           fun.y = 'mean') +
  geom_smooth(method = 'lm')

# Storing and re-plotting
#store the plot as a variable, can check by doing str(year_wgt)
year_wgt <- ggplot(data = animals_dm,
                   aes(x = year,
                       y = weight,
                       color = sex)) +
  geom_point(aes(shape = sex),
             size = 3,
             stat = 'summary',
             fun.y = 'mean') +
  geom_smooth(method = 'lm')

year_wgt +scale_color_manual(values=c('dark blue','orange'))
  ...
                     
year_wgt <- year_wgt +
  scale_color_manual(values=c('dark blue','orange'))

#can clear plot history by clicking on the broom, then just type
#year_wgt
#and see the plot
year_wgt

## Exercise 2

#Create a histogram, using a geom_histogram() layer, of the weights of 
#individuals of species DM and divide the data by sex. Note that instead 
#of using color in the aesthetic, you’ll use fill to distinguish the 
#sexes. Also open the help with ?geom_histogram and determine how to 
#explicitly set the bin width.
ggplot(data=animals_dm, aes(x=weight,fill=sex))+
geom_histogram(binwidth=1)

#binwwidth of 1 shows teh counts for each gram of weight
#bindwitch of 10 would group the counts by 10 gram chunks

## Axes, labels and themes

histo <- ggplot(data = animals_dm,
                aes(x = weight, fill = sex)) +
  geom_histogram(binwidth=3, color='white')
histo

histo <- histo +
  labs(title = 'Dipodomys merriami weight distribution',
       x = 'Weight (g)',
       y = 'Count') +
  scale_x_continuous(limits = c(20, 60),
                     breaks = c(20, 30, 40, 50, 60))
histo

histo <- histo +
  theme_bw() +
  theme(legend.position = c(0.2, 0.5),
        plot.title = element_text(face="bold", vjust=2),
        axis.title.x = element_text(size=13, vjust=1),
        axis.title.y = element_text(size = 13, vjust = 0))
histo

#vjust=  vertical justification
histo

## Facets

animals_common <- filter(animals, species_id %in% c("DM", "PP", "DO"))
ggplot(data = animals_common, aes(x=weight)) +
  geom_histogram() +
  facet_wrap(~species_id)+
  labs(title = "Weight of most common species",
       x = "Count",
       y = "Weight (g)")

#but how does each of these compare to the entire distribution
#add entire distribution as another layer on each of these plots
ggplot(data = animals_common,
       aes(x = weight)) +
  geom_histogram(data=select(animals_common, -species_id),
                 alpha=0.2) +
  geom_histogram() +
  facet_wrap( ~ species_id) +
  labs(title = "Weight of most common species",
       x = "Count",
       y = "Weight (g)")

ggplot(data = animals_common,
       aes(x = weight, fill=species_id)) +
  geom_histogram(aes(y=..density..)) +
  facet_wrap( ~ species_id) +
  labs(title = "Weight of most common species",
       x = "weight (g)",
       y = "count") +
  guides(fill = FALSE)		

## Exercise 3
#The formula notation for facet_grid (different from facet_wrap) 
#interprets left-side variables as one axis and right-side variables 
#as another. For these three common animals, create facets in the 
#weight histogram along two categorical variables, with a row for 
#each sex and a column for each species.

ggplot(data = animals_common,
       aes(x = weight, fill=species_id:sex)) +
  geom_histogram() +
  facet_grid(sex ~ species_id) +
  labs(title = 'Weight of common species by sex',
       x = 'Count',
       y = 'Weight (g)')

