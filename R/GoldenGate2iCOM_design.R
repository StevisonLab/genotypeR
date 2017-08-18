#########################################################################
#' Output GoldenGate markers for assay development with illumina iCOM
#'
#' @description
#' \code{GoldenGate2iCOM_design} outputs GoldenGate markers for
#' SNP genotyping assay development with illumina iCOM.
#'
#' @param SequenomMarkers maker data frame from make SequenomMarkers
#' @param Target_Type SNP/Indel
#' @param Genome_Build_Version genome build version (number; default 0)
#' @param Chromosome (default 0)
#' @param Coordinate genomic coordinate (default 0)
#' @param Source unknown/sequence information (default "unknown")
#' @param Source_Version number (default 0)
#' @param Sequence_Orientation "forward", "reverse", "unknown" (default "unknown")
#' @param Plus_Minus strand orientation "Plus" or "Minus" (default "Plus")
#' @keywords read Sequenom
#' @return A data frame suited for the genotypeR package
#' @export
#' @examples
#' \dontrun{
#' library(genotypeR)
#' data(markers)
#' SequenomMarkers <- markers
#' ##this is to reduce the marker lengths to 50 bp flanking SNP
#' SequenomMarkers$marker <- substr(markers$marker, 51, 155)

#' GG_SNPs <- GoldenGate2iCOM_design(SequenomMarkers)

#' write.csv(GG_SNPs, "test.csv", row.names=FALSE)
#' }
GoldenGate2iCOM_design <- function(SequenomMarkers, Target_Type="SNP", Genome_Build_Version="0", Chromosome="0", Coordinate="0", Source="unknown", Source_Version="0", Sequence_Orientation="unknown", Plus_Minus="Plus"){

if(any(nchar(SequenomMarkers$marker)>105)){stop("markers are are malformed. Please inspect the input data")}

out_df <- data.frame(Locus_Name=make_marker_names(SequenomMarkers)$marker_names, Sequence=SequenomMarkers$marker, Target_Type=Target_Type, Genome_Build_Version=Genome_Build_Version, Chromosome=Chromosome, Coordinate=Coordinate, Source=Source, Source_Version=Source_Version, Sequence_Orientation=Sequence_Orientation, Plus_Minus=Plus_Minus)

return(out_df)

}

