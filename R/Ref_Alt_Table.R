#############################################################################################################################
#' Make reference/alternate allelle table from make_marker_names output
#' 
#' @param markers_in_study make_marker_names output
#' @keywords make_marker_names
#' @return A dataframe of Ref/Alt genotypes
#' @export
#' @examples
#' \dontrun{
#' data(markers)
#' markers_in_study <- make_marker_names(markers)
#' genotype_table <- Ref_Alt_Table(markers_in_study = markers_in_study)
#' }
Ref_Alt_Table <- function(markers_in_study){
    ##look for ATCG at the [Ref/Alt] in the marker from GrandMasterSNPs.pl
    SNP_list <- regmatches(markers_in_study$marker, gregexpr("[A|T|C|G]\\/[A|T|C|G]", markers_in_study$marker))

    ##split up into Ref and Alt
    SNP_df <- data.frame(do.call(rbind, strsplit(do.call(rbind, SNP_list), split="/")), stringsAsFactors=FALSE)
    colnames(SNP_df) <- c("Ref", "Alt")

    ##make Alt_Ref geno
    SNP_df$Alt_Ref <- paste(SNP_df$Alt, SNP_df$Ref, sep="")
    ##make Ref_Alt geno
    SNP_df$Ref_Alt <- paste(SNP_df$Ref, SNP_df$Alt, sep="")

    ##add marker names
    SNP_df$marker_names <- markers_in_study$marker_names

####################################################################
    sort_SNPs <- function(SNP_df){

        genotype_table <- SNP_df

        ##sort
        genotype_table$sort_position <- as.numeric(do.call(rbind, strsplit(genotype_table$marker_names, "_(?=[0-9])", perl=TRUE))[,2])
        genotype_table$sort_chr <- do.call(rbind, strsplit(genotype_table$marker_names, "_(?=[0-9])", perl=TRUE))[,1]

        sorted_df <- genotype_table[order(genotype_table$sort_chr, genotype_table$sort_position),]
        out_sorted_df <- sorted_df[,colnames(SNP_df)]
        return(out_sorted_df)
    }

    sorted_SNP_df <- sort_SNPs(SNP_df=SNP_df)
####################################################################
    
    return(sorted_SNP_df) 

}
#############################################################################################################################
