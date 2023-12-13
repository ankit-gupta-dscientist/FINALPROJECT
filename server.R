#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)


hatecrimes <- read_excel("hatecrimes.xlsx")
# Clean column names (replace spaces with dots)
colnames(hatecrimes) <- make.names(colnames(hatecrimes))


# Define server logic required to draw a histogram
server <- function(input, output, session) {

  # Data Exploration
  
  output$exploration_plot <- renderPlot({
    plot_type <- input$plot_type
    
    if (plot_type == "Histogram") {
      ggplot(hatecrimes, aes_string(x = input$x)) +
        geom_histogram(fill = "skyblue", color = "black", bins = 30) +
        labs(title = paste("Histogram of", input$x),
             x = input$x,
             y = "Frequency")
    } else if (plot_type == "Boxplot") {
      ggplot(hatecrimes, aes_string(x = 1, y = input$y)) +
        geom_boxplot(fill = "skyblue", color = "black") +
        labs(title = paste("Boxplot of", input$y),
             x = "",
             y = input$y)
    } else if (plot_type == "Violin Plot") {
      ggplot(hatecrimes, aes_string(x = 1, y = input$y)) +
        geom_violin(fill = "skyblue", color = "black") +
        labs(title = paste("Violin Plot of", input$y),
             x = "",
             y = input$y)
    } else if (plot_type == "Scatter Plot") {
      if (input$multivariate) {
        ggplot(hatecrimes, aes_string(x = input$x, y = input$y, color = input$x)) +
          geom_point() +
          labs(title = paste("Scatter Plot of", input$x, "and", input$y),
               x = input$x,
               y = input$y)
      } else {
        ggplot(hatecrimes, aes_string(x = input$x, y = input$y)) +
          geom_point() +
          labs(title = paste("Scatter Plot of", input$x, "and", input$y),
               x = input$x,
               y = input$y)
      }
    }
  })
  
  output$exploration_summary <- renderText({
    # Summary statistics go here
    if (input$plot_type == "Histogram") {
      summary_stats <- summary(hatecrimes[[input$x]])
      paste("Summary Statistics for", input$x, ":\n", summary_stats)
    } else if (input$plot_type == "Boxplot") {
      summary_stats <- summary(hatecrimes[[input$y]])
      paste("Summary Statistics for", input$y, ":\n", summary_stats)
    } else if (input$plot_type == "Violin Plot") {
      summary_stats <- summary(hatecrimes[[input$y]])
      paste("Summary Statistics for", input$y, ":\n", summary_stats)
    } else if (input$plot_type == "Scatter Plot") {
      cor_val <- cor(hatecrimes[[input$x]], hatecrimes[[input$y]], use = "pairwise")
      paste("Correlation between", input$x, "and", input$y, " = ", round(cor_val, 3))
    }
  })
  
  # Splitting data into train/test factions
  split_data <- reactive({
    set.seed(123)
    split_index <- createDataPartition(hatecrimes$avg_hatecrimes_per_100k_fbi, p = input$split_percentage, list = FALSE)
    train_data <- hatecrimes[split_index, ]
    test_data <- hatecrimes[-split_index, ]
    list(train_data = train_data, test_data = test_data)
  })
  
  # Linear Regression Model
  lm_model <- reactive({
    formula_str <- paste("avg_hatecrimes_per_100k_fbi ~", paste(input$lm_predictors, collapse = "+"))
    lm(formula_str, data = split_data()$train_data)
  })
  
  # Random Forest Model
  rf_model <- reactive({
    rf_formula_str <- as.formula(paste("avg_hatecrimes_per_100k_fbi ~", paste(input$rf_predictors, collapse = "+")))
    rf_grid <- expand.grid(mtry = input$mtry, ntree = input$ntree)  # Corrected column names
    rf_ctrl <- trainControl(method = "cv", number = 5)
    train(rf_formula_str, data = split_data()$train_data, method = "rf", tuneGrid = rf_grid, trControl = rf_ctrl)
  })
  
  # Model fitting
  observeEvent(input$fit_models_btn, {
    lm_fit <- lm_model()
    rf_fit <- rf_model()
    
    output$lm_summary_train <- renderPrint({
      summary(lm_fit)
    })
    
    output$rf_summary_train <- renderPrint({
      rf_fit
    })
    
    # Model performance on the test set
    test_set_lm_predictions <- predict(lm_fit, newdata = split_data()$test_data)
    test_set_rf_predictions <- predict(rf_fit, newdata = split_data()$test_data)
    
    # RMSE for Linear Regression
    lm_rmse <- sqrt(mean((test_set_lm_predictions - split_data()$test_data$avg_hatecrimes_per_100k_fbi)^2))
    
    # RMSE for Random Forest
    rf_rmse <- sqrt(mean((test_set_rf_predictions - split_data()$test_data$avg_hatecrimes_per_100k_fbi)^2))
    
    output$comparison_test <- renderPrint({
      paste("Linear Regression RMSE on Test Set:", lm_rmse, "\n",
            "Random Forest RMSE on Test Set:", rf_rmse)
    })
  })
  
  lm_prediction <- reactive({
    new_data <- data.frame(
      Predictor1 = as.numeric(input$predictor1_val),
      Predictor2 = as.numeric(input$predictor2_val),
      Predictor3 = as.numeric(input$predictor3_val),
      Predictor4 = as.numeric(input$predictor4_val),
      Predictor5 = as.numeric(input$predictor5_val)
    )
    predict(lm_model(), newdata = new_data)
  })
  
  # Function for random forest prediction
  rf_prediction <- reactive({
    new_data <- data.frame(
      Predictor1 = as.numeric(input$predictor1_val),
      Predictor2 = as.numeric(input$predictor2_val),
      Predictor3 = as.numeric(input$predictor3_val),
      Predictor4 = as.numeric(input$predictor4_val),
      Predictor5 = as.numeric(input$predictor5_val)
    )
    predict(rf_model(), newdata = new_data)
  })
  
  # Output predictions on the Prediction tab
  output$lm_prediction <- renderPrint({
    lm_prediction()
  })
  
  output$rf_prediction <- renderPrint({
    rf_prediction()
  })
  
}

