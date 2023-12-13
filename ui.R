

library(shiny)
library(caret)
library(shinydashboard)


data("GermanCredit")

# ui.R
library(shiny)
library(DT)

shinyUI(fluidPage(
  titlePanel("German Credit Data"),
  sidebarLayout(
    sidebarPanel(
      h4("Select the Plot Type"),
      radioButtons("plot_type", "Plot Type:",
                   choices = c("Just Classification", "Classification and Unemployed", "Classification and Foreign"),
                   selected = "Just Classification"),
      
      h4("Variables to Summarize"),
      selectInput("variable", "Select Variable:", choices = c("Duration")),
      
      h4("Select the number of digits for rounding"),
      sliderInput("rounding_digits", "Number of Digits:",
                  min = 0, max = 5, value = 2),
      
      h4("Plot object"),
      numericInput("plot_entries", "Show entries:", value = 10)
    ),
    mainPanel(
      h3("Numeric Summaries"),
      DTOutput("numeric_table"),
      
      h3("Plot"),
      plotOutput("plot"),
      
      h4("Sample Mean for Duration:"),
      textOutput("sample_mean_text")
    )
  )
))