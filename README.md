# Aquatic Biodiversity Analysis

## Overview

This project investigates the relationship between the populations of the Dreissenidae and Cyprininae families across various countries. Utilizing data from the BOLD (Barcode of Life Data Systems) database, the study aims to explore how these two families influence each other's populations and to analyze biodiversity trends in terms of bin and species richness.

## Objectives

- Analyze population trends of Dreissenidae and Cyprininae families across different countries.
- Explore potential relationships between these two families in regions where they co-exist.
- Examine bin dissimilarity between countries and understand the influence of geographical factors on their populations.

## Key Technologies

- **R**: Used for data analysis and visualization.
- **tidyverse**: A collection of R packages for data manipulation and visualization.
- **vegan**: An R package for ecological analysis, used for calculating bin dissimilarity.
- **ggplot2**: A data visualization package within tidyverse, used to create bar plots, dot plots, and heatmaps.

## Data Description

The dataset was obtained from the BOLD database and includes information on bin and species counts for the Dreissenidae and Cyprininae families across various countries. The analysis focuses on understanding the impact of these families on each other's populations, as well as biodiversity trends within these families.

## Analysis Workflow

1. **Data Acquisition and Preprocessing**:
   - Filtered and cleaned the data for Dreissenidae and Cyprininae families.
   - Removed countries with missing bin or species data to ensure data integrity.

2. **Data Analysis**:
   - Analyzed bin and species counts for each family across different countries.
   - Compared bin counts between the two families in countries where both co-exist.
   - Calculated bin dissimilarity between countries using the Bray-Curtis dissimilarity matrix.

3. **Visualization**:
   - Created bar plots to visualize the species and bin richness of Dreissenidae and Cyprininae families by country.
   - Developed dot plots to compare bin counts between the two families across common countries.
   - Generated heatmaps to visualize the Bray-Curtis dissimilarity between countries for both families.

## Results

- **Species and Bin Richness**: Significant differences in species and bin richness for Dreissenidae were observed across various countries, indicating potential undiscovered species in certain regions.
- **Family Comparisons**: In countries like Turkey, Thailand, Iran, and China, Cyprininae had significantly higher bin counts compared to Dreissenidae, suggesting potential ecological influences.
- **Bin Dissimilarity**: The Bray-Curtis dissimilarity analysis revealed unique biodiversity patterns, with certain countries exhibiting high dissimilarity in bin counts compared to others.

## Future Directions

- Further investigation could focus on specific sites within countries where these families co-exist, to understand environmental factors influencing their relationship.
- Expanding the study to include additional families and environmental variables could provide deeper insights into aquatic biodiversity.

## References

- Bockrath, K., Wisniewski, J., Wares, J., Fritts, A., & Hill, M. (2013). The Mussel–Fish Relationship: A Potential New Twist in North America?. *Transactions of the American Fisheries Society*, 142(3), 642-648.
- Wickham, H., et al. (2019). Welcome to the Tidyverse. *Journal of Open Source Software*.
- Yang, L., Naylor, G. J. P., & Mayden, R. L. (2021). Deciphering reticulate evolution of the largest group of polyploid vertebrates, the subfamily Cyprininae (Teleostei: Cypriniformes). *ScienceDirect*.

