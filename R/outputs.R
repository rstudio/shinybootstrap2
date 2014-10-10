#' Create a text output element
#'
#' Render a reactive output variable as text within an application page. The
#' text will be included within an HTML \code{div} tag by default.
#' @param outputId output variable to read the value from
#' @param container a function to generate an HTML element to contain the text
#' @param inline use an inline (\code{span()}) or block container (\code{div()})
#'   for the output
#' @return A text output element that can be included in a panel
#' @details Text is HTML-escaped prior to rendering. This element is often used
#'   to display \link[shiny]{renderText} output variables.
#' @examples
#' \donttest{
#' h3(textOutput("caption"))
#' }
#' @export
textOutput <- function(outputId, container = if (inline) span else div, inline = FALSE) {
  container(id = outputId, class = "shiny-text-output")
}

#' Create a verbatim text output element
#'
#' Render a reactive output variable as verbatim text within an
#' application page. The text will be included within an HTML \code{pre} tag.
#' @param outputId output variable to read the value from
#' @return A verbatim text output element that can be included in a panel
#' @details Text is HTML-escaped prior to rendering. This element is often used
#' with the \link[shiny]{renderPrint} function to preserve fixed-width formatting
#' of printed objects.
#' @examples
#' \donttest{
#' mainPanel(
#'   h4("Summary"),
#'   verbatimTextOutput("summary"),
#'
#'   h4("Observations"),
#'   tableOutput("view")
#' )
#' }
#' @export
verbatimTextOutput <- function(outputId) {
  textOutput(outputId, container = pre)
}

#' Create a image output element
#'
#' Render a \link[shiny]{renderImage} within an application page.
#' @param outputId output variable to read the image from
#' @param width Image width. Must be a valid CSS unit (like \code{"100\%"},
#'   \code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
#'   string and have \code{"px"} appended.
#' @param height Image height
#' @inheritParams textOutput
#' @return An image output element that can be included in a panel
#' @examples
#' # Show an image
#' mainPanel(
#'   imageOutput("dataImage")
#' )
#' @export
imageOutput <- function(outputId, width = "100%", height="400px", inline=FALSE) {
  style <- paste("width:", validateCssUnit(width), ";",
    "height:", validateCssUnit(height))
  container <- if (inline) span else div
  container(id = outputId, class = "shiny-image-output", style = style)
}

#' Create an plot output element
#'
#' Render a \link[shiny]{renderPlot} within an application page.
#' @param outputId output variable to read the plot from
#' @param width,height Plot width/height. Must be a valid CSS unit (like
#'   \code{"100\%"}, \code{"400px"}, \code{"auto"}) or a number, which will be
#'   coerced to a string and have \code{"px"} appended. These two arguments are
#'   ignored when \code{inline = TRUE}, in which case the width/height of a plot
#'   must be specified in \code{renderPlot()}.
#' @param clickId If not \code{NULL}, the plot will send coordinates to the
#'   server whenever it is clicked. This information will be accessible on the
#'   \code{input} object using \code{input$}\emph{\code{clickId}}. The value
#'   will be a named list or vector with \code{x} and \code{y} elements
#'   indicating the mouse position in user units.
#' @param hoverId If not \code{NULL}, the plot will send coordinates to the
#'   server whenever the mouse pauses on the plot for more than the number of
#'   milliseconds determined by \code{hoverTimeout}. This information will be
#'   accessible on the \code{input} object using
#'   \code{input$}\emph{\code{clickId}}. The value will be \code{NULL} if the
#'   user is not hovering, and a named list or vector with \code{x} and \code{y}
#'   elements indicating the mouse position in user units.
#' @param hoverDelay The delay for hovering, in milliseconds.
#' @param hoverDelayType The type of algorithm for limiting the number of hover
#'   events. Use \code{"throttle"} to limit the number of hover events to one
#'   every \code{hoverDelay} milliseconds. Use \code{"debounce"} to suspend
#'   events while the cursor is moving, and wait until the cursor has been at
#'   rest for \code{hoverDelay} milliseconds before sending an event.
#' @inheritParams textOutput
#' @note The arguments \code{clickId} and \code{hoverId} only work for R base
#'   graphics (see the \pkg{\link{graphics}} package). They do not work for
#'   \pkg{\link[grid:grid-package]{grid}}-based graphics, such as \pkg{ggplot2},
#'   \pkg{lattice}, and so on.
#' @return A plot output element that can be included in a panel
#' @examples
#' # Show a plot of the generated distribution
#' mainPanel(
#'   plotOutput("distPlot")
#' )
#' @export
plotOutput <- function(outputId, width = "100%", height="400px",
                       clickId = NULL, hoverId = NULL, hoverDelay = 300,
                       hoverDelayType = c("debounce", "throttle"), inline = FALSE) {
  if (is.null(clickId) && is.null(hoverId)) {
    hoverDelay <- NULL
    hoverDelayType <- NULL
  } else {
    hoverDelayType <- match.arg(hoverDelayType)[[1]]
  }

  style <- if (!inline) {
    paste("width:", validateCssUnit(width), ";", "height:", validateCssUnit(height))
  }

  container <- if (inline) span else div
  container(id = outputId, class = "shiny-plot-output", style = style,
      `data-click-id` = clickId,
      `data-hover-id` = hoverId,
      `data-hover-delay` = hoverDelay,
      `data-hover-delay-type` = hoverDelayType)
}

#' Create a table output element
#'
#' Render a \link[shiny]{renderTable} within an application page.
#' @param outputId output variable to read the table from
#' @return A table output element that can be included in a panel
#' @examples
#' mainPanel(
#'   tableOutput("view")
#' )
#' @export
tableOutput <- function(outputId) {
  div(id = outputId, class="shiny-html-output")
}

dataTableDependency <- list(
  htmlDependency(
    "datatables", "1.10.2", c(href = "shared/datatables"),
    script = "js/jquery.dataTables.min.js"
  ),
  htmlDependency(
    "datatables-bootstrap", "1.10.2", c(href = "shared/datatables"),
    stylesheet = c("css/dataTables.bootstrap.css", "css/dataTables.extra.css"),
    script = "js/dataTables.bootstrap.js"
  )
)

#' @rdname tableOutput
#' @export
dataTableOutput <- function(outputId) {
  attachDependencies(
    div(id = outputId, class="shiny-datatable-output"),
    dataTableDependency
  )
}

#' Create an HTML output element
#'
#' Render a reactive output variable as HTML within an application page. The
#' text will be included within an HTML \code{div} tag, and is presumed to
#' contain HTML content which should not be escaped.
#'
#' \code{uiOutput} is intended to be used with \code{renderUI} on the
#' server side. It is currently just an alias for \code{htmlOutput}.
#'
#' @param outputId output variable to read the value from
#' @inheritParams textOutput
#' @return An HTML output element that can be included in a panel
#' @examples
#' htmlOutput("summary")
#' @export
htmlOutput <- function(outputId, inline = FALSE) {
  container <- if (inline) span else div
  container(id = outputId, class="shiny-html-output")
}

#' @rdname htmlOutput
#' @export
uiOutput <- htmlOutput
