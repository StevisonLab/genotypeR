####################################################################################################
#############################################################################################################################
#' Code genotypes as binary
#'
#' @description
#' \code{binary_coding} codes genotypes contained in a genotypeR object
#' and places them into a genotypeR object's binary_genotype slot.  
#' 
#' @param genotype_warnings2NA this is a genotypeR object that has been
#' through BC_Genotype_Warnings with either output="warnings2NA" or
#' output="pass_through"
#' @param genotype_table this is a marker table produced with
#' Ref_Alt_Table
#' @keywords code genotypes as binary
#' @return A data frame of binary coded genotypes as a slot in the
#' genotypeR input genotype_warnings2NA
#' @export
#' @examples
#' 
#' data(genotypes_data)
#' data(markers)
#' ## genotype table
#' marker_names <- make_marker_names(markers)
#' GT_table <- Ref_Alt_Table(marker_names)
#' ## remove those markers that did not work
#' genotypes_data_filtered <- genotypes_data[,c(1, 2, grep("TRUE",
#' colnames(genotypes_data)%in%GT_table$marker_names))]
#' 
#' warnings_out2NA <- initialize_genotypeR_data(seq_data = genotypes_data_filtered,
#' genotype_table = GT_table, output = "warnings2NA")
#' 
#' genotypes_object <- binary_coding(warnings_out2NA, GT_table)
#' 
binary_coding <- function(genotype_warnings2NA, genotype_table){

    ##require(reshape2)
    ##require(doBy)

##test data
test <- 0
if(test==1){
    seq_data <- genotype_warnings2NA
}


    seq_data <- genotype_warnings2NA

#####################################################################################################
    ##Error checking; 
    ##check if genotypeR class
    if(!(inherits(seq_data, "genotypeR"))){stop("object not of class genotypeR")} 
    ##if it is a genotypeR check is impossible_genotype is set and that it is set to Ref or Alt
    if(inherits(seq_data, "genotypeR")){
        if(length(impossible_genotype(seq_data))==0){stop("warning allele in  BC_Genotype_Warnings must be set to something...")}
        if(length(impossible_genotype(seq_data))==1){

            if(impossible_genotype(seq_data)!="Ref" & impossible_genotype(seq_data)!="Alt"){stop("warning allele in  BC_Genotype_Warnings must be set to Ref/Alt...")}
            
        }
}
#####################################################################################################
    
    
seq_split_list <- splitBy(~MARKER, data=genotypes(seq_data))

#######################################################
##Look for warnings
#######################################################

out <- vector(mode="list", length=length(names(seq_split_list)))

for(i in 1:length(names(seq_split_list))){

    ##test
    test_loop <- 0
    if(test_loop==1){
        i=1
    }

    ##marker name
    chr_to_get_from_genotype_table <- names(seq_split_list)[i]
    
    ##genotype based on marker name
    genotypes_from_table <- genotype_table[genotype_table$marker_names==chr_to_get_from_genotype_table,]
    ##Alt or Ref
    Alt_or_Ref <- c("Alt", "Ref")
    Alt_or_Ref <- Alt_or_Ref[-grep(impossible_genotype(seq_data), Alt_or_Ref)]
    
    ##START HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    marker_data_frame <- seq_split_list[[i]]

    marker_data_frame$GENOTYPE <- as.character(marker_data_frame$GENOTYPE) 
    
    ##code Homozygous not of the impossible genotype as 0##############################################
    ##homo_logic <- marker_data_frame$GENOTYPE==genotypes_from_table[, Alt_or_Ref] & !is.na(marker_data_frame$GENOTYPE)
    ##gsub(homo_logic, "TRUE", "0")

    ##code homozygous as 0; should have no impossible genotypes by now; make sure this is true; maybe check again
    marker_data_frame[grep(paste("^", genotypes_from_table[,Alt_or_Ref], "$", sep=""), marker_data_frame[,"GENOTYPE"]),"GENOTYPE"] <- "0"

    ##code heterozygous as 1
    toMatch <- genotypes_from_table[,c("Alt_Ref", "Ref_Alt")]
    ##exact match!!!
    toMatch <- paste("^", toMatch, "$", sep="")
    ##values for matching grabing the used markers...
    marker_data_frame[grep(paste(toMatch,collapse="|"), marker_data_frame[,"GENOTYPE"]),"GENOTYPE"] <- "1"
    
    out[[i]] <- marker_data_frame
    ###################################################################################################
    
    
}

    out_cast <- dcast(data=do.call(rbind, out), SAMPLE_NAME+WELL~MARKER, value.var="GENOTYPE")
#######################################################
##end for; !!!!!start here!!!!!
#######################################################
    binary_genotypes(genotype_warnings2NA) <- out_cast

    return(genotype_warnings2NA)
    
}
