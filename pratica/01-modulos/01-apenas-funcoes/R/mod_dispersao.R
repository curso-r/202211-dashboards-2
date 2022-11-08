# Módulo dispersão --------------------------------------------------------

dispersao_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Gráfico de dispersão"),
    selectInput(
      inputId = ns("variavel"),
      label = "Selecione uma variável",
      choices = names(mtcars)
    ),
    plotOutput(outputId = ns("grafico"))
  )
}

dispersao_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$grafico <- renderPlot({
      plot(
        x = mtcars[[input$variavel]],
        y = mtcars[["mpg"]]
      )
    })

  })
}
