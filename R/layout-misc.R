#' Create a column within a UI definition
#'
#' Create a column for use within a  \code{\link{fluidRow}} or
#' \code{\link{fixedRow}}
#'
#' @param width The grid width of the column (must be between 1 and 12)
#' @param ... Elements to include within the column
#' @param offset The number of columns to offset this column from the end of the
#'   previous column.
#'
#' @return A column that can be included within a
#'   \code{\link{fluidRow}} or \code{\link{fixedRow}}.
#'
#'
#' @seealso \code{\link{fluidRow}}, \code{\link{fixedRow}}.
#'
#' @examples
#' fluidRow(
#'   column(4,
#'     sliderInput("obs", "Number of observations:",
#'                 min = 1, max = 1000, value = 500)
#'   ),
#'   column(8,
#'     plotOutput("distPlot")
#'   )
#' )
#'
#' fluidRow(
#'   column(width = 4,
#'     "4"
#'   ),
#'   column(width = 3, offset = 2,
#'     "3 offset 2"
#'   )
#' )
#' @export
column <- function(width, ..., offset = 0) {

  if (!is.numeric(width) || (width < 1) || (width > 12))
    stop("column width must be between 1 and 12")

  colClass <- paste0("span", width)
  if (offset > 0)
    colClass <- paste0(colClass, " offset", offset)
  div(class = colClass, ...)
}


#' Create a panel containing an application title.
#'
#' @param title An application title to display
#' @param windowTitle The title that should be displayed by the browser window.
#'
#' @details Calling this function has the side effect of including a
#'   \code{title} tag within the head. You can also specify a page title
#'   explicitly using the `title` parameter of the top-level page function.
#'
#'
#' @examples
#' titlePanel("Hello Shiny!")
#'
#' @export
titlePanel <- function(title, windowTitle=title) {
  tagList(
    tags$head(tags$title(windowTitle)),
    h2(style = "padding: 10px 0px;", title)
  )
}

#' Layout a sidebar and main area
#'
#' Create a layout with a sidebar and main area. The sidebar is displayed with a
#' distinct background color and typically contains input controls. The main
#' area occupies 2/3 of the horizontal width and typically contains outputs.
#'
#' @param sidebarPanel The \link{sidebarPanel} containing input controls
#' @param mainPanel The \link{mainPanel} containing outputs
#' @param position The position of the sidebar relative to the main area ("left"
#'   or "right")
#' @param fluid \code{TRUE} to use fluid layout; \code{FALSE} to use fixed
#'   layout.
#'
#' @examples
#' # Define UI
#' fluidPage(
#'
#'   # Application title
#'   titlePanel("Hello Shiny!"),
#'
#'   sidebarLayout(
#'
#'     # Sidebar with a slider input
#'     sidebarPanel(
#'       sliderInput("obs",
#'                   "Number of observations:",
#'                   min = 0,
#'                   max = 1000,
#'                   value = 500)
#'     ),
#'
#'     # Show a plot of the generated distribution
#'     mainPanel(
#'       plotOutput("distPlot")
#'     )
#'   )
#' )
#'
#' @export
sidebarLayout <- function(sidebarPanel,
                          mainPanel,
                          position = c("left", "right"),
                          fluid = TRUE) {

  # determine the order
  position <- match.arg(position)
  if (position == "left") {
    firstPanel <- sidebarPanel
    secondPanel <- mainPanel
  }
  else if (position == "right") {
    firstPanel <- mainPanel
    secondPanel <- sidebarPanel
  }

  # return as as row
  if (fluid)
    fluidRow(firstPanel, secondPanel)
  else
    fixedRow(firstPanel, secondPanel)
}

#' Lay out UI elements vertically
#'
#' Create a container that includes one or more rows of content (each element
#' passed to the container will appear on it's own line in the UI)
#'
#' @param ... Elements to include within the container
#' @param fluid \code{TRUE} to use fluid layout; \code{FALSE} to use fixed
#'   layout.
#'
#' @seealso \code{\link{fluidPage}}, \code{\link{flowLayout}}
#'
#' @examples
#' \donttest{
#' fluidPage(
#'   verticalLayout(
#'     a(href="http://example.com/link1", "Link One"),
#'     a(href="http://example.com/link2", "Link Two"),
#'     a(href="http://example.com/link3", "Link Three")
#'   )
#' )
#' }
#' @export
verticalLayout <- function(..., fluid = TRUE) {
  lapply(list(...), function(row) {
    col <- column(12, row)
    if (fluid)
      fluidRow(col)
    else
      fixedRow(col)
  })
}

