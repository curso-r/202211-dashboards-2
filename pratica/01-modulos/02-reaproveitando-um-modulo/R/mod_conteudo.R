conteudo_ui <- function(id, tipo) {
  ns <- NS(id)
  tagList(
    h2(glue::glue("Pokémon do tipo {tipo}")),
    selectInput(
      ns("pokemon"),
      label = "Selecione um pokemon",
      choices = c("Carregando" = "...")
    ),
    fluidRow(
      column(
        width = 4,
        uiOutput(ns("imagem"))
      ),
      column(
        width = 8,
        plotOutput(ns("grafico"))
      )
    )
  )
}

conteudo_server <- function(id, dados, tipo) {
  moduleServer(id, function(input, output, session) {

    observe({
      escolhas <- dados |>
        filter(tipo_1 == tipo) |>
        pull(pokemon)

      updateSelectInput(
        inputId = "pokemon",
        choices = escolhas
      )
    })

    output$imagem <- renderUI({

      id <- dados |>
        filter(pokemon == input$pokemon) |>
        pull(id) |>
        stringr::str_pad(width = 3, side = "left", pad = "0")

      url <- glue::glue(
        "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
      )

      img(
        src = url,
        width = "60%"
      )

    })

    output$grafico <- renderPlot({

      dados_pokemon_escolhido <-  dados |>
        filter(pokemon == input$pokemon) |>
        tidyr::pivot_longer(
          names_to = "caracteristica",
          values_to = "valor",
          cols = hp:velocidade
        )


      dados |>
        filter(tipo_1 == tipo) |>
        tidyr::pivot_longer(
          names_to = "caracteristica",
          values_to = "valor",
          cols = hp:velocidade
        ) |>
        ggplot(aes(x = valor, y = caracteristica)) +
        ggridges::geom_density_ridges(
          aes(fill = caracteristica),
          show.legend = FALSE,
          alpha = 0.5
        ) +
        geom_point(
          data = dados_pokemon_escolhido,
          shape = 4
        ) +
        theme_minimal()

    })


  })
}
