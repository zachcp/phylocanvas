#' as.tree
#'
#' Convert objects to newick strings
#'
#' @importFrom ape write.tree
#' @importFrom ape read.tree
#' @export
#'
setGeneric("as.tree", function(phy, id) {standardGeneric("as.tree")})
#'
setMethod("as.tree", "phylo", function(phy, id) {
  write.tree(phy, file="")
})
#'
setMethod("as.tree", "phylo4", function(phy, id) {
  phy <- as(phy, "phylo")
  as.tree(phy)
})
setMethod("as.tree", "character", function(phy, id) {
  if (file.exists(phy)) {
    newphy <- NULL
    try(newphy <- read.tree(phy))
    if (!is.null(newphy)) {
      return(newphy)
    }
  } else {
    return(phy)
  }
})
