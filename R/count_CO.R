#####################################################################################################
#####################################################################################################
#####################################################################################################
#' Internal function to remove search and remove columns based on names
#'
#' @description
#' \code{count_CO} counts crossovers from binary coded genotypes in
#' a genotypeR object. This function assigns crossovers to
#' the counted_crossovers slot in a genotypeR object.
#' 
#' @param data genotype data read in with read_in_sequenom_data
#' @param naive this takes 2 values: 1) FALSE (default) will count
#' COs distributed by marker distance, and 2) TRUE returns will count
#' COs without regard to marker distance (i.e., at the final
#' non-missing data point in a string of missing genotypes)
#' 
#' @keywords Count Crossovers of a genotypeR object
#' @return genotypeR object with counted crossovers
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
#' binary_coding_genotypes <- binary_coding(warnings_out2NA, genotype_table = GT_table)
#' chr2 <- subsetChromosome(binary_coding_genotypes, chromosome="chr2")
#' count_CO <- count_CO(chr2)
#' 
#' 
##!!!!!!!!!!!!START HERE!!!!!!!!!!!!##
##Need to make a slot for counted crossovers and generic functions for accessing, replacement, etc.

count_CO <- function(data, naive=FALSE){

    ##inorder to put into slot
    input_data <- data
    
    ###require(doBy)

    ##set to zero to turn off test
    ###test <- 0

    ###if(test==1){
    ###    ##test
    ###    data <- chr2
    ###    naive=FALSE
    ###}

    data <- binary_genotypes(data) 

    data.split <- splitBy(~SAMPLE_NAME+WELL, data=data)

    CO <- function(indata, naive=FALSE){

        ##require(zoo)
        ##set to zero to turn off test
        test <- 0
        
        if(test==1){
            ##test data
            indata <- data.split[[1]]
            ##comment out once satisfied
            ##this is to test the case where 1 is followed by NA TWICE
            ##works - SAS 20170109
            ##indata <- c("sample", 0,NA,1,0,NA,1)
            naive <- FALSE
        }

        ##removes rubish column

        indata <- grep_df_subset(indata, toMatch = c("SAMPLE_NAME", "WELL"))

##########################################################################################
#interval distances - SAS 20170120
        ##grab_out column names        
        intervals <- data.frame(do.call(rbind, strsplit(names(indata), split="_")))

        ##changed SAS 20170120
        intervals <- intervals[,c(1, length(colnames(intervals))-1, length(intervals))]
        
        colnames(intervals)  <- c("chr", "start", "end")
        intervals$start <- as.numeric(as.character(intervals$start))
        intervals$end <- as.numeric(as.character(intervals$end))
        for_loop_length <- length(intervals[,1])-1
        interval_distances <- vector(length=for_loop_length)
        for(i in 1:for_loop_length){
            interval_distances[i] <- intervals[i+1,"start"]-intervals[i,"end"]
        }
##########################################################################################
        
        ##change to numeric
        indata_num <- as.numeric(indata)
#################################################################
        ##if NA at begining
        if(is.na(indata_num)[1]==TRUE){
            ##set 1st value to 1st non-NA value
            ##this allows the na.locf to work below
            indata_num[1] <- indata_num[grep("TRUE", !is.na(indata_num))[1]]
            
        }
#################################################################    
        ##carry value forward i.e., 1 NA NA 0 == 1 1 1 0
        ##And take the diff (indata_num(i+1)-indata_num(i)
        ##i.e., 1 1 1 0 == 0 0 -1 (diff(c(1,1,1,0))
        diff_geno <- diff(na.locf(indata_num))

        ##change -1 to 1 because it is a crossover
        diff_geno[diff_geno==-1] <- 1
        ##naive output
        diff_geno. <- diff_geno


        ##randomly assign COs to NA runs
        if(naive==FALSE){

            ##test
            runs <- rle(is.na(indata_num))

            ##indices ALL NA runs
            myruns <- which(runs$values == TRUE & runs$lengths >= 1)

######################################################
            ##test if there are any NAs; this needs to be done somewhere!!!
            ##any(myruns)
######################################################

            ##end of runs
            runs.lengths.cumsum <- cumsum(runs$lengths)
            ##indices
            ends <- runs.lengths.cumsum[myruns]

            ##set new index to the previous end
            newindex <- ifelse(myruns>1, myruns-1, 0)
            ##find the previous ending value and then add one for the start
            starts <- runs.lengths.cumsum[newindex] + 1
            ##this corrects the removal of index 1 if it happens
            if (0 %in% newindex) starts = c(1,starts)

            ##remove start and end position
            keep <- ends!=length(indata_num) | starts!=1
            starts <- starts[keep]
            ends <- ends[keep]
            ##starts are always going to be one back
            starts <- starts-1

            ##this finds the index in ends and starts
            ##that have COs counted as 1 in diff_geno
            ##at the end of a NA run
            ends. <- ends[ends%in%grep("1", diff_geno)]
            starts. <- starts[ends%in%grep("1", diff_geno)]

############################################
############################################
############################################
            
            if(length(ends.)>0){

                for(i in 1:length(ends.)){
                    
                    ##i <- 1

                    ##find indices
                    indexes <- starts.[i]:ends.[i]
                    ##assign_1 <- sample(indexes, 1)
                    ##assign_0 <- indexes[indexes!=assign_1]
                    
                    ##assign 1 and 0
                    ##diff_geno[assign_1] <- 1
                    ##diff_geno[assign_0] <- 0
                    ##assign proportional CO to each site
                    ##diff_geno[indexes] <- (1/length(indexes))
                    ##distributed by proportional distance - SAS 20170120
                    diff_geno[indexes] <- interval_distances[indexes]/sum(interval_distances[indexes])
                }
            }
############################################
############################################
############################################
        }
        if(naive==FALSE){
            return(diff_geno)
        }

        if(naive==TRUE){
            return(diff_geno.)
        }
    }

    ##which(lapply(lapply(data.split, CO), length)!=24)
    ##make dataframe and sum columns - these are the
    ##counts of crossovers
    ##test with plyr
    crossover_count <- colSums(do.call(rbind, lapply(data.split, function(x)CO(x, naive=naive))))

    ##plyr
    ##library(plyr)
    ##crossover_count <- colSums(do.call(rbind, laply(data.split, CO, .inform=TRUE)))
    
    ##get marker names from colnames of input
    markers <- colnames(grep_df_subset(data, toMatch = c("SAMPLE_NAME", "WELL")))

    ##start intervals
    interval_start <- markers[1:(length(markers)-1)]
    ##end intervals
    interval_end <- markers[2:length(markers)]
    ##cross over out data in same format as perl script
    crossovers_out <- data.frame(crossovers=crossover_count, interval_start=interval_start, interval_end=interval_end)


################################################################
################################################################
################################################################
    ##sample number
    ##samp_num_fun <- function(x){

    ##    sampnum <- x[,-1]
        
    ##    samp_num <- unname(sapply(sampnum, FUN=function(x)sum(!is.na(x))))
        
    ##    nMarkers <- length(samp_num)
        
    ##    out <- vector(mode="list", length=(nMarkers-1))

    ##    ##sample chr2 
    ##    for(i in 1:(nMarkers-1)){
            
    ##        ##i=25
            
    ##        print(i)
            
    ##        out[[i]] <- min(c(samp_num[i], samp_num[i+1]))    
            
    ##    }

    ##    num_progeny <- do.call(rbind, out)
   ## }

   ## crossovers_out$num_ind <- samp_num_fun(data)
###################################################################################
###################################################################################
###################################################################################
    ##fixed 20170119 - SAS
    ##make sure this works for naive <- TRUE
    raw_counts <- do.call(rbind, lapply(data.split, function(x)CO(x, naive=naive)))

    ##Keep proportional individuals; code 0 and 1 as 1
    raw_counts[raw_counts==0 | raw_counts==1] <- 1

    crossovers_out$num_ind <- colSums(raw_counts)
###################################################################################
###################################################################################
###################################################################################

    
################################################################
################################################################
################################################################

    ##new stuff
    ##requires markers to be name_start_end
    ##start position
    crossovers_out$start <- as.numeric(do.call(rbind, strsplit(as.character(crossovers_out$interval_start), split="_"))[,(length(do.call(rbind, strsplit(as.character(crossovers_out$interval_start), split="_"))[1,])-1)])
    ##end position
    crossovers_out$end <-  as.numeric(do.call(rbind, strsplit(as.character(crossovers_out$interval_end), split="_"))[,(length(do.call(rbind, strsplit(as.character(crossovers_out$interval_end), split="_"))[1,]))])
    ##percent CO
    crossovers_out$percent_CO <- 100*(crossovers_out$crossovers/crossovers_out$num_ind)
    ##cMperMb
    crossovers_out$cMperMb_CO <- crossovers_out$percent_CO/((crossovers_out$end-crossovers_out$start)/1000000)
    ##start in Mb
    crossovers_out$start_Mb <- crossovers_out$start/1000000
    ##end in Mb
    crossovers_out$end_Mb <- crossovers_out$end/1000000

##########################################################################################################
    ##Kosambi Distance 
    ##added 20170305
    Kosambi <- function(x){
        a <- 1 + (2*x)
        b <- 1 - (2*x)    
        d <- 0.25*log(a/b)
        Kosambi_distance <- d*100
        return(Kosambi_distance)
    }

    crossovers_out$Kosambi_cM <- Kosambi(crossovers_out$crossovers/crossovers_out$num_ind)
    
################################################################
################################################################
################################################################


    ##part of S4 object
    counted_crossovers(input_data) <- crossovers_out
    ##return data not naive
    ##return(crossovers_out)
    return(input_data)
    ##return data naive
    ##if(naive==TRUE){
    ##    return(diff_geno.)
    ##}
}


#####################################################################################################
#####################################################################################################
#####################################################################################################
