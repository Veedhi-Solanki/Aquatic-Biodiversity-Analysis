#Assignemnt 1 - Software Tools
#By Veedhi Solanki, last updated on October 6, 2023
#How many species or BINs (Barcode Index Numbers) of Dreissenidae family have been DNA barcoded from, for example, in different geographical regions? Overall, this study seeks to analyze unique trends seen in the population of the family Dreissenidae all over the world. Then it is looking to compare the relationship between the families of Dreissenidae and Cyprininae by looking at the bin dissimilarity between different countries where the population of these two families co-exist. As well as, it compares the number of species and bin counts for both famillies in the countries where they co-exist. 

#packages
library(tidyverse)
library(vegan)
library(dplyr)
library(ggplot2)
library(gplots)

## Edit #1 To make the code more reusable and readible, I will create a function that filters and summarizes data. I have also labeled the species count and bin count with the family name to make the names clearer. 
filter_and_summarize_data <- function(data, family) {
  filtered_data <- data %>%
    filter(!is.na(country)) %>%
    filter(!(is.na(bin_uri) & !is.na(species_name))) %>%
    group_by(country) %>%
    summarise(SpeciesCount = n_distinct(species_name),
              BINCount = n_distinct(bin_uri)) %>%
    ungroup() %>%
    mutate(
      !!paste0("SpeciesCount_", family) := SpeciesCount,
      !!paste0("BINCount_", family) := BINCount
    ) %>%
    arrange(desc(SpeciesCount)) %>%
    select(-SpeciesCount, -BINCount)
  
  filtered_data$Family <- family
  
  return(filtered_data)
}
#Setting up the working directory
getwd()

## Edit#2 To make data accquisition easier, I am adding a command that directly retrieves the bold data from the internet
dfBOLD_Dreissenidae <- read_tsv(file = "http://www.boldsystems.org/index.php/API_Public/combined?taxon=Dreissenidae&format=tsv")

#Looking at the variable names for Dreissenidae, summary and some genral data to help start the process of analyzing
class(dfBOLD_Dreissenidae)
head(dfBOLD_Dreissenidae)
dim(dfBOLD_Dreissenidae)
names(dfBOLD_Dreissenidae)
summary(dfBOLD_Dreissenidae)

#Grouping datta by geographical region and count species and BINS, so, Let's use the group_by() and summerise() functions to count the number of species and BINS.I am removing the ones without country first then the ones mssiing values for bin_uri and species name. 
filtered_country_Dreissenidae <-  filter_and_summarize_data(dfBOLD_Dreissenidae, "Dreissenidae")

# Create a bar plot to visualize species and BIN richness by geographical region

# Reshape the data from wide to long format
long_data.D <- pivot_longer(filtered_country_Dreissenidae, cols = c(SpeciesCount_Dreissenidae, BINCount_Dreissenidae), names_to = "Variable")

# Create a grouped bar plot to visualize both species count and BIN count
ggplot(long_data.D, aes(x = reorder(country, -value), y = value, fill = Variable)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.6) +
  labs(x = "Country", y = "Count", fill = "Variable") +
  ggtitle("Species and BIN Richness of Dreissenidae Family by countries") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("SpeciesCount_Dreissenidae" = "red", "BINCount_Dreissenidae" = "blue")) +
  guides(fill = guide_legend(title = "Legend"))

#Now that we have examined the species and Bin composition of Dreissenidae in different countries where data is availble, let's explore how is the distribution of the Cyprininae in the countroes where Dreissenidae is present to see the relationship between these to famillies and explore correlation. 

#To make data accquisition easier, I am adding a command that directly retrieves the bold data from the internet
dfBOLD_Cyprininae <- read_tsv(file = "http://www.boldsystems.org/index.php/API_Public/combined?taxon=Cyprininae&format=tsv")

#Looking at the variable names for Cyprininae, summary and some genral data to help start the process of analyzing
class(dfBOLD_Cyprininae)
head(dfBOLD_Cyprininae)
dim(dfBOLD_Cyprininae)
names(dfBOLD_Cyprininae)
summary(dfBOLD_Cyprininae)

