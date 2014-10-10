#' Create a download button or link
#'
#' Use these functions to create a download button or link; when clicked, it
#' will initiate a browser download. The filename and contents are specified by
#' the corresponding \code{\link[shiny]{downloadHandler}} defined in the server
#' function.
#'
#' @param outputId The name of the output slot that the \code{downloadHandler}
#'   is assigned to.
#' @param label The label that should appear on the button.
#' @param class Additional CSS classes to apply to the tag, if any.
#'
#' @examples
#' \dontrun{
#' # In server.R:
#' output$downloadData <- downloadHandler(
#'   filename = function() {
#'     paste('data-', Sys.Date(), '.csv', sep='')
#'   },
#'   content = function(con) {
#'     write.csv(data, con)
#'   }
#' )
#'
#' # In ui.R:
#' downloadLink('downloadData', 'Download')
#' }
#'
#' @aliases downloadLink
#' @seealso downloadHandler
#' @export
downloadButton <- function(outputId,
                           label="Download",
                           class=NULL) {
  aTag <- tags$a(id=outputId,
                 class=paste(c('btn shiny-download-link', class), collapse=" "),
                 href='',
                 target='_blank',
                 icon("download"),
                 label)
}

#' @rdname downloadButton
#' @export
downloadLink <- function(outputId, label="Download", class=NULL) {
  tags$a(id=outputId,
         class=paste(c('shiny-download-link', class), collapse=" "),
         href='',
         target='_blank',
         label)
}
