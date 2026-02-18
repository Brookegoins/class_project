Workflow for Processing and Analyzing Aquatic and Terrestrial Macroinvertebrate Communities in Franktown Creek

Project Overview

This repository contains a reproducible analytical workflow for processing and analyzing benthic macroinvertebrate data collected from Franktown Creek within Whittell Forest.
The project evaluates multiple dimensions of macroinvertebrate community structure, including:
- Taxonomic composition
- Abundance patterns
- Diversity metrics
- Functional feeding group distribution
- Biotic index calculations

The goal is to generate transparent, script-based analyses that produce publication-quality tables, figures, and spatial products while maintaining clear separation between raw data, processed data, and derived outputs.
All data cleaning, transformation, and analysis steps are conducted in R to ensure reproducibility and transparency.

Project Organization

The repository is organized to separate raw data, processed data, analytical scripts, and final outputs in a logical and reproducible structure.
The literature/ directory contains scientific articles, background materials, and reference documents relevant to macroinvertebrate ecology and study design.
The data_raw/ folder stores original datasets exactly as received or collected. These files remain unchanged to preserve data integrity.
The project_data/ directory contains cleaned and processed datasets used for analysis.
The metadata/ folder includes data dictionaries, field sampling protocols, and site-level metadata necessary for interpreting the datasets.
The scripts/ directory contains all R scripts used for importing, cleaning, analyzing, and visualizing data. Scripts are organized by analytical stage (e.g., data import and cleaning, exploratory analysis, diversity calculations, biotic index computation, visualization).
The outputs/ directory houses all derived products generated from analysis scripts. 
Within this folder:
- figures/ contains publication-quality plots and graphics.
- tables/ includes summary tables in CSV or Excel format.
- maps/ contains spatial and cartographic products, if applicable.
- The website/ folder contains files related to any interactive or web-based visualization components developed from the project.

File Naming Conventions

Scripts

Scripts are named according to their analytical purpose, for example:
- data_import_cleaning
- exploratory_analysis
- diversity_metrics
- biotic_index_calculations

Data Files

Processed datasets include descriptive identifiers and, when appropriate, year or version indicators, for example:
- master_invert_2026
- Outputs

Figures and tables are labeled by number and content:
- fig_5_abundance_estimation
- table_2_mean_metrics

Software Requirements

This workflow was developed using:
- R
- RStudio (recommended development environment)

Commonly used R packages may include (as applicable):
- tidyverse
- ggplot2
- vegan
- dplyr
- sf

Authors:
Brooke Goins 
University of Nevada, Reno

Jeff Falke
University of Nevada, Reno

Mark Kolwyck
University of Nevada, Reno

Tanner Morgan
University of Nevada, Reno
Contact Information

For questions regarding this repository or the Franktown Creek macroinvertebrate project, please contact:

Brooke Goins
University of Nevada, Reno
brookegoins@unr.edu


