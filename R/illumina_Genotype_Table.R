## illumina_Genoype_Table
#' Make genotypeR Alt_Ref_Table
#' 
#' @param tab_delimited_file is a tab delimited AB illumina GoldenGate file
#' @param flanking_region_length is the length in bp of the flanking region of the SNP
#' @param chromosome is a vector of chromosome names
#' @keywords illumina GoldenGate
#' @return data frame useful used in genotypeR
#' @export
#' @examples
#' \dontrun{
#' test_data <- read_in_illumina_GoldenGate(tab_delimited_file="Noor Plates 1-14__Feb-12-10_FinalReport.txt", flanking_region_length=50, chromosome=rep("chr2", length.out=length(552960)))
#' illumina_table <- illumina_Genoype_Table(tab_delimited_file="Noor Plates 1-14__Feb-12-10_FinalReport.txt", flanking_region_length=50, chromosome=rep("chr2", length.out=length(552960)))
#' }
illumina_Genoype_Table <- function(tab_delimited_file, flanking_region_length, chromosome){
test <- 0
if(test==1){
    tab_delimited_file <- "Noor Plates 1-14__Feb-12-10_FinalReport.txt"
    flanking_region_length <- 50
    chromosome <- rep("chr2", length.out=length(552960))
}
    
x <- read.table(tab_delimited_file, sep="\t", skip=9, header=TRUE, stringsAsFactors = FALSE, na.strings="-")

length_input_data <- length(x[,1])

##change SNP ID to REGION
startbp <- x$SNP.Name-flanking_region_length
endbp <- x$SNP.Name+flanking_region_length
##chr_start_end <- data.frame(chromosome=chromosome, start=startbp, end=endbp)
interval <- unique(paste(chromosome, paste(startbp, endbp, sep="_"), sep="_")) 
ref_alt_table <- data.frame(Ref=as.character(rep("A", length.out=length_input_data)), Alt=as.character(rep("B", length.out=length_input_data)), Alt_Ref=as.character(rep("AB", length.out=length_input_data)), Ref_Alt=as.character(rep("BA", length.out=length_input_data)), marker_names=as.character(interval), stringsAsFactors=FALSE)

  sort_SNPs <- function(SNP_df) {
        genotype_table <- SNP_df
        genotype_table$sort_position <- as.numeric(do.call(rbind, 
            strsplit(genotype_table$marker_names, "_(?=[0-9])", 
                perl = TRUE))[, 2])
        genotype_table$sort_chr <- do.call(rbind, strsplit(genotype_table$marker_names, 
            "_(?=[0-9])", perl = TRUE))[, 1]
        sorted_df <- genotype_table[order(genotype_table$sort_chr, 
            genotype_table$sort_position), ]
        out_sorted_df <- sorted_df[, colnames(SNP_df)]
        return(out_sorted_df)
    }

sorted_df <- sort_SNPs(ref_alt_table)

uniq_sorted_df <- unique(sorted_df)

return(uniq_sorted_df)

}
