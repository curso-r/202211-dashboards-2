#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  con <- conectar_bd()

  base_filtrada_1 <- mod_filtro_ano_server("filtro_ano_1")
  base_filtrada_2 <- mod_filtro_ano_server("filtro_ano_2")

  # se quiser os filtros DEPENDENTES
  observe({
    updateSelectInput(
      session,
      inputId = paste0("filtro_ano_2-ano"),
      selected = base_filtrada_1()$ano[1]
    )
  })

  observe({
    updateSelectInput(
      session,
      inputId = paste0("filtro_ano_1-ano"),
      selected = base_filtrada_2()$ano[1]
    )
  })


  mod_plotly_server("plotly_1", con, base_filtrada_1)
  mod_reactable_server("reactable_1", con)
  mod_leaflet_server(
    "leaflet_1", con,
    #base_filtrada_1 ## DEPENDENTES
    base_filtrada_2
  )
}
