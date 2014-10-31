  shinyApp(
    ui =fluidPage(
      checkboxGroupInput("variable", "Variable:", inline = TRUE,
                         c("Cylinders" = "cyl",
                           "Transmission" = "am",
                           "Gears" = "gear")),
      radioButtons("radio", "Variable:", inline = TRUE,
                         c("Cylinders" = "cyl",
                           "Transmission" = "am",
                           "Gears" = "gear"))
    ),
    server = function(input, output) {}
  )
