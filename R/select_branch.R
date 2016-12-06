#' select  branches
#'
#' @param phycnv Required.
#' @param nodeid Required.
#' @param cascade Optional. Default \code{FALSE}
#' @export
select_branch <- function(phycnv, nodeid, cascade=FALSE) {
  phycnv$x$selectbranch[[nodeid]] <- list(cascade)
  phycnv
}

