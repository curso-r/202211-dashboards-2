# Módulo histograma -------------------------------------------------------

histograma_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Histograma"),
    selectInput(
      inputId = ns("variavel"),
      label = "Selecione uma variável",
      choices = names(mtcars)
    ),
    plotOutput(outputId = ns("grafico"))
  )
}

histograma_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$grafico <- renderPlot({
      hist(mtcars[[input$variavel]])
    })

  })
}
