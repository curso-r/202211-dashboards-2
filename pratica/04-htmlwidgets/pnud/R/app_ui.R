#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage(
      "PNUD App",
      theme = bslib::bs_theme(5),
      tabPanel(
        "Plotly",
        mod_plotly_ui("plotly_1")
      ),
      tabPanel(
        "Reactable",
        mod_reactable_ui("reactable_1")
      ),
      tabPanel(
        "Leaflet",
        mod_leaflet_ui("leaflet_1")
      ),
      tabPanel(
        "echarts",
        "(exercício)"
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "pnud"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
