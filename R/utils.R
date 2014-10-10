`%OR%` <- function(x, y) {
  if (is.null(x) || isTRUE(is.na(x)))
    y
  else
    x
}

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

# Format a number without sci notation, and keep as many digits as possible (do
# we really need to go beyond 15 digits?)
formatNoSci <- function(x) {
  if (is.null(x)) return(NULL)
  format(x, scientific = FALSE, digits = 15)
}

# for options passed to DataTables/Selectize/..., the options of the class AsIs
# will be evaluated as literal JavaScript code
checkAsIs <- function(options) {
  evalOptions <- if (length(options)) {
    nms <- names(options)
    if (length(nms) == 0L || any(nms == '')) stop("'options' must be a named list")
    i <- unlist(lapply(options, function(x) {
      is.character(x) && inherits(x, 'AsIs')
    }))
    if (any(i)) {
      # must convert to character, otherwise toJSON() turns it to an array []
      options[i] <- lapply(options[i], paste, collapse = '\n')
      nms[i]  # options of these names will be evaluated in JS
    }
  }
  list(options = options, eval = evalOptions)
}


toJSON <- function(x, ..., digits = getOption("shiny.json.digits", 16)) {
  jsonlite::toJSON(x, dataframe = "columns", null = "null", na = "null",
                   auto_unbox = TRUE, digits = digits, ...)
}

# Given a vector or list, drop all the NULL items in it
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}

# turn column-based data to row-based data (mainly for JSON), e.g. data.frame(x
# = 1:10, y = 10:1) ==> list(list(x = 1, y = 10), list(x = 2, y = 9), ...)
columnToRowData <- function(data) {
  do.call(
    mapply, c(
      list(FUN = function(...) list(...), SIMPLIFY = FALSE, USE.NAMES = FALSE),
      as.list(data)
    )
  )
}
