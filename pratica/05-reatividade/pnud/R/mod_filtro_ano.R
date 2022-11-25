#' filtro_ano UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filtro_ano_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        selectInput(
          ns("ano"), "Selecione um ano",
          pegar_anos()
        ),
        width = 4
      )
    )
  )
}

#' filtro_ano Server Functions
#'
#' @noRd
mod_filtro_ano_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    pnud_filtrado <- shiny::reactive({
      dplyr::tbl(con, "pnud") |>
        dplyr::filter(ano == local(input$ano)) |>
        dplyr::collect()
    })

    observe({

      if (input$ano != pnud_filtrado()$ano[1]) {
        updateSelectInput(
          inputId = "ano",
          selected = pnud_filtrado()$ano[1]
        )
      }

    })

    return(pnud_filtrado)

  })
}

## To be copied in the UI
# mod_filtro_ano_ui("filtro_ano_1")

## To be copied in the server
# mod_filtro_ano_server("filtro_ano_1")