#Filtering the data of Cyprininae to only where countries are present and none of the values of Bin or species are missing the it will be grouped by countries and species and bin count per country will be in the following coloumns.

filtered_country_Cyprininae <-  filter_and_summarize_data(dfBOLD_Cyprininae, "Cyprininae")

long_data.C <- pivot_longer(filtered_country_Cyprininae, cols = c(SpeciesCount_Cyprininae, BINCount_Cyprininae), names_to = "Variable")

# Create a grouped bar plot to visualize both species count and BIN count
ggplot(long_data.C, aes(x = reorder(country, -value), y = value, fill = Variable)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.6) +
  labs(x = "Country", y = "Count", fill = "Variable") +
  ggtitle("Species and BIN Richness of Cyprininae Family by countries") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("SpeciesCount_Cyprininae" = "red", "BINCount_Cyprininae" = "blue")) +
  guides(fill = guide_legend(title = "Legend"))

#Now we have equal datat frames for both Dreissenidae and Cyprininae, I am going to merge them based on the common countries between these two famillies through inner_join() function of dplyr.

common_countries_data <- inner_join(filtered_country_Dreissenidae, filtered_country_Cyprininae, by = "country")

#I am creating a dot plot to visualize the data of both famillies. 
ggplot(common_countries_data, aes(x = country, y = BINCount_Dreissenidae, color = "Dreissenidae")) +
  geom_point(size = 3) +
  geom_point(aes(x = country, y = BINCount_Cyprininae, color = "Cyprininae"), size = 3) +
  labs(title = "Dot Plot of BIN Count by Country for Dreissenidae and Cyprininae",
       x = "Country",  
       y = "Count") +  
  scale_color_manual(values = c("Dreissenidae" = "blue", "Cyprininae" = "red"),
                     name = "Family") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip() +
  scale_y_continuous(breaks = seq(min(common_countries_data$BINCount_Dreissenidae, common_countries_data$BINCount_Cyprininae), 
                                  max(common_countries_data$BINCount_Dreissenidae, common_countries_data$BINCount_Cyprininae), 
                                  by = 2))

## Edit#3 I am making a grouped barplot illustrating the distribution of species and bins from each family in countries where the two families co-exist. 
long_data.Common <- pivot_longer(common_countries_data, 
                                 cols = c(SpeciesCount_Dreissenidae, BINCount_Dreissenidae, SpeciesCount_Cyprininae, BINCount_Cyprininae),
                                 names_to = "Variable")

# Create grouped bar plot
ggplot(long_data.Common, aes(x = country, y = value, fill = Variable)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.6) +
  labs(x = "Country", y = "Count", fill = "Variable") +
  ggtitle("Comparison of Species and BIN Counts between Dreissenidae and Cyprininae") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(
    values = c("SpeciesCount_Dreissenidae" = "red", 
               "BINCount_Dreissenidae" = "yellow", 
               "SpeciesCount_Cyprininae" = "blue", 
               "BINCount_Cyprininae" = "green"), 
    name = "Legend"
  )

#I want to look at BIN dissimilarity between countries for both Dreissenidae and Cyprininae families
# I am selecting the relevant columns for calculation
BIN_dissimilarity <- common_countries_data[, c("BINCount_Dreissenidae", "BINCount_Cyprininae")]

# Calculate Bray-Curtis dissimilarity
dissimilarity_matrix <- vegdist(BIN_dissimilarity, method = "bray")

# Print the dissimilarity matrix
print(dissimilarity_matrix)

#I am going to create a heat map for BIN count dissimilarity for two famillies from the matrix
heatmap.2(as.matrix(dissimilarity_matrix), 
          dendrogram = "row",  
          Rowv = TRUE, Colv = TRUE,
          col = colorRampPalette(c("white", "blue"))(100),  
          main = "Bray-Curtis Dissimilarity Heatmap",
          labRow = common_countries_data$country,
          labCol = common_countries_data$country)

#END SCRIPT