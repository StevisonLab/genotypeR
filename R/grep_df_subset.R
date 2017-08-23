#####################################################################################################
#####################################################################################################
#####################################################################################################
#' Internal function to remove search and remove columns based on names
#'
#' @description
#' \code{grep_df_subset} is an internal function that subsets
#' a data frame based on supplied pattern. This function is
#' provided in case it is found useful.
#' 
#' @param x data frame where columns are to be removed
#' @param toMatch vector of characters to remove from x
#' @keywords remove matching columns
#' @return A subset of a genotypeR object
#' @export
#' @examples
#' 
#' df <- data.frame(one=rep(1,5), two=rep(1,5), three=rep(1,5), four=rep(1,5))
#' toMatch <- paste(c("one", "two"), collapse="|")
#' ##remove toMatch
#' grep_df_subset(df, toMatch)
#' 
##bonus grep fxn
grep_df_subset <- function(x, toMatch){
    ##to match is a vector
    ##x is a data frame
    toMatch <- paste("^", toMatch, "$", sep="")
    ##values for matching grabing the used markers...
    matches <- grep(paste(toMatch,collapse="|"), colnames(x))
    out <- x[,-matches]
    return(out)
}

#####################################################################################################
#####################################################################################################
#####################################################################################################
