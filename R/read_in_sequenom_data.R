
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
#' @param ... Other arguments passed to the function
#' @keywords read sequenom
#' @return A data frame suited for the genotypeR package
#' @export
#' @examples
#' \dontrun{
#' sequenom_data <- read_in_sequenom_data("your.csv")
#' }
read_in_sequenom_data <- function(x, ...){
     sequenom_data <- read.csv(x, stringsAsFactors=FALSE, colClasses=c("character"), ...)

     out <- sort_sequenom_df(sequenom_data)
     
     return(out)

}
#########################################################################
