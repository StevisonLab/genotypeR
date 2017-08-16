#####################################################################################################
#####################################################################################################
#####################################################################################################
#' Subset genotypeR object by chromosome 
#' 
#' @param aa genotypeR object before binary coding
#' @param chromosome which chromosome to pull out (e.g., "chr2")
#' @keywords subset genotypeR object by chromosome
#' @return A subsetted genotypeR object
#' @export
#' @examples
#' \dontrun{
#' data(genotypes_data)
#' data(markers)
#' ## genotype table
#' marker_names <- make_marker_names(markers)
#' GT_table <- Ref_Alt_Table(marker_names)
#' ## remove those markers that did not work
#' genotypes_data_filtered <- genotypes_data[,c(1, 2, grep("TRUE", \
#' colnames(genotypes_data)%in%GT_table$marker_names))]
#' 
#' warnings_out2NA <- initialize_genotypeR_data(seq_data = genotypes_data_filtered, \
#' genotype_table = GT_table, output = "warnings2NA")
#' chromosome_subset <- subsetChromosome(warnings_out2NA, "chr2")
#' }
subsetChromosome <- function(aa, chromosome){

###    test <- 0
###    if(test==1){
###        chromosome <- "chr2"
###    }
    
    ##binary genotypes
    to_subset_binary <- binary_genotypes(aa)
    ##along with SAMPLE_NAME and WELL
    SAMPLE_NAME <- grep("^SAMPLE_NAME$", colnames(to_subset_binary))
    WELL <- grep("^WELL$", colnames(to_subset_binary))
    col_indices <- c(SAMPLE_NAME, WELL, grep(paste("^", chromosome, "_", sep=""), colnames(to_subset_binary)))
    binary_subset <- to_subset_binary[,col_indices]

    binary_genotypes(aa) <- binary_subset

    ##genotypes
    to_subset_raw_geno <- genotypes(aa)
    ##along with SAMPLE_NAME and WELL
    row_indices <- grep(paste("^", chromosome, "_", sep=""), to_subset_raw_geno$MARKER)
    geno_subset <- to_subset_raw_geno[row_indices,]

    genotypes(aa) <- geno_subset

    return(aa)
}
