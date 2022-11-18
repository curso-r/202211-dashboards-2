library(shiny)

ui <- fluidPage(
  tags$head(
    tags$title("Esse é o título do documento"),
    tags$link(
      rel = "stylesheet",
      href = "custom.css"
    ),
    tags$style(
      "p {
        color: gray;
      }"
    )
  ),
  h1("Título principal", style = "color: red; text-transform: uppercase;"),
  h2("Mais um título", style = "color: rgb(100, 100, 255);"),
  h3("Esse é o subsubsubsubsubcapítulo", style = "color: #abc123;"),
  p("Este é o primeiro", tags$b(" parágrafo ", .noWS = c("before", "after")), "desta página HTML."),
  br(),
  p(
    a("Esse é o site da curso-r", href = "https://curso-r.com", target = "_blank")
  ),
  p(class = "fundo-amarelo", "Outro parágrafo!", style = "color: red;"),
  img(
    style = "display: block; position: relative; left: 100px;",
    src = "hex-shiny.png",
    width = "100px",
    alt = "hexágono azul escrito shiny em branco no centro (sticker do shiny)",
    title = "descrição da imagem que aparece quando colocamos o mouse em cima"
  ),
  img(
    src = "hex-shiny.png",
    width = "100px",
    alt = "hexágono azul escrito shiny em branco no centro (sticker do shiny)",
    title = "descrição da imagem que aparece quando colocamos o mouse em cima"
  ),
  div(
    style = "position: relative;",
    p("Mais um parágrafo", class = "fundo-azul letra-branca text-center"),
    div(
      id = "div-com-fundo-amarelo",
      style = "font-family: 'Sofia', cursive;",
      p("Esse texto aparece dentro do fundo amarelo"),
      p("Esse texto aparece dentro do fundo amarelo"),
      p("Esse texto aparece dentro do fundo amarelo")
    ),
    img(
      src = "hex-shiny.png",
      width = "100px",
      alt = "hexágono azul escrito shiny em branco no centro (sticker do shiny)",
      title = "descrição da imagem que aparece quando colocamos o mouse em cima"
    ),
    p("Esse parágrafo contém um", span("elemento span")),
    div(
      style = "position: static; height: 100px; background-color: pink;",
      p("Um texto que vem primeiro"),
      p("Texto qualquer", style = "position: absolute; top: 0;"),
      p("Mais um texto qualquer", style = "position: fixed; top: 100px;")
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
