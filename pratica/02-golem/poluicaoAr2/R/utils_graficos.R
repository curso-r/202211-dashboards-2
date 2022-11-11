echart_linha <- function(tab) {
  tab |>
    echarts4r::e_chart(x = x) |>
    echarts4r::e_line(serie = y) |>
    echarts4r::e_color("orange") |>
    echarts4r::e_legend(show = FALSE)
}
