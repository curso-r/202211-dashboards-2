library(shiny)
library(echarts4r)

dados <- readr::read_rds(here::here("dados/rick_and_morty.rds"))

ui <- fluidPage(
  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "custom.css"
    )
  ),
  h1("Rick and Morty"),
  hr(),
  fluidRow(
    column(
      width = 4,
      selectInput(
        inputId = "temporada",
        label = "Selecione a temporada",
        choices = sort(unique(dados$num_temporada))
      )
    )
  ),
  fluidRow(
    column(
      width = 10,
      offset = 2,
      echarts4rOutput("grafico")
    )
  )
)

server <- function(input, output, session) {

  output$grafico <- renderEcharts4r({
    dados |>
      dplyr::filter(num_temporada == input$temporada) |>
      dplyr::mutate(
        titulo = paste(num_dentro_temporada, titulo, sep = " - ")
      ) |>
      dplyr::arrange(desc(num_dentro_temporada)) |>
      e_chart(x = qtd_espectadores_EUA, reorder = FALSE) |>
      e_bar(serie = titulo) |>
      e_y_axis(type = "category") |>
      e_grid(
        containLabel = TRUE
      ) |>
      e_legend(show = FALSE)
  })

}

shinyApp(ui, server)
