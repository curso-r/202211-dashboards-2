#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  mod_plotly_server("plotly_1")
  mod_reactable_server("reactable_1")
  mod_leaflet_server("leaflet_1")
}
