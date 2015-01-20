shinybootstrap2
===============

This package provides R code and web resources for using [Bootstrap 2](http://getbootstrap.com/2.3.2/) with Shiny.

Versions of Shiny up to and including 0.10.2.2 generate HTML that uses Bootstrap 2. With version 0.11, Shiny switched to [Bootstrap 3](http://getbootstrap.com/), which is not fully compatible with Bootstrap 2. This package enables backward compatibility for Shiny apps that require Bootstrap 2.


## Quick start

shinybootstrap2 has not yet been released to CRAN, but you can install it using the devtools package.


```R
devtools::install_github('rstudio/shinybootstrap2')
```

You can also install the [shinyBS2demo](https://github.com/rstudio/shinyBS2demo) package, which demonstrates how to use shinybootstrap2 within a package:

```R
devtools::install_github('rstudio/shinyBS2demo')
```


## Using shinybootstrap2

There are a number of ways to run a Shiny app: at the console, 

### At the console

If you're using Shiny 0.11 or higher, this generates a page using Bootstrap 3 when run at the R console:

```R
library(shiny)

shinyApp(
  ui = fluidPage(
    sidebarPanel(selectInput("n", "n", c(1, 5, 10))),
    mainPanel(plotOutput("plot"))
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      plot(head(cars, as.numeric(input$n)))
    })
  }
)
```


To use Bootstrap 2, simply wrap your code in `shinybootstrap2::withBootstrap2({ })`. For example:

```R
shinybootstrap2::withBootstrap2({
  shinyApp(
    ui = fluidPage(
      sidebarPanel(selectInput("n", "n", c(1, 5, 10))),
      mainPanel(plotOutput("plot"))
    ),
    server = function(input, output) {
      output$plot <- renderPlot({
        plot(head(cars, as.numeric(input$n)))
      })
    }
  )
})
```

You'll notice that the appearance is slightly different. If you inspect the HTML source in your web browser, you'll see that this uses Bootstrap 2, while the previous code uses Bootstrap 3.

Similarly, instead of `shinyApp()`, you can also wrap calls to `runApp()` with `shinybootstrap2::withBootstrap2()`.


## In a package

The [shinyBS2demo](https://github.com/rstudio/shinyBS2demo/) package demonstrates how to use shinybootstrap2 in an R package.

To use shinybootstrap2 components in a package, the DESCRIPTION file should list it in Imports:

```
Imports:
    shinybootstrap2
```

However, the NAMESPACE should _not_ contain `import(shinybootstrap2)`: this will result in warnings in `R CMD check` if NAMESPACE also contains `import(shiny)`, because many objects from these two packages have the same name. If you are using roxygen2 for documentation, this means you should not have `#' @import shinybootstrap2` in your code.

There are a few different ways you can use shinybootstrap2 in a package:

* Use `shinybootstrap2::withBootstrap2()`.
* Add `importFrom(shinybootstrap2,withBootstrap2)` to your NAMESPACE file (if you are using roxygen2, you would add `#' @importFrom shinybootstrap2 withBootstrap2` to your code), then use `withBootstrap2()` in your code. 

The examples below will use the first method.

### Functions that return a shiny app object

If your package has functions that return a shiny app object (by calling `shinyApp()`), then you can call `shinybootstrap2::withBootstrap2()` inside those functions. For example, `bs2appObj` function in the shinyBS2demo package looks like this:

```R
bs2appObj <- function() {
  shinybootstrap2::withBootstrap2({
    shinyApp(
      ui = fluidPage(
        sidebarPanel(selectInput("n", "n", c(1, 5, 10))),
        mainPanel(plotOutput("plot"))
      ),
      server = function(input, output) {
        output$plot <- renderPlot({
          plot(head(cars, as.numeric(input$n)))
        })
      }
    )
  })
}
```

A user of this test package would run it with:

```R
library(shinyBS2demo)
bs2appObj()
```

You can contrast it to the `bs3appObj()` function, which doesn't have `withBootstrap2()` and therefore uses the default Bootstrap 3 components from Shiny:

```R
bs3appObj()
```

You can view the code for these functions at https://github.com/rstudio/shinyBS2demo/blob/master/R/demo.R.


### Shiny application files

Most Shiny applications consist of a `server.R` plus `ui.R`, or, for single file apps, `app.R`. To use these with shinybootstrap2, simply wrap all the code in `shinybootstrap2::withBootstrap2()`. The applications in shinyBS2demo's [inst/](https://github.com/rstudio/shinyBS2demo/tree/master/inst) directory use this format. To run them, you can do:


```R
# Uses shinybootstrap2
runApp(system.file('bs2app', package='shinyBS2demo'))

# Uses Bootstrap 3 components from shiny
runApp(system.file('bs3app', package='shinyBS2demo'))
```

You can view the code for these apps at https://github.com/rstudio/shinyBS2demo/tree/master/inst/.

To create an app in inst/ like this, the code in ui.R should be wrapped in `withBootstrap2()`:

```R
## ui.R
shinybootstrap2::withBootstrap2({
  fluidPage(
    selectInput("ui", "Input type", choices = c("numeric", "slider")),
    uiOutput("n_ui"),
    plotOutput("plot")
  )
})
```

The code in server.R needs `withBootstrap2()` if it contains dynamic UI-generating code, or code that updates particular types of inputs -- that is, code that is used with `renderUI()` or `updateCheckboxInput()`, or `updateRadioButtons()`. Here's an example server.R to go with the code above:

```R
## server.R
shinybootstrap2::withBootstrap2({
  function(input, output) {
    output$n_ui <- renderUI({
      if (input$ui == "numeric")
        numericInput("n", "n", 1)
      else if (input$ui == "slider")
        sliderInput("n", "n", 1, 10, value = 1)
    })
    output$plot <- renderPlot( plot(head(cars, input$n)) )
  }
})
```

It's safest to simply wrap all server code in `shinybootstrap2::withBootstrap2()`. If you have `global.R`, or other files that generate UI code, all the UI-generating code must also be wrapped in `shinybootstrap2::withBootstrap2()`.


For a single-file app, you can simply wrap all the code in `shinybootstrap2::withBootstrap2()`.
