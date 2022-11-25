#' plotly UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plotly_ui <- function(id){
  ns <- NS(id)
  tagList(
    mod_filtro_ano_ui("filtro_ano_1"),
    fluidRow(
      column(
        width = 8,
        plotly::plotlyOutput(ns("grafico"), height = 400)
      ),
      column(
        width = 4,
        reactable::reactableOutput(ns("tabela"))
      )
    ),
    fluidRow(
      column(
        width = 8,
        plotly::plotlyOutput(ns("grafico2"), height = 400)
      ),
      column(
        width = 4,
        reactable::reactableOutput(ns("tabela2"))
      )
    )


  )
}

#' plotly Server Functions
#'
#' @noRd
mod_plotly_server <- function(id, con, pnud_filtrado){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$grafico <- plotly::renderPlotly({

      p <- pnud_filtrado() |>
        ggplot2::ggplot() +
        ggplot2::aes(x = idhm, y = rdpc) +
        ggplot2::geom_point()

      plotly::ggplotly(p)

    })

    output$grafico2 <- plotly::renderPlotly({

      p <- pnud_filtrado() |>
        ggplot2::ggplot() +
        ggplot2::aes(x = rdpc, y = idhm) +
        ggplot2::geom_point()

      ## precisa criar o source e o event register para
      ## que a gente possa especificar de qual input
      ## queremos pegar eventos.
      plotly::ggplotly(p, source = "grafico2") |>
        plotly::event_register('plotly_click') |>
        plotly::event_register('plotly_selected')

    })

    output$tabela <- reactable::renderReactable({


      clique <- plotly::event_data("plotly_click")
      selecao <- plotly::event_data("plotly_selected")

      if (is.null(clique)) {
        req(selecao)
        el <- selecao
      } else {
        req(clique)
        el <- clique
      }

      # browser()

      pnud_filtrado() |>
        dplyr::slice(el$pointNumber + 1) |>
        dplyr::select(
          muni_nm, uf_sigla,
          idhm, rdpc, gini
        ) |>
        reactable::reactable()
    })

    output$tabela2 <- reactable::renderReactable({


      clique <- plotly::event_data("plotly_click", "grafico2")
      selecao <- plotly::event_data("plotly_selected", "grafico2")

      if (is.null(clique)) {
        req(selecao)
        el <- selecao
      } else {
        req(clique)
        el <- clique
      }

      # browser()

      pnud_filtrado() |>
        dplyr::slice(el$pointNumber + 1) |>
        dplyr::select(
          muni_nm, uf_sigla,
          idhm, rdpc, gini
        ) |>
        reactable::reactable()
    })



  })
}
