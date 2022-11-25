library(shiny)

ui <- fluidPage(
  h1("Filtros hierárquicos"),
  hr(),
  column(
    width = 4,
    selectInput(
      "regiao",
      label = "Selecione a região",
      choices = c("Carregando" = "")
    )
  ),
  column(
    width = 4,
    selectInput(
      "muni",
      label = "Selecione o município",
      choices = c("Carregando" = "")
    )
  ),
  column(
    width = 4,
    selectInput(
      "delegacia",
      label = "Selecione a delegacia",
      choices = c("Carregando" = "")
    )
  ),
  fluidRow(
    column(
      width = 12,
      plotly::plotlyOutput("grafico")
    )
  )
)

server <- function(input, output, session) {

  ssp <- readr::read_rds(here::here("dados/ssp.rds"))

  # dplyr::glimpse(ssp)



  base_filtro <- ssp |>
    dplyr::distinct(regiao_nome, municipio_nome, delegacia_nome) |>
    dplyr::select(regiao_nome, municipio_nome, delegacia_nome)


  updateSelectInput(
    inputId = "regiao",
    choices = sort(unique(base_filtro$regiao_nome))
  )

  observe({

    req(input$regiao)

    opcoes <- base_filtro |>
      dplyr::filter(regiao_nome == input$regiao) |>
      dplyr::pull(municipio_nome) |>
      unique() |>
      sort()

    updateSelectInput(
      inputId = "muni",
      choices = opcoes
    )

  })

  observe({

    req(input$muni)

    opcoes <- base_filtro |>
      dplyr::filter(
        regiao_nome == input$regiao,
        municipio_nome == input$muni
      ) |>
      dplyr::pull(delegacia_nome) |>
      unique() |>
      sort()

    updateSelectInput(
      inputId = "delegacia",
      choices = opcoes
    )

  }) |>
    shiny::bindEvent(input$muni)


  output$grafico <- plotly::renderPlotly({

    req(input$delegacia)

    # Sys.sleep(2)

    p <- ssp |>
      dplyr::filter(
        regiao_nome == isolate(input$regiao),
        municipio_nome == isolate(input$muni),
        delegacia_nome == input$delegacia
      ) |>
      dplyr::group_by(ano) |>
      dplyr::summarise(roubo = mean(roubo_veiculo, na.rm = TRUE)) |>
      ggplot2::ggplot(ggplot2::aes(as.numeric(ano), roubo)) +
      ggplot2::geom_point() +
      ggplot2::geom_line()

    plotly::ggplotly(p)

  })

}

shinyApp(ui, server)
