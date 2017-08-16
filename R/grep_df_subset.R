#####################################################################################################
#####################################################################################################
#####################################################################################################
#' Internal function to remove search and remove columns based on names
#'
#' @description
#' \code{grep_df_subset} is an interal function that subsets
#' a dataframe based on supplied pattern. This function is
#' provided incase it is found useful.
#' 
#' @param x dataframe where columns are to be removed
#' @param toMatch vector of characters to remove from x
#' @keywords remove matching columns
#' @return A subsetted genotypeR object
#' @export
#' @examples
#' \dontrun{
#' data_frame_columns_removed <- grep_df_subset(x, toMatch)
#' }##subset function
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
