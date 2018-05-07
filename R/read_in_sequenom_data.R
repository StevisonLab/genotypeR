
#########################################################################
#' Read in Sequenom Data
#'
#' @description
#' \code{read_in_sequenom_data} reads in a csv file produced from
#' the Sequenom platform (i.e., sequenom excel output saved as a csv).
#' 
#' This function is a wrapper function around read.csv in order to read genotype data from the Sequenom Platform,
#' and provide data compatible with the genotypeR package.
#' @param x This is a csv formatted Genotypes tab of exported sequenom data that you would like to read in.
#' @param sort_char is the character string output by the PERL pipeline in the marker design phase
#' (i.e., chr 1000 1050 AAA[A/T]GTC; the chr is the sort_char. Defaults to chr or contig.
#' @param ... Other arguments passed to the function
#' @keywords read sequenom
#' @return A data frame suited for the genotypeR package
#' @export
#' @examples
#  \dontrun{
#' sequenom_file <- system.file("extdata/sequenom_test_data.csv", package = "genotypeR")
#' 
#' sequenom_data <- read_in_sequenom_data(sequenom_file)
#' }
read_in_sequenom_data <- function(x, sort_char="chr|contig", ...){
     sequenom_data <- read.csv(x, stringsAsFactors=FALSE, colClasses=c("character"), ...)

     out <- sort_sequenom_df(sequenom_data, sort_char=sort_char)
     
     return(out)

}
#########################################################################
