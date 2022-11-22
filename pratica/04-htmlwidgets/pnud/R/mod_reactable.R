#' reactable UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_reactable_ui <- function(id){
  ns <- NS(id)
  tagList(

    fluidRow(
      selectInput(
        ns("ano"), "Selecione um ano",
        unique(pnud::pnud$ano)
      ),
      column(
        width = 8,
        reactable::reactableOutput(ns("tabela"))
      )
    ),
    fluidRow(
      column(
        width = 12,
        leaflet::leafletOutput(ns("mapa"))
      )
    )

  )
}

#' reactable Server Functions
#'
#' @noRd
mod_reactable_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    sumario <- shiny::reactive({

      pnud::pnud |>
        dplyr::filter(ano == input$ano) |>
        dplyr::group_by(regiao_nm, uf_sigla) |>
        dplyr::summarise(
          idhm = mean(idhm),
          rdpc = mean(rdpc),
          .groups = "drop"
        )

    })

    output$tabela <- reactable::renderReactable({


      shiny::isolate({
        linhas <- reactable::getReactableState(
          "tabela", "selected"
        )
      })

      if (!is.null(linhas)) {
        ids <- linhas
      } else {
        ids <- 1
      }

      reactable::reactable(
        sumario(),
        selection = "multiple",
        defaultSelected = ids
      )

    })

    output$mapa <- leaflet::renderLeaflet({

      linhas <- reactable::getReactableState(
        "tabela", "selected"
      )

      req(linhas)

      # browser()

      uf_sel <- sumario() |>
        dplyr::slice(linhas) |>
        dplyr::pull(uf_sigla)

      pnud::pnud |>
        dplyr::filter(
          ano == input$ano,
          uf_sigla %in% uf_sel
        ) |>
        leaflet::leaflet() |>
        leaflet::addTiles() |>
        leaflet::addMarkers(
          lat = ~lat,
          lng = ~lon,
          popup = ~muni_nm,
          clusterOptions = leaflet::markerClusterOptions()
        )

    })




  })
}
