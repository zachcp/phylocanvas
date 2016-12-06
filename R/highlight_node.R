#' highlight node
#'
#' @param phycnv Required.
#' @param nodeid Required.
#' @export
highlight_node <- function(phycnv, nodeid) {
  phycnv$x$nodehighlights[[nodeid]] <- list(TRUE)
  phycnv
}

