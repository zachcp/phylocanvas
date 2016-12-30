#' collapse branch
#'
#' given a \code{\link{phylocanvas}} object and an id node,
#' collapse the node.
#'
#'
#' @param phycnv Required.
#' @param nodeid Required.
#' @param collapse Optional. Default \code{TRUE}.  Whether to collapse the node.
#'
#' @seealso \url{http://phylocanvas.org/docs/features/#collapse-branches}
#' @export
collapse_branch <- function(phycnv, nodeid, collapse = TRUE) {
  phycnv$x$nodecollapses[[nodeid]] <- list(collapse)
  phycnv
}
#' prune branch
#'
#' given a \code{\link{phylocanvas}} object and an nodeid for
#' an internal node, prune the branch.
#'
#' @param phycnv Required.
#' @param nodeid Required.
#'
#' @seealso  \url{http://phylocanvas.org/docs/features/#prune-branches}
#' @export
prune_branch <- function(phycnv, nodeid) {
  phycnv$x$prunebranch[[nodeid]] <- list(TRUE)
  phycnv
}
#' rotate a branch
#'
#' given a \code{\link{phylocanvas}} object and an nodeid for
#' an internal node, rotate the branch defined by the node
#'
#' @param phycnv Required.
#' @param nodeid Required.
#'
#' @seealso \url{http://phylocanvas.org/docs/features/#rotate-branches}
#' @export
rotate_branch <- function(phycnv, nodeid) {
  phycnv$x$noderotations[[nodeid]] <- list(TRUE)
  phycnv
}
#' select  branch
#'
#' given a \code{\link{phylocanvas}} object and an nodeid for
#' an internal node, select the branch defined by the node
#'
#' @param phycnv Required.
#' @param nodeid Required.
#' @param cascade Optional. Default \code{FALSE}
#'
#' @seealso \url{http://phylocanvas.org/docs/features/#select-branches}
#' @export
select_branch <- function(phycnv, nodeid, cascade=FALSE) {
  phycnv$x$selectbranch[[nodeid]] <- list(cascade)
  phycnv
}

#' highlight node
#'
#' given a \code{\link{phylocanvas}} object and an nodeid,
#' highlight the node.
#'
#' @param phycnv Required.
#' @param nodeid Required.
#'
#' @seealso \url{http://phylocanvas.org/docs/features/#highlight-leaves}
#' @export
highlight_node <- function(phycnv, nodeid) {
  phycnv$x$nodehighlights[[nodeid]] <- list(TRUE)
  phycnv
}

#' style node
#'
#' add styles to a node
#'
#' given a \code{\link{phylocanvas}} object and nodeid, apply
#' the given styles to that node.
#'
#'
#' @param phycnv Required.
#' @param nodeid Required.
#' @param highlighted Optional. Default \code{FALSE}.  Whether to highlight the node.
#' @param color Optional. Color of the node/branch
#' @param shape Optional. Default \code{'circle'}. Can be either 'circle', 'square' or 'traingle'.
#' @param nodesizeratio Optional. Default \code{1}. Scale ratio of the nodesize to the base node size.
#' @param strokecolor Optional. Default \code{"black"}. Colors are strings in the format of names, rgb strings or hex values.
#' @param fillcolor Optional. Default \code{"black"}. Scale ratio of the node.
#' @param linewidth Optional. Default \code{1}.
#' @param labelcolor Optional. Default \code{"black"}. Label color. Colors are strings in the format of names, rgb strings or hex values.
#' @param labeltextsize Optional.Default \code{20}. Label size.
#' @param labelfont Optional. Default \code{"Arial"}. Label font.
#' @param labelformat Optional. Default \code{"bold"}. Label format.
#'
#' @seealso \url{http://phylocanvas.org/docs/features/#style-branches-individually}
#' @export
style_node <- function(phycnv, nodeid,
                       highlighted = FALSE,
                       color = "black",
                       shape  = 'circle',
                       nodesizeratio = 1,
                       strokecolor= "black",
                       fillcolor ='black',
                       linewidth = 1,
                       labelcolor='black',
                       labeltextsize=20, #// points
                       labelfont ='Arial',
                       labelformat = 'bold'
) {
  nodestyles <- list(
    highlighted = highlighted,
    colour = color,
    shape  = shape,
    size = nodesizeratio,
    leafStyle = list(
      strokeStyle= strokecolor,
      fillStyle = fillcolor,
      lineWidth = linewidth
    ),
    labelStyle = list(
      colour=labelcolor,
      textSize=labeltextsize,
      font =labelfont,
      format = labelformat
    )
  )

  phycnv$x$nodestyles[[nodeid]] <- nodestyles
  phycnv
}
