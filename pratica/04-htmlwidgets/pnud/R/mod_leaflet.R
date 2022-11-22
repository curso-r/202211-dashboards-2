#' leaflet UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_leaflet_ui <- function(id){
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
        leaflet::leafletOutput(ns("mapa"), height = 600)
      ),
      column(
        width = 4,
        reactable::reactableOutput(ns("tabela"))
      )
    )
  )
}

#' leaflet Server Functions
#'
#' @noRd
mod_leaflet_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    pnud_filtrado <- shiny::reactive({

      pnud::pnud |>
        dplyr::filter(ano == input$ano)

    })

    output$mapa <- leaflet::renderLeaflet({

      pnud_filtrado() |>
        leaflet::leaflet() |>
        leaflet::addTiles() |>
        leaflet::addMarkers(
          layerId = ~muni_id,
          lat = ~lat,
          lng = ~lon,
          popup = ~muni_nm,
          clusterOptions = leaflet::markerClusterOptions()
        )

    })

    output$tabela <- reactable::renderReactable({


      req(input$mapa_marker_click)

      # browser()

      pnud_filtrado() |>
        # dplyr::slice(el$pointNumber + 1) |>
        dplyr::filter(muni_id == input$mapa_marker_click$id) |>
        dplyr::select(
          muni_nm, uf_sigla,
          idhm, rdpc, gini
        ) |>
        reactable::reactable()
    })


  })
}
