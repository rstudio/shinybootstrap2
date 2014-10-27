#' Bootstrap 2 components for use with Shiny
#'
#' @name shinyBootstrap2-package
#' @aliases shinyBootstrap2
#' @docType package
#' @import htmltools jsonlite
NULL


#' @export
withBootstrap2 <- function(expr, env = parent.frame()) {
  expr <- substitute(expr)

  # Copy everything from the shinyBootstrap2 environment to a new environment
  # which is a child of the calling environment.
  bs2env <- list2env(as.list(bs2env), parent = env)

  eval(expr, bs2env)
}

bs2env <- environment()
