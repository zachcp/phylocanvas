#' get descendants
#'
#' get the names of the tips of descendants given a tree
#' and the name of an internal node.
#'
#' @param tree Required. A \code{\link[phylobase]{phylo4}} object.
#' @param nodename Required. A character corresponding to an internal node.
#'
#' @return a character vector of descendant names
#'
#' @importFrom phylobase tipLabels
#' @importFrom phylobase subset
#' @export
#'
#' @examples
#' birdfile <- system.file("treedata/birdfamilies.tree", package="phylocanvas")
#' tree <- load.tree(birdfile)
#' node <- phylobase::MRCA(tree, c("Cerylidae", "Upupidae"))
#' get.descendants(tree, node)
#'
get.descendants <- function(tree, nodename) {
  if (!inherits(tree, "phylo4")) stop("get.Descendants requires a phylo4 object")

  subtree <- subset(tree, node.subtree=nodename)
  tips    <- as.character(tipLabels(subtree))
}
