library(shiny)
library(dplyr)
library(ggplot2)

dados <- readr::read_rds(
  here::here("dados/pkmn.rds")
)

ui <- navbarPage(
  title = "App Pokémon",
  id = "menu"
)

server <- function(input, output, session) {

  tipos <- unique(dados$tipo_1)

  purrr::walk(
    tipos,
    ~ appendTab(
      inputId = "menu",
      tab = tabPanel(
        title = stringr::str_to_sentence(.x),
        conteudo_ui(
          id = glue::glue("conteudo_{.x}"),
          tipo = .x
        )
      ),
      select = ifelse(.x == tipos[1], TRUE, FALSE)
    )
  )

  purrr::walk(
    tipos,
    ~ conteudo_server(
      id = glue::glue("conteudo_{.x}"),
      dados = dados,
      tipo = .x
    )
  )

}

shinyApp(ui, server)
