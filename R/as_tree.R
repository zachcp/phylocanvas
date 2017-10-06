#' as_tree
#'
#' Convert objects to newick strings
#'
#' @param phy Required. phy is either a \code{\link[ape]{phylo}} class object,
#' \code{\link[phylobase]{phylo4}} class object, or a character that can be a newick
#'  literal or apath to newick-containing file.
#' @importClassesFrom phylobase phylo4
#'
#' @docType methods
#' @rdname as_tree-methods
#'
#' @export
setGeneric("as_tree", function(phy) {standardGeneric("as_tree")})
################################################################################
#' @aliases as_tree, phylo, phylo-method
#' @rdname as_tree-methods
#' @importFrom ape write.tree
setMethod("as_tree", "phylo", function(phy) {
  write.tree(phy, file="")
})
################################################################################
#' @aliases as_tree, phylo4, phylo4-method
#' @rdname as_tree-methods
#' @importFrom methods as
setMethod("as_tree", "phylo4", function(phy) {
  phy <- as(phy, "phylo")
  as_tree(phy)
})

