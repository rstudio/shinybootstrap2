#' Slider Input Widget
#'
#' Constructs a slider widget to select a numeric value from a range.
#'
#' @param inputId Specifies the \code{input} slot that will be used to access
#'   the value.
#' @param label A descriptive label to be displayed with the widget, or
#'   \code{NULL}.
#' @param min The minimum value (inclusive) that can be selected.
#' @param max The maximum value (inclusive) that can be selected.
#' @param value The initial value of the slider. A numeric vector of length
#'   one will create a regular slider; a numeric vector of length two will
#'   create a double-ended range slider. A warning will be issued if the
#'   value doesn't fit between \code{min} and \code{max}.
#' @param step Specifies the interval between each selectable value on the
#'   slider (\code{NULL} means no restriction).
#' @param round \code{TRUE} to round all values to the nearest integer;
#'   \code{FALSE} if no rounding is desired; or an integer to round to that
#'   number of digits (for example, 1 will round to the nearest 10, and -2 will
#'   round to the nearest .01). Any rounding will be applied after snapping to
#'   the nearest step.
#' @param format Customize format values in slider labels. See
#'   \url{https://code.google.com/p/jquery-numberformatter/} for syntax
#'   details.
#' @param locale The locale to be used when applying \code{format}. See details.
#' @param ticks \code{FALSE} to hide tick marks, \code{TRUE} to show them
#'   according to some simple heuristics.
#' @param animate \code{TRUE} to show simple animation controls with default
#'   settings; \code{FALSE} not to; or a custom settings list, such as those
#'   created using \code{animationOptions}.
#' @inheritParams selectizeInput
#' @family input elements
#' @seealso \code{\link{updateSliderInput}}
#'
#' @details
#'
#' Valid values for \code{locale} are: \tabular{ll}{ Arab Emirates \tab "ae" \cr
#' Australia \tab "au" \cr Austria \tab "at" \cr Brazil \tab "br" \cr Canada
#' \tab "ca" \cr China \tab "cn" \cr Czech \tab "cz" \cr Denmark \tab "dk" \cr
#' Egypt \tab "eg" \cr Finland \tab "fi" \cr France  \tab "fr" \cr Germany \tab
#' "de" \cr Greece \tab "gr" \cr Great Britain \tab "gb" \cr Hong Kong \tab "hk"
#' \cr India \tab "in" \cr Israel \tab "il" \cr Japan \tab "jp" \cr Russia \tab
#' "ru" \cr South Korea \tab "kr" \cr Spain \tab "es" \cr Sweden \tab "se" \cr
#' Switzerland \tab "ch" \cr Taiwan \tab "tw" \cr Thailand \tab "th" \cr United
#' States \tab "us" \cr Vietnam \tab "vn" \cr }
#'
#' @export
sliderInput <- function(inputId, label, min, max, value, step = NULL,
                        round=FALSE, format='#,##0.#####', locale='us',
                        ticks=TRUE, animate=FALSE, width=NULL) {

  if (identical(animate, TRUE))
    animate <- shiny:::animationOptions()

  if (!is.null(animate) && !identical(animate, FALSE)) {
    if (is.null(animate$playButton))
      animate$playButton <- tags$i(class='icon-play')
    if (is.null(animate$pauseButton))
      animate$pauseButton <- tags$i(class='icon-pause')
  }

  # build slider
  sliderTag <- shiny:::slider(inputId, min=min, max=max, value=value, step=step,
    round=round, locale=locale, format=format, ticks=ticks, animate=animate,
    width=width)

  if (is.null(label)) {
    sliderTag
  } else {
    tags$div(
      controlLabel(inputId, label),
      sliderTag
    )
  }
}
