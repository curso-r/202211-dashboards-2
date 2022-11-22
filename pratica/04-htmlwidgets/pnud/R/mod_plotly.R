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

    fluidRow(
      column(
        selectInput(
          ns("ano"), "Selecione um ano",
          unique(pnud::pnud$ano)
        ),
        width = 4
      )
    ),
    fluidRow(
      column(
        width = 8,
        plotly::plotlyOutput(ns("grafico"), height = 600)
      ),
      column(
        width = 4,
        reactable::reactableOutput(ns("tabela"))
      )
    )


  )
}

#' plotly Server Functions
#'
#' @noRd
mod_plotly_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    pnud_filtrado <- shiny::reactive({

      pnud::pnud |>
        dplyr::filter(ano == input$ano)

    })

    output$grafico <- plotly::renderPlotly({

      p <- pnud_filtrado() |>
        ggplot2::ggplot() +
        ggplot2::aes(x = idhm, y = rdpc) +
        ggplot2::geom_point()

      plotly::ggplotly(p)

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



  })
}
