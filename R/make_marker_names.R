#######################
#' Make genotypeR compliant marker names from the output of read_in_Master_SNPs_data function
#' 
#' @param x Output of read_in_Master_SNPs_data
#' @keywords genotypeR compliant marker names GrandMasterSNPs with the associated markers
#' @return A dataframe of GrandMasterSNPs markers with correct marker names
#' @export
#' @examples
#' \dontrun{
#' GrandMasterSNPs_markers  <- read_in_Master_SNPs_data("GrandMasterSNPs_output")
#' marker_names_GrandMasterSNPs_markers <- make_marker_names(GrandMasterSNPs_markers)
#' ##If subset of markers needed
#' ##use the sequenom output to subset the overall marker set from
#' GrandMasterSNPs output
#' seq_test_data <- read_in_sequenom_data("path_to_sequenom_data")
#' col_seq_data <- colnames(seq_test_data)
#' col_markers <- test_data_marker_names$marker_names
#' markerinstudy <- test_data_marker_names[col_markers%in%col_seq_data,]
#' }
make_marker_names <- function(x){

    x$marker_names  <- paste(x$chr, x$start, x$end, sep="_")
    ##Only want chr, start, and end
    ##So, grab out everything except the markers to make the names
    toMatch <- c("chr", "start", "end")
    ##exact match!!!
    toMatch <- paste("^", toMatch, "$", sep="")
    ##values for matching grabing the used markers...
    matches <- grep(paste(toMatch,collapse="|"), colnames(x))
    x <- x[,-matches]
    ##return marker names in the format chr_start_end
    ##and the markers themselves
    return(x[,c("marker_names", "marker")])
      
}
#############################################################################################################################
