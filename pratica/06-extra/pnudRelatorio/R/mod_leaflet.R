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
    mod_filtro_ano_ui("filtro_ano_2"),
    fluidRow(
      checkboxInput(ns("colocar_cluster"), "Cluster?", value = TRUE)
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
mod_leaflet_server <- function(id, con, pnud_filtrado){
  moduleServer( id, function(input, output, session){
    ns <- session$ns




    output$mapa <- leaflet::renderLeaflet({

      if (input$colocar_cluster) {
        clust_opts <- leaflet::markerClusterOptions()
      } else {
        clust_opts <- NULL
      }

      pnud_filtrado() |>
        leaflet::leaflet() |>
        leaflet::addTiles() |>
        leaflet::addMarkers(
          layerId = ~muni_id,
          lat = ~lat,
          lng = ~lon,
          popup = ~muni_nm,
          clusterOptions = clust_opts
        )

    })

    output$tabela <- reactable::renderReactable({


      req(input$mapa_marker_click)

      # browser()

      pnud_filtrado() |>
        # dplyr::slice(el$pointNumber + 1) |>
        dplyr::filter(muni_id == input$mapa_marker_click$id) |>
        dplyr::select(
          ano, muni_nm, uf_sigla,
          idhm, rdpc, gini
        ) |>
        reactable::reactable()
    })


  })
}
