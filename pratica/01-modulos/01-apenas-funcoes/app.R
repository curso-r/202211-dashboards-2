# app principal (app.R) ---------------------------------------------------

library(shiny)

# source("R/mod_dispersao.R")

ui <- fluidPage(
  dispersao_ui("dispersao_1"),
  hr(),
  histograma_ui("histograma_1"),
  hr(),
  histograma_ui("histograma_2")
)

server <- function(input, output, session) {

  dispersao_server("dispersao_1")
  histograma_server("histograma_1")
  histograma_server("histograma_2")

}

shinyApp(ui, server)
