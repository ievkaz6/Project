library(shiny)
library(tidyverse)
library(h2o)
h2o.init()

ui <- fluidPage(
  titlePanel("Banking APP"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV file")
    ),
    mainPanel(
      tableOutput("table")
    )
  )
)

server <- function(input, output) {
  model <- h2o.import_mojo("XGBoost_1_AutoML_2_20231115_212512.zip")
  output$table <- renderTable({
    req(input$file)
    test_data <- h2o.importFile(input$file$datapath)
    predictions <- h2o.predict(model, test_data)
    predictions %>%
      as_tibble() %>%
      mutate(id = row_number(), y = p0) %>%
      select(id, y) %>%
      head(10)
  })
  
  
}
shinyApp(ui = ui, server = server)