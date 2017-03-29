
##################################################################################################
##################################################################################################
##################################################################################################
##Sequenom Dataframe Sort

#########################################################################
#' Sequenom Dataframe Sort
#'
#' This function sorts Sequenom Data at the read-in stage.
#' @param Sequenom_Data2Sort
#' @keywords sort sequenom
#' @return A sorted dataframe suited for the genotypeR package
#' @export
#' @examples
#' \dontrun{
#' sequenom_data <- read_in_sequenom_data("your.csv")
#' sort_sequenom_df(sequenom_data)
#' }
sort_sequenom_df <- function(Sequenom_Data2Sort){
colnames_seq_df <- colnames(Sequenom_Data2Sort)

colnames_to_sort <- colnames_seq_df[grep("chr", colnames_seq_df)]

colnames_sort_df <- data.frame(do.call(rbind, strsplit(colnames_to_sort, "_(?=[0-9])", perl=TRUE)))

colnames_sort_df$colnumbers <- 3:(length(colnames_to_sort)+2)

new_order <- colnames_sort_df[order(colnames_sort_df[,1], as.numeric(as.character(colnames_sort_df[,2]))),]

sort_by_this <- c(1, 2, new_order$colnumbers)

sorted_df <- Sequenom_Data2Sort[,sort_by_this]

return(sorted_df)
}
##################################################################################################
##################################################################################################
##################################################################################################

