library(shiny)
# remotes::install_github("rstudio/bslib")
library(bslib)
library(bsicons)

# análogo às boxes do bs4Dash ou shinydashboard
card1 <- navs_tab_card(
  title = "Plotly",
  nav(
    "Plotly",
    card_title("A plotly plot"),
    card_body(plotly::plotlyOutput("p1"))
  ),
  nav(
    "Leaflet",
    card_title("A leaflet plot"),
    card_body(leaflet::leafletOutput("m1")) |>
      tippy::with_tippy("mostra uma telinha")
  ),
  nav(
    shiny::icon("circle-info"),
    "Learn more about",
    tags$a("htmlwidgets", href = "http://www.htmlwidgets.org/")|>
      tippy::with_tippy("mostra uma telinha")
  )
)

card2 <- navs_pill_card(
  title = "Plotly",
  nav(
    "Plotly",
    card_title("A plotly plot"),
    card_body(plotly::plotlyOutput("p2"))
  ),
  nav(
    "Leaflet",
    card_title("A leaflet plot"),
    card_body(leaflet::leafletOutput("m2"))
  )
)
card3 <- card(
  card_header(class = "bg-dark", "Um header"),
  card_body(markdown("Link para [Curso-R](https://curso-r.com)"))
)
card4 <- card(
  card_header(class = "bg-dark", "Um header"),
  card_body(markdown("Link para [Curso-R](https://curso-r.com)")),
  card_footer("Texto de informação")
)

vbox1 <- value_box(
  "Titulo",
  value = markdown("Texto **muito** legal"),
  showcase = bs_icon("airplane"),
  "Mais texto"
) |> tippy::with_tippy("mostra uma telinha")
vbox2 <- value_box(
  "Titulo",
  value = markdown("Texto **muito** legal"),
  showcase = bs_icon("android"),
  showcase_layout = showcase_top_right(),
  theme_color = "secondary",
  "Mais texto"
)

ui <- page_navbar(
  title = "Observatório do PNUD",
  theme = bs_theme(version = 5),
  nav(
    "Primeira Aba",
    layout_column_wrap(
      1/4, vbox1, vbox2, vbox1, vbox2
    ),
    br(),
    layout_column_wrap(
      1/2, height = 400,
      card1, card2
    ),
    br(),
    layout_column_wrap(
      1/2, height = 400,
      card3, card4
    )
  )
)

server <- function(input, output, session) {

  output$p1 <- plotly::renderPlotly({

    p <- abjData::pnud_min |>
      dplyr::filter(ano == 2010) |>
      ggplot2::ggplot(ggplot2::aes(x = idhm, y = rdpc, colour = gini)) +
      ggplot2::geom_point() +
      ggplot2::theme_minimal()

    plotly::ggplotly(p)

  })

  output$p2 <- plotly::renderPlotly({

    p <- abjData::pnud_min |>
      dplyr::filter(ano == 2010) |>
      ggplot2::ggplot(ggplot2::aes(x = espvida, y = rdpc, colour = gini)) +
      ggplot2::geom_point() +
      ggplot2::theme_minimal()

    plotly::ggplotly(p)

  })

  output$m1 <- leaflet::renderLeaflet({

    abjData::pnud_min |>
      dplyr::filter(ano == 2010) |>
      leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addMarkers(
        lat = ~lat,
        lng = ~lon,
        popup = ~muni_nm,
        clusterOptions = leaflet::markerClusterOptions()
      )
  })

  output$m2 <- leaflet::renderLeaflet({

    abjData::pnud_min |>
      dplyr::filter(ano == 2010) |>
      dplyr::slice_sample(n = 100) |>
      leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addMarkers(
        lat = ~lat,
        lng = ~lon,
        popup = ~muni_nm
      )
  })

}

shinyApp(ui, server)
