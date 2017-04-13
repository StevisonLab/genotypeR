#' R wrapper script to run Sequenom Marker design pipeline
#'
#' This function designs Sequenom markers.
#' @param vcf1 this is an uncompressed vcf file (Ref allele)
#' @param vcf2 this is an uncompressed vcf file (Alt allele)
#' @param outdir this is where the tab-delimited extended bed file will
#' be written
#' @keywords SequenomMarker
#' @return SequenomMarker design into "outdir"
#' @export
#' @examples
#' \dontrun{
#' SequenomMarkers("/path/to/vcf1", "/path/to/vcf2", "path_to_outdir" 
#' }

SequenomMarkers <- function(vcf1, vcf2, outdir){

perl_module <- system.file("SequenomMarkers", package="genotypeR")

files <- dir(perl_module, full.names=TRUE)



##test data
###test <- 0
###if(test==1){
###    outdir <- paste("/home/ssefick/Desktop/Stevison_PostDoc/Projects/genotypeR/inst/SequenomMarkers", "test_dir", sep="/")


###    vcf1 <- paste(perl_module, "FS14_test.vcf", sep="/")

###    vcf2 <- paste(perl_module, "FS16_test.vcf", sep="/")
###  }

if(dir.exists(outdir)==FALSE){
dir.create(outdir, showWarnings = TRUE, recursive = FALSE, mode = "0777")
}

path_to_script <- paste(perl_module, "R_Pipeline_Rapper.sh", sep="/")

cmd <- paste(shQuote(path_to_script), shQuote(perl_module), shQuote(outdir), shQuote(vcf1), shQuote(vcf2), sep=" ")

system(cmd)
    

}
