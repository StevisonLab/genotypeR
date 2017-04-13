#############################################################################################################################
#' Heterogametic warnings
#' 
#' @param seq_data is genotyping data read in with read_in_sequenom_data
#' @param heterogametic_sex character of heterogametic sex (e.g., "M")
#' @param sex_chromosome character of the sex chromosome coded in sequenom markers produced with make_marker_names.
#' For example, the sex chromosome in the data provided with genotypeR is chrXL and it has been coded as
#' chrXL_start_end. The character provided would be "chrXL"
#' @param sex_vector a vector of the sex of each individual in seq_data coded the same as that in heterogametic sex.
#' For example, a vector of "F" and "M".
#' @return A dataframe of warnings
#' @export
#' @examples
#' \dontrun{
#' sex_vector <- do.call(rbind, strsplit(seq_data[,"SAMPLE_NAME"], split="_"))[,2]
#' Heterogametic_Genotype_Warnings(seq_data=seq_test_data, \
#' sex_chromosome="chrXL", sex_vector=sex_vector, heterogametic_sex="M")
#' }
Heterogametic_Genotype_Warnings <- function(seq_data, sex_chromosome, sex_vector, heterogametic_sex){

##require(reshape2)
##require(doBy)

##warnings are an impossible genotype
##for these data it is homo. Ref/Ref

##test data
###test <- 0
###if(test==1){
###    seq_data <- seq_test_data
    
###    sex_vector <- do.call(rbind, strsplit(seq_data[,"SAMPLE_NAME"], split="_"))[,2]

###    heterogametic_sex <- "M"

###    sex_chromosome <- "chrXL"
    
###}

##melt by SAMPLE_NAME and WELL
seq_melt <- melt(seq_data, id.vars=c("SAMPLE_NAME", "WELL"))

heterogametic_sex_seq_melt <- seq_melt[sex_vector==heterogametic_sex,]
    
heterogametic_sex_warnings <- heterogametic_sex_seq_melt[nchar(heterogametic_sex_seq_melt$value)==2,]

heterogametic_sex_warnings$value <- "warning"

colnames(heterogametic_sex_warnings)  <- c("SAMPLE_NAME", "WELL", "MARKER", "GENOTYPE")

    ##subset only the sex chromosome
    heterogametic_sex_warnings <- heterogametic_sex_warnings[grep(paste("^", sex_chromosome, sep=""), heterogametic_sex_warnings$MARKER),] 
    ##
    
    return(heterogametic_sex_warnings)
    
}
