#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  observe({
    opcoes <- cetesb |>
      dplyr::filter(estacao_cetesb == input$estacao) |>
      dplyr::pull(poluente) |>
      unique()

    updateSelectInput(
      inputId = "poluente",
      choices = opcoes
    )

  })

  output$grafico <- echarts4r::renderEcharts4r({

    cetesb |>
      dplyr::filter(
        estacao_cetesb == input$estacao,
        poluente == input$poluente
      ) |>
      dplyr::group_by(data) |>
      dplyr::summarise(
        media = mean(concentracao, na.rm = TRUE)
      ) |>
      dplyr::rename(
        x = data,
        y = media
      ) |>
      echart_linha()

  })



}
