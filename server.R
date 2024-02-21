## Shiny Server component for dashboard

function(input, output, session) {
  
  # Data table Output
  output$dataT <- renderDataTable({
    DT::datatable(my_data)
  })
  
  # Rendering the box header  
  output$head1 <- renderText({
    paste("5 districts with latest year data")
  })
  
  # Rendering the box header 
  output$head2 <- renderText({
    paste("5 districts with the least recent year data")
  })
  
  # Rendering table with 5 districts with the highest rate of specific crime type
  output$top5 <- renderTable({
    my_data %>%
      arrange(desc(.data[["Year"]])) %>%
      head(5)
  })
  
  
  # Rendering table with 5 districts with the lowest rate of specific crime type
  output$low5 <- renderTable({
    my_data %>%
      arrange(.data[["Year"]]) %>%
      head(5)
  })
  
  
  # For Structure output
  output$structure <- renderPrint({
    str(my_data)
  })
  
  # For Summary Output
  output$summary <- renderPrint({
    summary(my_data)
  })
  
  output$histogram <- renderPlotly({
    # Group the data by state and calculate the total counts of No_of_CSCs, CasesR, and Advice
    state_data <- my_data %>%
      group_by(state) %>%
      summarise(total_No_of_CSCs = sum(No_of_CSCs),
                total_CasesR = sum(CasesR),
                total_Advice = sum(Advice))
    
    # Create the histogram chart
    plot_ly(state_data, x = ~state, y = ~total_No_of_CSCs, type = "bar", name = "No_of_CSCs") %>%
      add_trace(y = ~total_CasesR, name = "CasesR") %>%
      add_trace(y = ~total_Advice, name = "Advice") %>%
      layout(title = "Distribution of No_of_CSCs, CasesR, and Advice by State",
             xaxis = list(title = "State"),
             yaxis = list(title = "Count"))
  })
  
  
  
  
  
  
 
  
  
  ### Bar Charts - district wise trend
  output$bar <- renderPlotly({
    plot_ly(my_data, x = ~district, y = ~No_of_CSCs, type = "bar") %>%
      layout(title = "Bar Chart of No_of_CSCs by District",
             xaxis = list(title = "District"),
             yaxis = list(title = "No_of_CSCs"))
  })
  
  
  output$scatter <- renderPlotly({
    plot_ly(my_data, x = ~district, y = ~CasesR, type = "scatter", mode = "markers", color = ~CasesR) %>%
      layout(title = "Scatter Plot of CasesR by District",
             xaxis = list(title = "District"),
             yaxis = list(title = "CasesR"))
  })
  
  
  

  
  ## Correlation plot
  output$cor <- renderPlotly({
    # Select only numeric columns from your dataset
    numeric_data <- my_data %>%
      select(where(is.numeric))
    
    # Display the structure of the new dataset to confirm
    str(numeric_data)
    
    # Clean the numeric data to remove infinite, NA, and NaN values
    numeric_data_clean <- numeric_data %>%
      filter_all(all_vars(!is.infinite(.) & !is.na(.) & !is.nan(.)))
    
    # Compute a correlation matrix
    corr <- round(cor(numeric_data_clean), 1)
    
    # Compute a matrix of correlation p-values
    p.mat <- cor_pmat(numeric_data_clean)
    
    # Create the correlation plot using ggcorrplot
    corr.plot <- ggcorrplot(
      corr, 
      hc.order = TRUE, 
      lab = TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    
    # Convert the ggplot object to Plotly
    ggplotly(corr.plot)
  })
  
  
  
  
  
  
  
  
}