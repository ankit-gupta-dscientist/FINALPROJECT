#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load required libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(shinythemes)
library(openintro)
library(plotly)
library(DT)
library(readxl)
library(shiny)
library(shinydashboard)
library(tidyverse)



# Read the data
hatecrimes <- read_excel("hatecrimes.xlsx")

# Shiny Project
my_css <- "
#descriptionreg {
  color: darkred; font-size: 18px; font-style: bold;
}
#descriptionbox {
  color: darkred; font-size: 18px; font-style: bold;
}
#description {
  color: darkred; font-size: 18px; font-style: bold;
}
#descriptiontukey {
  color: darkred; font-size: 18px; font-style: bold;
}
"

# Define UI for application that draws a histogram
fluidPage(theme = shinytheme("sandstone"),

  # Add the CSS style to the Shiny app
  tags$style(my_css),
  
  
  tabsetPanel(
    
    tabPanel("About", fluid = TRUE,
             
             # Purpose of the App
             h4("Purpose"),
             p("This app provides an analysis of hate crimes data."),

             h4("About Data"),
             p("This app uses hate crime data available in the official U.S. Department of Justice.  It contains various crime related attributes for 50 states & Washington D.C."),
             p("For more information about the data, visit:",
               a("[U.S. Department of Justice]", 
                 href = "https://www.justice.gov/hatecrimes/")),
             
             
             h4("App Content"),
             p("This app contains the following tabs:"),
             tags$div(tags$ul(
               tags$li(tags$b("About:") ,"contains key details of this app"),
               tags$li(tags$b("Data Exploration:"), "contains summaries of the crime data"),
               tags$li(tags$b("Modeling:"), "contains supervised learning models to predict crime"))),
             
             img(src='images.jpeg', align = "left")
    ),
    
    tabPanel("Data Explorations",
                        column(4,
                               # Select variable for y-axis
                               selectInput(inputId = "y", 
                                           label = "Y-axis:",
                                           choices = colnames(hatecrimes),
                                           selected = colnames(hatecrimes)[1]),
                               
                               # Select variable for x-axis
                               selectInput(inputId = "x", 
                                           label = "X-axis:",
                                           choices = colnames(hatecrimes),
                                           selected = colnames(hatecrimes)[2]),
                               
                               # Select plot type
                               selectInput(inputId = "plot_type",
                                           label = "Plot Type:",
                                           choices = c("Histogram", "Boxplot", "Violin Plot", "Scatter Plot"),
                                           selected = "Histogram"),
                               
                               # Add checkbox for multivariate relationships
                               checkboxInput("multivariate", "Show Multivariate Relationships", FALSE)
                        ),
                        column(6,
                               # Output for selected plot
                               plotOutput(outputId = "exploration_plot"),
                               # Output for summary
                               verbatimTextOutput(outputId = "exploration_summary")
                               )),
    tabPanel("Modeling",

             tabsetPanel(
               tabPanel("Model Info",
                        p("The two models being utilized for this project are linear regression and random forest techniques."),
                        
                        p("Both models have strengths and weaknesses for the purposes of statistical modeling and inference."),
                        
                        p("MLR comes with all familiar perceptions of linear modeling in terms of p-values, confidence intervals with an ability to add interaction and higher order terms."),
                        
                        p("Random forest models are generally good for datasets with a large number of predictor variables and ones where there is no need to do any hypothesis testing. Random Forest models have inbuilt feature selection albeit can overfit it in a few cases.")
                        
                        ),
              tabPanel("Model Fitting",
                       sidebarLayout(
                         sidebarPanel(
                           numericInput("split_percentage", "Test/Train Split Percentage:", value = 0.2, min = 0, max = 1, step = 0.01),
                           selectInput("lm_predictors", "Select Linear Regression Predictors", choices = colnames(hatecrimes), multiple = TRUE),
                           selectInput("rf_predictors", "Select Random Forest Predictors", choices = colnames(hatecrimes), multiple = TRUE),
                           numericInput("ntree", "Number of Trees (Random Forest):", value = 100, min = 1),
                           numericInput("mtry", "Number of Variables to Split on (Random Forest):", value = 3, min = 1),
                           actionButton("fit_models_btn", "Fit Models")
                         ),
                         mainPanel(
                           h4("Linear Regression Model Summary:"),
                           verbatimTextOutput("lm_summary_train"),
                           h4("Random Forest Model Summary:"),
                           verbatimTextOutput("rf_summary_train"),
                           h4("Comparison on Test Set:"),
                           verbatimTextOutput("comparison_test")
                         )
                       )
              )
            ,
            
            tabPanel("Model Prediction",
            sidebarLayout(
              sidebarPanel(
                selectInput("predictor1_val", "Select Value for Predictor 1", choices = NULL),
                selectInput("predictor2_val", "Select Value for Predictor 2", choices = NULL),
                selectInput("predictor3_val", "Select Value for Predictor 3", choices = NULL),
                selectInput("predictor4_val", "Select Value for Predictor 4", choices = NULL),
                selectInput("predictor5_val", "Select Value for Predictor 5", choices = NULL),
                actionButton("predict_btn", "Get Predictions")
              ),
              mainPanel(
                h4("Predictions:"),
                verbatimTextOutput("lm_prediction"),
                verbatimTextOutput("rf_prediction")
              )
            )
            )
    ))))

