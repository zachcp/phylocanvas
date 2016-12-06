#' collapse a branch
#'
#' @param phycnv Required.
#' @param nodeid Required.
#' @param collapse Optional. Default \code{TRUE}.  Whether to collapse the node.
#' @export
collapse_branch <- function(phycnv, nodeid, collapse = TRUE) {
  phycnv$x$nodecollapses[[nodeid]] <- list(collapse)
  phycnv
}

