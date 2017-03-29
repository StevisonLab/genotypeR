#############################################################################################################################
#' Backcross genotype warnings; must provide warning allele
#' 
#' @param seq_data
#' @param genotype_table
#' @param warning_allele
#' @param output
#' @keywords 
#' @return A dataframe of warnings
#' @export
#' @examples
#' \dontrun{
#' genotype_warnings <- BC_Genotype_Warnings(seq_data, genotype_table, warning_allele="Ref", output="warnings")
#' }
## in this case Drosophila FS14/FS16 are Ref/Alt
## Homo. Ref is a warning based on the backcross and is the default
## can be set to another column in genotype table
BC_Genotype_Warnings <- function(seq_data, genotype_table, warning_allele="Ref", output="warnings"){

require(reshape2)
require(doBy)

##warnings are an impossible genotype
##for these data it is homo. Ref/Ref

##test data
test <- 0
if(test==1){
    seq_data <- seq_test_data
    ##genotype_table already read in
    warning_allele <- "Ref"
}

##melt by SAMPLE_NAME and WELL
seq_melt <- melt(seq_data, id.vars=c("SAMPLE_NAME", "WELL"))

seq_split_list <- splitBy(~variable, data=seq_melt)

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
    warning_genotype <- genotype_table[genotype_table$marker_names==chr_to_get_from_genotype_table, warning_allele]

    ##
    marker_data_frame <- seq_split_list[[i]]
    marker_data_frame[marker_data_frame$value==warning_genotype,"value"] <- "warning"
    out[[i]] <- marker_data_frame
    
}
#######################################################
##end for
#######################################################

seq_data_warnings_coded <- do.call(rbind, out)

colnames(seq_data_warnings_coded) <- c("SAMPLE_NAME", "WELL", "MARKER", "GENOTYPE")

    ##warnings
    if(output=="warnings"){
        warnings_out <- seq_data_warnings_coded[seq_data_warnings_coded$GENOTYPE=="warning",] 
        return(warnings_out)
    }

    ##warnings to NA
    if(output=="warnings2NA"){
        seq_data_warnings_coded[seq_data_warnings_coded$GENOTYPE=="warning","GENOTYPE"] <- NA
        seq_data_warnings_coded[seq_data_warnings_coded$GENOTYPE=="" & !is.na(seq_data_warnings_coded$GENOTYPE),"GENOTYPE"] <- NA
        seq_data_warnings_coded_S4 <- crossOveRs(genotypes=seq_data_warnings_coded, impossible_genotype=warning_allele)
        return(seq_data_warnings_coded_S4)
    }
    
    ##pass through 
    if(output=="pass_through"){
        seq_data_warnings_coded[seq_data_warnings_coded$GENOTYPE=="warning","GENOTYPE"] <- NA
        seq_data_warnings_coded[seq_data_warnings_coded$GENOTYPE=="" & !is.na(seq_data_warnings_coded$GENOTYPE),"GENOTYPE"] <- NA
        seq_data_warnings_coded_S4 <- crossOveRs(genotypes=seq_data_warnings_coded, impossible_genotype=warning_allele)
        return(seq_data_warnings_coded_S4)
    }
    
}

