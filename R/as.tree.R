#' as.tree
#'
#' Convert objects to newick strings
#'
#' @importFrom ape write.tree
#' @importFrom ape read.tree
#' @export
as.tree <- function(phy) {

  if (class(phy) == "phylo") {
    return( write.tree(phy, file=""))
  }

  if (class(phy) == "character") {
    if (file.exists(phy)) {
      newphy <- NULL
      try(newphy <- read.tree(phy))
      if (!is.null(phewphy)) {
        return(newphy)
      }
    } else {
      return(phy)
    }

    return(message("This class not supported. Try using a direct newick string or phylo-class object"))
  }
}
