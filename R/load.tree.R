#' load tree
#'
#' load a newick tree.
#'
#' this is the recommended way to load a tree for use with phylocanvas. The reason is that
#' all of the javascript selector methods require that the nodes are named and the
#' selection of nodes based on names is straightforward with \code{\link[phylobase]{phylo4}}
#' objects. Therefore this function will read your newick tree, add names, and return a
#'  \code{\link[phylobase]{phylo4}}  object that can be easily manipulated and subsetted
#' generating custom displays.
#'
#' @param treefile Required. Path of phylogenetic tree to read
#' @param ... Optional. Pass any other arguments to read.tree
#'
#' @return a \code{\link[phylobase]{phylo4}} tree object.
#'
#' @importFrom ape read.tree
#' @importFrom ape makeNodeLabel
#' @importFrom methods as
#' @importClassesFrom phylobase phylo4
#' @export
#' @examples
#' birdfile <- system.file("treedata/birdfamilies.tree", package="phylocanvas")
#' tree <- load.tree(birdfile)
load.tree <- function(treefile, ...) {
  tree <- read.tree(file=treefile, ...)
  tree <- makeNodeLabel(tree)
  tree <- as(tree, "phylo4")
  tree
}
