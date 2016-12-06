#' rotate a branch
#'
#' @param phycnv Required.
#' @param nodeid Required.
#' @export
rotate_branch <- function(phycnv, nodeid) {
  phycnv$x$noderotations[[nodeid]] <- list(TRUE)
  phycnv
}

