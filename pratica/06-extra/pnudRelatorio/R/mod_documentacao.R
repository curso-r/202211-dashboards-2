#' documentacao UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_documentacao_ui <- function(id){
  ns <- NS(id)
  tagList(

    shiny::fluidRow(
      shiny::column(
        width = 5, offset = 1,
        shiny::includeMarkdown(system.file(
          "documentacao.md", package = "pnudRelatorio"
        ))
      ),
      shiny::column(
        width = 5,
        shiny::fluidRow(
          shiny::selectInput(
            ns("ano"), "Selecione o ano",
            c("1991", "2000", "2010")
          ),
          shiny::downloadButton(
            ns("relatorio"), "Gerar relatório"
          )
        )
      )
    )

  )
}

#' documentacao Server Functions
#'
#' @noRd
mod_documentacao_server <- function(id, con){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$relatorio <- shiny::downloadHandler(
      filename = "relatorio.pdf",
      content = function(file) {

        dados <- dplyr::tbl(con, "pnud") |>
          dplyr::filter(ano == local(input$ano)) |>
          dplyr::collect()

        arquivo_html <- fs::file_temp(ext = ".html")

        rmarkdown::render(
          system.file(
            "template_analise.Rmd",
            package = "pnudRelatorio"
          ),
          output_file = arquivo_html,
          params = list(
            ano_selecionado = input$ano,
            bd = dados
          )
        )

        pagedown::chrome_print(
          arquivo_html,
          file
        )

      }
    )

  })
}
