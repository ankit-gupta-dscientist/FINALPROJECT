# Define server logic
server <- function(input, output, session) {
  
  # Data Exploration: Render selected plot
  output$explorationPlot <- renderPlot({
    # Check if user selected a plot type
    if (!is.null(input$plotType)) {
      # Generate the selected plot based on user input using ggplot2
      if (input$plotType == "Scatter Plot") {
        # Scatter plot with color by an additional variable
        ggplot(mtcars, aes_string(x = input$xVariable, y = input$yVariable, color = input$colorVariable)) +
          geom_point() +
          ggtitle("Scatter Plot with Color")
        
      } else if (input$plotType == "Bar Plot") {
        # Bar plot with faceting across another variable
        ggplot(mtcars, aes_string(x = input$xVariable, fill = input$colorVariable)) +
          geom_bar() +
          ggtitle("Side-by-Side Bar Plot")
        
      } else if (input$plotType == "Box Plot") {
        # Box plot with color by an additional variable
        ggplot(mtcars, aes_string(x = input$xVariable, y = input$yVariable, color = input$colorVariable)) +
          geom_boxplot() +
          ggtitle("Box Plot with Color")
        
      } 
    }
  })
  
  # Modeling: Fit models and display summary
  observeEvent(input$fitModelsButton, {
    # Check if the user selected predictors for linear regression and random forest
    if (!is.null(input$lmPredictors) && !is.null(input$rfPredictors)) {
      # Fit linear regression model
      
      lm_model <<- lm(mpg ~ ., data = mtcars[, c("mpg", input$lmPredictors)])
      
      # Fit random forest model
      rf_model <<- randomForest(mpg ~ ., data = mtcars[, c("mpg", input$rfPredictors)])
      
      # Additional code for comparing performance on the test set
      # Step 1: Split the data into training and test sets
      set.seed(123)  # Set seed for reproducibility
      train_indices <- sample(1:nrow(mtcars), size = round(input$trainSplit / 100 * nrow(mtcars)))
      mtcars_train <- mtcars[train_indices, ]
      mtcars_test <- mtcars[-train_indices, ]
      
      # Step 2: Make predictions on test data
      lm_predictions_test <- predict(lm_model, newdata = mtcars_test[, c(input$lmPredictors)])
      rf_predictions_test <- predict(rf_model, newdata = mtcars_test[, c(input$rfPredictors)])
      
      # Step 3: Evaluate model performance
      lm_rmse <- sqrt(mean((lm_predictions_test - mtcars_test$mpg)^2))
      rf_rmse <- sqrt(mean((rf_predictions_test - mtcars_test$mpg)^2))
      
      # Display performance metrics
      cat("Linear Regression RMSE on Test Set:", lm_rmse, "\n")
      cat("Random Forest RMSE on Test Set:", rf_rmse, "\n")
      
    }
  })
  
  # Prediction: Get predictions based on user input
  observeEvent(input$predictButton, {
    # Check if the user selected predictors for prediction
    if (!is.null(input$predictInput1) && !is.null(input$predictInput2)) {
      # Assuming linear regression model is already fitted (lm_model)
      lm_prediction <- predict(lm_model, newdata = data.frame(input$xVariable == input$predictInput1))
      
      # Assuming random forest model is already fitted (rf_model)
      rf_prediction <- predict(rf_model, newdata = data.frame(input$xVariable == input$predictInput2))
      
      # Display prediction results
      cat("Linear Regression Prediction:\n")
      print(lm_prediction)
      
      cat("\nRandom Forest Prediction:\n")
      print(rf_prediction)
    }
  })
}
