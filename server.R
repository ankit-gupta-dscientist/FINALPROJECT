

library(shiny)
library(dplyr)
library(shinydashboard)
library(shiny)
library(caret)
library(tidyverse)
library(DT)
library(huxtable)

# server.R

data("GermanCredit")

shinyServer(function(input, output) {
  
  # Numeric Summaries
  output$numeric_table <- renderDT({
    tab <- GermanCredit %>%
      select("Class", "InstallmentRatePercentage", input$variable) %>%
      group_by(Class, InstallmentRatePercentage) %>%
      summarize(mean = round(mean(get(input$variable)), input$rounding_digits))
    
    datatable(tab, options = list(pageLength = input$plot_entries))
  })
  
  # Plot
  output$plot <- renderPlot({
    ggplot(GermanCredit, aes(x = Class, y = get(input$variable), fill = Class)) +
      geom_bar(stat = "summary", fun = "mean", position = "dodge") +
      labs(title = "Bar Plot", x = "Class", y = input$variable)
  })
  
  # Sample Mean Text
  output$sample_mean_text <- renderText({
    paste("The sample mean of", (input$variable), "is:",
          round(mean(GermanCredit[[input$variable]]), input$rounding_digits))
  })
  
})