#' Flow layout
#'
#' Lays out elements in a left-to-right, top-to-bottom arrangement. The elements
#' on a given row will be top-aligned with each other. This layout will not work
#' well with elements that have a percentage-based width (e.g. `plotOutput` at
#' its default setting of `width = "100%"`).
#'
#' @param ... Unnamed arguments will become child elements of the layout. Named
#'   arguments will become HTML attributes on the outermost tag.
#' @param cellArgs Any additional attributes that should be used for each cell
#'   of the layout.
#'
#' @seealso \code{\link{verticalLayout}}
#'
#' @examples
#' flowLayout(
#'   numericInput("rows", "How many rows?", 5),
#'   selectInput("letter", "Which letter?", LETTERS),
#'   sliderInput("value", "What value?", 0, 100, 50)
#' )
#' @export
flowLayout <- function(..., cellArgs = list()) {

  children <- list(...)
  childIdx <- !nzchar(names(children) %OR% character(length(children)))
  attribs <- children[!childIdx]
  children <- children[childIdx]

  do.call(tags$div, c(list(class = "shiny-flow-layout"),
    attribs,
    lapply(children, function(x) {
      do.call(tags$div, c(cellArgs, list(x)))
    })
  ))
}

#' Input panel
#'
#' A \code{\link{flowLayout}} with a grey border and light grey background,
#' suitable for wrapping inputs.
#'
#' @param ... Input controls or other HTML elements.
#'
#' @export
inputPanel <- function(...) {
  div(class = "shiny-input-panel",
    flowLayout(...)
  )
}

#' Split layout
#'
#' Lays out elements horizontally, dividing the available horizontal space into
#' equal parts (by default).
#'
#' @param ... Unnamed arguments will become child elements of the layout. Named
#'   arguments will become HTML attributes on the outermost tag.
#' @param cellWidths Character or numeric vector indicating the widths of the
#'   individual cells. Recycling will be used if needed. Character values will
#'   be interpreted as CSS lengths (see \code{\link{validateCssUnit}}), numeric
#'   values as pixels.
#' @param cellArgs Any additional attributes that should be used for each cell
#'   of the layout.
#'
#' @examples
#' # Equal sizing
#' splitLayout(
#'   plotOutput("plot1"),
#'   plotOutput("plot2")
#' )
#'
#' # Custom widths
#' splitLayout(cellWidths = c("25%", "75%"),
#'   plotOutput("plot1"),
#'   plotOutput("plot2")
#' )
#'
#' # All cells at 300 pixels wide, with cell padding
#' # and a border around everything
#' splitLayout(
#'   style = "border: 1px solid silver;",
#'   cellWidths = 300,
#'   cellArgs = list(style = "padding: 6px"),
#'   plotOutput("plot1"),
#'   plotOutput("plot2"),
#'   plotOutput("plot3")
#' )
#' @export
splitLayout <- function(..., cellWidths = NULL, cellArgs = list()) {

  children <- list(...)
  childIdx <- !nzchar(names(children) %OR% character(length(children)))
  attribs <- children[!childIdx]
  children <- children[childIdx]
  count <- length(children)

  if (length(cellWidths) == 0 || is.na(cellWidths)) {
    cellWidths <- sprintf("%.3f%%", 100 / count)
  }
  cellWidths <- rep(cellWidths, length.out = count)
  cellWidths <- sapply(cellWidths, validateCssUnit)

  do.call(tags$div, c(list(class = "shiny-split-layout"),
    attribs,
    mapply(children, cellWidths, FUN = function(x, w) {
      do.call(tags$div, c(
        list(style = sprintf("width: %s;", w)),
        cellArgs,
        list(x)
      ))
    }, SIMPLIFY = FALSE)
  ))
}
