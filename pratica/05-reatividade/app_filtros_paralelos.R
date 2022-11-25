library(shiny)

ui <- fluidPage(
  h1("Filtros paralelos"),
  hr(),
  column(
    width = 3,
    shinyWidgets::pickerInput(
      "cor_dos_olhos",
      label = "Selecione a cor dos olhos",
      choices = c("Carregando" = ""),
      multiple = TRUE
    )
  ),
  column(
    width = 3,
    shinyWidgets::pickerInput(
      "cor_da_pele",
      label = "Selecione a cor da pele",
      choices = c("Carregando" = ""),
      multiple = TRUE
    )
  ),
  column(
    width = 3,
    shinyWidgets::pickerInput(
      "sexo_biologico",
      label = "Selecione o sexo",
      choices = c("Carregando" = ""),
      multiple = TRUE
    )
  ),
  column(
    width = 3,
    actionButton("voltar_filtros", "Recarregar")
  ),
  fluidRow(
    column(
      width = 12,
      plotly::plotlyOutput("grafico")
    )

  )
)

server <- function(input, output, session) {
  da <- dados::dados_starwars


  dados_filtrados <- shiny::reactive({

    req(input$cor_dos_olhos)
    req(input$cor_da_pele)
    req(input$sexo_biologico)

    da |>
      dplyr::filter(
        cor_dos_olhos %in% input$cor_dos_olhos,
        cor_da_pele %in% input$cor_da_pele,
        sexo_biologico %in% input$sexo_biologico
      )
  })

  observe({


    shinyWidgets::updatePickerInput(
      session,
      inputId = "cor_dos_olhos",
      choices = unique(da$cor_dos_olhos),
      selected = unique(da$cor_dos_olhos)
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "cor_da_pele",
      choices = unique(da$cor_da_pele),
      selected = unique(da$cor_da_pele)
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "sexo_biologico",
      choices = unique(da$sexo_biologico),
      selected = unique(da$sexo_biologico)
    )

  }) |>
    shiny::bindEvent(input$voltar_filtros, ignoreNULL = FALSE)

  observe({

    shinyWidgets::updatePickerInput(
      session,
      inputId = "cor_dos_olhos",
      choices = unique(dados_filtrados()$cor_dos_olhos),
      selected = unique(dados_filtrados()$cor_dos_olhos)
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "cor_da_pele",
      choices = unique(dados_filtrados()$cor_da_pele),
      selected = unique(dados_filtrados()$cor_da_pele)
    )
    shinyWidgets::updatePickerInput(
      session,
      inputId = "sexo_biologico",
      choices = unique(dados_filtrados()$sexo_biologico),
      selected = unique(dados_filtrados()$sexo_biologico)
    )

  })



  output$grafico <- plotly::renderPlotly({

    p <- dados_filtrados() |>
      ggplot2::ggplot(ggplot2::aes(massa, altura)) +
      ggplot2::geom_point()

    plotly::ggplotly(p)

  })




}

shinyApp(ui, server)
