#######################################################################
#######################################################################
##Illumina
#' Read in Illumina GoldenGate AB tab delimited text file
#' 
#' @param tab_delimited_file is a tab delimited AB illumina GoldenGate file
#' @param flanking_region_length is the length in bp of the flanking region of the SNP
#' @param chromosome is a vector of chromosome names
#' @keywords illumina GoldenGate
#' @return data frame useful used in genotypeR
#' @export
#' @examples
#' \dontrun{
#' test_data <- read_in_illumina_GoldenGate(tab_delimited_file= \
#' "path_to_golden_gate_file", flanking_region_length=50,  \
#' chromosome=rep("chr2", length.out=length(552960)))
#' }
read_in_illumina_GoldenGate <- function(tab_delimited_file, chromosome, flanking_region_length){

###test <- 0
###if(test==1){
###    tab_delimited_file <- "Noor Plates 1-14__Feb-12-10_FinalReport.txt"
###    flanking_region_length <- 50
###    chromosome <- rep("chr2", length.out=length(552960))
###}
    
x <- read.table(tab_delimited_file, sep="\t", skip=9, header=TRUE, stringsAsFactors = FALSE)

x$Allele1...AB <- gsub("-", "", x$Allele1...AB)
x$Allele2...AB <- gsub("-", "", x$Allele2...AB)
    
##grab those alleles that are homozygous
Hom <- grep("TRUE", x$Allele1...AB==x$Allele2...AB & !is.na(x$Allele1...AB) & !is.na(x$Allele2...AB))
x[Hom,"Sequenom_Genotypes"] <- x[Hom, "Allele1...AB"]

##grab those alleles that are htereozygous
Het <- grep("TRUE", x$Allele1...AB!=x$Allele2...AB & !is.na(x$Allele1...AB) & !is.na(x$Allele2...AB))
x[Het,"Sequenom_Genotypes"] <- paste(x$Allele1...AB, x$Allele2...AB, sep="")[Het]

##change SNP ID to REGION
startbp <- x$SNP.Name-flanking_region_length
endbp <- x$SNP.Name+flanking_region_length
x$interval <- paste(chromosome, paste(startbp, endbp, sep="_"), sep="_") 

##add fake well
y <- data.frame(SAMPLE_NAME=x$Sample.ID, WELL=NA, interval=x$interval, Sequenom_Genotypes=x$Sequenom_Genotypes)

z <- dcast(SAMPLE_NAME+WELL~interval, data=y, value.var="Sequenom_Genotypes")

    a <- sort_sequenom_df(z)
    
return(a)
}
