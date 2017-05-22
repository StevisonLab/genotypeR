#' R wrapper script to run Sequenom Marker design pipeline
#'
#' This function designs Sequenom markers.
#' @param vcf1 this is an uncompressed vcf file (Ref allele)
#' @param vcf2 this is an uncompressed vcf file (Alt allele)
#' @param outdir this is where the tab-delimited extended bed file will
#' be written
#' @param platform is a character vector taking "sq" for sequenom (100 bp reference flanking region) or "gg" for goldengate (50 bp reference flanking region).  
#' @keywords SequenomMarker
#' @return SequenomMarker design into "outdir"
#' @export
#' @examples
#' \dontrun{
#' SequenomMarkers("/path/to/vcf1", "/path/to/vcf2", "path_to_outdir" 
#' }

SequenomMarkers <- function(vcf1=NULL, vcf2=NULL, outdir=NULL, platform="sq"){

    ##change to actual SequenomMarkers directory
    perl_module <- system.file("SequenomMarkers_v2", package="genotypeR")

#####################################################################################
##turn off and comment out when fully tested
    ##test data
    ##test <- 1
    ##num_sample_test <- "one"
    ##num_sample_test <- "two"
    ##num_sample_test <- "null"
    
    ##if(test==1){

        ##create test dir on desktop
        ##test_dir <- "~/Desktop/test_sequenom_dir"
        
        ##if(dir.exists(test_dir)==FALSE){
            ##dir.create(test_dir, showWarnings = TRUE, recursive = FALSE, mode = "0777")
        ##}
        ##
        
        ##platform="sq"

        ##outdir_to_test
        ##outdir <- "/home/ssefick/Desktop/test_sequenom_dir"

        ##if null
        ##if(num_sample_test=="null"){
            ##vcf1 <- NULL
            ##vcf2 <- NULL
        ##}

        ##if pop sample
        ##if(num_sample_test=="one"){
            
            ##pop_sample_path <- paste(perl_module, "pop_sample", sep="/")

            ##pop_sample_vcf_test <- paste(pop_sample_path, "test_files", sep="/")
        
            ##vcf1 <- paste(pop_sample_vcf_test, "Pop_sample.vcf", sep="/")

            ##vcf2 <- NULL

            ##outdir <- "/home/ssefick/Desktop/test_sequenom_dir/pop_sample"
        ##}

        ##if two sample
        ##if(num_sample_test=="two"){
            ##two_sample_path <- paste(perl_module, "two_sample", sep="/")

            ##two_sample_vcf_test <- paste(two_sample_path, "test_files", sep="/")
        
            ##vcf1 <- paste(pop_sample_vcf_test, "Sample1.vcf", sep="/")

            ##vcf2 <- paste(pop_sample_vcf_test, "Sample2.vcf", sep="/")

            ##outdir <- "/home/ssefick/Desktop/test_sequenom_dir/two_sample"
        ##}
    ##}
#####################################################################################
    
    ##Print out some useful warning messages
    if(is.null(vcf1) & is.null(vcf2)){stop("must provide vcf files")}
    if(!is.null(vcf1) & is.null(vcf2)){print("using population marker designer")}
    if(!is.null(vcf1) & !is.null(vcf2)){print("using two sample marker designer")}
    ##
    

    ##find files in installed directory
    files <- dir(perl_module, full.names=TRUE)

    ##create outdir if it does not exist
    if(dir.exists(outdir)==FALSE){
        dir.create(outdir, showWarnings = TRUE, recursive = FALSE, mode = "0777")
    }

###################################################################################################3
    ##Do some stuff if population sample or two sample vcf
    ##set up wrapper scripts
    if(is.null(vcf1) & is.null(vcf2)){stop("must provide vcf files")}

    if(!is.null(vcf1) & is.null(vcf2)){
        ##go to pop_sample dir
        pop_sample_path <- paste(perl_module, "pop_sample", sep="/")
        ##Finding_SNPs_pop_sample.pl path
        finding_snps <- paste(pop_sample_path, "Finding_SNPs_pop_sample.pl", sep="/")
        ##Grandmaster_SNPs_pop_sample.pl path
        grandmaster_snps <- paste(pop_sample_path, "Grandmaster_SNPs_pop_sample.pl", sep="/")
        ##use below
        pop_or_two <- "pop"
    }

    if(!is.null(vcf1) & !is.null(vcf2)){
        ##go to two_sample dir
        two_sample_path <- paste(perl_module, "two_sample", sep="/")
        ##Finding_SNPs_two_sample.pl path
        finding_snps <- paste(two_sample_path, "Finding_SNPs_two_sample.pl", sep="/")
        ##Grandmaster_SNPs_two_sample.pl path
        grandmaster_snps <- paste(two_sample_path, "Grandmaster_SNPs_two_sample.pl", sep="/")
        ##set up the path to this sort script written in bash
        ##has to be in outdir for marker design to work
        sort_by_chr <- paste(two_sample_path, "sort_by_chr.sh", sep="/")
        ##use below
        pop_or_two <- "two"
    }

###############################################################################################

    ##execute the wrapper
    setwd(outdir)

    ##pop sample
    if(pop_or_two=="pop"){
        ##set up commands; simpler for pop sample
        cmd_finding_snps <- paste(shQuote(finding_snps), shQuote(vcf1), shQuote(platform), sep=" ")
        cmd_grandmaster_snps <- paste(shQuote(grandmaster_snps), shQuote(vcf1), sep=" ")
    }

    ##two sample
    if(pop_or_two=="two"){
        ##vcftools set up...
        vcf_tools_output <- paste(outdir, "Sample1_v_Sample2.out", sep="/")
        ##vcftools has to be in the PATH!!!
        cmd_vcftools <- paste(shQuote("vcftools"), shQuote("--vcf"), shQuote(vcf1), shQuote("--diff"), shQuote(vcf2), shQuote("--diff-site"), shQuote("--out"), shQuote(vcf_tools_output), sep=" ")
        ##Do the vcftools step for the diff site file
        system(cmd_vcftools)
        ##vcftools does what it wants just like Cartman by adding a new file extension to the specified output file name...
        awesome_vcf_name_change <- paste(outdir, "Sample1_v_Sample2.out.diff.sites_in_files", sep="/")
        ##set up commands as above
        cmd_finding_snps <- paste(shQuote(finding_snps), shQuote(awesome_vcf_name_change), shQuote(platform), sep=" ")
        cmd_grandmaster_snps <- paste(shQuote(grandmaster_snps), shQuote(vcf2), shQuote(vcf1), sep=" ")
        ##must copy sort_by_chr.sh into the working directory for the Perl script to work
        system(paste("cp", sort_by_chr, "."))
    }

    ##execute common part of the pipeline
    system(cmd_finding_snps)
    system(cmd_grandmaster_snps)    
}



