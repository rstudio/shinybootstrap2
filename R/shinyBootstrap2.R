#' Bootstrap 2 components for use with Shiny
#'
#' @name shinyBootstrap2-package
#' @aliases shinyBootstrap2
#' @docType package
#' @import htmltools jsonlite
NULL


#' @export
withBootstrap2 <- function(x, env = parent.frame(), quoted = FALSE) {
  if (!quoted) x <- substitute(x)

  # Copy everything from the shinyBootstrap2 environment to a new environment
  # which is a child of the calling environment.
  bs2env <- list2env(bs2exports(), parent = env)

  eval(x, bs2env)
}


# Return a list of all exported objects from this package.
bs2exports <- function() {
  if (is.null(cache$exports)) {
    cache$exports <- mget(getNamespaceExports("shinyBootstrap2"), asNamespace("shinyBootstrap2"))
  }

  cache$exports
}

# A cache for the list of exported objects from this package.
cache <- new.env()


.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "You probably do not want to attach this package (with library() or require()).",
    " Instead, you should use shinyBootstrap2::withBootstrap2().",
    " You can hide this message with suppressPackageStartupMessages()."
  )
}
