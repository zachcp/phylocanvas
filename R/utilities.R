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

