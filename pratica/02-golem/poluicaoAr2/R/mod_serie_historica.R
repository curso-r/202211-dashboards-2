#' serie_historica UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_serie_historica_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Polui\u00E7\u00E3o do ar na Grande S\u00E3o Paulo"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = ns("estacao"),
          label = "Selecione uma esta\u00E7\u00E3o",
          choices = unique(cetesb$estacao_cetesb)
        ),
        selectInput(
          inputId = ns("poluente"),
          label = "Selecione um poluente",
          choices = c("Carregando..." = "")
        )
      ),
      mainPanel(
        echarts4r::echarts4rOutput(ns("grafico"))
      )
    )
  )
}

#' serie_historica Server Functions
#'
#' @noRd
mod_serie_historica_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      opcoes <- poluicaoAr2::cetesb |>
        dplyr::filter(estacao_cetesb == input$estacao) |>
        dplyr::pull(poluente) |>
        unique()

      updateSelectInput(
        inputId = "poluente",
        choices = opcoes
      )

    })

    output$grafico <- echarts4r::renderEcharts4r({

      poluicaoAr2::cetesb |>
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

  })
}

