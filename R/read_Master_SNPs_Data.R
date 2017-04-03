#######################
#' Read in GrandMasterSNPs output
#'
#' This reads in single nucleotide polymorphism markers generated by the GrandMasterSNPs perl program
#' @param x This is a tab delimited text file from GrandMasterSNPs perl program
#' @param ... Other arguments passed to the function
#' @keywords read GrandMasterSNPs
#' @return A dataframe of GrandMasterSNPs markers
#' @export
#' @examples
#' \dontrun{
#' GrandMasterSNPs_markers  <- read_in_Master_SNPs_data("GrandMasterSNPs_output")
#' }
read_in_Master_SNPs_data <- function(x, ...){
    ##read in table
    out <- read.table(x, stringsAsFactors=FALSE, colClasses=c("character"), sep="\t", ...)

    ##set column names
    colnames(out)  <- c("chr", "start", "end", "marker")

    ##return from function
    return(out)
}
#############################################################################################################################