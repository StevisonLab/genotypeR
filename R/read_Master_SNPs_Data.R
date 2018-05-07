#######################
#' Read in GrandMasterSNPs output
#'
#' @description
#' This reads in single nucleotide polymorphism markers generated
#' by the GrandMasterSNPs Perl program.
#' 
#' @param x This is a tab delimited text file from GrandMasterSNPs Perl program
#' @param ... Other arguments passed to the function
#' @keywords read GrandMasterSNPs
#' @return A data frame of GrandMasterSNPs markers
#' @export
#' @examples
#' \dontrun{
#' 
#' ##this should be used with the output of the PERL pipeline "GrandMasterSNPs"
#' marker_file <- system.file("extdata/filtered_markers.txt", package = "genotypeR")
#' 
#' GrandMasterSNPs_markers  <- read_in_Master_SNPs_data(marker_file)
#'} 
read_in_Master_SNPs_data <- function(x, ...){
    ##read in table
    out <- read.table(x, stringsAsFactors=FALSE, colClasses=c("character"), sep="\t", ...)

    ##set column names
    colnames(out)  <- c("chr", "start", "end", "marker")

    ##return from function
    return(out)
}
#############################################################################################################################
