####################################################################################################
#############################################################################################################################
#' Code genotypes as 0, 1, 2
#'
#' @description
#' \code{zero_one_two_coding} code homozygous reference as 0, heterozygous as 1, and homozygous alternate as 2 using a genotypeR object created with \code{initialize_genotypeR_data} with the pass_through argument. 
#' 
#' @param genotype_warnings_passthrough is a genotypeR object that has been processed by BC_Genotype_Warnings
#' with output="pass_through"
#' @param genotype_table is a data frame produced with Ref_Alt_Table
#' @keywords code genotypes as 0 Homozygous Ref, 1 Heterozygous, and 2 Homozygous Alt
#' @return A data frame of 0, 1, and 2 coded genotypes as a slot in the input
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
#' pass_through <- initialize_genotypeR_data(seq_data \
#' = genotypes_data_filtered, genotype_table = GT_table, \
#' output = "pass_through")
#' 
#' genotypes_object <- zero_one_two_coding(pass_through, GT_table)
#' }
zero_one_two_coding <- function(genotype_warnings_passthrough, genotype_table){

    ##require(reshape2)
    ##require(doBy)

##test data
###test <- 0
###if(test==1){
###    seq_data <- genotype_warnings2NA
###}


    seq_data <- genotype_warnings_passthrough

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
    ##removed for Ref/Alt 0, 1, 2 coding
    ##Alt or Ref
    ##Alt_or_Ref <- c("Alt", "Ref")
    ##Alt_or_Ref <- Alt_or_Ref[-grep(impossible_genotype(seq_data), Alt_or_Ref)]
    
    ##START HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    marker_data_frame <- seq_split_list[[i]]

    marker_data_frame$GENOTYPE <- as.character(marker_data_frame$GENOTYPE) 
    
    ##code Homozygous not of the impossible genotype as 0##############################################
    ##homo_logic <- marker_data_frame$GENOTYPE==genotypes_from_table[, Alt_or_Ref] & !is.na(marker_data_frame$GENOTYPE)
    ##gsub(homo_logic, "TRUE", "0")

    ##code homozygous Ref as 0
    marker_data_frame[grep(paste("^", genotypes_from_table[,"Ref"], "$", sep=""), marker_data_frame[,"GENOTYPE"]),"GENOTYPE"] <- "0"

    ##code heterozygous as 1
    toMatch <- genotypes_from_table[,c("Alt_Ref", "Ref_Alt")]
    ##exact match!!!
    toMatch <- paste("^", toMatch, "$", sep="")
    ##values for matching grabing the used markers...
    marker_data_frame[grep(paste(toMatch,collapse="|"), marker_data_frame[,"GENOTYPE"]),"GENOTYPE"] <- "1"

    ##code homozygous Ref as 2
    marker_data_frame[grep(paste("^", genotypes_from_table[,"Alt"], "$", sep=""), marker_data_frame[,"GENOTYPE"]),"GENOTYPE"] <- "2"
    
    out[[i]] <- marker_data_frame
    ###################################################################################################
    
    
}

    out_cast <- dcast(data=do.call(rbind, out), SAMPLE_NAME+WELL~MARKER, value.var="GENOTYPE")
#######################################################
##end for; !!!!!start here!!!!!
#######################################################
    ##changed 20170413
    binary_genotypes(genotype_warnings_passthrough) <- out_cast

    return(genotype_warnings_passthrough)
    
}
