#' Create a header panel
#'
#' Create a header panel containing an application title.
#'
#' @param title An application title to display
#' @param windowTitle The title that should be displayed by the browser window.
#'   Useful if \code{title} is not a string.
#' @return A headerPanel that can be passed to \link{pageWithSidebar}
#'
#' @examples
#' headerPanel("Hello Shiny!")
#' @export
headerPanel <- function(title, windowTitle=title) {
  tagList(
    tags$head(tags$title(windowTitle)),
    div(class="span12", style="padding: 10px 0px;",
      h1(title)
    )
  )
}

#' Create a well panel
#'
#' Creates a panel with a slightly inset border and grey background. Equivalent
#' to Bootstrap's \code{well} CSS class.
#'
#' @param ... UI elements to include inside the panel.
#' @return The newly created panel.
#'
#' @export
wellPanel <- function(...) {
  div(class="well", ...)
}

#' Create a sidebar panel
#'
#' Create a sidebar panel containing input controls that can in turn be passed
#' to \code{\link{sidebarLayout}}.
#'
#' @param ... UI elements to include on the sidebar
#' @param width The width of the sidebar. For fluid layouts this is out of 12
#'   total units; for fixed layouts it is out of whatever the width of the
#'   sidebar's parent column is.
#' @return A sidebar that can be passed to \code{\link{sidebarLayout}}
#'
#' @examples
#' # Sidebar with controls to select a dataset and specify
#' # the number of observations to view
#' sidebarPanel(
#'   selectInput("dataset", "Choose a dataset:",
#'               choices = c("rock", "pressure", "cars")),
#'
#'   numericInput("obs", "Observations:", 10)
#' )
#' @export
sidebarPanel <- function(..., width = 4) {
  div(class=paste0("span", width),
    tags$form(class="well",
      ...
    )
  )
}

#' Create a main panel
#'
#' Create a main panel containing output elements that can in turn be passed to
#' \code{\link{sidebarLayout}}.
#'
#' @param ... Output elements to include in the main panel
#' @param width The width of the main panel. For fluid layouts this is out of 12
#'   total units; for fixed layouts it is out of whatever the width of the main
#'   panel's parent column is.
#' @return A main panel that can be passed to \code{\link{sidebarLayout}}.
#'
#' @examples
#' # Show the caption and plot of the requested variable against mpg
#' mainPanel(
#'    h3(textOutput("caption")),
#'    plotOutput("mpgPlot")
#' )
#' @export
mainPanel <- function(..., width = 8) {
  div(class=paste0("span", width),
    ...
  )
}

#' Conditional Panel
#'
#' Creates a panel that is visible or not, depending on the value of a
#' JavaScript expression. The JS expression is evaluated once at startup and
#' whenever Shiny detects a relevant change in input/output.
#'
#' In the JS expression, you can refer to \code{input} and \code{output}
#' JavaScript objects that contain the current values of input and output. For
#' example, if you have an input with an id of \code{foo}, then you can use
#' \code{input.foo} to read its value. (Be sure not to modify the input/output
#' objects, as this may cause unpredictable behavior.)
#'
#' @param condition A JavaScript expression that will be evaluated repeatedly to
#'   determine whether the panel should be displayed.
#' @param ... Elements to include in the panel.
#'
#' @note You are not recommended to use special JavaScript characters such as a
#'   period \code{.} in the input id's, but if you do use them anyway, for
#'   example, \code{inputId = "foo.bar"}, you will have to use
#'   \code{input["foo.bar"]} instead of \code{input.foo.bar} to read the input
#'   value.
#' @examples
#' sidebarPanel(
#'    selectInput(
#'       "plotType", "Plot Type",
#'       c(Scatter = "scatter",
#'         Histogram = "hist")),
#'
#'    # Only show this panel if the plot type is a histogram
#'    conditionalPanel(
#'       condition = "input.plotType == 'hist'",
#'       selectInput(
#'          "breaks", "Breaks",
#'          c("Sturges",
#'            "Scott",
#'            "Freedman-Diaconis",
#'            "[Custom]" = "custom")),
#'
#'       # Only show this panel if Custom is selected
#'       conditionalPanel(
#'          condition = "input.breaks == 'custom'",
#'          sliderInput("breakCount", "Break Count", min=1, max=1000, value=10)
#'       )
#'    )
#' )
#'
#' @export
conditionalPanel <- function(condition, ...) {
  div('data-display-if'=condition, ...)
}
