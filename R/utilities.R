#' getNodeName
#'
#' Get the Nodename for a Given ID
#'
#' @export
getNodeName <- function(phy, id) {
  df  <- as.data.frame(phy)
  df2 <- df[df$node==id, ]
  df2$label
}

#' Derived from Liam Revel's blogpost:
#' http://blog.phytools.org/2012/01/function-to-get-descendant-node-numbers.html
#'
#' @export
#'
getDescendants <- function(tree, node, curr=NULL, onlytips=TRUE) {
  if(is.null(curr)) curr<-vector()
  daughters <- tree$edge[which(tree$edge[,1]==node),2]
  curr      <- c(curr,daughters)
  w         <- which(daughters>=length(tree$tip))

  if(length(w) > 0) {
    for(i in 1:length(w)) {
      curr <- getDescendants(tree,daughters[w[i]],curr)
    }
  }

  return(curr)
}

#' get descendent tips
#'
#' return a character vector of descendant node names given an ancestral node.
#'
#' @export
#'
getDescendantNames <- function(tree, node) {
  descendants     <- getDescendants(tree, node)
  descendantnames <- as.character(lapply(descendants, function(n) {getNodeName(phy = tree, id=n)}))
  descendantnames <- descendantnames[descendantnames %in% tree$tip.label]
  descendantnames
}
