library(shiny)
library(dplyr)
library(ggplot2)

dados <- readr::read_rds(
  here::here("dados/pkmn.rds")
)

ui <- navbarPage(
  title = "App Pokémon",
  tabPanel(
    title = "Grama",
    conteudo_ui("conteudo_1", tipo = "grama")
  ),
  tabPanel(
    title = "Fogo",
    conteudo_ui("conteudo_2", tipo = "fogo")
  ),
  tabPanel(
    title = "Água",
    conteudo_ui("conteudo_3", tipo = "água")
  )
)

server <- function(input, output, session) {

  conteudo_server("conteudo_1", dados = dados, tipo = "grama")
  conteudo_server("conteudo_2", dados = dados, tipo = "fogo")
  conteudo_server("conteudo_3", dados = dados, tipo = "água")

}

shinyApp(ui, server)
