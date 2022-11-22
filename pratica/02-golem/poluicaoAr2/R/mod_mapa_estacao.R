#' mapa_estacao UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_mapa_estacao_ui <- function(id){
  ns <- NS(id)
  tagList(

    sidebarLayout(
      sidebarPanel = sidebarPanel(
        selectInput(
          ns("estacao"),
          "Selecione a esta\u00E7\u00E3o",
          choices = c("Carregando" = "..."),
          multiple = TRUE
        )
      ),
      mainPanel = mainPanel(

        leaflet::leafletOutput(ns("mapa"))

      )
    )

  )
}

#' mapa_estacao Server Functions
#'
#' @noRd
mod_mapa_estacao_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    updateSelectInput(
      inputId = "estacao",
      choices = unique(poluicaoAr2::cetesb$estacao_cetesb)
    )


    output$mapa <- leaflet::renderLeaflet({

      sumario <- poluicaoAr2::cetesb |>
        dplyr::filter(estacao_cetesb %in% input$estacao) |>
        dplyr::group_by(estacao_cetesb) |>
        dplyr::summarise(
          lat = dplyr::first(lat),
          long = dplyr::first(long),
          media = mean(concentracao, na.rm = TRUE)
        ) |>
        dplyr::mutate(
          lab = stringr::str_glue(
            "<strong>Esta\u00E7\u00E3o: </strong>{estacao_cetesb}<br/>",
            "<strong>M\u00E9dia concentra\u00E7\u00E3o</strong>: {media}"
          )
        )

      sumario |>
        leaflet::leaflet() |>
        leaflet::addTiles() |>
        leaflet::addMarkers(
          lng = ~long,
          lat = ~lat,
          popup = ~lab
        )



    })


  })
}

