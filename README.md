# FINALPROJECT
Final Project for ST 558 - Ankit Gupta

Hate Crimes Dataset and R Shiny Project


For this project, I wanted to look at frequency of hate crimes around different impacting factors across different states. Since, I recently moved to NY, I have noticed varying crime rates across neighborhoods and was interested in looking if any predictors were significant.

The app is for anyone else who is interested in visualizing and modelling different determinants for crime rate across the country. 

The Git Command to run the Shiny App:  

shiny::runGitHub('FINALPROJECT', 'ankit-gupta-dscientist')

The following packages are necessary to run the application: 

install.packages('shiny')
library(shiny)

install.packages('ggplot2')
library(ggplot2)

install.packages('dplyr')
library(dplyr)

install.packages('shinythemes')
library(shinythemes)

install.packages('openintro')
library(openintro)

install.packages('pltoly')
library(plotly)

install.packages('DT')
library(DT)

install.packages('readxl')
library(readxl)

install.packages('shinydashboard')
library(shinydashboard)

install.packages('tidyverse')
library(tidyverse)


Had issues with modeling section, debugged code many time, and ultimately ran into issues capping execution. Gave a best faith coding effort with all present in the .r file. R Project originated with github integration, however multiple push requests eroded connection, so uploaded UI and server files.

