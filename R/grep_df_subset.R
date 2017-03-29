#####################################################################################################
#####################################################################################################
#####################################################################################################
#' Internal function to remove search and remove columns based on names
#' 
#' @param x
#' @param toMatch
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
